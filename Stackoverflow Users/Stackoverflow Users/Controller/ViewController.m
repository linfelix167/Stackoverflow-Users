//
//  ViewController.m
//  Stackoverflow Users
//
//  Created by Felix Lin on 6/13/18.
//  Copyright © 2018 Felix Lin. All rights reserved.
//

#import "ViewController.h"
#import "HTTPService.h"
#import "User.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation ViewController

NSString *cellId = @"cellId";

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self setupSearchBar];
  
  // Create a list to hold search result
  self.filteredUserList = NSMutableArray.new;
  
  [self fetchUsers];
  
  self.navigationItem.title = @"Stack Overflow";
  self.navigationController.navigationBar.prefersLargeTitles = YES;
  
  [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:cellId];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  self.navigationItem.hidesSearchBarWhenScrolling = NO;
}

- (void) fetchUsers {
  [[HTTPService instance] getUsers:^(NSDictionary * _Nullable dataDictionary, NSString * _Nullable errMessage) {
    if (dataDictionary) {
      
      NSMutableArray<User *> *users = NSMutableArray.new;
      NSDictionary *items = [dataDictionary objectForKey:@"items"];
      
      for (NSDictionary *dictionary in items) {
        User *user = User.new;
        NSDictionary *badgeCounts = [dictionary objectForKey:@"badge_counts"];
        
        NSString *name = dictionary[@"display_name"];
        NSString *imageUrl = dictionary[@"profile_image"];
        NSString *link = dictionary[@"link"];
        NSNumber *bronzeCount = badgeCounts[@"bronze"];
        NSNumber *silverCount = badgeCounts[@"silver"];
        NSNumber *goldCount = badgeCounts[@"gold"];
        
        user.name = name;
        user.imageUrl = imageUrl;
        user.link = link;
        user.bronzeCount = bronzeCount;
        user.silverCount = silverCount;
        user.goldCount = goldCount;
        
        [users addObject:user];
      }
      
      self.userList = users;
      
      // Initially display the full list. This will toggle between the full and the filtered lists
      self.displayedUserList = self.userList;
      [self updateTableData];
      
      NSLog(@"items: %@", items.debugDescription);
    }
  }];
}

- (void)setupSearchBar {
  self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
  self.searchController.searchResultsUpdater = self;
  self.searchController.dimsBackgroundDuringPresentation = NO;
  self.searchController.searchBar.delegate = self;
  self.searchController.searchBar.placeholder = @"Search for users";
  self.navigationItem.searchController = self.searchController;
  self.definesPresentationContext = YES;
}

- (void)updateTableData {
  dispatch_async(dispatch_get_main_queue(), ^{
    [self.tableView reloadData];
  });
}

- (NSAttributedString *)setTextImage:(NSString *)name{
  NSTextAttachment *imageText = NSTextAttachment.new;
  imageText.image = [UIImage imageNamed:name];
  imageText.bounds = CGRectMake(0, -5.0, imageText.image.size.width, imageText.image.size.height);
  NSAttributedString *attach = [NSAttributedString attributedStringWithAttachment:imageText];
  return attach;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.displayedUserList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  
  User *user = self.displayedUserList[indexPath.row];
  
  // Set cell title
  cell.textLabel.text = user.name;
  
  // Set cell image
  [cell.imageView sd_setImageWithURL:[NSURL URLWithString:user.imageUrl] placeholderImage:[UIImage imageNamed:@"loading"]];
  
  // Set badge value
  NSMutableAttributedString *completeText = [[NSMutableAttributedString alloc] initWithString:@""];
  
  [completeText appendAttributedString:[self setTextImage:@"gold"]];
  NSMutableAttributedString *goldValue = [[NSMutableAttributedString alloc] initWithString:user.goldCount.stringValue];
  [goldValue addAttribute:NSKernAttributeName value:@1.0 range:NSMakeRange(0, goldValue.length)];
  [completeText appendAttributedString:goldValue];
  
  [completeText appendAttributedString:[self setTextImage:@"silver"]];
  NSMutableAttributedString *silverValue = [[NSMutableAttributedString alloc] initWithString:user.silverCount.stringValue];
  [silverValue addAttribute:NSKernAttributeName value:@1.0 range:NSMakeRange(0, silverValue.length)];
  [completeText appendAttributedString:silverValue];
  
  [completeText appendAttributedString:[self setTextImage:@"bronze"]];
  NSMutableAttributedString *bronzeValue = [[NSMutableAttributedString alloc] initWithString:user.bronzeCount.stringValue];
  [bronzeValue addAttribute:NSKernAttributeName value:@1.0 range:NSMakeRange(0, bronzeValue.length)];
  [completeText appendAttributedString:bronzeValue];
  
  cell.detailTextLabel.textAlignment = NSTextAlignmentRight;
  cell.detailTextLabel.attributedText = completeText;
  
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  User *user = self.displayedUserList[indexPath.row];
  
  SFSafariViewController *sfVC = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:user.link]];
  sfVC.delegate = self;
  [self presentViewController:sfVC animated:YES completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 50;
}

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
  NSString *searchText = searchController.searchBar.text;
  
  // Check if user cancelled or delete the search term
  if (![searchText isEqualToString:@""]) {
    [self.filteredUserList removeAllObjects];
    for (User *user in self.userList) {
      if ([searchText isEqualToString:@""] || [user.name localizedCaseInsensitiveContainsString:searchText] == YES) {
        [self.filteredUserList addObject:user];
      }
    }
    self.displayedUserList = self.filteredUserList;
  } else {
    self.displayedUserList = self.userList;
  }
  [self.tableView reloadData];
}

@end

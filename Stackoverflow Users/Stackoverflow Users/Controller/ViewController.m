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
  
  cell.textLabel.text = user.name;
  
  UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:user.imageUrl]]];
  cell.imageView.image = image;
  
  NSMutableAttributedString *completeText = [[NSMutableAttributedString alloc] initWithString:@""];
  
  NSTextAttachment *goldImage = NSTextAttachment.new;
  goldImage.image = [UIImage imageNamed:@"gold"];
  goldImage.bounds = CGRectMake(0, -5.0, goldImage.image.size.width, goldImage.image.size.height);
  NSAttributedString *attachGold = [NSAttributedString attributedStringWithAttachment:goldImage];
  [completeText appendAttributedString:attachGold];
  NSMutableAttributedString *goldValue = [[NSMutableAttributedString alloc] initWithString:user.goldCount.stringValue];
  [goldValue addAttribute:NSKernAttributeName value:@1.0 range:NSMakeRange(0, goldValue.length)];
  [completeText appendAttributedString:goldValue];
  
  NSTextAttachment *silverImage = NSTextAttachment.new;
  silverImage.image = [UIImage imageNamed:@"silver"];
  silverImage.bounds = CGRectMake(0, -5.0, silverImage.image.size.width, silverImage.image.size.height);
  NSAttributedString *attachSilver = [NSAttributedString attributedStringWithAttachment:silverImage];
  [completeText appendAttributedString:attachSilver];
  NSMutableAttributedString *silverValue = [[NSMutableAttributedString alloc] initWithString:user.silverCount.stringValue];
  [silverValue addAttribute:NSKernAttributeName value:@1.0 range:NSMakeRange(0, silverValue.length)];
  [completeText appendAttributedString:silverValue];
  
  NSTextAttachment *bronzeImage = NSTextAttachment.new;
  bronzeImage.image = [UIImage imageNamed:@"bronze"];
  bronzeImage.bounds = CGRectMake(0, -5.0, bronzeImage.image.size.width, bronzeImage.image.size.height);
  NSAttributedString *attachBronze = [NSAttributedString attributedStringWithAttachment:bronzeImage];
  [completeText appendAttributedString:attachBronze];
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
  return 70;
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

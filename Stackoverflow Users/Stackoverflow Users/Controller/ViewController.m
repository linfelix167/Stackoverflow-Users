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

@interface ViewController()

@property (strong, nonatomic) NSMutableArray<User *> *userList;

@end

@implementation ViewController

NSString *cellId = @"cellId";

- (void)viewDidLoad {
  [super viewDidLoad];
  
  searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
  [searchBar setPlaceholder:@"Search for User"];
  self.tableView.tableHeaderView = searchBar;
  
  [self fetchUsers];
  
  self.navigationItem.title = @"Users";
  self.navigationController.navigationBar.prefersLargeTitles = YES;
  
  [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:cellId];
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
        NSNumber *bronzeCount = badgeCounts[@"bronze"];
        NSNumber *silverCount = badgeCounts[@"silver"];
        NSNumber *goldCount = badgeCounts[@"gold"];
        
        user.name = name;
        user.imageUrl = imageUrl;
        user.bronzeCount = bronzeCount;
        user.silverCount = silverCount;
        user.goldCount = goldCount;
        
        [users addObject:user];
      }
      
      self.userList = users;
      [self updateTableData];
      
      NSLog(@"items: %@", items.debugDescription);
    }
  }];
}

- (void)updateTableData {
  dispatch_async(dispatch_get_main_queue(), ^{
    [self.tableView reloadData];
  });
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.userList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
  
  User *user = self.userList[indexPath.row];
  
  cell.textLabel.text = user.name;
  UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:user.imageUrl]]];
  cell.imageView.image = image;
  
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 100;
}

@end

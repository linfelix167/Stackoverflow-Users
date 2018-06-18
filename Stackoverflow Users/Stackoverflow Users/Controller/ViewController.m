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
#import "UserCell.h"

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.navigationItem.title = @"Users";
  self.navigationController.navigationBar.prefersLargeTitles = YES;
  
  self.userList = NSArray.new;
  
  [[HTTPService instance] getUsers:^(NSDictionary * _Nullable dataDictionary, NSString * _Nullable errMessage) {
    if (dataDictionary) {
      
      NSMutableArray *arr = NSMutableArray.new;
      NSDictionary *items = [dataDictionary objectForKey:@"items"];
      
      for (NSDictionary *dictionary in items) {
        User *user = User.new;
        user.name = [dictionary objectForKey:@"display_name"];
        user.imageUrl = [dictionary objectForKey:@"profile_image"];
        
        NSDictionary *badgeCounts = [dictionary objectForKey:@"badge_counts"];
        user.bronzeCount = [badgeCounts objectForKey:@"bronze"];
        user.silverCount = [badgeCounts objectForKey:@"silver"];
        user.goldCount = [badgeCounts objectForKey:@"gold"];
        
        [arr addObject:user];
      }
      
      self.userList = arr;
      [self updateTableData];
      
      NSLog(@"items: %@", items.debugDescription);
    }
  }];
}

- (void) updateTableData {
  dispatch_async(dispatch_get_main_queue(), ^{
    [self.tableView reloadData];
  });
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.userList.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  UserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
  
  if (!cell) {
    cell = UserCell.new;
  }
  
  return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
  
  User *user = [self.userList objectAtIndex:indexPath.row];
  UserCell *userCell = (UserCell*)cell;
  [userCell updateUI:user];
}

@end

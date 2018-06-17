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

@interface ViewController ()

@property (strong, nonatomic) NSArray *userList;

@end

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
        
        [arr addObject:user.name];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.userList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"main" forIndexPath:indexPath];
  
  cell.textLabel.text = self.userList[indexPath.row];
  
  return cell;
}

@end

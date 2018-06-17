//
//  ViewController.m
//  Stackoverflow Users
//
//  Created by Felix Lin on 6/13/18.
//  Copyright © 2018 Felix Lin. All rights reserved.
//

#import "ViewController.h"
#import "HTTPService.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.navigationItem.title = @"Users";
  self.navigationController.navigationBar.prefersLargeTitles = YES;
  
  [[HTTPService instance] getUsers:^(NSArray * _Nullable dataArray, NSString * _Nullable errMessage) {
    if (dataArray) {
      NSLog(@"DataArray: %@", dataArray.debugDescription);
    }
  }];
}

- (void) updateTableData {
  dispatch_async(dispatch_get_main_queue(), ^{
    [self.tableView reloadData];
  });
}

@end

//
//  ViewController.h
//  Stackoverflow Users
//
//  Created by Felix Lin on 6/13/18.
//  Copyright © 2018 Felix Lin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
@import SafariServices;

@interface ViewController : UITableViewController <UISearchResultsUpdating, UISearchBarDelegate, SFSafariViewControllerDelegate>

@property (strong, nonatomic) NSMutableArray<User *> *userList;
@property (strong, nonatomic) NSMutableArray<User *> *filteredUserList;
@property (strong, nonatomic) NSMutableArray<User *> *displayedUserList;
@property (strong, nonatomic) UISearchController *searchController;

@end


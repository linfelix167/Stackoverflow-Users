//
//  UserCell.h
//  Stackoverflow Users
//
//  Created by Felix Lin on 6/18/18.
//  Copyright © 2018 Felix Lin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class User;

@interface UserCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bronzeLabel;
@property (weak, nonatomic) IBOutlet UILabel *silverLabel;
@property (weak, nonatomic) IBOutlet UILabel *goldLabel;
@property (weak, nonatomic) IBOutlet UIView *cellView;

-(void)updateUI:(nonnull User*)user;

@end

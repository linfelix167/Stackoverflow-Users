//
//  UserCell.m
//  Stackoverflow Users
//
//  Created by Felix Lin on 6/18/18.
//  Copyright © 2018 Felix Lin. All rights reserved.
//

#import "UserCell.h"
#import "User.h"

@implementation UserCell

- (void)awakeFromNib {
  [super awakeFromNib];
  
  self.layer.cornerRadius = 2.0;
  self.layer.shadowColor = [UIColor colorWithRed:157.0/ 255.0 green:157.0 / 255.0 blue:157.0 / 255.0 alpha:0.8].CGColor;
  self.layer.shadowOpacity = 0.8;
  self.layer.shadowRadius = 5.0;
  self.layer.shadowOffset = CGSizeMake(0.0, 2.0);
}

- (void)updateUI:(nonnull User*)user {
  self.userNameLabel.text = user.name;
  self.bronzeLabel.text = user.bronzeCount;
  self.silverLabel.text = user.silverCount;
  self.goldLabel.text = user.goldCount;
  
  UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:user.imageUrl]]];
  self.userImage.image = image;
}

@end

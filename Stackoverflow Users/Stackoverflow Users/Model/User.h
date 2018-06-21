//
//  User.h
//  Stackoverflow Users
//
//  Created by Felix Lin on 6/17/18.
//  Copyright © 2018 Felix Lin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *imageUrl;
@property (strong, nonatomic) NSString *link;
@property (strong, nonatomic) NSNumber *bronzeCount;
@property (strong, nonatomic) NSNumber *silverCount;
@property (strong, nonatomic) NSNumber *goldCount;

@end


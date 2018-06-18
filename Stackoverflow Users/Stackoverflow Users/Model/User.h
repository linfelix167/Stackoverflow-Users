//
//  User.h
//  Stackoverflow Users
//
//  Created by Felix Lin on 6/17/18.
//  Copyright © 2018 Felix Lin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *imageUrl;
@property(nonatomic, strong) NSNumber *bronzeCount;
@property(nonatomic, strong) NSNumber *silverCount;
@property(nonatomic, strong) NSNumber *goldCount;

@end


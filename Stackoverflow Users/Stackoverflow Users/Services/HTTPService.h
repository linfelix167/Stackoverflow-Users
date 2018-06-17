//
//  HTTPService.h
//  Stackoverflow Users
//
//  Created by Felix Lin on 6/16/18.
//  Copyright © 2018 Felix Lin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^onComplete)(NSArray * __nullable dataArray, NSString * __nullable errMessage);

@interface HTTPService : NSObject

+ (id)instance;
- (void)getUsers: (nullable onComplete)completionHandler;

@end

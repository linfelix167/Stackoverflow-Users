//
//  HTTPService.m
//  Stackoverflow Users
//
//  Created by Felix Lin on 6/16/18.
//  Copyright © 2018 Felix Lin. All rights reserved.
//

#import "HTTPService.h"

#define URL "https://api.stackexchange.com/2.2/users?site=stackoverflow"

@implementation HTTPService

+ (id)instance {
  static HTTPService *sharedInstance = nil;
  
  @synchronized(self) {
    if (sharedInstance == nil) {
      sharedInstance = HTTPService.new;
    }
  }
  return sharedInstance;
}

- (void)getUsers:(nullable onComplete)completionHandler {
  NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%s", URL]];
  NSURLSession *session = [NSURLSession sharedSession];
  
  [[session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    
    if (data != nil) {
      NSError *err;
      NSArray *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
      
      if (err == nil) {
        completionHandler(json, nil);
      } else {
        completionHandler(nil, @"Data is corrupt. Please try again");
      }
      
      if (err == nil) {
        NSLog(@"JSON %@", json.debugDescription);
      }
    } else {
      NSLog(@"Network Err %@", error.debugDescription);
      completionHandler(nil, @"Problem connecting to server");
    }
    
  }] resume];
}

@end

//
//  PeopleRequest.h
//  fitmoo
//
//  Created by hongjian lin on 6/17/17.
//  Copyright © 2017 com.fitmoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "FitmooHelper.h"
#import "UserManager.h"
@interface PeopleRequest : NSObject


- (NSString *)url;
- (NSDictionary *)parameters;
- (NSDictionary *)infinityParameters;
- (NSString *)featureUrl;
- (NSString *)activeUrl;
@property (assign, nonatomic)  int offset;

+ (PeopleRequest *)requestWithPeople;
+ (PeopleRequest *)requestWithOffsetPeople:(int) off;

@end

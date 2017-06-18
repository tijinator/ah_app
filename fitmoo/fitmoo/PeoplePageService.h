//
//  peoplePageService.h
//  fitmoo
//
//  Created by hongjian lin on 6/17/17.
//  Copyright © 2017 com.fitmoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PeopleRequest.h"
#import "User.h"
#import "AFNetworking.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "FitmooHelper.h"
#import "UserManager.h"
@interface PeoplePageService : NSObject

typedef void (^PeopleSuccessCallback)(NSArray <User *> * _Nullable results);
typedef void (^TotalListSuccessCallback)(NSArray * _Nullable results);
typedef void (^ServiceFailureCallback)(NSError * _Nonnull error);

- (void)getTotalUserRequest:(PeopleRequest *_Nullable)request
                                         success:(TotalListSuccessCallback _Nullable )success
                                         failure:(ServiceFailureCallback _Nullable )failure;


- (void)getFeatureUserRequest:(PeopleRequest *_Nullable)request
                    success:(TotalListSuccessCallback _Nullable )success
                    failure:(ServiceFailureCallback _Nullable )failure;

- (void)getActiveUserRequest:(PeopleRequest *_Nullable)request
                      success:(TotalListSuccessCallback _Nullable )success
                      failure:(ServiceFailureCallback _Nullable )failure;


@end

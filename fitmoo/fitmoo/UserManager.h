//
//  UserManager.h
//  fitmoo
//
//  Created by hongjian lin on 4/8/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "User.h"
#import "LocalUser.h"
#import <CoreData/CoreData.h>
#import "AFNetworking.h"



@interface UserManager : NSObject
{
    
}

@property (strong, nonatomic) NSManagedObjectContext * context;

//+ (UserManager*) sharedInstance;

+ (id)sharedUserManager;
- (void) saveLocalUser: (User *) localUser;
- (void) setContext: (NSManagedObjectContext *) con;
- (User *) getUserLocally;

-(void) performLogin: (User *) localUser;
-(void) performLogout: (User *) user;
-(void) performPost:(NSString *) postText;
-(void) performComment:(NSString *) postText withId:(NSString *) postId;
-(void) performLike:(NSString *) postId;
-(void) performShare:(NSString *) postText withId:(NSString *) postId;
-(void) performGetUserProfile;

@property (strong, nonatomic) NSString * loginUrl;
@property (strong, nonatomic) NSString * logoutUrl;
@property (strong, nonatomic) NSString * homeFeedUrl;
@property (strong, nonatomic) NSString * postUrl;
@property (strong, nonatomic) NSString * commentUrl;
@property (strong, nonatomic) NSString * likeUrl;
@property (strong, nonatomic) NSString * shareUrl;
@property (strong, nonatomic) NSString * clientUrl;

@property (strong, nonatomic)  NSDictionary * responseDic;
@property (strong, nonatomic) User * localUser;


@end

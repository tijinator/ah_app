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
#import <FacebookSDK/FacebookSDK.h>


@interface UserManager : NSObject
{
    
}

@property (strong, nonatomic) NSManagedObjectContext * context;

//+ (UserManager*) sharedInstance;

+ (id)sharedUserManager;
- (void) saveLocalUser: (User *) localUser;
- (void) setContext: (NSManagedObjectContext *) con;
- (User *) getUserLocally;

-(User *) performLogin: (User *) user;
-(void) performLogout: (User *) user;
-(void) performPost:(NSDictionary *)feed;
-(void) performComment:(NSString *) postText withId:(NSString *) postId;
-(void) performLike:(NSString *) postId;
-(void) performShare:(NSString *) postText withId:(NSString *) postId;
-(void) performReport:(NSString *) postId;
-(void) performDelete:(NSString *) postId;
-(void) performEndorse:(NSString *) postId;
-(void) performPostToAmazon:(NSDictionary *)feed;

-(void) checkEmailExistFromFitmoo:(User *) user;
-(void) createAccountFromFacebook:(User *) user;
-(void) getUserProfile:(User *) user;


@property (strong, nonatomic) NSString * loginUrl;
@property (strong, nonatomic) NSString * logoutUrl;
@property (strong, nonatomic) NSString * homeFeedUrl;
@property (strong, nonatomic) NSString * postUrl;
@property (strong, nonatomic) NSString * amazonUrl;

@property (strong, nonatomic) NSString * clientUrl;
@property (strong, nonatomic) NSString * feedsUrl;

@property (strong, nonatomic)  NSDictionary * responseDic;
@property (strong, nonatomic) User * localUser;


@end

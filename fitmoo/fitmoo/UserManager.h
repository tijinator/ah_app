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
-(void) performFollow:(NSString *) postId;
-(void) performUnFollow:(NSString *) postId;
-(void) performPostToAmazon:(NSDictionary *)feed;
-(void) performUpdate:(User *) user;
-(void) checkEmailExistFromFitmoo:(User *) user;
-(void) createAccountFromFacebook:(User *) user;
-(void) getUserProfile:(User *) user;
-(void) performUpdatePrivacy:(User *) user;
-(void) getUserProfileForOtherPeople:(NSString *) other_people_id;
-(void) performUnLike:(NSString *) postId;

@property (strong, nonatomic) NSString * loginUrl;
@property (strong, nonatomic) NSString * logoutUrl;
@property (strong, nonatomic) NSString * homeFeedUrl;
@property (strong, nonatomic) NSString * postUrl;
@property (strong, nonatomic) NSString * amazonUrl;
@property (strong, nonatomic) NSString * amazonUploadUrl;

@property (strong, nonatomic) NSString * clientUrl;
@property (strong, nonatomic) NSString * feedsUrl;

@property (strong, nonatomic) NSString * s3_accountId;
@property (strong, nonatomic) NSString * s3_identityPoolId;
@property (strong, nonatomic) NSString * s3_unauthRoleArn;
@property (strong, nonatomic) NSString * s3_authRoleArn;
@property (strong, nonatomic) NSString * s3_bucket;



@property (strong, nonatomic)  NSDictionary * responseDic;
@property (strong, nonatomic) User * localUser;


@end

//
//  User.h
//  fitmoo
//
//  Created by hongjian lin on 4/8/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreatedByCommunity.h"

@interface User : NSObject
{
    NSString *_secret_id;
    NSString *_auth_token;
    NSString *_user_id;
    NSString *_email;
    NSString *_password;
}

@property (nonatomic, strong) NSString *secret_id;
@property (nonatomic, strong) NSString *auth_token;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *cover_photo_url;
@property (nonatomic, strong) NSString *profile_avatar_thumb;
@property (nonatomic, strong) NSString *profile_avatar_original;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *following;
@property (nonatomic, strong) NSString *followers;
@property (nonatomic, strong) NSString *communities;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSString *day_of_birth;
@property (nonatomic, strong) NSString *facebook_uid;
@property (nonatomic, strong) NSString *bio;
@property (nonatomic, strong) NSString *geolocation;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *website;
@property (nonatomic, strong) NSString *current_user_can_view_profile;
@property (nonatomic, strong) NSString *is_following;

@property (nonatomic, strong) NSString *hide_global_privacy;
@property (nonatomic, strong) NSString *hide_location;
@property (nonatomic, strong) NSString *hide_email;
@property (nonatomic, strong) NSString *hide_phone;
@property (nonatomic, strong) NSString *hide_website;
@property (nonatomic, strong) NSString *hide_facebook;
@property (nonatomic, strong) NSString *hide_twitter;
@property (nonatomic, strong) NSString *hide_linkedin;
@property (nonatomic, strong) NSString *hide_google;
@property (nonatomic, strong) NSString *hide_instagram;

@property (nonatomic, strong) NSString *vanity_url;

@property (nonatomic, strong) NSMutableArray * communityArray;
@property (nonatomic, strong) CreatedByCommunity *created_by_community;
-(id)init;
-(void) resetCommunity;

@end

//
//  User.h
//  fitmoo
//
//  Created by hongjian lin on 4/8/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import <UIKit/UIKit.h>

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
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *following;
@property (nonatomic, strong) NSString *followers;
@property (nonatomic, strong) NSString *communities;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSString *day_of_birth;
@property (nonatomic, strong) NSString *facebook_uid;
-(id)init;


@end

//
//  UserManager.m
//  fitmoo
//
//  Created by hongjian lin on 4/8/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import "UserManager.h"
#import <FacebookSDK/FacebookSDK.h>
#import "AFNetworking.h"
@implementation UserManager

+ (id)sharedUserManager;
{
    static dispatch_once_t pred;
    static UserManager *mFUserManagement = nil;
    
    dispatch_once(&pred, ^{ mFUserManagement = [[self alloc] init]; });
    return mFUserManagement;
    
}


-(void) performFollow:(NSString *) postId
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:_localUser.secret_id, @"secret_id", _localUser.auth_token, @"auth_token", nil];
    NSString *url= [NSString stringWithFormat:@"%@%@%@",_homeFeedUrl, postId,@"/follow" ];
    [manager POST: url parameters:jsonDict success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        _responseDic= responseObject;
        
        
        //      NSLog(@"Submit response data: %@", responseObject);
    } // success callback block
     
          failure:^(AFHTTPRequestOperation *operation, NSError *error){
              NSLog(@"Error: %@", error);} // failure callback block
     ];

}
-(void) performUnFollow:(NSString *) postId
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:_localUser.secret_id, @"secret_id", _localUser.auth_token, @"auth_token", nil];
    NSString *url= [NSString stringWithFormat:@"%@%@%@",_homeFeedUrl, postId,@"/unfollow" ];
    [manager POST: url parameters:jsonDict success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        _responseDic= responseObject;
        
        
        //      NSLog(@"Submit response data: %@", responseObject);
    } // success callback block
     
          failure:^(AFHTTPRequestOperation *operation, NSError *error){
              NSLog(@"Error: %@", error);} // failure callback block
     ];
}


-(void) checkEmailExistFromFitmoo:(User *)user
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    _localUser= [self getUserLocally];
    
    
    
    NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"undefined", @"secret_id", user.facebook_uid, @"uid",user.email, @"email",nil];
    NSString *url= [NSString stringWithFormat:@"%@%@",_homeFeedUrl, @"find_user_by_fb_uid"];
    [manager GET: url parameters:jsonDict success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        _responseDic= responseObject;
    
        NSNumber * found=[_responseDic objectForKey:@"found"];
        NSString *f= [found stringValue];
        if ([f isEqualToString:@"1"]) {
            _localUser=user;
            _localUser.secret_id= [_responseDic objectForKey:@"secret_id"];
            _localUser.auth_token=[_responseDic objectForKey:@"auth_token"];
            NSNumber * user_id=[_responseDic objectForKey:@"user_id"];
            _localUser.user_id= [user_id stringValue];
     //       _localUser.user_id=[_responseDic objectForKey:@"user_id"];
      //      [self performLogin:_localUser];
            [self saveLocalUser:_localUser];
            [self getUserProfile:_localUser];
        }else if ([f isEqualToString:@"0"])
        {
            _localUser=user;
            [self createAccountFromFacebook:_localUser];
        }
        
        
              //      NSLog(@"Submit response data: %@", responseObject);
    } // success callback block
     
         failure:^(AFHTTPRequestOperation *operation, NSError *error){
             NSLog(@"Error: %@", error);} // failure callback block
     ];
    

}


-(void) createAccountFromFacebook:(User *)user
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    NSDictionary *jsonUserDict = [[NSDictionary alloc] initWithObjectsAndKeys:user.email, @"email", user.name, @"full_name",user.gender, @"gender",nil];
    NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:user.day_of_birth, @"date_of_birth", jsonUserDict, @"user",nil];
    NSString *url= [NSString stringWithFormat:@"%@%@",_homeFeedUrl, @"create_user_from_mobile"];
    [manager POST: url parameters:jsonDict success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        _responseDic= responseObject;
        
        _localUser.secret_id= [_responseDic objectForKey:@"secret_id"];
        _localUser.auth_token= [_responseDic objectForKey:@"auth_token"];
        NSNumber * user_id=[_responseDic objectForKey:@"user_id"];
        _localUser.user_id= [user_id stringValue];
         [self saveLocalUser:_localUser];
        [self getUserProfile:_localUser];
        
        //      NSLog(@"Submit response data: %@", responseObject);
    } // success callback block
     
         failure:^(AFHTTPRequestOperation *operation, NSError *error){
             NSLog(@"Error: %@", error);} // failure callback block
     ];
    
    
}


-(void) getUserProfileForOtherPeople:(NSString *) other_people_id
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    User *localUser= [[User alloc] init];
    NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:_localUser.secret_id, @"secret_id", _localUser.auth_token, @"auth_token",@"true", @"mobile",nil];
    NSString *url= [NSString stringWithFormat:@"%@%@",_homeFeedUrl, other_people_id];
    [manager GET: url parameters:jsonDict success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        _responseDic= responseObject;
        
        localUser.name=[_responseDic objectForKey:@"full_name"];
        
        NSNumber * following=[_responseDic objectForKey:@"following"];
        localUser.following= [following stringValue];
        NSNumber * followers=[_responseDic objectForKey:@"followers"];
        localUser.followers= [followers stringValue];
        NSNumber * communities=[_responseDic objectForKey:@"communities"];
        localUser.communities= [communities stringValue];
        
        NSDictionary * profile=[_responseDic objectForKey:@"profile"];
        localUser.cover_photo_url=[profile objectForKey:@"cover_photo_url"];
        NSDictionary *avatar=[profile objectForKey:@"avatars"];
        localUser.profile_avatar_thumb=[avatar objectForKey:@"small"];
        localUser.profile_avatar_original=[avatar objectForKey:@"original"];
        localUser.bio=[profile objectForKey:@"bio"];
        if ([localUser.bio isEqual:[NSNull null]]) {
            localUser.bio=@"";
        }
        localUser.is_following=[_responseDic objectForKey:@"is_following"];
        localUser.current_user_can_view_profile=[_responseDic objectForKey:@"current_user_can_view_profile"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"didGetProfileFinished" object:localUser];
       
     
        
        //      NSLog(@"Submit response data: %@", responseObject);
    } // success callback block
     
         failure:^(AFHTTPRequestOperation *operation, NSError *error){
             NSLog(@"Error: %@", error);} // failure callback block
     ];
    
    
}


-(void) getUserProfile:(User *) user
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];

    
    NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:_localUser.secret_id, @"secret_id", _localUser.auth_token, @"auth_token",@"true", @"mobile",nil];
    NSString *url= [NSString stringWithFormat:@"%@%@",_homeFeedUrl, _localUser.user_id];
    [manager GET: url parameters:jsonDict success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        _responseDic= responseObject;
        
        _localUser.name=[_responseDic objectForKey:@"full_name"];
        
         NSNumber * following=[_responseDic objectForKey:@"following"];
        _localUser.following= [following stringValue];
         NSNumber * followers=[_responseDic objectForKey:@"followers"];
        _localUser.followers= [followers stringValue];
         NSNumber * communities=[_responseDic objectForKey:@"communities"];
        _localUser.communities= [communities stringValue];
        
        NSDictionary * profile=[_responseDic objectForKey:@"profile"];
        _localUser.cover_photo_url=[profile objectForKey:@"cover_photo_url"];
        NSDictionary *avatar=[profile objectForKey:@"avatars"];
        _localUser.profile_avatar_thumb=[avatar objectForKey:@"small"];
        _localUser.profile_avatar_original=[avatar objectForKey:@"original"];
        _localUser.bio=[profile objectForKey:@"bio"];
        if ([_localUser.bio isEqual:[NSNull null]]) {
            _localUser.bio=@"";
        }
        
        
        [self saveLocalUser:_localUser];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"checkLogin" object:_localUser];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateTopImage" object:_localUser];
        //      NSLog(@"Submit response data: %@", responseObject);
    } // success callback block
     
         failure:^(AFHTTPRequestOperation *operation, NSError *error){
             NSLog(@"Error: %@", error);} // failure callback block
     ];
    
    
}

-(void) performReport:(NSString *)postId
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    NSDictionary *feed=[[NSDictionary alloc] initWithObjectsAndKeys: nil];
    NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:_localUser.secret_id, @"secret_id", _localUser.auth_token, @"auth_token", feed, @"feed",@"Flagged from mobile.", @"content",postId, @"id", nil];
    NSString *url= [NSString stringWithFormat:@"%@%@%@",_feedsUrl, postId,@"/report" ];
    [manager POST: url parameters:jsonDict success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        _responseDic= responseObject;
        
        
        //      NSLog(@"Submit response data: %@", responseObject);
    } // success callback block
     
            failure:^(AFHTTPRequestOperation *operation, NSError *error){
                NSLog(@"Error: %@", error);} // failure callback block
     ];
    
}


-(void) performDelete:(NSString *)postId
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:_localUser.secret_id, @"secret_id", _localUser.auth_token, @"auth_token", nil];
    NSString *url= [NSString stringWithFormat:@"%@%@",_feedsUrl, postId  ];
    [manager DELETE: url parameters:jsonDict success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        _responseDic= responseObject;
        UIAlertView *alert = [[ UIAlertView alloc ] initWithTitle : @"Delete Sucess"
                                                          message : @"" delegate : nil cancelButtonTitle : @"OK"
                                                otherButtonTitles : nil ];
        [alert show ];

      
        
        //      NSLog(@"Submit response data: %@", responseObject);
    } // success callback block
     
          failure:^(AFHTTPRequestOperation *operation, NSError *error){
              NSLog(@"Error: %@", error);} // failure callback block
     ];
    
}

-(void) performEndorse:(NSString *)postId
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:_localUser.secret_id, @"secret_id", _localUser.auth_token, @"auth_token", nil];
    NSString *url= [NSString stringWithFormat:@"%@%@%@",_feedsUrl, postId ,@"/endorse" ];
    [manager POST: url parameters:jsonDict success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        _responseDic= responseObject;
    

        //      NSLog(@"Submit response data: %@", responseObject);
    } // success callback block
     
          failure:^(AFHTTPRequestOperation *operation, NSError *error){
              NSLog(@"Error: %@", error);} // failure callback block
     ];

}

-(void) performShare:(NSString *) postText withId:(NSString *) postId
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    
    NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:_localUser.secret_id, @"secret_id", _localUser.auth_token, @"auth_token", postText, @"share_message",@"true", @"share_to_me",nil];
    NSString *url= [NSString stringWithFormat:@"%@%@%@",_feedsUrl, postId ,@"/share" ];
    [manager POST: url parameters:jsonDict success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        _responseDic= responseObject;
        
        UIAlertView *alert = [[ UIAlertView alloc ] initWithTitle : @"Share Sucess"
                                                          message : @"" delegate : nil cancelButtonTitle : @"OK"
                                                otherButtonTitles : nil ];
        [alert show ];

     //   [[NSNotificationCenter defaultCenter] postNotificationName:@"postFinished" object:nil];
        
        //      NSLog(@"Submit response data: %@", responseObject);
    } // success callback block
     
          failure:^(AFHTTPRequestOperation *operation, NSError *error){
              NSLog(@"Error: %@", error);} // failure callback block
     ];
    
}



-(void) performComment:(NSString *) postText withId:(NSString *) postId
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
   
    NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:_localUser.secret_id, @"secret_id", _localUser.auth_token, @"auth_token", postText, @"text",
                             nil];
    NSString *url= [NSString stringWithFormat:@"%@%@%@",_feedsUrl, postId ,@"/comments" ];
    [manager POST: url parameters:jsonDict success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        _responseDic= responseObject;
 
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"postFinished" object:nil];
        
        //      NSLog(@"Submit response data: %@", responseObject);
    } // success callback block
     
          failure:^(AFHTTPRequestOperation *operation, NSError *error){
              NSLog(@"Error: %@", error);} // failure callback block
     ];
    
}

-(void) performLike:(NSString *) postId
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:_localUser.secret_id, @"secret_id", _localUser.auth_token, @"auth_token",nil];
    
     NSString *url= [NSString stringWithFormat:@"%@%@%@",_feedsUrl, postId ,@"/like" ];
    [manager POST: url parameters:jsonDict success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        _responseDic= responseObject;
        
        
        
        
       // [[NSNotificationCenter defaultCenter] postNotificationName:@"likeFinished" object:nil];
        
        //      NSLog(@"Submit response data: %@", responseObject);
    } // success callback block
     
          failure:^(AFHTTPRequestOperation *operation, NSError *error){
              NSLog(@"Error: %@", error);} // failure callback block
     ];
    
}

-(void) performPostToAmazon:(NSDictionary *)feed
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    //   NSDictionary *photos_attributes= [[NSDictionary alloc] initWithObjectsAndKeys: nil];
    
    
    //    NSDictionary *feed= [[NSDictionary alloc] initWithObjectsAndKeys: postText, @"text",photos_attributes, @"photos_attributes", nil];
    NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:_localUser.secret_id, @"secret_id", _localUser.auth_token, @"auth_token",
                              feed, @"feed",nil];
    
    [manager POST: _amazonUrl parameters:jsonDict success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        _responseDic= responseObject;
        
        
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"makePostFinished" object:nil];
        
        //      NSLog(@"Submit response data: %@", responseObject);
    } // success callback block
     
          failure:^(AFHTTPRequestOperation *operation, NSError *error){
              NSLog(@"Error: %@", error);} // failure callback block
     ];
    
}

-(void) performPost:(NSDictionary *)feed
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    

    
    NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:_localUser.secret_id, @"secret_id", _localUser.auth_token, @"auth_token",
        feed, @"feed",nil];

    [manager POST: _postUrl parameters:jsonDict success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        _responseDic= responseObject;
        
        UIAlertView *alert = [[ UIAlertView alloc ] initWithTitle : @"Post Sucess"
                                                          message : @"" delegate : nil cancelButtonTitle : @"OK"
                                                otherButtonTitles : nil ];
        [alert show ];
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"makePostFinished" object:nil];
        
        //      NSLog(@"Submit response data: %@", responseObject);
    } // success callback block
     
          failure:^(AFHTTPRequestOperation *operation, NSError *error){
              NSLog(@"Error: %@", error);} // failure callback block
     ];

}

-(User *) performLogin: (User *) user
{
   
    
    User *tempUser= [[User alloc] init];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
      NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:user.email, @"email", user.password, @"password", @"undefined", @"secret_id", nil];
    
    [manager POST: _loginUrl parameters:jsonDict success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        _responseDic= responseObject;
       
        tempUser.auth_token= [_responseDic objectForKey:@"auth_token"];
        tempUser.secret_id= [_responseDic objectForKey:@"secret_id"];
        tempUser.email=user.email;
        tempUser.password=user.password;
        
        //not stored yet
    
        NSDictionary * userInfo=[_responseDic objectForKey:@"user_info"];
       
        NSDictionary * profile=[userInfo objectForKey:@"profile"];
        tempUser.cover_photo_url=[profile objectForKey:@"cover_photo_url"];
        NSDictionary *avatar=[profile objectForKey:@"avatars"];
        tempUser.profile_avatar_thumb=[avatar objectForKey:@"thumb"];
        NSNumber * user_id=[userInfo objectForKey:@"id"];
        tempUser.user_id= [user_id stringValue];
        tempUser.name= [userInfo objectForKey:@"full_name"];
        
        [self saveLocalUser:tempUser];
        self.localUser=tempUser;
        
        
        [self getUserProfile:_localUser];
        
       
        
        //      NSLog(@"Submit response data: %@", responseObject);
    } // success callback block
    failure:^(AFHTTPRequestOperation *operation, NSError *error){
        self.localUser=tempUser;
              NSLog(@"Error: %@", error);

        NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:user.email, @"email",@"true", @"mobile",nil];
        NSString *url= [NSString stringWithFormat:@"%@%@",[[UserManager sharedUserManager] homeFeedUrl], @"unique_email"];
        [manager GET: url parameters:jsonDict success:^(AFHTTPRequestOperation *operation, id responseObject){
            
            NSDictionary * responseDic= responseObject;
            NSNumber *unique= [responseDic objectForKey:@"is_unique"];
       
            if ([[unique stringValue] isEqualToString:@"1"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"openNextpage" object:@"signUp"];
            
            }else
            {
         
            UIAlertView *alert = [[ UIAlertView alloc ] initWithTitle : @"Could not log in"
                                                                          message : @"Invalid username/password." delegate : nil cancelButtonTitle : @"OK"
                                                                otherButtonTitles : nil ];
            [alert show ];
            }

            
        } // success callback block
             failure:^(AFHTTPRequestOperation *operation, NSError *error){
                 NSLog(@"Error: %@", error);} // failure callback block
         ];

        
     //   [self performva]
    } // failure callback block
     
     ];

    
    return tempUser;
}

-(void) performLogout: (User *) user
{
    
   
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:user.auth_token, @"auth_token", user.secret_id, @"secret_id", nil];
    
    [manager DELETE:_logoutUrl parameters:jsonDict success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        _responseDic= responseObject;

        [self deleteDataLocally];
         self.localUser=nil;
         [[NSNotificationCenter defaultCenter] postNotificationName:@"leftSideMenuAction" object:@"5"];
        
        NSLog(@"logout response data: %@", responseObject);
    } // success callback block
     
          failure:^(AFHTTPRequestOperation *operation, NSError *error){
       
              NSLog(@"Error: %@", error);} // failure callback block
     ];
    
    FBSession* session = [FBSession activeSession];
    [session closeAndClearTokenInformation];
    [session close];
    [FBSession setActiveSession:nil];
    
    NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray* facebookCookies = [cookies cookiesForURL:[NSURL         URLWithString:@"https://facebook.com/"]];
    
    for (NSHTTPCookie* cookie in facebookCookies) {
        [cookies deleteCookie:cookie];
    }
    
}



-(void) deleteDataLocally
{
    
    NSFetchRequest * UserFetched = [[NSFetchRequest alloc] init];
    [UserFetched setEntity:[NSEntityDescription entityForName:@"LocalUser" inManagedObjectContext:_context]];
    [UserFetched setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    
    NSError * error = nil;
    NSArray * users = [_context executeFetchRequest:UserFetched error:&error];
    
    for (NSManagedObject * user in users) {
        [_context deleteObject:user];
    }
    NSError *saveError = nil;
    [_context save:&saveError];
    
    
    //more error handling here
}

- (void) setContext: (NSManagedObjectContext *) con
{
    _context=con;
}

- (void) setLocalUser:(User *)User{
    
    _localUser=User;
}


- (void) saveLocalUser: (User *) localUser
{
    [self deleteDataLocally];
    LocalUser *user = [NSEntityDescription insertNewObjectForEntityForName:@"LocalUser"
                                                    inManagedObjectContext:_context];
    user.auth_token= localUser.auth_token;
    user.secret_id=localUser.secret_id;
    user.user_id=localUser.user_id;
    user.email=localUser.email;
    user.password=localUser.password;
    
    NSError *error;
    if (![_context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    
}

-(User *) getUserLocally
{
    
    NSError *error;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"LocalUser"
                                              inManagedObjectContext:_context];
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [_context executeFetchRequest:fetchRequest error:&error];
    
    User *user= [[User alloc] init];
    
    for (LocalUser *result in fetchedObjects) {
        user.auth_token= result.auth_token;
        user.secret_id=result.secret_id;
        user.user_id=result.user_id;
        user.email=result.email;
        user.password=result.password;
    }
    
    _localUser=user;
    return user;
}


-(void) performUpdatePrivacy:(User *) user
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    
    NSString *url= [NSString stringWithFormat:@"%@%@",_clientUrl, @"/api/users/update_privacy" ];
 //   NSDictionary *privacy = [[NSDictionary alloc] initWithObjectsAndKeys:user.bio, @"bio", user.location, @"location", user.phone, @"phone",user.website, @"website",nil];
    
    
    NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:_localUser.secret_id, @"secret_id", _localUser.auth_token, @"auth_token", user.hide_global_privacy, @"global_privacy", user.hide_location, @"location", user.hide_email, @"email", user.hide_phone, @"phone", user.hide_website, @"website", user.hide_facebook, @"facebook",user.hide_twitter, @"twitter", user.hide_linkedin, @"linkedin",user.hide_google, @"google", user.hide_instagram, @"instagram",nil];
    
    [manager PUT: url parameters:jsonDict success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        _responseDic= responseObject;
        
        
        UIAlertView *alert = [[ UIAlertView alloc ] initWithTitle : @"Save Sucess"
                                                          message : @"Update privacy sucess" delegate : nil cancelButtonTitle : @"OK"
                                                otherButtonTitles : nil ];
        [alert show ];
        

        
     
    } // success callback block
     
         failure:^(AFHTTPRequestOperation *operation, NSError *error){
             NSLog(@"Error: %@", error);} // failure callback block
     ];
    
}

-(void) performUpdate:(User *) user
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    
    NSString *url= [NSString stringWithFormat:@"%@%@%@",_clientUrl, @"/api/users/",user.user_id ];
    NSDictionary *profile = [[NSDictionary alloc] initWithObjectsAndKeys:user.bio, @"bio", user.location, @"location", user.phone, @"phone",user.website, @"website",nil];
    
    
    NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:_localUser.secret_id, @"secret_id", _localUser.auth_token, @"auth_token", profile, @"profile_attributes", user.name, @"full_name",user.email, @"email",@"", @"password",user.profile_avatar_original, @"profile_photo_url",@"true", @"mobile",@"true", @"ios_app",nil];
    
    [manager PUT: url parameters:jsonDict success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        _responseDic= responseObject;
        
        
        _localUser.profile_avatar_original=user.profile_avatar_original;
        _localUser.profile_avatar_thumb=user.profile_avatar_original;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"makeUpdateFinished" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateTopImage" object:_localUser];
        //      NSLog(@"Submit response data: %@", responseObject);
    } // success callback block
     
          failure:^(AFHTTPRequestOperation *operation, NSError *error){
              NSLog(@"Error: %@", error);} // failure callback block
     ];
    
}



- (id)init;{
    
    self = [super init];
    if (self) {

    }
    _clientUrl= @"http://staging.fitmoo.com";
    _loginUrl= @"http://staging.fitmoo.com/api/tokens";
    _homeFeedUrl= @"http://staging.fitmoo.com/api/users/";
    _logoutUrl=@"http://staging.fitmoo.com/api/tokens/delete_token?";
    _postUrl=@"http://staging.fitmoo.com/api/users/feeds";
    _feedsUrl=@"http://staging.fitmoo.com/api/feeds/";
    _amazonUrl= @"https://fitmoo-staging.s3.amazonaws.com/";
    
//    _clientUrl= @"http://uat.fitmoo.com";
//    _loginUrl= @"http://uat.fitmoo.com/api/tokens";
//    _homeFeedUrl= @"http://uat.fitmoo.com/api/users/";
//    _logoutUrl=@"http://uat.fitmoo.com/api/tokens/delete_token?";
//    _postUrl=@"http://uat.fitmoo.com/api/users/feeds";
//    _feedsUrl=@"http://uat.fitmoo.com/api/feeds/";
//    _amazonUrl= @"https://fitmoo-staging.s3.amazonaws.com/";
    
    
    _amazonUploadUrl= @"https://s3.amazonaws.com/fitmoo-staging-test/photos/";
    
    
    _s3_accountId=@"074088242106";
    _s3_identityPoolId=@"us-east-1:ac2dffe3-21e1-4c8d-b370-9466c23538dc";
    _s3_unauthRoleArn=@"arn:aws:iam::074088242106:role/Cognito_fitmoo_appUnauth_Role";
    _s3_authRoleArn=@"arn:aws:iam::074088242106:role/Cognito_fitmoo_appAuth_Role";
    
    return self;
}





@end

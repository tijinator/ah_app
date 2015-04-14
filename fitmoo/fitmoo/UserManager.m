//
//  UserManager.m
//  fitmoo
//
//  Created by hongjian lin on 4/8/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import "UserManager.h"

@implementation UserManager

+ (id)sharedUserManager;
{
    static dispatch_once_t pred;
    static UserManager *mFUserManagement = nil;
    
    dispatch_once(&pred, ^{ mFUserManagement = [[self alloc] init]; });
    return mFUserManagement;
    
}

-(void) getUserProfile
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];

    
    NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:_localUser.secret_id, @"secret_id", _localUser.auth_token, @"auth_token",@"true", @"mobile",nil];
    NSString *url= [NSString stringWithFormat:@"%@%@",@"http://staging.fitmoo.com/api/users/", _localUser.user_id];
    [manager GET: url parameters:jsonDict success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        _responseDic= responseObject;
        
         NSNumber * following=[_responseDic objectForKey:@"following"];
        _localUser.following= [following stringValue];
         NSNumber * followers=[_responseDic objectForKey:@"followers"];
        _localUser.followers= [followers stringValue];
         NSNumber * communities=[_responseDic objectForKey:@"communities"];
        _localUser.communities= [communities stringValue];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"checkLoginScuess" object:_localUser];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateTopImage" object:_localUser.cover_photo_url];
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
    NSString *url= [NSString stringWithFormat:@"%@%@%@",_shareUrl, postId ,@"/share" ];
    [manager POST: url parameters:jsonDict success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        _responseDic= responseObject;
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"postFinished" object:nil];
        
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
    NSString *url= [NSString stringWithFormat:@"%@%@%@",_commentUrl, postId ,@"/comments" ];
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
    
     NSString *url= [NSString stringWithFormat:@"%@%@%@",_likeUrl, postId ,@"/like" ];
    [manager POST: url parameters:jsonDict success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        _responseDic= responseObject;
        
        
        
        
       // [[NSNotificationCenter defaultCenter] postNotificationName:@"likeFinished" object:nil];
        
        //      NSLog(@"Submit response data: %@", responseObject);
    } // success callback block
     
          failure:^(AFHTTPRequestOperation *operation, NSError *error){
              NSLog(@"Error: %@", error);} // failure callback block
     ];
    
}


-(void) performPost:(NSString *) postText
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    NSDictionary *photos_attributes= [[NSDictionary alloc] initWithObjectsAndKeys: nil];
    NSDictionary *feed= [[NSDictionary alloc] initWithObjectsAndKeys: postText, @"text",photos_attributes, @"photos_attributes", nil];
    NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:_localUser.secret_id, @"secret_id", _localUser.auth_token, @"auth_token", postText, @"text",
        feed, @"feed",nil];
    
    [manager POST: _postUrl parameters:jsonDict success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        _responseDic= responseObject;
        
      
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"postFinished" object:nil];
        
        //      NSLog(@"Submit response data: %@", responseObject);
    } // success callback block
     
          failure:^(AFHTTPRequestOperation *operation, NSError *error){
              NSLog(@"Error: %@", error);} // failure callback block
     ];

}

-(void) performLogin: (User *) user
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
        
        
        [self getUserProfile];
        //      NSLog(@"Submit response data: %@", responseObject);
    } // success callback block
     
          failure:^(AFHTTPRequestOperation *operation, NSError *error){
        self.localUser=tempUser;
              NSLog(@"Error: %@", error);} // failure callback block
     ];

    
   
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
    
    
    return user;
}


- (id)init;{
    
    self = [super init];
    if (self) {

    }
    _clientUrl= @"http://staging.fitmoo.com";
    _loginUrl= @"http://staging.fitmoo.com/api/tokens";
    _homeFeedUrl= @"http://staging.fitmoo.com/api/users/";
    
   // _homeFeedUrl= @"http://staging.fitmoo.com/api/users/3952/feeds?";
    
    _logoutUrl=@"http://staging.fitmoo.com/api/tokens/delete_token?";
 
    _postUrl=@"http://staging.fitmoo.com/api/users/feeds";
    
    _commentUrl=@"http://staging.fitmoo.com/api/feeds/";
    _likeUrl=@"http://staging.fitmoo.com/api/feeds/";
    _shareUrl= @"http://staging.fitmoo.com/api/feeds/";
    return self;
}





@end

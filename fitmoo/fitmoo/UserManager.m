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
        
        NSDictionary * userInfo=[_responseDic objectForKey:@"user_info"];

        NSNumber * user_id=[userInfo objectForKey:@"id"];
        tempUser.user_id= [user_id stringValue];
        
        [self saveLocalUser:tempUser];
        
        self.localUser=tempUser;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"checkLoginScuess" object:tempUser];
        
        //      NSLog(@"Submit response data: %@", responseObject);
    } // success callback block
     
          failure:^(AFHTTPRequestOperation *operation, NSError *error){
        self.localUser=tempUser;
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
    _loginUrl= @"http://staging.fitmoo.com/api/tokens";
    _homeFeedUrl= @"http://staging.fitmoo.com/api/users/";
    return self;
}





@end

//
//  FitmooHelper.m
//  fitmoo
//
//  Created by hongjian lin on 4/7/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import "FitmooHelper.h"

@implementation FitmooHelper

+ (FitmooHelper*)sharedInstance
{
    static dispatch_once_t pred;
    static FitmooHelper *settings = nil;
    
    dispatch_once(&pred, ^{ settings = [[self alloc] init]; });
    return settings;
    
}

- (CGRect) resizeFrameWithFrame:(UIView *) view  respectToSuperFrame: (UIView *) superView
{
    if (superView!=nil) {
         double Radio= superView.frame.size.width / 320;
         view.frame= CGRectMake(view.frame.origin.x * Radio, view.frame.origin.y * Radio, view.frame.size.width * Radio, view.frame.size.height*Radio);
    }else
    {
        double Radio= self.screenSizeView.frame.size.width/320;
        view.frame= CGRectMake(view.frame.origin.x * Radio, view.frame.origin.y * Radio, view.frame.size.width * Radio, view.frame.size.height*Radio);
    }
   
    
   
    
    return view.frame;
}

-(HomeFeed *) generateHomeFeed: (NSDictionary *) dic
{
    HomeFeed * homeFeed= [[HomeFeed alloc] init];
    
    NSNumber * feed_id=[dic objectForKey:@"id"];
    homeFeed.feed_id= [feed_id stringValue];
    homeFeed.text= [dic objectForKey:@"text"];
    homeFeed.community_id=[dic objectForKey:@"community_id"];
    
    
   
  
    homeFeed.community_name= [dic objectForKey:@"community_name"];
    homeFeed.community_cover_photo= [dic objectForKey:@"community_cover_photo"];
    
    NSNumber * created_at=[dic objectForKey:@"created_at"];
    if (created_at!=nil) {
        homeFeed.created_at= [created_at stringValue];
    }
    
    
    
    NSNumber * updated_at=[dic objectForKey:@"updated_at"];
    
    if (updated_at!=nil) {
         homeFeed.updated_at= [updated_at stringValue];
    }
   
    
    NSNumber * total_comment=[dic objectForKey:@"total_comment"];
    
    if (total_comment!=nil) {
         homeFeed.total_comment= [total_comment stringValue];
    }
 
   
    NSNumber * total_like=[dic objectForKey:@"total_like"];
    if (total_like!=nil) {
        homeFeed.total_like= [total_like stringValue];
    }
  
    
    
    homeFeed.is_liked= [dic objectForKey:@"is_liked"];
    homeFeed.workout_title= [dic objectForKey:@"workout_title"];
    homeFeed.type= [dic objectForKey:@"type"];
    homeFeed.action_sheet= [dic objectForKey:@"action_sheet"];
    homeFeed.service= [dic objectForKey:@"service"];
    
    NSDictionary * photoArray= [dic objectForKey:@"photos"];
    if (photoArray !=nil) {
        for (NSDictionary *photoDic in photoArray) {
            
        }
    }
    
    
    
    return homeFeed;
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

- (void) setScreenSizeView:(UIView *)screenView
{
    _screenSizeView=screenView;
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


- (id) init;{
    
    if ((self = [super init])) {
    }
    
    _loginUrl= @"http://staging.fitmoo.com/api/tokens";
    _homeFeedUrl= @"http://staging.fitmoo.com/api/users/";
    
    
    return self;
}


@end
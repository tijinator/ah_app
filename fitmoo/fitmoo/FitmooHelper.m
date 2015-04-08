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
    double Radio= superView.frame.size.width / 320;
    
    view.frame= CGRectMake(view.frame.origin.x * Radio, view.frame.origin.y * Radio, view.frame.size.width * Radio, view.frame.size.height*Radio);
    
    return view.frame;
}

-(void) deleteDataLocally:(NSManagedObjectContext *) context
{
  
   
    NSFetchRequest * UserFetched = [[NSFetchRequest alloc] init];
    [UserFetched setEntity:[NSEntityDescription entityForName:@"Fuzz" inManagedObjectContext:context]];
    [UserFetched setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    
    NSError * error = nil;
    NSArray * users = [context executeFetchRequest:UserFetched error:&error];
    
    //error handling goes here
    for (NSManagedObject * user in users) {
        [context deleteObject:user];
    }
    NSError *saveError = nil;
    [context save:&saveError];
    //more error handling here
}


- (void) saveLocalUser: (LocalUser *) localUser withContent: (NSManagedObjectContext *) context
{
    [self deleteDataLocally: context];
    
    //get the context from appDelegate
  
    NSManagedObjectContext * localcontext = context;
    
    
   
        
    LocalUser *user = [NSEntityDescription insertNewObjectForEntityForName:@"LocalUser"
                                                   inManagedObjectContext:context];
   
    user.auth_token= localUser.auth_token;
    user.secret_id=localUser.secret_id;
    
    
        NSError *error;
        if (![context save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
        
    

}


- (id) init;{
    
    if ((self = [super init])) {
        
        
        
    }
    
    return self;
}


@end
//
//  User.m
//  fitmoo
//
//  Created by hongjian lin on 4/8/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import "User.h"

@implementation User : NSObject
@synthesize secret_id = _secret_id;
@synthesize auth_token = _auth_token;
@synthesize user_id = _user_id;
@synthesize email = _email;
@synthesize password = _password;

-(id)init
{
    _created_by_community= [[CreatedByCommunity alloc] init];
     _communityArray= [[NSMutableArray alloc] init];
    return self;
}

-(void) resetCommunity
{
    _created_by_community= [[CreatedByCommunity alloc] init];
    
}
@end

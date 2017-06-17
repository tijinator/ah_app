//
//  PeopleRequest.m
//  fitmoo
//
//  Created by hongjian lin on 6/17/17.
//  Copyright © 2017 com.fitmoo. All rights reserved.
//

#import "PeopleRequest.h"

@implementation PeopleRequest


+ (PeopleRequest *)requestWithPeople
{
    // All these global variables should be refactored and removed.
    
    return [PeopleRequest new];
}


- (NSDictionary *)parameters
{
    User *localUser= [[FitmooHelper sharedInstance] getUserLocally];
    
    NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:localUser.secret_id, @"secret_id", localUser.auth_token, @"auth_token", nil];
    
    return jsonDict;
}


- (NSString *)url
{
    return [NSString stringWithFormat:@"%@%@",[[UserManager sharedUserManager] clientUrl],@"/api/users/discover?keyword=&gender=&lat=&lng=&min=18&max=102"];
}


@end

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

+ (PeopleRequest *)requestWithOffsetPeople:(int) off
{
    // All these global variables should be refactored and removed.
    
    PeopleRequest * people = [PeopleRequest new];
    people.offset = off;
    
    return people;
}


- (NSDictionary *)infinityParameters
{
    User *localUser= [[FitmooHelper sharedInstance] getUserLocally];
    NSString *ofs= [NSString stringWithFormat:@"%i", _offset];

    NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:localUser.secret_id, @"secret_id", localUser.auth_token, @"auth_token",ofs, @"offset",@"10", @"limit",nil];
    return jsonDict;

}
- (NSDictionary *)parameters
{
    User *localUser= [[FitmooHelper sharedInstance] getUserLocally];
    
    NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:localUser.secret_id, @"secret_id", localUser.auth_token, @"auth_token", nil];
    
    return jsonDict;
}

- (NSString *)featureUrl
{
    return [NSString stringWithFormat:@"%@%@",[[UserManager sharedUserManager] clientUrl],@"/api/users/discover?keyword=&gender=&lat=&lng=&min=0&max=102tab=featured"];
}

- (NSString *)activeUrl
{
    return [NSString stringWithFormat:@"%@%@",[[UserManager sharedUserManager] clientUrl],@"/api/users/discover?keyword=&gender=&lat=&lng=&min=0&max=102tab=active"];
}

- (NSString *)productPeopleUrl
{
    return [NSString stringWithFormat:@"%@%@",[[UserManager sharedUserManager] clientUrl],@"/api/products/home_products.json"];
}



- (NSString *)url
{
    return [NSString stringWithFormat:@"%@%@",[[UserManager sharedUserManager] clientUrl],@"/api/users/discover?keyword=&gender=&lat=&lng=&min=18&max=102"];
}


@end

//
//  peoplePageService.m
//  fitmoo
//
//  Created by hongjian lin on 6/17/17.
//  Copyright © 2017 com.fitmoo. All rights reserved.
//

#import "PeoplePageService.h"

@implementation PeoplePageService


- (NSArray *)parsePeople:(NSArray *) results {
    
    NSMutableArray * peopleArray = [[NSMutableArray alloc] init];
    for (NSDictionary *result in results) {
        @try {
            
            User *tempUser= [[User alloc]  init];
            NSNumber * following=[result objectForKey:@"is_following"];
            tempUser.is_following= [following stringValue];
            NSNumber * followers=[result objectForKey:@"follower_count"];
            tempUser.followers= [followers stringValue];
            
            
            NSDictionary * profile=[result objectForKey:@"profile"];
            NSDictionary *avatar=[profile objectForKey:@"avatars"];
            tempUser.profile_avatar_thumb=[avatar objectForKey:@"medium"];
            
            tempUser.name= [result objectForKey:@"full_name"];
            NSNumber * user_id=[result objectForKey:@"id"];
            tempUser.user_id= [user_id stringValue];
            
            [peopleArray addObject:tempUser];
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }

    }
    
    return [peopleArray copy];
    
}


- (void)getTotalUserRequest:(PeopleRequest *_Nullable)request
                    success:(TotalListSuccessCallback _Nullable )success
                    failure:(ServiceFailureCallback _Nullable )failure{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager GET: request.url parameters:request.parameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSDictionary *dic = (NSDictionary *) responseObject;
        NSArray *leaderDic= [dic objectForKey:@"popular"];
        NSArray *featuredDic= [dic objectForKey:@"featured"];
        NSArray *activeDic= [dic objectForKey:@"active"];
        
        NSArray *leaderArray = [self parsePeople:leaderDic];
        NSArray *featureArray = [self parsePeople:featuredDic];
        NSArray *activeArray = [self parsePeople:activeDic];
        
        NSArray *resultArray = [NSArray arrayWithObjects: featureArray,activeArray,leaderArray, nil];
        success(resultArray);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
             NSLog(@"Error: %@", error);
             failure(error);
         }
     
     ];

}


@end

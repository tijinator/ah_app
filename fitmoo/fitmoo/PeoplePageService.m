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
            NSNumber * followers=[result objectForKey:@"followers"];
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

- (NSArray *)parseLeader:(NSArray *) results {
    
    NSMutableArray * peopleArray = [[NSMutableArray alloc] init];
    for (NSDictionary *leader in results) {
        @try {
            
            User *temUser= [[User alloc] init];
            temUser.name= [leader objectForKey:@"full_name"];
            
            NSNumber *days_a_week= [leader objectForKey:@"days_a_week"];
            temUser.days_a_week= [days_a_week stringValue];
            
            NSNumber *workout_count= [leader objectForKey:@"workout_count"];
            temUser.workout_count= [workout_count stringValue];
            NSNumber *user_id= [leader objectForKey:@"id"];
            temUser.user_id=[user_id stringValue];
            
            NSNumber *nutrition_count= [leader objectForKey:@"nutrition_count"];
            temUser.nutrition_count= [nutrition_count stringValue];
            
            NSDictionary *profile= [leader objectForKey:@"profile"];
            
            NSDictionary *avatars= [profile objectForKey:@"avatars"];
            temUser.profile_avatar_thumb= [avatars objectForKey:@"thumb"];
 
            [peopleArray addObject:temUser];
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
        
        NSArray *leaderArray = [self parseLeader:leaderDic];
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

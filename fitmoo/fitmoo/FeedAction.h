//
//  FeedAction.h
//  fitmoo
//
//  Created by hongjian lin on 4/10/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CreatedBy.h"
#import "CreatedByCommunity.h"

@interface FeedAction : NSObject

@property (nonatomic, strong) NSString *feed_action_id;
@property (nonatomic, strong) NSString *user_id;     //if not community_id, then use person who did the share
@property (nonatomic, strong) NSString *community_id;  //if community_id then us community_id first
@property (nonatomic, strong) NSString *share_message; //share message is on top of text message
@property (nonatomic, strong) NSString *action;      //three types: post, sharem endorse
@property (nonatomic, strong) CreatedBy *created_by;
@property (nonatomic, strong) CreatedByCommunity *created_by_community;
@end

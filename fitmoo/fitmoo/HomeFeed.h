//
//  HomeFeed.h
//  fitmoo
//
//  Created by hongjian lin on 4/10/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Photos.h"
#import "Comments.h"
#import "CreatedBy.h"
#import "CreatedByCommunity.h"
#import "FeedAction.h"
#import "TitleInfo.h"
#import "Product.h"
#import "Nutrition.h"
#import "Videos.h"
#import "Event.h"

@interface HomeFeed : NSObject
@property (nonatomic, strong) NSString *notification_id;
@property (nonatomic, strong) NSString *feed_id;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *community_id;
@property (nonatomic, strong) NSString *community_name;
@property (nonatomic, strong) Photos *photos;
@property (nonatomic, strong) NSMutableArray * photoArray;
@property (nonatomic, strong) NSMutableArray * AsycImageViewArray;

@property (nonatomic, strong) Comments *comments;
@property (nonatomic, strong) NSMutableArray * commentsArray;
@property (nonatomic, strong) CreatedBy *created_by;
@property (nonatomic, strong) CreatedByCommunity *created_by_community;
@property (nonatomic, strong) NSString *community_cover_photo;  //not used
@property (nonatomic, strong) NSString *created_at;

@property (nonatomic, strong) NSString *updated_at;
@property (nonatomic, strong) NSString *total_comment;
@property (nonatomic, strong) NSString *total_like;
@property (nonatomic, strong) NSString *is_liked;
@property (nonatomic, strong) NSString *workout_title;

@property (nonatomic, strong) FeedAction *feed_action;
@property (nonatomic, strong) TitleInfo *title_info;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) Product *product;
@property (nonatomic, strong) NSString *action_sheet;

@property (nonatomic, strong) NSObject *service;    //not used
@property (nonatomic, strong) Nutrition *nutrition;
@property (nonatomic, strong) Videos *videos;
@property (nonatomic, strong) NSMutableArray * videosArray;

@property (nonatomic, strong) Event *event;


@property (nonatomic, strong) NSString * confirmation_id;
@property (nonatomic, strong) NSString * confirmation_token;

-(void) resetAsycImageViewArray;
-(id)init;
-(void) resetCommentsArray;
-(void) resetPhotoArray;
-(void) resetComments;
-(void) resetPhotos;
-(void) resetVideos;
@end

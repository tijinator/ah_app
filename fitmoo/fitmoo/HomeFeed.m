//
//  HomeFeed.m
//  fitmoo
//
//  Created by hongjian lin on 4/10/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import "HomeFeed.h"

@implementation HomeFeed

-(id)init
{
    _photos= [[Photos alloc] init];
    _photoArray= [[NSMutableArray alloc] init];
    _comments=[[Comments alloc] init];
    _commentsArray= [[NSMutableArray alloc] init];
    _created_by=[[CreatedBy alloc] init];
    _created_by_community=[[CreatedByCommunity alloc] init];
    
    _feed_action=[[FeedAction alloc] init] ;
    _title_info= [[TitleInfo alloc] init];
    _product= [[Product alloc] init];
    _nutrition= [[Nutrition alloc] init];
    _videos= [[Videos alloc] init];
    _videosArray= [[NSMutableArray alloc] init];
    _event= [[Event alloc] init];
    return self;
}
-(void) resetVideos
{
    _videos=[[Videos alloc] init];
}
-(void) resetComments
{
    _comments= [[Comments alloc] init];
}
-(void) resetCommentsArray
{
    _commentsArray= [[NSMutableArray alloc] init];
}

-(void) resetPhotoArray
{
    _photoArray= [[NSMutableArray alloc] init];
   
}

-(void) resetAsycImageViewArray
{
   
    _AsycImageViewArray=[[NSMutableArray alloc] init];
}

-(void) resetPhotos
{
    _photos= [[Photos alloc] init];
  //  _photoArray= [[NSMutableArray alloc] init];
}

@end

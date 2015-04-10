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
    _feed_action=[[FeedAction alloc] init] ;
    _title_info= [[TitleInfo alloc] init];
    _product= [[Product alloc] init];
    _nutrition= [[Nutrition alloc] init];
    _videos= [[Videos alloc] init];
    _event= [[Event alloc] init];
    return self;
}


@end

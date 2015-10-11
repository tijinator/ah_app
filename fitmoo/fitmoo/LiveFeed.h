//
//  LiveFeed.h
//  fitmoo
//
//  Created by hongjian lin on 10/11/15.
//  Copyright © 2015 com.fitmoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Comments.h"
@interface LiveFeed : NSObject

@property (nonatomic, retain) NSString * live_feed_id;
@property (nonatomic, retain) NSString * live_stream_video_id;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSString * stream_start;
@property (nonatomic, retain) NSString * stream_image_url;

//advertisement
@property (nonatomic, retain) NSString * company;
@property (nonatomic, retain) NSString * advertisement_id;
@property (nonatomic, retain) NSString * logo_image_url;
@property (nonatomic, retain) NSString * tagline_text;
@property (nonatomic, retain) NSString * updated_at;
@property (nonatomic, retain) NSString * logo_link_url;

@property (nonatomic, retain) NSString * banner_link_url;
@property (nonatomic, retain) NSString * app_banner_image_url;


-(void) resetComments;

@property (nonatomic, retain) Comments * comments;
@property (nonatomic, retain) NSMutableArray * commentsArray;

@end

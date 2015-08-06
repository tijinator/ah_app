//
//  Workout.h
//  fitmoo
//
//  Created by hongjian lin on 7/20/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Workout : NSObject
@property (nonatomic, strong) NSString *workout_id;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *workout_type;
@property (nonatomic, strong) NSString *detail;
@property (nonatomic, strong) NSString *rank;

@property (nonatomic, strong) NSString *feed_id;
@property (nonatomic, strong) NSString *begin_time;
@property (nonatomic, strong) NSString *end_time;
@property (nonatomic, strong) NSString *is_owner;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *is_repeated;

@property (nonatomic, strong) NSString *style_url;
@property (nonatomic, strong) NSString *video_style_url;

@end

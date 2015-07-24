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

@end

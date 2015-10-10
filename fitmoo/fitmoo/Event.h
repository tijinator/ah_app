//
//  Event.h
//  fitmoo
//
//  Created by hongjian lin on 4/10/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Event : NSObject

@property (nonatomic, strong) NSString *event_id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *begin_time;
@property (nonatomic, strong) NSString *end_time;
@property (nonatomic, strong) NSString *theme;   //picture for event
@property (nonatomic, strong) NSString *peopleAttending;

@property (nonatomic, strong) NSString *total_attendees;
@property (nonatomic, strong) NSString *is_joined;
@property (nonatomic, strong) NSString *event_instance_id;
@property (nonatomic, strong) NSString *price;



@end

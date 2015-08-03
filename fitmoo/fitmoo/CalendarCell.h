//
//  CalendarCell.h
//  fitmoo
//
//  Created by hongjian lin on 7/27/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarViewController.h"
#import "CalendarSubCell.h"
#import "Workout.h"
@interface CalendarCell : UITableViewCell


@property (strong, nonatomic) UIView *buttomView;
@property (strong, nonatomic) UITableView *calendarTableview;
@property (strong, nonatomic) NSString *calendarModleType;
@property (strong, nonatomic) NSDate *dateSelected;
@property (strong, nonatomic) NSMutableArray *calendarArray;
- (IBAction)didChangeModeTouch;
- (void) CreateCalendarManager;
- (void) addNoWorkoutLabel;
@end

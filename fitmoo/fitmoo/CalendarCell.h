//
//  CalendarCell.h
//  fitmoo
//
//  Created by hongjian lin on 7/27/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarViewController.h"
@interface CalendarCell : UITableViewCell


@property (strong, nonatomic) UIView *buttomView;
@property (strong, nonatomic) UITableView *tableview;
@property (strong, nonatomic) NSString *calendarModleType;
@property (strong, nonatomic) NSDate *dateSelected;
- (IBAction)didChangeModeTouch;
@end

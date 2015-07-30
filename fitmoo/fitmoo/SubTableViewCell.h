//
//  SubTableViewCell.h
//  fitmoo
//
//  Created by hongjian lin on 7/28/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarSubCell.h"
@interface SubTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UITableView *calendarTableview;
@property (strong, nonatomic) NSMutableArray *calendarArray;
@property (strong, nonatomic) NSMutableArray *SelectedcalendarArray;
@property (strong, nonatomic) NSMutableArray *SelectedWkArray;
@property (strong, nonatomic) NSDate *dateSelected;
- (void) defineWorkoutsForSelectedToday;
@end

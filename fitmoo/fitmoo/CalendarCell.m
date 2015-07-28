//
//  CalendarCell.m
//  fitmoo
//
//  Created by hongjian lin on 7/27/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import "CalendarCell.h"
#import <JTCalendar/JTCalendar.h>
#import "FitmooHelper.h"
@interface CalendarCell ()<JTCalendarDelegate>
{
    NSMutableDictionary *_eventsByDate;
    
    NSDate *_todayDate;
    NSDate *_minDate;
    NSDate *_maxDate;
    
 //   NSDate *_dateSelected;
}

@property (strong, nonatomic) IBOutlet JTCalendarMenuView *calendarMenuView;
@property (strong, nonatomic) IBOutlet JTHorizontalCalendarView *calendarContentView;

@property (strong, nonatomic) JTCalendarManager *calendarManager;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *calendarContentViewHeight;

@end

@implementation CalendarCell

- (void)awakeFromNib {
    
    
    
    _calendarManager = [JTCalendarManager new];
    _calendarManager.delegate = self;
    
    // Generate random events sort by date using a dateformatter for the demonstration
    [self createRandomEvents];
    
    // Create a min and max date for limit the calendar, optional
    [self createMinAndMaxDate];
    [self initFrames];
    [_calendarManager setMenuView:_calendarMenuView];
    [_calendarManager setContentView:_calendarContentView];
    [_calendarManager setDate:_todayDate];
    // Initialization code
}

- (void) initFrames
{
    
    self.contentView.frame=[[FitmooHelper sharedInstance] resizeFrameWithFrame:self.contentView respectToSuperFrame:nil];
    
    _calendarMenuView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_calendarMenuView respectToSuperFrame:nil];
    
    _calendarContentView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_calendarContentView respectToSuperFrame:nil];

//    if ([self.calendarModleType isEqualToString:@"day"]) {
//        [self didChangeModeTouch];
//    }
    
    _buttomView= [[UIView alloc] initWithFrame:_calendarContentView.frame];
  
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark - Buttons callback

- (IBAction)didGoTodayTouch
{
    [_calendarManager setDate:_todayDate];
}

- (IBAction)didChangeModeTouch
{
    if ([self.calendarModleType isEqualToString:@"day"]) {
        _calendarManager.settings.weekModeEnabled = !_calendarManager.settings.weekModeEnabled;
        if (_dateSelected!=nil) {
            [_calendarManager setDate:_dateSelected];
        }
        [_calendarManager reload];
        
        CGFloat newHeight = 85*[[FitmooHelper sharedInstance] frameRadio];
        _calendarContentView.frame= CGRectMake(_calendarContentView.frame.origin.x, _calendarContentView.frame.origin.y, _calendarContentView.frame.size.width, newHeight);
        
//        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main1" bundle:nil];
//        CalendarViewController *CalendarView = [mainStoryboard instantiateViewControllerWithIdentifier:@"CalendarViewController"];
//      
//    
//        CalendarView.view.frame=CGRectMake(0, _calendarContentView.frame.size.height+_calendarContentView.frame.origin.y, 320*[[FitmooHelper sharedInstance] frameRadio], 400*[[FitmooHelper sharedInstance] frameRadio]);
//        [self.contentView addSubview:CalendarView.tableview];
//        
//        
//        _buttomView= [[UIView alloc] initWithFrame:CGRectMake(0, _calendarContentView.frame.size.height+_calendarContentView.frame.origin.y, 320*[[FitmooHelper sharedInstance] frameRadio], 400*[[FitmooHelper sharedInstance] frameRadio])];
        _buttomView= [[UIView alloc] initWithFrame: _calendarContentView.frame];
    }else{
        if (_dateSelected!=nil) {
              [_calendarManager setDate:_dateSelected];
        }
      
        [_calendarManager reload];
    }
  
  //  [_tableview reloadData];
  
}

#pragma mark - CalendarManager delegate

// Exemple of implementation of prepareDayView method
// Used to customize the appearance of dayView
- (void)calendar:(JTCalendarManager *)calendar prepareDayView:(JTCalendarDayView *)dayView
{
    if([dayView isFromAnotherMonth]&&![self.calendarModleType isEqualToString:@"day"]){
        dayView.hidden = YES;
    }else
    {
        dayView.hidden=false;
    }
    // Today
    if([_calendarManager.dateHelper date:[NSDate date] isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = [UIColor blueColor];
        dayView.dotView.backgroundColor = [UIColor whiteColor];
        dayView.textLabel.textColor = [UIColor whiteColor];
    }
    // Selected date
    else if(_dateSelected && [_calendarManager.dateHelper date:_dateSelected isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = [UIColor redColor];
        dayView.dotView.backgroundColor = [UIColor whiteColor];
        dayView.textLabel.textColor = [UIColor whiteColor];
    }
    // Other month
    else if(![_calendarManager.dateHelper date:_calendarContentView.date isTheSameMonthThan:dayView.date]){
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = [UIColor redColor];
        dayView.textLabel.textColor = [UIColor lightGrayColor];
    }
    // Another day of the current month
    else{
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = [UIColor redColor];
        dayView.textLabel.textColor = [UIColor blackColor];
    }
    
    if([self haveEventForDay:dayView.date]){
        dayView.dotView.hidden = NO;
    }
    else{
        dayView.dotView.hidden = YES;
    }
}

- (void)calendar:(JTCalendarManager *)calendar didTouchDayView:(JTCalendarDayView *)dayView
{
    _dateSelected = dayView.date;
    
    // Animation for the circleView
    dayView.circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
    [UIView transitionWithView:dayView
                      duration:.3
                       options:0
                    animations:^{
                        dayView.circleView.transform = CGAffineTransformIdentity;
                        [_calendarManager reload];
                    } completion:^(BOOL finished){
                    
             [[NSNotificationCenter defaultCenter] postNotificationName:@"calenderModelAction" object:@[@"day", _dateSelected]];
                    }];
    
    
//    // Load the previous or next page if touch a day from another month
//    
//    if(![_calendarManager.dateHelper date:_calendarContentView.date isTheSameMonthThan:dayView.date]){
//        if([_calendarContentView.date compare:dayView.date] == NSOrderedAscending){
//            [_calendarContentView loadNextPageWithAnimation];
//        }
//        else{
//            [_calendarContentView loadPreviousPageWithAnimation];
//        }
//    }
    
   
}

#pragma mark - CalendarManager delegate - Page mangement

// Used to limit the date for the calendar, optional
- (BOOL)calendar:(JTCalendarManager *)calendar canDisplayPageWithDate:(NSDate *)date
{
    return [_calendarManager.dateHelper date:date isEqualOrAfter:_minDate andEqualOrBefore:_maxDate];
}

- (void)calendarDidLoadNextPage:(JTCalendarManager *)calendar
{
    //    NSLog(@"Next page loaded");
}

- (void)calendarDidLoadPreviousPage:(JTCalendarManager *)calendar
{
    //    NSLog(@"Previous page loaded");
}

#pragma mark - Fake data

- (void)createMinAndMaxDate
{
    _todayDate = [NSDate date];
    
    // Min date will be 2 month before today
    _minDate = [_calendarManager.dateHelper addToDate:_todayDate months:-2];
    
    // Max date will be 2 month after today
    _maxDate = [_calendarManager.dateHelper addToDate:_todayDate months:2];
}

// Used only to have a key for _eventsByDate
- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"dd-MM-yyyy";
    }
    
    return dateFormatter;
}

- (BOOL)haveEventForDay:(NSDate *)date
{
    NSString *key = [[self dateFormatter] stringFromDate:date];
    
    if(_eventsByDate[key] && [_eventsByDate[key] count] > 0){
        return YES;
    }
    
    return NO;
    
}

- (void)createRandomEvents
{
    _eventsByDate = [NSMutableDictionary new];
    
    for(int i = 0; i < 30; ++i){
        // Generate 30 random dates between now and 60 days later
        NSDate *randomDate = [NSDate dateWithTimeInterval:(rand() % (3600 * 24 * 60)) sinceDate:[NSDate date]];
        
        // Use the date as key for eventsByDate
        NSString *key = [[self dateFormatter] stringFromDate:randomDate];
        
        if(!_eventsByDate[key]){
            _eventsByDate[key] = [NSMutableArray new];
        }
        
        [_eventsByDate[key] addObject:randomDate];
    }
}



@end

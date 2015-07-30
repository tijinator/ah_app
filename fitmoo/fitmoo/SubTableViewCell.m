//
//  SubTableViewCell.m
//  fitmoo
//
//  Created by hongjian lin on 7/28/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import "SubTableViewCell.h"
#import "FitmooHelper.h"

@interface SubTableViewCell ()<UITableViewDataSource , UITableViewDelegate>
{

    double cellHeight;
    NSMutableArray * heightArray;
    //   NSDate *_dateSelected;
}

@end
@implementation SubTableViewCell

- (void)awakeFromNib {
    [self initFrames];
    // Initialization code
}

- (void) defineWorkoutsForSelectedToday
{
    _SelectedcalendarArray= [[NSMutableArray alloc] init];

    for (int i=0; i<25; i++) {
        _SelectedWkArray=[[NSMutableArray alloc] init];
        
        [_SelectedcalendarArray addObject:_SelectedWkArray];
    }
    
    for (int i=0; i<25; i++) {
         _SelectedWkArray=[[NSMutableArray alloc] init];
    for (Workout *wk in _calendarArray) {
        
        NSTimeInterval time=(NSTimeInterval ) wk.begin_time.intValue;
        NSDate *dateFromWk = [[NSDate alloc] initWithTimeIntervalSince1970:time];
      
        
        NSDateComponents *otherDay = [[NSCalendar currentCalendar] components:NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour fromDate:dateFromWk];
        NSDateComponents *selectedday = [[NSCalendar currentCalendar] components:NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour fromDate:_dateSelected];
        if([selectedday day] == [otherDay day] &&
           [selectedday month] == [otherDay month] &&
           [selectedday year] == [otherDay year] &&
           [selectedday era] == [otherDay era]) {
            
            
            NSTimeInterval time=(NSTimeInterval ) wk.begin_time.intValue;
            NSDate *beginDateFromWk = [[NSDate alloc] initWithTimeIntervalSince1970:time];
            NSDateComponents *beginday = [[NSCalendar currentCalendar] components:NSCalendarUnitEra | NSCalendarUnitHour fromDate:beginDateFromWk];
            
            NSTimeInterval time1=(NSTimeInterval ) wk.end_time.intValue;
            NSDate *endDateFromWk = [[NSDate alloc] initWithTimeIntervalSince1970:time1];
            NSDateComponents *endday = [[NSCalendar currentCalendar] components:NSCalendarUnitEra | NSCalendarUnitHour fromDate:endDateFromWk];
            
            if ([beginday hour]<=i && [endday hour]>=i) {
                [_SelectedWkArray addObject:wk];
            }

     //       NSMutableArray *wkArray= [_SelectedcalendarArray objectAtIndex:[otherDay hour]];
     //       [wkArray addObject:wk];
     //       [_SelectedcalendarArray replaceObjectAtIndex:[otherDay hour] withObject:wkArray];
            
        }
    }
        [_SelectedcalendarArray replaceObjectAtIndex:i withObject:_SelectedWkArray];
      }
    
    
    
//    for (int i=0; i<25; i++) {
//        _SelectedWkArray=[[NSMutableArray alloc] init];
//        for (Workout *wk in _SelectedcalendarArray) {
//            NSTimeInterval time=(NSTimeInterval ) wk.begin_time.intValue;
//            NSDate *beginDateFromWk = [[NSDate alloc] initWithTimeIntervalSince1970:time];
//            NSDateComponents *beginday = [[NSCalendar currentCalendar] components:NSCalendarUnitEra | NSCalendarUnitHour fromDate:beginDateFromWk];
//            
//            NSTimeInterval time1=(NSTimeInterval ) wk.begin_time.intValue;
//            NSDate *endDateFromWk = [[NSDate alloc] initWithTimeIntervalSince1970:time1];
//            NSDateComponents *endday = [[NSCalendar currentCalendar] components:NSCalendarUnitEra | NSCalendarUnitHour fromDate:endDateFromWk];
//            
//            if ([beginday hour]<=i && [endday hour]>=i) {
//                [_SelectedWkArray addObject:wk];
//            }
//            
//            
//        }
//        
//         [_SelectedcalendarArray addObject:_SelectedWkArray];
//        
//    }

    

    [self.calendarTableview reloadData];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    
    return 27;
    
}

- (NSString *) generateTimeString: (NSDateComponents *) dayCom
{
    NSString *timestring;
    NSString * minuteStr= [NSString stringWithFormat:@"%ld",(long)[dayCom minute]];
    NSString * secondStr= [NSString stringWithFormat:@"%ld",(long)[dayCom second]];
    NSString * hourStr= [NSString stringWithFormat:@"%ld",(long)[dayCom hour]];
    if ([dayCom minute]<10) {
        minuteStr= [NSString stringWithFormat:@"0%ld",(long)[dayCom minute]];
    }
    if ([dayCom second]<10) {
        secondStr= [NSString stringWithFormat:@"0%ld",(long)[dayCom second]];
    }
    
    if ([dayCom hour]<10) {
        hourStr= [NSString stringWithFormat:@"0%ld",(long)[dayCom hour]];
    }
    
    timestring= [NSString stringWithFormat:@"%@:%@:%@",hourStr, minuteStr, secondStr];
    
    
    return timestring;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CalendarSubCell *cell =(CalendarSubCell *) [self.calendarTableview cellForRowAtIndexPath:indexPath];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CalendarSubCell" owner:self options:nil];
        
        cell = [nib objectAtIndex:0];
    }else
    {
        return cell;
    }
    
    if (indexPath.row==0) {
        UILabel *timeLabel= (UILabel *)[cell viewWithTag:1];
        timeLabel.text=@"0 AM";
        UIView *detailView= (UIView *)[cell viewWithTag:2];
        detailView.hidden=true;
        return cell;
    }
    
    if (indexPath.row>24) {
        [cell.contentView.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
     //   cell.separatorInset=UITableViewCellSeparatorStyleNone;
        return cell;
    }
    
    NSString *time=[NSString stringWithFormat:@"%ld%@", (long)indexPath.row, @" AM"];
    if (indexPath.row>12) {
        time=[NSString stringWithFormat:@"%ld%@", (long)indexPath.row-12, @" PM"];
    }
    
    if (indexPath.row==24) {
          time=[NSString stringWithFormat:@"%ld%@", (long)0, @" AM"];
    }
    
    UILabel *timeLabel= (UILabel *)[cell viewWithTag:1];
    timeLabel.text=time;
    
//    UILabel *nameLabel= (UILabel *)[cell viewWithTag:3];
//    UILabel *locationLabel= (UILabel *)[cell viewWithTag:4];
//    locationLabel.hidden=true;
    
    UIView *detailView= (UIView *)[cell viewWithTag:2];
    NSMutableArray *wkArray= [_SelectedcalendarArray objectAtIndex:indexPath.row-1];
    [detailView.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    
    
    for (int i=0; i<[wkArray count]; i++) {
        Workout *wk= [wkArray objectAtIndex:i];
        NSTimeInterval time=(NSTimeInterval ) wk.begin_time.intValue;
        NSDate *begintime = [[NSDate alloc] initWithTimeIntervalSince1970:time];
        NSDateComponents *beginday = [[NSCalendar currentCalendar] components:NSCalendarUnitEra | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond  fromDate:begintime];
        
        NSTimeInterval time1=(NSTimeInterval ) wk.end_time.intValue;
        NSDate *endtime = [[NSDate alloc] initWithTimeIntervalSince1970:time1];
        NSDateComponents *endday = [[NSCalendar currentCalendar] components:NSCalendarUnitEra | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond  fromDate:endtime];
        
        
        detailView.hidden=false;
        
        NSString *beginTimeString=[self generateTimeString:beginday];
        
        NSString *endTimeString= [self generateTimeString:endday];
        
        UILabel *nameLabel=[[UILabel alloc] init];
        nameLabel.font=[UIFont fontWithName:@"BentonSans" size:(CGFloat)(13)];
        nameLabel.frame= CGRectMake(10,i*20+5, 262, 15);
        nameLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:nameLabel respectToSuperFrame:nil];
        nameLabel.textColor=[UIColor whiteColor];
        nameLabel.text= [NSString stringWithFormat:@"%@ %@ - %@", wk.name, beginTimeString, endTimeString];
        

        if ([beginday hour]==indexPath.row-1) {
            nameLabel.hidden=false;
        }else
        {
            nameLabel.hidden=true;
        }
        
        [detailView addSubview:nameLabel];
    
    }

    cellHeight=MAX(40*[[FitmooHelper sharedInstance]frameRadio], [wkArray count]*20*[[FitmooHelper sharedInstance]frameRadio]);
    
    detailView.frame=CGRectMake(detailView.frame.origin.x, detailView.frame.origin.y, detailView.frame.size.width, cellHeight);
    timeLabel.frame= CGRectMake(timeLabel.frame.origin.x, cellHeight-13*[[FitmooHelper sharedInstance] frameRadio], timeLabel.frame.size.width, timeLabel.frame.size.height);
    
    
    cell.clipsToBounds=NO;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView
estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    double height1=40*[[FitmooHelper sharedInstance]frameRadio];
    if (indexPath.row==0||indexPath.row>24) {
        return height1;
    }
    
    NSMutableArray *wkArray= [_SelectedcalendarArray objectAtIndex:indexPath.row-1];
    
    double height=[wkArray count]*20*[[FitmooHelper sharedInstance]frameRadio];
    
    
    
    return  MAX(height, height1);
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
}

// multy high table cell
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
      double height1=40*[[FitmooHelper sharedInstance]frameRadio];
    if (indexPath.row==0||indexPath.row>24) {
        return height1;
    }
    
    NSMutableArray *wkArray= [_SelectedcalendarArray objectAtIndex:indexPath.row-1];
    
    double height=[wkArray count]*20*[[FitmooHelper sharedInstance]frameRadio];
    
  
    
    return  MAX(height, height1);
}




- (void) initFrames
{
    
    self.contentView.frame=[[FitmooHelper sharedInstance] resizeFrameWithFrame:self.contentView respectToSuperFrame:nil];
    self.calendarTableview.delegate=self;
    self.calendarTableview.dataSource=self;

    
//    self.calendarTableview = ({
//        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320* [[FitmooHelper sharedInstance] frameRadio], 400*[[FitmooHelper sharedInstance] frameRadio]) style:UITableViewStylePlain];
//        tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
//        tableView.delegate = self;
//        tableView.dataSource = self;
//        tableView.opaque = NO;
//        tableView.backgroundColor = [UIColor blueColor];
//        tableView.backgroundView = nil;
//        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        tableView.bounces = NO;
//        tableView.scrollsToTop = NO;
//        tableView;
//    });
//    [self.contentView addSubview:self.calendarTableview];
    
    
   
   
    
}


@end

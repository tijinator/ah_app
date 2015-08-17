//
//  FollowLeaderBoardCell.m
//  fitmoo
//
//  Created by hongjian lin on 8/5/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import "FollowLeaderBoardCell.h"
#import "FitmooHelper.h"
#import "AsyncImageView.h"
@implementation FollowLeaderBoardCell

- (void)awakeFromNib {
    
    [self initFrames];
    _tempUser=[[User alloc] init];
    // Initialization code
}


- (void) buildCell
{
    _nameLabel.text=_tempUser.name;
    _workoutPostCount.text=_tempUser.workout_count;
    _workoutWeekCount.text=_tempUser.nutrition_count;
    
    _workoutPostLabel.textAlignment= NSTextAlignmentCenter;
    _workoutWeekLabel.textAlignment= NSTextAlignmentCenter;
    
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, _headerButton.frame.size.width, _headerButton.frame.size.height)];
    view.layer.cornerRadius=view.frame.size.width/2;
    view.clipsToBounds=YES;
    view.userInteractionEnabled = NO;
    view.exclusiveTouch = NO;

    
    AsyncImageView *headerImage = [[AsyncImageView alloc] initWithFrame:CGRectMake(0, 0, _headerButton.frame.size.width, _headerButton.frame.size.height)];
    headerImage.userInteractionEnabled = NO;
    headerImage.exclusiveTouch = NO;
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:headerImage];
    
  
    headerImage.imageURL =[NSURL URLWithString:_tempUser.profile_avatar_thumb];
        
    [view addSubview:headerImage];
    [_headerButton.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    [_headerButton addSubview:view];
    _headerButton.userInteractionEnabled = NO;
    _headerButton.exclusiveTouch = NO;
    
    
    
}

- (void) initFrames
{
    
 //   self.contentView.frame=[[FitmooHelper sharedInstance] resizeFrameWithFrame:self.contentView respectToSuperFrame:nil];
   
    _CountLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_CountLabel respectToSuperFrame:nil];
    
    _headerButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_headerButton respectToSuperFrame:nil];
    _nameLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_nameLabel respectToSuperFrame:nil];
    _workoutPostCount.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_workoutPostCount respectToSuperFrame:nil];
    
    _workoutWeekCount.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_workoutWeekCount respectToSuperFrame:nil];
    
    _workoutWeekLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_workoutWeekLabel respectToSuperFrame:nil];
    _workoutPostLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_workoutPostLabel respectToSuperFrame:nil];
    
    double radio= [[FitmooHelper sharedInstance] frameRadio];
    _seprelaterView.frame=CGRectMake(20*radio, 74*radio, 300*radio, 1);
    

    
    
   
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
 
  //  if (selected==true) {
        _CountLabel.backgroundColor=[UIColor colorWithRed:16.0/255.0 green:156.0/255.0 blue:251.0/255.0 alpha:1.0f];
        _CountLabel.textColor=[UIColor whiteColor];
        _workoutPostCount.textColor=[UIColor colorWithRed:16.0/255.0 green:156.0/255.0 blue:251.0/255.0 alpha:1.0f];
        _workoutWeekCount.textColor=[UIColor colorWithRed:16.0/255.0 green:156.0/255.0 blue:251.0/255.0 alpha:1.0f];
//    }else
//    {
//        _CountLabel.backgroundColor=[UIColor colorWithRed:194.0/255.0 green:202.0/255.0 blue:206.0/255.0 alpha:1.0f];
//        _CountLabel.textColor=[UIColor blackColor];
//        _workoutPostCount.textColor=[UIColor colorWithRed:128.0/255.0 green:148.0/255.0 blue:160.0/255.0 alpha:1.0f];
//        _workoutWeekCount.textColor=[UIColor colorWithRed:128.0/255.0 green:148.0/255.0 blue:160.0/255.0 alpha:1.0f];
//    }
    // Configure the view for the selected state
}

@end

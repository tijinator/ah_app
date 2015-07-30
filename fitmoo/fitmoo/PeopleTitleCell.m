//
//  PeopleTitleCell.m
//  fitmoo
//
//  Created by hongjian lin on 4/14/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import "PeopleTitleCell.h"

@implementation PeopleTitleCell

- (void)awakeFromNib {
     [self initFrames];
    
    int frameHeight= self.buttomView.frame.origin.y + self.buttomView.frame.size.height;
    self.contentView.frame= CGRectMake(self.contentView.frame.origin.x, self.contentView.frame.origin.y, self.contentView.frame.size.width, frameHeight);
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
   
    // Configure the view for the selected state
}

- (void) loadHeaderImage: (NSString *)url
{
    AsyncImageView *headerImage = [[AsyncImageView alloc] init];
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:headerImage];
    headerImage.imageURL =[NSURL URLWithString:url];
    self.headerImage.image=headerImage.image;

}

- (void) loadHeader1Image: (NSString *)url
{
    [self.headerImage1.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    
    AsyncImageView *headerImage1 = [[AsyncImageView alloc] initWithFrame:CGRectMake(0, 0, _headerImage1.frame.size.width, _headerImage1.frame.size.height)];
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:headerImage1];
    headerImage1.imageURL =[NSURL URLWithString:url];
   
    [self.headerImage1 addSubview:headerImage1];
    
}


- (void) setFrameForComunity
{
    double differentHeight=105*[[FitmooHelper sharedInstance] frameRadio];
    _headerImage1.frame=CGRectMake(0, _headerImage1.frame.origin.y, _headerImage1.frame.size.width, _headerImage1.frame.size.height-differentHeight);
    _shadowImageView.frame=CGRectMake(0, _shadowImageView.frame.origin.y-differentHeight, _shadowImageView.frame.size.width, _shadowImageView.frame.size.height);
    _followCountLabel.frame=CGRectMake(_followCountLabel.frame.origin.x, _followCountLabel.frame.origin.y-differentHeight, _followCountLabel.frame.size.width, _followCountLabel.frame.size.height);
    _followerCountLabel.frame=CGRectMake(_followerCountLabel.frame.origin.x, _followerCountLabel.frame.origin.y-differentHeight, _followerCountLabel.frame.size.width, _followerCountLabel.frame.size.height);
    _followerLabel.frame=CGRectMake(_followerLabel.frame.origin.x, _followerLabel.frame.origin.y-differentHeight, _followerLabel.frame.size.width, _followerLabel.frame.size.height);
    _followingLabel.frame=CGRectMake(_followingLabel.frame.origin.x, _followingLabel.frame.origin.y-differentHeight, _followingLabel.frame.size.width, _followingLabel.frame.size.height);
    _editProfileButton.frame=CGRectMake(_editProfileButton.frame.origin.x, _editProfileButton.frame.origin.y-differentHeight, _editProfileButton.frame.size.width, _editProfileButton.frame.size.height);
    _buttomView.frame=CGRectMake(_buttomView.frame.origin.x, _buttomView.frame.origin.y-differentHeight, _buttomView.frame.size.width, _buttomView.frame.size.height);
    

    
}

- (void) initFrames
{
    
    self.contentView.frame=[[FitmooHelper sharedInstance] resizeFrameWithFrame:self.contentView respectToSuperFrame:nil];
    
    
   
    
    _buttomView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_buttomView respectToSuperFrame:nil];
    
    _headerImage1.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_headerImage1 respectToSuperFrame:nil];
    _headerImage.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_headerImage respectToSuperFrame:nil];
    _nameLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_nameLabel respectToSuperFrame:nil];
    _followCountLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_followCountLabel respectToSuperFrame:nil];
    _followerCountLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_followerCountLabel respectToSuperFrame:nil];
    _communityCountLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_communityCountLabel respectToSuperFrame:nil];
    
    _followerLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_followerLabel respectToSuperFrame:nil];
    _followingLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_followingLabel respectToSuperFrame:nil];
    _communityLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_communityLabel respectToSuperFrame:nil];
    
    _feedButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_feedButton respectToSuperFrame:nil];
    
    _workoutButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_workoutButton respectToSuperFrame:nil];
    _storeButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_storeButton respectToSuperFrame:nil];
    _scheduleButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_scheduleButton respectToSuperFrame:nil];
   
    _topView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_topView respectToSuperFrame:nil];
    _bioButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_bioButton respectToSuperFrame:nil];
    _editProfileButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_editProfileButton respectToSuperFrame:nil];
    _buttonView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_buttonView respectToSuperFrame:nil];
    
    _backButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_backButton respectToSuperFrame:nil];
    _view1.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_view1 respectToSuperFrame:nil];
    _view2.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_view2 respectToSuperFrame:nil];
    _view3.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_view3 respectToSuperFrame:nil];
    _view4.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_view4 respectToSuperFrame:nil];
     _view5.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_view5 respectToSuperFrame:nil];
    
    _workoutLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_workoutLabel respectToSuperFrame:nil];
    _workoutCountLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_workoutCountLabel respectToSuperFrame:nil];
    
     _calendarButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_calendarButton respectToSuperFrame:nil];
    [self.contentView bringSubviewToFront:_view1];
    _shadowImageView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_shadowImageView respectToSuperFrame:nil];
    _bioLabel.frame= CGRectMake(0, 0, _bioButton.frame.size.width, _bioButton.frame.size.height);
 //   _headerImage1.layer.cornerRadius=_headerImage1.frame.size.width/2;
 //   _headerImage1.layer.masksToBounds = YES;
}



@end

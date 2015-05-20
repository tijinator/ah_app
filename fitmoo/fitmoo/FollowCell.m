//
//  FollowCell.m
//  fitmoo
//
//  Created by hongjian lin on 5/19/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import "FollowCell.h"

@implementation FollowCell

- (void)awakeFromNib {
      [self initFrames];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) initFrames
{
    
    self.contentView.frame=[[FitmooHelper sharedInstance] resizeFrameWithFrame:self.contentView respectToSuperFrame:nil];
   // _image.frame= CGRectMake(0, 0, 140, 120);
    
    _image1.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_image1 respectToSuperFrame:nil];
    _image2.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_image2 respectToSuperFrame:nil];
    
    _nameLabel1.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_nameLabel1 respectToSuperFrame:nil];
    _nameLabel2.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_nameLabel2 respectToSuperFrame:nil];
    
    _userIconImage1.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_userIconImage1 respectToSuperFrame:nil];
    _userIconImage2.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_userIconImage2 respectToSuperFrame:nil];
    
    _followLabel1.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_followLabel1 respectToSuperFrame:nil];
    _followLabel2.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_followLabel2 respectToSuperFrame:nil];
    
    _followButton1.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_followButton1 respectToSuperFrame:nil];
    _followButton2.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_followButton2 respectToSuperFrame:nil];
    
    _view1.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_view1 respectToSuperFrame:nil];
    _view2.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_view2 respectToSuperFrame:nil];
    
    
    _clickbutton1.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_clickbutton1 respectToSuperFrame:nil];
    _clickbutton2.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_clickbutton2 respectToSuperFrame:nil];
}

@end

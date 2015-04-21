//
//  CommunityTableViewCell.m
//  fitmoo
//
//  Created by hongjian lin on 4/21/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import "CommunityTableViewCell.h"

@implementation CommunityTableViewCell

- (void)awakeFromNib {
    [self initFrames];
    
    int frameHeight= self.buttomView.frame.origin.y + self.buttomView.frame.size.height;
    self.contentView.frame= CGRectMake(self.contentView.frame.origin.x, self.contentView.frame.origin.y, self.contentView.frame.size.width, frameHeight);

    // Initialization code
}
- (void) initFrames
{
    
    self.contentView.frame=[[FitmooHelper sharedInstance] resizeFrameWithFrame:self.contentView respectToSuperFrame:nil];
    
    _buttomView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_buttomView respectToSuperFrame:nil];
    
    _headerImage.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_headerImage respectToSuperFrame:nil];
    _nameLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_nameLabel respectToSuperFrame:nil];
    
    _feedButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_feedButton respectToSuperFrame:nil];
    _scheduleButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_scheduleButton respectToSuperFrame:nil];
    
    _joinButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_joinButton respectToSuperFrame:nil];
    _memberCountLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_memberCountLabel respectToSuperFrame:nil];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

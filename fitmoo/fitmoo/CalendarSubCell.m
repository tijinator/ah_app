//
//  CalendarSubCell.m
//  fitmoo
//
//  Created by hongjian lin on 7/28/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import "CalendarSubCell.h"
#import "FitmooHelper.h"
@implementation CalendarSubCell

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
    self.hourLabel.frame=[[FitmooHelper sharedInstance] resizeFrameWithFrame:self.hourLabel respectToSuperFrame:nil];
    self.view1.frame=[[FitmooHelper sharedInstance] resizeFrameWithFrame:self.view1 respectToSuperFrame:nil];
    self.nameLabel.frame=[[FitmooHelper sharedInstance] resizeFrameWithFrame:self.nameLabel respectToSuperFrame:nil];
    self.locationLabel.frame=[[FitmooHelper sharedInstance] resizeFrameWithFrame:self.locationLabel respectToSuperFrame:nil];
    
}

@end

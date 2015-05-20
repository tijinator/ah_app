//
//  FollowHeaderCell.m
//  fitmoo
//
//  Created by hongjian lin on 5/20/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import "FollowHeaderCell.h"

@implementation FollowHeaderCell

- (void)awakeFromNib {
    // Initialization code
    [self initFrames];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void) initFrames
{
    
    self.contentView.frame=[[FitmooHelper sharedInstance] resizeFrameWithFrame:self.contentView respectToSuperFrame:nil];

    
   
    _button1.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_button1 respectToSuperFrame:nil];
    _button2.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_button2 respectToSuperFrame:nil];
    
    _label1.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_label1 respectToSuperFrame:nil];
    _label2.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_label2 respectToSuperFrame:nil];
}
@end

//
//  SearchTapCell.m
//  fitmoo
//
//  Created by hongjian lin on 8/18/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import "SearchTapCell.h"
#import "FitmooHelper.h"
@implementation SearchTapCell

- (void)awakeFromNib {
    [self initFrames];
    // Initialization code
}

- (void) initFrames
{
    
    self.peopleButton.frame=[[FitmooHelper sharedInstance] resizeFrameWithFrame:_peopleButton respectToSuperFrame:nil];
    self.workoutButton.frame=[[FitmooHelper sharedInstance] resizeFrameWithFrame:_workoutButton respectToSuperFrame:nil];
    self.productButton.frame=[[FitmooHelper sharedInstance] resizeFrameWithFrame:_productButton respectToSuperFrame:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//
//  FollowCollectionViewCell.m
//  fitmoo
//
//  Created by hongjian lin on 5/19/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import "FollowCollectionViewCell.h"

@implementation FollowCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    [self initFrames];
}


- (void) initFrames
{
    
//    self.contentView.frame=[[FitmooHelper sharedInstance] resizeFrameWithFrame:self.contentView respectToSuperFrame:nil];
    _image.frame= CGRectMake(0, 0, 120, 120);
    _image.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_image respectToSuperFrame:nil];
    
    _userLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_userLabel respectToSuperFrame:nil];
    _blackImage.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_blackImage respectToSuperFrame:nil];
    _nameLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_nameLabel respectToSuperFrame:nil];

    _followButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_followButton respectToSuperFrame:nil];
  

}



@end

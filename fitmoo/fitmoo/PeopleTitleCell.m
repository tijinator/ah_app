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
    AsyncImageView *headerImage1 = [[AsyncImageView alloc] initWithFrame:CGRectMake(0, 0, _headerImage1.frame.size.width, _headerImage1.frame.size.height)];
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:headerImage1];
    headerImage1.imageURL =[NSURL URLWithString:url];
   // self.headerImage1.image=headerImage1.image;
    [self.headerImage1 addSubview:headerImage1];
    
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
    _scheduleButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_scheduleButton respectToSuperFrame:nil];
   
    _topView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_topView respectToSuperFrame:nil];
    _bioButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_bioButton respectToSuperFrame:nil];
    _editProfileButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_editProfileButton respectToSuperFrame:nil];
    _buttonView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_buttonView respectToSuperFrame:nil];
    
    _shadowImageView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_shadowImageView respectToSuperFrame:nil];
    _bioLabel.frame= CGRectMake(0, 0, _bioButton.frame.size.width, _bioButton.frame.size.height);
 //   _headerImage1.layer.cornerRadius=_headerImage1.frame.size.width/2;
 //   _headerImage1.layer.masksToBounds = YES;
}



@end

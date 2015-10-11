//
//  LiveCell.m
//  fitmoo
//
//  Created by hongjian lin on 10/11/15.
//  Copyright © 2015 com.fitmoo. All rights reserved.
//

#import "LiveCell.h"
#import "YTPlayerView.h"
@interface LiveCell()
@property(nonatomic, strong) IBOutlet YTPlayerView *playerView;
@end

@implementation LiveCell

- (void)awakeFromNib {
    
    [self initFrames];
    // Initialization code
}


- (void) initFrames
{
    
    self.contentView.frame=[[FitmooHelper sharedInstance] resizeFrameWithFrame:self.contentView respectToSuperFrame:nil];
    
    _headerView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_headerView respectToSuperFrame:nil];
       _heanderImage1.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_heanderImage1 respectToSuperFrame:nil];
    _headerImage2.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_headerImage2 respectToSuperFrame:nil];
    _titleLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_titleLabel respectToSuperFrame:nil];
    _dayLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_dayLabel respectToSuperFrame:nil];
  
    _playerView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_playerView respectToSuperFrame:nil];
    
    
    
    
    
    
    
}


- (void) builtCell
{
    NSDictionary *playerVars = @{ @"playsinline" : @1,};
    [self.playerView loadWithVideoId:@"RUMmq5ChgNM" playerVars:playerVars];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

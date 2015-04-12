//
//  ShareTableViewCell.m
//  fitmoo
//
//  Created by hongjian lin on 4/9/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import "ShareTableViewCell.h"
#import "FitmooHelper.h"
@implementation ShareTableViewCell

- (void)awakeFromNib {
   
    [self initFrames];
    _homeFeed= [[HomeFeed alloc] init];
    
    int frameHeight= self.commentView.frame.origin.y + self.commentView.frame.size.height+20;
    self.contentView.frame= CGRectMake(self.contentView.frame.origin.x, self.contentView.frame.origin.y, self.contentView.frame.size.width, frameHeight);
    // Initialization code
}

- (void) addScrollView
{
//    if (_scrollView!=nil) {
//        [_scrollView removeFromSuperview];
//        _scrollView=nil;
//    }
//    
//    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(14, 58, 290, 290)];
//    _scrollView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_scrollView respectToSuperFrame:nil];
//    
//    [self.bodyView insertSubview:_scrollView atIndex:0];
//    
//    _scrollView.delegate = self;
//    
//    UIImageView *scrollImageView= [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _scrollView.frame.size.width, _scrollView.frame.size.height)];
//    scrollImageView.image=[UIImage imageNamed:@"play.png"];
//    
//    AsyncImageView *scrollImage = [[AsyncImageView alloc] init];
//    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:scrollImage];
//    _homeFeed.photos= [_homeFeed.photoArray objectAtIndex:0];
//    scrollImage.imageURL =[NSURL URLWithString:_homeFeed.photos.stylesUrl];
//
//  //  scrollImageView.image= scrollImage.image;
//    
//    [_scrollView addSubview:scrollImageView];
    
    
//     UIImageView *scrollImageView= [[UIImageView alloc] initWithFrame:CGRectMake(14, 58, 290, 290)];
    UIImageView *scrollImageView= (UIImageView *) [self.bodyView viewWithTag:9];
    AsyncImageView *scrollImage = [[AsyncImageView alloc] init];
  //  [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:scrollImage];
    _homeFeed.photos= [_homeFeed.photoArray objectAtIndex:0];
    scrollImage.imageURL =[NSURL URLWithString:_homeFeed.photos.stylesUrl];
    scrollImageView.image= scrollImage.image;
    
  //  [_bodyView addSubview:scrollImageView];
}

- (void) initFrames
{
    
    self.contentView.frame=[[FitmooHelper sharedInstance] resizeFrameWithFrame:self.contentView respectToSuperFrame:nil];
    _headerView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_headerView respectToSuperFrame:nil];
    _bodyView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_bodyView respectToSuperFrame:nil];
    _commentView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_commentView respectToSuperFrame:nil];
    _buttomView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_buttomView respectToSuperFrame:nil];
    
    _heanderImage1.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_heanderImage1 respectToSuperFrame:nil];
    _headerImage2.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_headerImage2 respectToSuperFrame:nil];
    _titleLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_titleLabel respectToSuperFrame:nil];
    _dayLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_dayLabel respectToSuperFrame:nil];
    
    _bodyDetailLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_bodyDetailLabel respectToSuperFrame:nil];
    _commentImage.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_commentImage respectToSuperFrame:nil];
    _commentName.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_commentName respectToSuperFrame:nil];
    _commentDetail.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_commentDetail respectToSuperFrame:nil];
    

    _likeButton.imageEdgeInsets = UIEdgeInsetsMake(15,38,15,38);
    _likeButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_likeButton respectToSuperFrame:nil];
    
    _shareButton.imageEdgeInsets = UIEdgeInsetsMake(15,38,15,38);
    _shareButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_shareButton respectToSuperFrame:nil];
    _commentButton.imageEdgeInsets = UIEdgeInsetsMake(15,38,15,38);
    _commentButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_commentButton respectToSuperFrame:nil];
    _optionButton.imageEdgeInsets = UIEdgeInsetsMake(15,38,15,38);
    _optionButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_optionButton respectToSuperFrame:nil];
    
    _bodyImage.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_bodyImage respectToSuperFrame:nil];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)likeClick:(id)sender {
}
@end

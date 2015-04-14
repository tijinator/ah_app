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
    
    int frameHeight= self.buttomView.frame.origin.y + self.buttomView.frame.size.height;
    self.contentView.frame= CGRectMake(self.contentView.frame.origin.x, self.contentView.frame.origin.y, self.contentView.frame.size.width, frameHeight);
    
    NSLog(@"%d",frameHeight);
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



- (void) removeViewsFromBodyView: (UIView *) removeView
{
    [removeView removeFromSuperview];
    int frameHeight=self.bodyDetailLabel.frame.origin.y + self.bodyDetailLabel.frame.size.height;
    self.bodyView.frame= CGRectMake(self.bodyView.frame.origin.x, self.bodyView.frame.origin.y, self.bodyView.frame.size.width, frameHeight);
    self.commentView.frame= CGRectMake(self.commentView.frame.origin.x, self.commentView.frame.origin.y-removeView.frame.size.height, self.commentView.frame.size.width, self.commentView.frame.size.height);
    self.buttomView.frame= CGRectMake(self.buttomView.frame.origin.x, self.buttomView.frame.origin.y-removeView.frame.size.height, self.buttomView.frame.size.width, self.buttomView.frame.size.height);
    self.contentView.frame= CGRectMake(self.contentView.frame.origin.x, self.contentView.frame.origin.y, self.contentView.frame.size.width, self.contentView.frame.size.height-removeView.frame.size.height);
    
}

- (void) loadHeaderImage1: (NSString *)url
{
    AsyncImageView *headerImage1 = [[AsyncImageView alloc] init];
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:headerImage1];
    headerImage1.imageURL =[NSURL URLWithString:url];
    [self.heanderImage1 setImage:headerImage1.image forState:UIControlStateNormal];
   
    
}

- (void) loadCommentImage: (NSString *)url
{
    AsyncImageView *commentImage = [[AsyncImageView alloc] init];
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:commentImage];
    commentImage.imageURL =[NSURL URLWithString:url];
    [self.commentImage setImage:commentImage.image forState:UIControlStateNormal];
}

- (void) loadHeaderImage2: (NSString *)url
{
    AsyncImageView *headerImage2 = [[AsyncImageView alloc] init];
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:headerImage2];
    headerImage2.imageURL =[NSURL URLWithString:url];
    [self.headerImage2 setImage:headerImage2.image forState:UIControlStateNormal];
    
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
    

    UIView *v= [[UIView alloc] initWithFrame:CGRectMake(14,33,14,33)];
     v.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:v respectToSuperFrame:nil];
    
    _likeButton.imageEdgeInsets = UIEdgeInsetsMake(v.frame.origin.x,v.frame.origin.y,v.frame.size.width,v.frame.size.height);
    _likeButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_likeButton respectToSuperFrame:nil];
    
    _shareButton.imageEdgeInsets = UIEdgeInsetsMake(v.frame.origin.x,v.frame.origin.y,v.frame.size.width,v.frame.size.height);
    _shareButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_shareButton respectToSuperFrame:nil];
    
    _commentButton.imageEdgeInsets = UIEdgeInsetsMake(v.frame.origin.x,v.frame.origin.y,v.frame.size.width,v.frame.size.height);
    _commentButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_commentButton respectToSuperFrame:nil];
    _optionButton.imageEdgeInsets = UIEdgeInsetsMake(v.frame.origin.x,v.frame.origin.y,v.frame.size.width,v.frame.size.height);
    _optionButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_optionButton respectToSuperFrame:nil];
    
    _bodyImage.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_bodyImage respectToSuperFrame:nil];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end

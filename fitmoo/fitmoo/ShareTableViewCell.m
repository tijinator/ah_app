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
    _frameRadio= [[FitmooHelper sharedInstance] frameRadio];
   // NSLog(@"%d",frameHeight);
    // Initialization code
}

- (void) rebuiltBodyViewFrame
{
    int maxHeight=0;
    for (UIView * subview in _bodyView.subviews) {
        int temHeight= (subview.frame.size.height+subview.frame.origin.y+5);
        maxHeight= MAX(maxHeight, temHeight);
    }
    _bodyView.frame= CGRectMake(0, _bodyView.frame.origin.y, _bodyView.frame.size.width, maxHeight);
    self.commentView.frame= CGRectMake(self.commentView.frame.origin.x, _bodyView.frame.size.height+_bodyView.frame.origin.y+2, self.commentView.frame.size.width, self.commentView.frame.size.height);
    self.commentView1.frame= CGRectMake(self.commentView1.frame.origin.x, self.commentView.frame.origin.y+self.commentView.frame.size.height+2, self.commentView1.frame.size.width, self.commentView1.frame.size.height);
    self.commentView2.frame= CGRectMake(self.commentView2.frame.origin.x, self.commentView1.frame.origin.y+self.commentView1.frame.size.height+2, self.commentView1.frame.size.width, self.commentView2.frame.size.height);
    self.buttomView.frame= CGRectMake(self.buttomView.frame.origin.x, self.commentView2.frame.size.height+self.commentView2.frame.origin.y+2, self.buttomView.frame.size.width, self.buttomView.frame.size.height);

    
    
}

- (void) addScrollView
{
    if (_scrollView!=nil) {
        [_scrollView removeFromSuperview];
        _scrollView=nil;
    }
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(14, _bodyDetailLabel.frame.origin.y+_bodyDetailLabel.frame.size.height+10, 290, 290)];
    _scrollView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_scrollView respectToSuperFrame:nil];

    _scrollView.delegate = self;
    
    if ([_homeFeed.videosArray count]>0) {
        AsyncImageView *scrollImage = [[AsyncImageView alloc] initWithFrame:CGRectMake(0, 0, _scrollView.frame.size.width, _scrollView.frame.size.height)];
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:scrollImage];
        _homeFeed.videos= [_homeFeed.videosArray objectAtIndex:0];
        
        if ([_homeFeed.videos.thumbnail_url isEqual:[NSNull null]]) {
            
        }else
        {
        scrollImage.imageURL =[NSURL URLWithString:_homeFeed.videos.thumbnail_url];
        }
         scrollImage.contentMode = UIViewContentModeScaleAspectFit;
        
        
        [_scrollView addSubview:scrollImage];
        
        UIImageView *play= [[UIImageView alloc] initWithFrame:CGRectMake(_scrollView.frame.size.width/4, _scrollView.frame.size.height/4, _scrollView.frame.size.width/2, _scrollView.frame.size.height/2)];
        play.image= [UIImage imageNamed:@"play.png"];
        [_scrollView addSubview:play];
        
        _scrollView.userInteractionEnabled=NO;
        _scrollView.exclusiveTouch=NO;
        
    }else
    {
    
    int x =0;
    for (int i=0; i<[_homeFeed.photoArray count]; i++) {
         AsyncImageView *scrollImage = [[AsyncImageView alloc] initWithFrame:CGRectMake(x, 0, _scrollView.frame.size.width, _scrollView.frame.size.height)];
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:scrollImage];
        _homeFeed.photos= [_homeFeed.photoArray objectAtIndex:i];
        if (![_homeFeed.photos.stylesUrl isEqual:@""]) {
             scrollImage.imageURL =[NSURL URLWithString:_homeFeed.photos.stylesUrl];
        }else
        {
             scrollImage.imageURL =[NSURL URLWithString:_homeFeed.photos.originalUrl];
        }
        scrollImage.contentMode = UIViewContentModeScaleAspectFit;
        [_scrollView addSubview:scrollImage];
         _scrollView.contentSize= CGSizeMake(290*_frameRadio+i*x, 290*_frameRadio);
        x= x+ 290*_frameRadio;
    }
    if ([_homeFeed.photoArray count]==1) {
        _scrollView.userInteractionEnabled=NO;
        _scrollView.exclusiveTouch=NO;
    }
    }
   
    [_bodyView insertSubview:_scrollView aboveSubview:_bodyImage];
}

-(void) deleteViews:(UIView *)view
{
   
}

- (void) addCommentView: (UIView *) addView Atindex:(int) index
{
    if (index==0) {
        AsyncImageView *commentImage = [[AsyncImageView alloc] initWithFrame:CGRectMake(0, 0, _commentImage.frame.size.width, _commentImage.frame.size.height)];
        commentImage.userInteractionEnabled = NO;
        commentImage.exclusiveTouch = NO;
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:commentImage];
        _homeFeed.comments= [_homeFeed.commentsArray objectAtIndex:0];
        commentImage.imageURL =[NSURL URLWithString:_homeFeed.comments.thumb];
        [_commentImage.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
        [_commentImage addSubview:commentImage];
        self.commentName.text=_homeFeed.comments.full_name;
        self.commentDetail.text= _homeFeed.comments.text;
    }
   
    if (index==1) {
        AsyncImageView *commentImage1 = [[AsyncImageView alloc] initWithFrame:CGRectMake(0, 0, _commentImage1.frame.size.width, _commentImage1.frame.size.height)];
        commentImage1.userInteractionEnabled = NO;
        commentImage1.exclusiveTouch = NO;
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:commentImage1];
        _homeFeed.comments= [_homeFeed.commentsArray objectAtIndex:1];
        commentImage1.imageURL =[NSURL URLWithString:_homeFeed.comments.thumb];
        [_commentImage1.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
        [_commentImage1 addSubview:commentImage1];
        self.commentName1.text=_homeFeed.comments.full_name;
        self.commentDetail1.text= _homeFeed.comments.text;
    }
    
    if (index==2) {
        AsyncImageView *commentImage2 = [[AsyncImageView alloc] initWithFrame:CGRectMake(0, 0, _commentImage2.frame.size.width, _commentImage2.frame.size.height)];
        commentImage2.userInteractionEnabled = NO;
        commentImage2.exclusiveTouch = NO;
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:commentImage2];
        _homeFeed.comments= [_homeFeed.commentsArray objectAtIndex:2];
        commentImage2.imageURL =[NSURL URLWithString:_homeFeed.comments.thumb];
        [_commentImage2.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
        [_commentImage2 addSubview:commentImage2];
        self.commentName2.text=_homeFeed.comments.full_name;
        self.commentDetail2.text= _homeFeed.comments.text;
    }
    
}

- (void) removeCommentView2
{
    self.buttomView.frame= CGRectMake(self.buttomView.frame.origin.x, self.commentView2.frame.origin.y, self.buttomView.frame.size.width, self.buttomView.frame.size.height);
    [_commentView2 removeFromSuperview];
}
- (void) removeCommentView1
{
    self.buttomView.frame= CGRectMake(self.buttomView.frame.origin.x, self.commentView1.frame.origin.y, self.buttomView.frame.size.width, self.buttomView.frame.size.height);
    [_commentView1 removeFromSuperview];
}

- (void) removeCommentView
{
     self.buttomView.frame= CGRectMake(self.buttomView.frame.origin.x, self.commentView.frame.origin.y, self.buttomView.frame.size.width, self.buttomView.frame.size.height);
    [_commentView removeFromSuperview];
}

- (void) removeViewsFromBodyView: (UIView *) removeView
{
    int frameHeight=_bodyView.frame.size.height-removeView.frame.size.height;
    self.bodyView.frame= CGRectMake(self.bodyView.frame.origin.x, self.bodyView.frame.origin.y, self.bodyView.frame.size.width, frameHeight);
    self.commentView.frame= CGRectMake(self.commentView.frame.origin.x, self.commentView.frame.origin.y-removeView.frame.size.height, self.commentView.frame.size.width, self.commentView.frame.size.height);
    self.commentView1.frame= CGRectMake(self.commentView1.frame.origin.x, self.commentView1.frame.origin.y-removeView.frame.size.height, self.commentView1.frame.size.width, self.commentView1.frame.size.height);
    self.commentView2.frame= CGRectMake(self.commentView2.frame.origin.x, self.commentView2.frame.origin.y-removeView.frame.size.height, self.commentView1.frame.size.width, self.commentView2.frame.size.height);
    self.buttomView.frame= CGRectMake(self.buttomView.frame.origin.x, self.buttomView.frame.origin.y-removeView.frame.size.height, self.buttomView.frame.size.width, self.buttomView.frame.size.height);
    [removeView removeFromSuperview];
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

- (void) reDefineHearderViewsFrame
{
    _headerImage2.frame=CGRectMake(_headerImage2.frame.origin.x-40*_frameRadio, _headerImage2.frame.origin.y, _headerImage2.frame.size.width, _headerImage2.frame.size.height);
    _titleLabel.frame=CGRectMake(_titleLabel.frame.origin.x-40*_frameRadio, _titleLabel.frame.origin.y, _titleLabel.frame.size.width, _titleLabel.frame.size.height);
    _dayLabel.frame=CGRectMake(_dayLabel.frame.origin.x-40*_frameRadio, _dayLabel.frame.origin.y, _dayLabel.frame.size.width, _dayLabel.frame.size.height);
}

- (void) initFrames
{
    
    self.contentView.frame=[[FitmooHelper sharedInstance] resizeFrameWithFrame:self.contentView respectToSuperFrame:nil];
    _headerView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_headerView respectToSuperFrame:nil];
    _bodyView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_bodyView respectToSuperFrame:nil];
       _buttomView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_buttomView respectToSuperFrame:nil];
    _heanderImage1.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_heanderImage1 respectToSuperFrame:nil];
    _headerImage2.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_headerImage2 respectToSuperFrame:nil];
    _titleLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_titleLabel respectToSuperFrame:nil];
    _dayLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_dayLabel respectToSuperFrame:nil];
    _bodyDetailLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_bodyDetailLabel respectToSuperFrame:nil];
    
    _commentView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_commentView respectToSuperFrame:nil];
    _commentImage.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_commentImage respectToSuperFrame:nil];
    _commentName.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_commentName respectToSuperFrame:nil];
    _commentDetail.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_commentDetail respectToSuperFrame:nil];
    
    _commentView1.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_commentView1 respectToSuperFrame:nil];
    _commentImage1.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_commentImage1 respectToSuperFrame:nil];
    _commentName1.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_commentName1 respectToSuperFrame:nil];
    _commentDetail1.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_commentDetail1 respectToSuperFrame:nil];
    
    _commentView2.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_commentView2 respectToSuperFrame:nil];
    _commentImage2.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_commentImage2 respectToSuperFrame:nil];
    _commentName2.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_commentName2 respectToSuperFrame:nil];
    _commentDetail2.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_commentDetail2 respectToSuperFrame:nil];
    

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
    
  //  _viewArray=[[NSMutableArray alloc] initWithObjects:_headerView,_bodyView,_commentView,_commentView1,_commentView2, nil];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end

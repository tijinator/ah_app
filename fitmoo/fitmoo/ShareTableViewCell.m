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
    _scrollViewWidth=320;
    _scrollViewHeight=320;
  //  _scrollbelowFrame= [[UIView alloc] initWithFrame:_bodyDetailLabel.frame];
 //   _scrollViewOriginx=14;
   // NSLog(@"%d",frameHeight);
    // Initialization code
}

- (void) rebuiltCommentViewFrame
{
    int maxHeight=0;
    for (UIView * subview in _commentView.subviews) {
        int temHeight= (subview.frame.size.height+subview.frame.origin.y+5);
        maxHeight= MAX(maxHeight, temHeight);
    }
    _commentView.frame= CGRectMake(0, _commentView.frame.origin.y, _commentView.frame.size.width, maxHeight);

    self.buttomView.frame= CGRectMake(self.buttomView.frame.origin.x, self.commentView.frame.size.height+self.commentView.frame.origin.y+2, self.buttomView.frame.size.width, self.buttomView.frame.size.height);

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
//    self.commentView1.frame= CGRectMake(self.commentView1.frame.origin.x, self.commentView.frame.origin.y+self.commentView.frame.size.height+2, self.commentView1.frame.size.width, self.commentView1.frame.size.height);
//    self.commentView2.frame= CGRectMake(self.commentView2.frame.origin.x, self.commentView1.frame.origin.y+self.commentView1.frame.size.height+2, self.commentView1.frame.size.width, self.commentView2.frame.size.height);
//    self.buttomView.frame= CGRectMake(self.buttomView.frame.origin.x, self.commentView2.frame.size.height+self.commentView2.frame.origin.y+2, self.buttomView.frame.size.width, self.buttomView.frame.size.height);

    self.buttomView.frame= CGRectMake(self.buttomView.frame.origin.x, self.commentView.frame.size.height+self.commentView.frame.origin.y+2, self.buttomView.frame.size.width, self.buttomView.frame.size.height);
    
}

- (void) addScrollView
{
    if (_scrollView!=nil) {
        [_scrollView removeFromSuperview];
        _scrollView=nil;
    }
    
 //   self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(_scrollbelowFrame.frame.origin.x-3, _scrollbelowFrame.frame.origin.y+_scrollbelowFrame.frame.size.height, _scrollViewWidth, _scrollViewHeight)];
    _scrollView= [[UIScrollView alloc] initWithFrame:_scrollbelowFrame.frame];
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
        
        _bodyImage= [[UIButton alloc] initWithFrame:CGRectMake(0,0, _scrollView.frame.size.width, _scrollView.frame.size.height)];
        
        UIView *v= [[UIView alloc] initWithFrame:CGRectMake(80,80,80,80)];
        v.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:v respectToSuperFrame:nil];
        _bodyImage.imageEdgeInsets = UIEdgeInsetsMake(v.frame.origin.x,v.frame.origin.y,v.frame.size.width,v.frame.size.height);

        [_bodyImage setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
        [_scrollView addSubview:_bodyImage];
        
  //      _scrollView.userInteractionEnabled=NO;
  //      _scrollView.exclusiveTouch=NO;
        
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
         _scrollView.contentSize= CGSizeMake(_scrollView.frame.size.width*_frameRadio+i*x, _scrollView.frame.size.height*_frameRadio);
        x= x+ _scrollView.frame.size.width*_frameRadio;
    }
    if ([_homeFeed.photoArray count]==1) {
        _scrollView.userInteractionEnabled=NO;
        _scrollView.exclusiveTouch=NO;
    }
    }
   
  //  [_bodyView insertSubview:_scrollView aboveSubview:_bodyImage];
    [_bodyView addSubview:_scrollView];
}



-(void) deleteViews:(UIView *)view
{
   
}

- (void) setBodyFrameForProduct
{
    if ([_homeFeed.feed_action.action isEqualToString:@"share"]) {
        _bodyDetailLabel.text= _homeFeed.feed_action.share_message;
        _bodyDetailLabel.frame= [[FitmooHelper sharedInstance] caculateLabelHeight:_bodyDetailLabel];
    }
    
    _scrollbelowFrame= [[UIView alloc] initWithFrame:CGRectMake(0, _bodyDetailLabel.frame.origin.y+_bodyDetailLabel.frame.size.height, _scrollViewWidth, _scrollViewHeight)];
    
    _bodyTitle.text= _homeFeed.product.detail;
    _bodyTitle.frame= CGRectMake(14, 315, 200, _bodyTitle.frame.size.height);
    _bodyTitle.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_bodyTitle respectToSuperFrame:nil];
    
    _bodyLabel1.text= [NSString stringWithFormat:@"%@%@%@",_homeFeed.product.type_product,@" | ", _homeFeed.product.gender];
    _bodyLabel1.frame= CGRectMake(14, 335, 200, _bodyLabel1.frame.size.height);
    _bodyLabel1.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_bodyLabel1 respectToSuperFrame:nil];
   
    _bodyLabel2.text=[NSString stringWithFormat:@"%@%@",@"$", _homeFeed.product.selling_price];
    _bodyLabel2.frame= CGRectMake(260, 315, 40, _bodyLabel2.frame.size.height);
    _bodyLabel2.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_bodyLabel2 respectToSuperFrame:nil];
    
    if (![_homeFeed.product.original_price isEqualToString:@"0"]) {
        _bodyLabel3.text=[NSString stringWithFormat:@"%@%@",@"$", _homeFeed.product.original_price];
        _bodyLabel3.frame= CGRectMake(260, 335, 40, _bodyLabel3.frame.size.height);
        _bodyLabel3.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_bodyLabel3 respectToSuperFrame:nil];
        UIView *crossView= [[UIView alloc] initWithFrame:CGRectMake(0, _bodyLabel3.frame.size.height/2, 30, 1)];
        crossView.backgroundColor=[UIColor blackColor];
        [_bodyLabel3 addSubview:crossView];
    }
}

- (void) setBodyFrameForEvent
{
    _bodyTitle.text= _homeFeed.event.name;
    _bodyDetailLabel.text= _homeFeed.text;
    _bodyLabel1.text= _homeFeed.event.begin_time;
    _bodyLabel2.text=_homeFeed.event.end_time;
    [_homeFeed resetPhotos];
    _homeFeed.photos.originalUrl=_homeFeed.event.theme;
    _homeFeed.photos.stylesUrl=_homeFeed.event.theme;
    [_homeFeed.photoArray addObject:_homeFeed.photos];
    
 

    _bodyCastView.hidden=false;
    _scrollViewWidth=260;
    _scrollViewHeight=60;
    _scrollbelowFrame= [[UIView alloc] initWithFrame:CGRectMake(30, 30, _scrollViewWidth, _scrollViewHeight)];
    
    _bodyTitle.frame= CGRectMake(36, 95, 290, _bodyTitle.frame.size.height);
    _bodyTitle.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_bodyTitle respectToSuperFrame:nil];
    
    _bodyLabel1.frame= CGRectMake(37, 115, 260, _bodyLabel1.frame.size.height);
    _bodyLabel1.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_bodyLabel1 respectToSuperFrame:nil];
    
    _bodyLabel2.frame= CGRectMake(37,135, 260, _bodyLabel2.frame.size.height);
    _bodyLabel2.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_bodyLabel2 respectToSuperFrame:nil];
    [_bodyLabel2 setFont:_bodyLabel1.font];
    [_bodyLabel2 setTextColor:_bodyLabel1.textColor];

    _bodyDetailLabel.frame=[[FitmooHelper sharedInstance] caculateLabelHeight:_bodyDetailLabel];
    _bodyDetailLabel.frame=CGRectMake(38, 155, _bodyDetailLabel.frame.size.width, _bodyDetailLabel.frame.size.height);
    _bodyDetailLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_bodyDetailLabel respectToSuperFrame:nil];
    
    _bodyCastView.frame=CGRectMake(_bodyCastView.frame.origin.x, _bodyCastView.frame.origin.y
                                   , _bodyCastView.frame.size.width, _bodyDetailLabel.frame.size.height+_bodyDetailLabel.frame.origin.y+3);
}
- (void) setBodyFrameForRegular
{
    _bodyDetailLabel.text= _homeFeed.text;
    _bodyDetailLabel.frame= [[FitmooHelper sharedInstance] caculateLabelHeight:_bodyDetailLabel];
    _scrollbelowFrame= [[UIView alloc] initWithFrame:CGRectMake(0, _bodyDetailLabel.frame.origin.y+_bodyDetailLabel.frame.size.height, _scrollViewWidth, _scrollViewHeight)];
    
}
- (void) setBodyFrameForWorkout
{
    _bodyDetailLabel.text= _homeFeed.text;
    _bodyTitle.text= _homeFeed.workout_title;
    _bodyTitle.frame= CGRectMake(29, 18, 290, _bodyTitle.frame.size.height);
    _bodyTitle.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_bodyTitle respectToSuperFrame:nil];
    _bodyDetailLabel.frame=[[FitmooHelper sharedInstance] caculateLabelHeight:_bodyDetailLabel];
    _bodyDetailLabel.frame=CGRectMake(31, _bodyTitle.frame.size.height+_bodyTitle.frame.origin.y+3, _bodyDetailLabel.frame.size.width, _bodyTitle.frame.size.height);
    _bodyCastView.hidden=false;
    _scrollViewWidth=260;
    _scrollViewHeight=260;
    _scrollbelowFrame= [[UIView alloc] initWithFrame:CGRectMake(_bodyDetailLabel.frame.origin.x-3, _bodyDetailLabel.frame.origin.y+_bodyDetailLabel.frame.size.height, _scrollViewWidth, _scrollViewHeight)];
   // _scrollbelowFrame= [[UIView alloc] initWithFrame:_bodyDetailLabel.frame];
}

- (void) setBodyFrameForNutrition
{
    _bodyTitle.text= _homeFeed.nutrition.title;
    _bodyLabel2.text=@"Ingredients";
    _bodyDetailLabel.text= _homeFeed.nutrition.ingredients;
    _bodyLabel3.text=@"Preparation";
    _bodyLabel1.text= _homeFeed.nutrition.preparation;
    
    _bodyTitle.frame= CGRectMake(30, 20, 260, _bodyTitle.frame.size.height);
    _bodyTitle.textAlignment = NSTextAlignmentCenter;
    _bodyTitle.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_bodyTitle respectToSuperFrame:nil];
    
    _bodyLabel2.frame= CGRectMake(30, 309, 260, _bodyLabel2.frame.size.height);
    _bodyLabel2.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_bodyLabel2 respectToSuperFrame:nil];
    
    _bodyDetailLabel.frame=[[FitmooHelper sharedInstance] caculateLabelHeight:_bodyDetailLabel];
    _bodyDetailLabel.frame= CGRectMake(30, _bodyLabel2.frame.size.height+_bodyLabel2.frame.origin.y+3, 260, _bodyDetailLabel.frame.size.height);
    _bodyDetailLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_bodyDetailLabel respectToSuperFrame:nil];
    _bodyDetailLabel.frame= CGRectMake(_bodyDetailLabel.frame.origin.x, _bodyLabel2.frame.size.height+_bodyLabel2.frame.origin.y+3, _bodyDetailLabel.frame.size.width, _bodyDetailLabel.frame.size.height);
    
    _bodyLabel3.frame= CGRectMake(30, 309, 260, _bodyLabel3.frame.size.height);
    _bodyLabel3.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_bodyLabel3 respectToSuperFrame:nil];
    _bodyLabel3.frame= CGRectMake(_bodyLabel3.frame.origin.x, _bodyDetailLabel.frame.size.height+_bodyDetailLabel.frame.origin.y+3, _bodyLabel3.frame.size.width, _bodyLabel3.frame.size.height);
    
    _bodyLabel1.frame=[[FitmooHelper sharedInstance] caculateLabelHeight:_bodyLabel1];
    _bodyLabel1.frame= CGRectMake(30, 309, 260, _bodyLabel1.frame.size.height);
    _bodyLabel1.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_bodyLabel1 respectToSuperFrame:nil];
    _bodyLabel1.frame= CGRectMake(_bodyLabel1.frame.origin.x, _bodyLabel3.frame.size.height+_bodyLabel3.frame.origin.y+3, _bodyLabel1.frame.size.width, _bodyLabel1.frame.size.height);
    
    _bodyCastView.frame=CGRectMake(_bodyCastView.frame.origin.x, _bodyCastView.frame.origin.y
    , _bodyCastView.frame.size.width, _bodyLabel1.frame.size.height+_bodyLabel1.frame.origin.y+3);
    
    _bodyCastView.hidden=false;
    _scrollViewWidth=260;
    _scrollViewHeight=260;
    _scrollbelowFrame= [[UIView alloc] initWithFrame:CGRectMake(_bodyTitle.frame.origin.x-3, _bodyTitle.frame.origin.y+_bodyTitle.frame.size.height, _scrollViewWidth, _scrollViewHeight)];
  //  _scrollbelowFrame= [[UIView alloc] initWithFrame:_bodyTitle.frame];
    
}

- (void) addCommentView: (UIView *) addView Atindex:(int) index
{
  
//    for(NSString* family in [UIFont familyNames]) {
//        NSLog(@"%@", family);
//        for(NSString* name in [UIFont fontNamesForFamilyName: family]) {
//            NSLog(@"  %@", name);
//        }
//    }
   // UIFont *font= [UIFont fontWithName:@"BentonSans-ExtraLight" size:(CGFloat)(14)];
    UIFont *font= [UIFont fontWithName:@"BentonSans" size:(CGFloat)(13)];
    UIFont *font1= [UIFont fontWithName:@"BentonSans-Medium" size:(CGFloat)(13)];
    NSString *string1=_homeFeed.comments.full_name;
    NSString *string2=_homeFeed.comments.text;
    UIColor *fontColor= [UIColor colorWithRed:87/255 green:93/255 blue:96/255 alpha:0.7];
    
    NSString *string= [NSString stringWithFormat:@"%@ %@",string1,string2];
    NSMutableAttributedString *attributedString= [[NSMutableAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName: font} ];
    attributedString=(NSMutableAttributedString *) [[FitmooHelper sharedInstance] replaceAttributedString:attributedString Font:font1 range:string1 newString:string1];
    NSRange range= [string rangeOfString:string2];
    [attributedString addAttribute:NSForegroundColorAttributeName value:fontColor range:range];
    
    
    
    if (index==0) {
     _commentImage= [[UIImageView alloc] initWithFrame:CGRectMake(12, 16, 11, 9)];
     _commentImage.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_commentImage respectToSuperFrame:nil];
     _commentImage.image= [UIImage imageNamed:@"greycommenticon.png"];
   
    _commentDetail= [[UILabel alloc] initWithFrame:CGRectMake(30, 15, 270,20)];
    [_commentDetail setAttributedText:attributedString];
        _commentDetail.frame= [[FitmooHelper sharedInstance] caculateLabelHeight:_commentDetail];
    _commentDetail.lineBreakMode=  NSLineBreakByWordWrapping;
    _commentDetail.numberOfLines=30;
    _commentDetail.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_commentDetail respectToSuperFrame:nil];
    [_commentView addSubview:_commentImage];
    [_commentView addSubview:_commentDetail];
    }
   
    if (index==1) {
       
        _commentDetail1= [[UILabel alloc] initWithFrame:CGRectMake(30, 15, 270,20)];
        _commentDetail1.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_commentDetail1 respectToSuperFrame:nil];
        [_commentDetail1 setAttributedText:attributedString];
        _commentDetail1.frame= [[FitmooHelper sharedInstance] caculateLabelHeight:_commentDetail1];
        _commentDetail1.frame= CGRectMake(_commentDetail1.frame.origin.x, 15+_commentDetail.frame.size.height+_commentDetail.frame.origin.y, _commentDetail1.frame.size.width,_commentDetail1.frame.size.height);
        _commentDetail1.lineBreakMode= NSLineBreakByWordWrapping;
        _commentDetail1.numberOfLines=30;
        
        [_commentView addSubview:_commentDetail1];
    }
    
    if (index==2) {
      
        _commentDetail2= [[UILabel alloc] initWithFrame:CGRectMake(30, 15, 270,20)];
        _commentDetail2.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_commentDetail2 respectToSuperFrame:nil];
        [_commentDetail2 setAttributedText:attributedString];
        _commentDetail2.frame= [[FitmooHelper sharedInstance] caculateLabelHeight:_commentDetail2];
        _commentDetail2.frame= CGRectMake(_commentDetail2.frame.origin.x, 15+_commentDetail1.frame.size.height+_commentDetail1.frame.origin.y, _commentDetail2.frame.size.width,_commentDetail2.frame.size.height);
        _commentDetail2.lineBreakMode= NSLineBreakByWordWrapping;
        _commentDetail2.numberOfLines=30;
        
        [_commentView addSubview:_commentDetail2];
    }
    
    
    
}

//- (void) removeCommentView2
//{
//    self.buttomView.frame= CGRectMake(self.buttomView.frame.origin.x, self.commentView2.frame.origin.y, self.buttomView.frame.size.width, self.buttomView.frame.size.height);
//    [_commentView2 removeFromSuperview];
//}
//- (void) removeCommentView1
//{
//    self.buttomView.frame= CGRectMake(self.buttomView.frame.origin.x, self.commentView1.frame.origin.y, self.buttomView.frame.size.width, self.buttomView.frame.size.height);
//    [_commentView1 removeFromSuperview];
//}
//
- (void) removeCommentView
{
     self.buttomView.frame= CGRectMake(self.buttomView.frame.origin.x, self.commentView.frame.origin.y, self.buttomView.frame.size.width, self.buttomView.frame.size.height);
    [_commentView removeFromSuperview];
}

- (void) removeViewsFromBodyView: (UIView *) removeView
{
    int frameHeight=_bodyView.frame.size.height-removeView.frame.size.height;
    self.bodyView.frame= CGRectMake(self.bodyView.frame.origin.x, self.bodyView.frame.origin.y, self.bodyView.frame.size.width, frameHeight);
    self.bodyCastView.frame= CGRectMake(self.bodyCastView.frame.origin.x, self.bodyCastView.frame.origin.y, self.bodyCastView.frame.size.width, frameHeight);
    self.commentView.frame= CGRectMake(self.commentView.frame.origin.x, self.commentView.frame.origin.y-removeView.frame.size.height, self.commentView.frame.size.width, self.commentView.frame.size.height);
//    self.commentView1.frame= CGRectMake(self.commentView1.frame.origin.x, self.commentView1.frame.origin.y-removeView.frame.size.height, self.commentView1.frame.size.width, self.commentView1.frame.size.height);
//    self.commentView2.frame= CGRectMake(self.commentView2.frame.origin.x, self.commentView2.frame.origin.y-removeView.frame.size.height, self.commentView1.frame.size.width, self.commentView2.frame.size.height);
    self.buttomView.frame= CGRectMake(self.buttomView.frame.origin.x, self.buttomView.frame.origin.y-removeView.frame.size.height, self.buttomView.frame.size.width, self.buttomView.frame.size.height);
    
    [_scrollView removeFromSuperview];
}

- (void) loadHeaderImage1: (NSString *)url
{
    AsyncImageView *headerImage1 = [[AsyncImageView alloc] init];
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:headerImage1];
    headerImage1.imageURL =[NSURL URLWithString:url];
    [self.heanderImage1 setImage:headerImage1.image forState:UIControlStateNormal];
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

    _commentName.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_commentName respectToSuperFrame:nil];
    _commentDetail.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_commentDetail respectToSuperFrame:nil];
    
    _commentView1.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_commentView1 respectToSuperFrame:nil];

    _commentName1.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_commentName1 respectToSuperFrame:nil];
    _commentDetail1.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_commentDetail1 respectToSuperFrame:nil];
    
    _commentView2.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_commentView2 respectToSuperFrame:nil];

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
    
 //   _bodyImage.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_bodyImage respectToSuperFrame:nil];
    _scrollView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_scrollView respectToSuperFrame:nil];
    _bodyCastView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_bodyCastView respectToSuperFrame:nil];
  //  _viewArray=[[NSMutableArray alloc] initWithObjects:_headerView,_bodyView,_commentView,_commentView1,_commentView2, nil];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end

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
    _scrollbelowFrame= [[UIView alloc] initWithFrame:CGRectMake(0, 0, _scrollViewWidth, _scrollViewHeight)];
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
    _commentView.frame= CGRectMake(0, _commentView.frame.origin.y, _commentView.frame.size.width, maxHeight+15*_frameRadio);

    self.buttomView.frame= CGRectMake(self.buttomView.frame.origin.x, self.commentView.frame.size.height+self.commentView.frame.origin.y+2, self.buttomView.frame.size.width, self.buttomView.frame.size.height);

}

- (void) rebuiltBodyViewFrame
{
    int maxHeight=0;
    for (UIView * subview in _bodyView.subviews) {
        if ([_bodyDetailLabel.text isEqualToString:@""]||[_homeFeed.type isEqualToString:@"event"]) {
            int temHeight= (subview.frame.size.height+subview.frame.origin.y);
            maxHeight= MAX(maxHeight, temHeight);
        }else
        {
        int temHeight= (subview.frame.size.height+subview.frame.origin.y+15);
        maxHeight= MAX(maxHeight, temHeight);
        }
    }
    _bodyView.frame= CGRectMake(0, _bodyView.frame.origin.y, _bodyView.frame.size.width, maxHeight);
    self.commentView.frame= CGRectMake(self.commentView.frame.origin.x, _bodyView.frame.size.height+_bodyView.frame.origin.y, self.commentView.frame.size.width, self.commentView.frame.size.height);

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
        _scrollView.backgroundColor= [UIColor blackColor];
        
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
        [_homeFeed resetPhotos];
        _homeFeed.photos= [_homeFeed.photoArray objectAtIndex:i];
        
        if (![_homeFeed.photos.stylesUrl isEqual:@""]) {
             scrollImage.imageURL =[NSURL URLWithString:_homeFeed.photos.stylesUrl];
        }else
        {
             scrollImage.imageURL =[NSURL URLWithString:_homeFeed.photos.originalUrl];
        }
        scrollImage.contentMode = UIViewContentModeScaleAspectFit;
        [_scrollView addSubview:scrollImage];
         _scrollView.contentSize= CGSizeMake(_scrollView.frame.size.width+x, _scrollView.frame.size.height);
        x= x+ _scrollView.frame.size.width;
    }
    if ([_homeFeed.photoArray count]==1) {
        _scrollView.userInteractionEnabled=NO;
        _scrollView.exclusiveTouch=NO;
    }
    }
   
    [_bodyView insertSubview:_scrollView belowSubview:_bodyShadowView];
   // [_bodyView addSubview:_scrollView];
}



-(void) deleteViews:(UIView *)view
{
   
}

- (void) setBodyFrameForProduct
{
    _bodyTitle.text= _homeFeed.product.title;
    _bodyTitle.frame= CGRectMake(30*_frameRadio, _scrollView.frame.size.height+15, 200*_frameRadio, _bodyTitle.frame.size.height);

    if ([_homeFeed.feed_action.action isEqualToString:@"share"]) {
        _bodyDetailLabel.text= _homeFeed.feed_action.share_message;
        _bodyDetailLabel.frame= CGRectMake(30*_frameRadio, _scrollView.frame.size.height+15, 200*_frameRadio, _bodyTitle.frame.size.height);
        
        _bodyTitle.frame= CGRectMake(30*_frameRadio, _bodyDetailLabel.frame.size.height+_bodyDetailLabel.frame.origin.y+15, 200*_frameRadio, _bodyTitle.frame.size.height);
        _bodyDetailLabel.frame= [[FitmooHelper sharedInstance] caculateLabelHeight:_bodyDetailLabel];
    }
    
  //  _scrollbelowFrame= [[UIView alloc] initWithFrame:CGRectMake(0, _bodyDetailLabel.frame.origin.y+_bodyDetailLabel.frame.size.height, _scrollViewWidth, _scrollViewHeight)];
    
    
    
    _bodyLabel1.text= [NSString stringWithFormat:@"%@%@%@",_homeFeed.product.type_product,@" | ", _homeFeed.product.gender];
    _bodyLabel1.frame= CGRectMake(30*_frameRadio, _bodyTitle.frame.size.height+_bodyTitle.frame.origin.y+10, 200*_frameRadio, _bodyLabel1.frame.size.height);

   
    _bodyLabel2.text=[NSString stringWithFormat:@"%@%@",@"$", _homeFeed.product.selling_price];
    _bodyLabel2.frame= CGRectMake(260*_frameRadio, _bodyTitle.frame.origin.y, 40*_frameRadio, _bodyLabel2.frame.size.height);

    
    if (![_homeFeed.product.original_price isEqualToString:@"0"]) {
        _bodyLabel3.text=[NSString stringWithFormat:@"%@%@",@"$", _homeFeed.product.original_price];
        _bodyLabel3.frame= CGRectMake(260*_frameRadio,  _bodyLabel2.frame.size.height+_bodyLabel2.frame.origin.y+3, 40*_frameRadio, _bodyLabel3.frame.size.height*_frameRadio);

        UIView *crossView= [[UIView alloc] initWithFrame:CGRectMake(0, _bodyLabel3.frame.size.height/2, 30, 1)];
        crossView.backgroundColor=[UIColor blackColor];
        [_bodyLabel3 addSubview:crossView];
    }
    [_bodyCastView removeFromSuperview];
}

- (void) setBodyFrameForEvent
{
    _bodyTitle.text= _homeFeed.event.name;
  //  _bodyDetailLabel.text= _homeFeed.text;
    _bodyDetailLabel.text= _homeFeed.event.end_time;
    _bodyLabel1.text= _homeFeed.event.begin_time;
  //  _bodyLabel2.text=_homeFeed.event.end_time;

    

    _bodyTitle.frame= CGRectMake(90, 95, 200, _bodyTitle.frame.size.height);
    _bodyTitle.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_bodyTitle respectToSuperFrame:nil];
    
    _bodyLabel1.frame= CGRectMake(90, 120, 200, _bodyLabel1.frame.size.height);
    _bodyLabel1.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_bodyLabel1 respectToSuperFrame:nil];
    
    
    _bodyDetailLabel.frame= CGRectMake(90,135, 200, _bodyDetailLabel.frame.size.height);
    _bodyDetailLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_bodyDetailLabel respectToSuperFrame:nil];
   
    [_bodyLabel1 setTextColor:[UIColor blackColor]];
    [_bodyDetailLabel setTextColor:[UIColor blackColor]];
    
    _bodyLabel2.text=@"people going";
    _bodyLabel2.frame= CGRectMake(115,170, 200, _bodyLabel2.frame.size.height);
    _bodyLabel2.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_bodyLabel2 respectToSuperFrame:nil];
    [_bodyLabel2 setTextColor:[UIColor colorWithRed:16.0/255.0 green:156.0/255.0 blue:251.0/255.0 alpha:1]];
    
    _bodyYesButton.frame=CGRectMake(90,210, 105, 33);
    _bodyYesButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_bodyYesButton respectToSuperFrame:nil];
    _bodyYesButton.layer.cornerRadius=5;

    _bodyMaybeButton.frame=CGRectMake(200,210, 105, 33);
    _bodyMaybeButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_bodyMaybeButton respectToSuperFrame:nil];
    _bodyMaybeButton.layer.cornerRadius=5;
    
    _bodyYesButton.hidden=false;
    _bodyMaybeButton.hidden=false;
    _bodyBluePeopleImage.hidden=false;
    _bodyDateImage.hidden=false;
    _bodyMonthLabel.hidden=false;
    _bodyDayLabel.hidden=false;
    
    _bodyDateImage.frame=CGRectMake(20,95, 47, 65);
    _bodyDateImage.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_bodyDateImage respectToSuperFrame:nil];
    
    _bodyBluePeopleImage.frame=CGRectMake(90,170, 15, 15);
    _bodyBluePeopleImage.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_bodyBluePeopleImage respectToSuperFrame:nil];
    
    _bodyMonthLabel.frame=CGRectMake(18,105, 50, 20);
    _bodyMonthLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_bodyMonthLabel respectToSuperFrame:nil];
    
    _bodyDayLabel.frame=CGRectMake(19,125, 50, 20);
    _bodyDayLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_bodyDayLabel respectToSuperFrame:nil];
    
    _bodyShadowView.frame=CGRectMake(0,_bodyYesButton.frame.size.height+_bodyYesButton.frame.origin.y , _bodyShadowView.frame.size.width, _bodyShadowView.frame.size.height);
    
    [self resetShawdowElement];
    
    
    [_bodyCastView removeFromSuperview];

//    _bodyLabel2.frame= CGRectMake(90,135, 200, _bodyLabel2.frame.size.height);
//    _bodyLabel2.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_bodyLabel2 respectToSuperFrame:nil];
//    [_bodyLabel2 setFont:_bodyLabel1.font];
//    [_bodyLabel2 setTextColor:[UIColor colorWithRed:87/255 green:93/255 blue:96/255 alpha:0.4]];
//   
//    _bodyDetailLabel.frame=[[FitmooHelper sharedInstance] caculateLabelHeight:_bodyDetailLabel];
//    _bodyDetailLabel.frame=CGRectMake(40, 155, _bodyDetailLabel.frame.size.width, _bodyDetailLabel.frame.size.height);
//    _bodyDetailLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_bodyDetailLabel respectToSuperFrame:nil];
//    _bodyCastView.frame=CGRectMake(_bodyCastView.frame.origin.x, _bodyCastView.frame.origin.y
//                                   , _bodyCastView.frame.size.width, _bodyDetailLabel.frame.size.height+_bodyDetailLabel.frame.origin.y+3);
// [_bodyShadowView removeFromSuperview];
}

- (void) resetShawdowElement
{
    [_bodyLikeButton setImage:[UIImage imageNamed:@"greyhearticon.png"] forState:UIControlStateNormal];
    [_bodyCommentButton setImage:[UIImage imageNamed:@"greycommenticon.png"] forState:UIControlStateNormal];
    [_bodyShareButton setImage:[UIImage imageNamed:@"greyendorseicon.png"] forState:UIControlStateNormal];
    [_bodyLikeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_bodyCommentButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_bodyShareButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    _bodyGradian.hidden=true;
  //  [_bodyShadowView setBackgroundColor:[UIColor clearColor] ];
}

- (void) setBodyFrameForRegular
{
    _bodyDetailLabel.text= _homeFeed.text;
    _bodyDetailLabel.frame= CGRectMake(30*_frameRadio, _scrollView.frame.size.height+20, _bodyDetailLabel.frame.size.width, _bodyDetailLabel.frame.size.height);
 
    _bodyDetailLabel.frame= [[FitmooHelper sharedInstance] caculateLabelHeight:_bodyDetailLabel];

    if ([_homeFeed.photoArray count]==0&&[_homeFeed.videosArray count]==0)
    {
    _bodyShadowView.frame=CGRectMake(0,_bodyDetailLabel.frame.size.height+_bodyDetailLabel.frame.origin.y , _bodyShadowView.frame.size.width, _bodyShadowView.frame.size.height);

        [self resetShawdowElement];
    }
    
    if ([_bodyDetailLabel.text isEqualToString:@""]) {
        [_bodyDetailLabel removeFromSuperview];
    }
    
    [_bodyCastView removeFromSuperview];
}
- (void) setBodyFrameForWorkout
{
    _bodyDetailLabel.text= _homeFeed.text;
    _bodyTitle.text= _homeFeed.workout_title;
    _bodyTitle.frame= CGRectMake(30*_frameRadio, _scrollView.frame.size.height+20, _bodyTitle.frame.size.width, _bodyTitle.frame.size.height);
  
    
    _bodyDetailLabel.frame=CGRectMake(30*_frameRadio, _bodyTitle.frame.size.height+_bodyTitle.frame.origin.y+5, _bodyDetailLabel.frame.size.width, _bodyTitle.frame.size.height);
    _bodyDetailLabel.frame=[[FitmooHelper sharedInstance] caculateLabelHeight:_bodyDetailLabel];

    
    if ([_homeFeed.photoArray count]==0&&[_homeFeed.videosArray count]==0)
    {

    _bodyShadowView.frame=CGRectMake(0,_bodyDetailLabel.frame.size.height+_bodyDetailLabel.frame.origin.y , _bodyShadowView.frame.size.width, _bodyShadowView.frame.size.height);
        [self resetShawdowElement];
    }
    [_bodyCastView removeFromSuperview];
    
   
    _headerTag.hidden=false;
}

- (void) setBodyFrameForNutrition
{
    _bodyTitle.text= _homeFeed.nutrition.title;
    _bodyLabel2.text=@"Ingredients";
    _bodyDetailLabel.text= _homeFeed.nutrition.ingredients;
    _bodyLabel3.text=@"Preparation";
    _bodyLabel1.text= _homeFeed.nutrition.preparation;
    
    _bodyTitle.frame= CGRectMake(30*_frameRadio, _scrollView.frame.size.height+20, 260*_frameRadio, _bodyTitle.frame.size.height);
    _bodyTitle.textAlignment = NSTextAlignmentCenter;

    
    _bodyLabel2.frame= CGRectMake(30*_frameRadio, _bodyTitle.frame.origin.y+_bodyTitle.frame.size.height+15, 260, _bodyLabel2.frame.size.height);
  
    _bodyDetailLabel.frame= CGRectMake(30*_frameRadio, _bodyLabel2.frame.size.height+_bodyLabel2.frame.origin.y+3, 260*_frameRadio, _bodyDetailLabel.frame.size.height);
    _bodyDetailLabel.frame=[[FitmooHelper sharedInstance] caculateLabelHeight:_bodyDetailLabel];


    _bodyLabel3.frame= CGRectMake(30*_frameRadio,_bodyDetailLabel.frame.size.height+_bodyDetailLabel.frame.origin.y+15 , 260*_frameRadio, _bodyLabel3.frame.size.height);
    
    _bodyLabel1.frame= CGRectMake(30*_frameRadio, _bodyLabel3.frame.size.height+_bodyLabel3.frame.origin.y+5, 260*_frameRadio, _bodyLabel1.frame.size.height);
    _bodyLabel1.frame=[[FitmooHelper sharedInstance] caculateLabelHeight:_bodyLabel1];


    
    if ([_homeFeed.photoArray count]==0&&[_homeFeed.videosArray count]==0)
    {
        _bodyShadowView.frame=CGRectMake(0,_bodyLabel1.frame.size.height+_bodyLabel1.frame.origin.y , _bodyShadowView.frame.size.width, _bodyShadowView.frame.size.height);
          [self resetShawdowElement];
    }

    [_bodyCastView removeFromSuperview];
    _headerTag.hidden=false;
    _headerTag.image= [UIImage imageNamed:@"nutritiontag.png"];
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
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:8];
    [attributedString addAttribute:NSParagraphStyleAttributeName
                             value:style
                             range:NSMakeRange(0, string.length)];
    
    if (index==0) {
     _commentImage= [[UIImageView alloc] initWithFrame:CGRectMake(12, 17, 11, 9)];
     _commentImage.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_commentImage respectToSuperFrame:nil];
     _commentImage.image= [UIImage imageNamed:@"greycommenticon.png"];

    _commentDetail= [[UILabel alloc] initWithFrame:CGRectMake(30*_frameRadio, 15*_frameRadio, 270*_frameRadio,20*_frameRadio)];
  //  [_commentDetail setText:string];
   
  //  _commentDetail.frame= [[FitmooHelper sharedInstance] caculateLabelHeight:_commentDetail];
    [_commentDetail setAttributedText:attributedString];
        
    _commentDetail.lineBreakMode= NSLineBreakByWordWrapping;
    _commentDetail.numberOfLines=0;
    [_commentDetail sizeToFit];
      [_commentView addSubview:_commentImage];
    [_commentView addSubview:_commentDetail];
    }
   
    if (index==1) {
       
        _commentDetail1= [[UILabel alloc] initWithFrame:CGRectMake(30*_frameRadio, 15*_frameRadio+_commentDetail.frame.size.height+_commentDetail.frame.origin.y, 270*_frameRadio,20*_frameRadio)];
     //   [_commentDetail1 setText:string];
     //   _commentDetail1.frame= [[FitmooHelper sharedInstance] caculateLabelHeight:_commentDetail1];
        [_commentDetail1 setAttributedText:attributedString];
        _commentDetail1.lineBreakMode= NSLineBreakByWordWrapping;
        _commentDetail1.numberOfLines=0;
        [_commentDetail1 sizeToFit];
        
        [_commentView addSubview:_commentDetail1];
    }
    
    if (index==2) {
       
        _commentDetail2= [[UILabel alloc] initWithFrame:CGRectMake(30*_frameRadio, 15*_frameRadio+_commentDetail1.frame.size.height+_commentDetail1.frame.origin.y, 270*_frameRadio,20*_frameRadio)];
     //   [_commentDetail2 setText:string];
      //  _commentDetail2.frame= [[FitmooHelper sharedInstance] caculateLabelHeight:_commentDetail2];
        [_commentDetail2 setAttributedText:attributedString];
        _commentDetail2.lineBreakMode= NSLineBreakByWordWrapping;
        _commentDetail2.numberOfLines=0;
        [_commentDetail2 sizeToFit];
        
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
     self.buttomView.frame= CGRectMake(self.buttomView.frame.origin.x, self.commentView.frame.origin.y+2, self.buttomView.frame.size.width, self.buttomView.frame.size.height);
    [_commentView removeFromSuperview];
}

- (void) removeViewsFromBodyView: (UIView *) removeView
{
    int frameHeight=_bodyView.frame.size.height-removeView.frame.size.height;
    self.bodyView.frame= CGRectMake(self.bodyView.frame.origin.x, self.bodyView.frame.origin.y, self.bodyView.frame.size.width, frameHeight);
  //  self.bodyCastView.frame= CGRectMake(self.bodyCastView.frame.origin.x, self.bodyCastView.frame.origin.y, self.bodyCastView.frame.size.width, self.bodyCastView.frame.size.height);
    self.commentView.frame= CGRectMake(self.commentView.frame.origin.x, self.commentView.frame.origin.y-removeView.frame.size.height, self.commentView.frame.size.width, self.commentView.frame.size.height);

    self.buttomView.frame= CGRectMake(self.buttomView.frame.origin.x, self.buttomView.frame.origin.y-removeView.frame.size.height, self.buttomView.frame.size.width, self.buttomView.frame.size.height);
    
  //  [_scrollView removeFromSuperview];
   _scrollView.frame= CGRectMake(0, 0, _scrollView.frame.size.width, 0);
}

- (void) loadHeaderImage1: (NSString *)url
{
    AsyncImageView *headerImage1 = [[AsyncImageView alloc] init];
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:headerImage1];
    headerImage1.imageURL =[NSURL URLWithString:url];
    [self.heanderImage1 setImage:headerImage1.image forState:UIControlStateNormal];
}

- (void) setTitleLabelForHeader
{
    UIFont *font = [UIFont fontWithName:@"BentonSans" size:self.titleLabel.font.pointSize];
    NSMutableAttributedString *attributedString= [[NSMutableAttributedString alloc] initWithString:self.titleLabel.text attributes:@{NSFontAttributeName: font}  ];
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:3];
    [attributedString addAttribute:NSParagraphStyleAttributeName
                             value:style
                             range:NSMakeRange(0, self.titleLabel.text.length)];
    
    
    [self.titleLabel setAttributedText:attributedString];
    self.titleLabel.numberOfLines=2;
    [self.titleLabel sizeToFit];

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

- (void) setBodyShadowFrameForTextPost
{

}
- (void) setBodyShadowFrameForImagePost
{
    _bodyShadowView.frame=CGRectMake(0, _scrollView.frame.size.height+_scrollView.frame.origin.y-_bodyShadowView.frame.size.height, _bodyShadowView.frame.size.width, _bodyShadowView.frame.size.height);
  
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
    
    _headerTag.frame=[[FitmooHelper sharedInstance] resizeFrameWithFrame:_headerTag respectToSuperFrame:nil];
    

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
    
    _scrollView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_scrollView respectToSuperFrame:nil];
    _bodyCastView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_bodyCastView respectToSuperFrame:nil];
    

    _bodyShadowView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_bodyShadowView respectToSuperFrame:nil];
    _bodyLikeButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_bodyLikeButton respectToSuperFrame:nil];
    _bodyCommentButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_bodyCommentButton respectToSuperFrame:nil];
    _bodyShareButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_bodyShareButton respectToSuperFrame:nil];
    _bodyGradian.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_bodyGradian respectToSuperFrame:nil];
  //  _viewArray=[[NSMutableArray alloc] initWithObjects:_headerView,_bodyView,_commentView,_commentView1,_commentView2, nil];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end

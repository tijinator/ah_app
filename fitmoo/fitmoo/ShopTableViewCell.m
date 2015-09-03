//
//  ShopTableViewCell.m
//  fitmoo
//
//  Created by hongjian lin on 9/1/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import "ShopTableViewCell.h"
#import "FitmooHelper.h"
@implementation ShopTableViewCell

- (void)awakeFromNib {
    [self initFrames];
    _homeFeed= [[HomeFeed alloc] init];
    
    int frameHeight= self.buttomView.frame.origin.y + self.buttomView.frame.size.height;
    self.contentView.frame= CGRectMake(self.contentView.frame.origin.x, self.contentView.frame.origin.y, self.contentView.frame.size.width, frameHeight);
    _frameRadio= [[FitmooHelper sharedInstance] frameRadio];
    _scrollViewWidth=320;
    _scrollViewHeight=320;
    _scrollbelowFrame= [[UIView alloc] initWithFrame:CGRectMake(0, 0, _scrollViewWidth, _scrollViewHeight)];

}


- (void) rebuiltCommentViewFrame
{
    int maxHeight=0;
    for (UIView * subview in _commentView.subviews) {
        int temHeight= (subview.frame.size.height+subview.frame.origin.y+5);
        maxHeight= MAX(maxHeight, temHeight);
    }
    _commentView.frame= CGRectMake(0, _commentView.frame.origin.y, _commentView.frame.size.width, maxHeight+5*_frameRadio);
    
    self.buttomView.frame= CGRectMake(self.buttomView.frame.origin.x, self.commentView.frame.size.height+self.commentView.frame.origin.y+1, self.buttomView.frame.size.width, self.buttomView.frame.size.height);
    
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
    
    
    self.variantsView.frame=CGRectMake(self.variantsView.frame.origin.x, _bodyView.frame.size.height+_bodyView.frame.origin.y, self.variantsView.frame.size.width, self.variantsView.frame.size.height);
    self.headerView.frame= CGRectMake(self.headerView.frame.origin.x, _variantsView.frame.size.height+_variantsView.frame.origin.y, self.headerView.frame.size.width, self.headerView.frame.size.height);
    
    self.commentView.frame= CGRectMake(self.commentView.frame.origin.x, _headerView.frame.size.height+_headerView.frame.origin.y, self.commentView.frame.size.width, self.commentView.frame.size.height);
    
    self.buttomView.frame= CGRectMake(self.buttomView.frame.origin.x, self.commentView.frame.size.height+self.commentView.frame.origin.y+1, self.buttomView.frame.size.width, self.buttomView.frame.size.height);
    
}

- (void) addScrollView
{
    if (_scrollView!=nil) {
        [_scrollView removeFromSuperview];
        _scrollView=nil;
    }
    
    _scrollView= [[UIScrollView alloc] initWithFrame:_scrollbelowFrame.frame];
    _scrollView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_scrollView respectToSuperFrame:nil];
    
    _scrollView.delegate = self;
    

        
        int x =0;
        [_homeFeed resetAsycImageViewArray];
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
            
            [_homeFeed.AsycImageViewArray addObject:scrollImage];
        }
        _bodyImage= [[UIButton alloc] initWithFrame:CGRectMake(0,0, _scrollView.contentSize.width, _scrollView.contentSize.height)];
        [_scrollView addSubview:_bodyImage];
        
        
    
    
    [_bodyView insertSubview:_scrollView belowSubview:_bodyShadowView];
    // [_bodyView addSubview:_scrollView];
}

- (void) reBuiltTopViewFrame
{
    int maxHeight=0;
    for (UIView * subview in _topView.subviews) {
        
            int temHeight= (subview.frame.size.height+subview.frame.origin.y+20);
            maxHeight= MAX(maxHeight, temHeight);
       
    }
    _topView.frame= CGRectMake(0, _topView.frame.origin.y, _topView.frame.size.width, maxHeight);
    
    self.bodyView.frame=CGRectMake(self.bodyView.frame.origin.x, _topView.frame.size.height+_topView.frame.origin.y, self.bodyView.frame.size.width, self.bodyView.frame.size.height);
    
    self.variantsView.frame=CGRectMake(self.variantsView.frame.origin.x, _bodyView.frame.size.height+_bodyView.frame.origin.y, self.variantsView.frame.size.width, self.variantsView.frame.size.height);
    self.headerView.frame= CGRectMake(self.headerView.frame.origin.x, _variantsView.frame.size.height+_variantsView.frame.origin.y, self.headerView.frame.size.width, self.headerView.frame.size.height);
    
    self.commentView.frame= CGRectMake(self.commentView.frame.origin.x, _headerView.frame.size.height+_headerView.frame.origin.y, self.commentView.frame.size.width, self.commentView.frame.size.height);
    
    self.buttomView.frame= CGRectMake(self.buttomView.frame.origin.x, self.commentView.frame.size.height+self.commentView.frame.origin.y+1, self.buttomView.frame.size.width, self.buttomView.frame.size.height);

}

- (void) setTopViewFrameForProduct
{
    _topTitleLabel.text=_homeFeed.product.title.uppercaseString;
    _topTitleLabel.frame= [[FitmooHelper sharedInstance] caculateLabelHeight:_topTitleLabel];
    
    
    _topCategoryLabel.frame= CGRectMake(self.topCategoryLabel.frame.origin.x, _topTitleLabel.frame.size.height+_topTitleLabel.frame.origin.y+5, self.topCategoryLabel.frame.size.width, self.topCategoryLabel.frame.size.height);
    _topPriceLabel.frame= CGRectMake(self.topPriceLabel.frame.origin.x, _topCategoryLabel.frame.size.height+_topCategoryLabel.frame.origin.y+10, self.topPriceLabel.frame.size.width, self.topPriceLabel.frame.size.height);
    
    _topCategoryLabel.text= [NSString stringWithFormat:@"%@%@%@",_homeFeed.product.type_product,@" • ", _homeFeed.product.gender];
    _topPriceLabel.text=[NSString stringWithFormat:@"%@%@",@"$", _homeFeed.product.selling_price];
    
    [self reBuiltTopViewFrame];
}




- (void) setBodyFrameForProduct
{

    _bodyDetailLabel.text= _homeFeed.product.detail;
    _bodyDetailLabel.frame= CGRectMake(30*_frameRadio, _scrollView.frame.size.height+20, _bodyDetailLabel.frame.size.width, _bodyDetailLabel.frame.size.height);
    
    _bodyDetailLabel.frame= [[FitmooHelper sharedInstance] caculateLabelHeight:_bodyDetailLabel];
    
    if (_bodyDetailLabel.frame.size.height>100) {
        _bodyDetailLabel.numberOfLines=0;
        [_bodyDetailLabel sizeToFit];
        double radio=_bodyDetailLabel.frame.size.height/100;
        _bodyDetailLabel.frame=CGRectMake(_bodyDetailLabel.frame.origin.x,_bodyDetailLabel.frame.origin.y, _bodyDetailLabel.frame.size.width, _bodyDetailLabel.frame.size.height+30*radio);
        
    }
    
    if ([_bodyDetailLabel.text isEqualToString:@""]) {
        [_bodyDetailLabel removeFromSuperview];
    }
    
 

}

- (void) rebuiltVariantsViewFrame
{
    int maxHeight=0;
    for (UIView * subview in _variantsView.subviews) {
        
        int temHeight= (subview.frame.size.height+subview.frame.origin.y+15);
        maxHeight= MAX(maxHeight, temHeight);
        
    }
    _variantsView.frame= CGRectMake(0, _variantsView.frame.origin.y, _variantsView.frame.size.width, maxHeight);
    

    self.headerView.frame= CGRectMake(self.headerView.frame.origin.x, _variantsView.frame.size.height+_variantsView.frame.origin.y, self.headerView.frame.size.width, self.headerView.frame.size.height);
    
    self.commentView.frame= CGRectMake(self.commentView.frame.origin.x, _headerView.frame.size.height+_headerView.frame.origin.y, self.commentView.frame.size.width, self.commentView.frame.size.height);
    
    self.buttomView.frame= CGRectMake(self.buttomView.frame.origin.x, self.commentView.frame.size.height+self.commentView.frame.origin.y+1, self.buttomView.frame.size.width, self.buttomView.frame.size.height);
}

- (void) setVariantsFrame
{
    if ([_homeFeed.product.variant_options_array count]==1) {
        
        [_variantsButton4 removeFromSuperview];
        [_variantsButton3 removeFromSuperview];
        
        [_homeFeed.product resetOptions];
        _homeFeed.product.variant_options=[_homeFeed.product.variant_options_array objectAtIndex:0] ;
        [_variantsButton1 setTitle:_homeFeed.product.variant_options.title forState:UIControlStateNormal];
        [_variantsButton2 setTitle:@"QTY" forState:UIControlStateNormal];
    }else if ([_homeFeed.product.variant_options_array count]==2) {
        [_variantsButton4 removeFromSuperview];
        [_homeFeed.product resetOptions];
        _homeFeed.product.variant_options=[_homeFeed.product.variant_options_array objectAtIndex:0] ;
        [_variantsButton1 setTitle:_homeFeed.product.variant_options.title forState:UIControlStateNormal];
        
        [_homeFeed.product resetOptions];
        _homeFeed.product.variant_options=[_homeFeed.product.variant_options_array objectAtIndex:1] ;
        [_variantsButton2 setTitle:_homeFeed.product.variant_options.title forState:UIControlStateNormal];
        [_variantsButton3 setTitle:@"QTY" forState:UIControlStateNormal];
        
    }else if ([_homeFeed.product.variant_options_array count]==3) {
        [_homeFeed.product resetOptions];
        _homeFeed.product.variant_options=[_homeFeed.product.variant_options_array objectAtIndex:0] ;
        [_variantsButton1 setTitle:_homeFeed.product.variant_options.title forState:UIControlStateNormal];
        
        [_homeFeed.product resetOptions];
        _homeFeed.product.variant_options=[_homeFeed.product.variant_options_array objectAtIndex:1] ;
        [_variantsButton2 setTitle:_homeFeed.product.variant_options.title forState:UIControlStateNormal];
        
        [_homeFeed.product resetOptions];
        _homeFeed.product.variant_options=[_homeFeed.product.variant_options_array objectAtIndex:2] ;
        [_variantsButton3 setTitle:_homeFeed.product.variant_options.title forState:UIControlStateNormal];
        
        [_variantsButton4 setTitle:@"QTY" forState:UIControlStateNormal];
        
    }else if ([_homeFeed.product.variant_options_array count]==0) {
        [_variantsButton4 removeFromSuperview];
        [_variantsButton3 removeFromSuperview];
        [_variantsButton2 removeFromSuperview];
        
        [_variantsButton1 setTitle:@"QTY" forState:UIControlStateNormal];
        
    }
    
     [self rebuiltVariantsViewFrame];
}



- (CGRect)caculateLabelHeight: (UILabel *) originalLabel withString: (NSString *) string
{
    UIFont *font= [UIFont fontWithName:@"BentonSans" size:(CGFloat)(14)];
    UILabel *temLabel= [[UILabel alloc] initWithFrame:originalLabel.frame];
    temLabel.lineBreakMode= NSLineBreakByWordWrapping;
    temLabel.baselineAdjustment = UIBaselineAdjustmentAlignBaselines; // or UIBaselineAdjustmentAlignCenters, or UIBaselineAdjustmentNone
    temLabel.adjustsFontSizeToFitWidth = YES;
    temLabel.numberOfLines=30;
    temLabel.text=string;
    temLabel.minimumScaleFactor = 10.0f/12.0f;
    temLabel.textAlignment = NSTextAlignmentLeft;
    temLabel.font=font;
    
    temLabel.frame=[[FitmooHelper sharedInstance] caculateLabelHeight:temLabel];
    return  temLabel.frame;
}

- (void) addCommentView: (UIView *) addView Atindex:(int) index
{
    
    
    UIFont *font= [UIFont fontWithName:@"BentonSans" size:(CGFloat)(14)];
    UIFont *font1= [UIFont fontWithName:@"BentonSans-Medium" size:(CGFloat)(14)];
    NSString *string1=_homeFeed.comments.full_name;
    NSString *string2=_homeFeed.comments.text;
    UIColor *fontColor= [UIColor colorWithRed:87.0/255.0 green:93.0/255.0 blue:96.0/255.0 alpha:1];
    
    NSString *string= [NSString stringWithFormat:@"%@  %@",string1,string2];
    NSMutableAttributedString *attributedString= [[NSMutableAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName: font} ];
    attributedString=(NSMutableAttributedString *) [[FitmooHelper sharedInstance] replaceAttributedString:attributedString Font:font1 range:string1 newString:string1];
    NSRange range= [string rangeOfString:string2];
    [attributedString addAttribute:NSForegroundColorAttributeName value:fontColor range:range];
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:6];
    [style setLineBreakMode:NSLineBreakByWordWrapping];
    [attributedString addAttribute:NSParagraphStyleAttributeName
                             value:style
                             range:NSMakeRange(0, string.length)];
    
    
    
    if (index==0) {
        
        
        _commentDetail= [[UILabel alloc] initWithFrame:CGRectMake(30*_frameRadio, 15*_frameRadio, 270*_frameRadio,22*_frameRadio)];
        [_commentDetail setAttributedText:attributedString];
        
        _commentDetail.numberOfLines=0;
        [_commentDetail sizeToFit];
        _commentDetail.lineBreakMode= NSLineBreakByWordWrapping;
        
        _commentImage= [[UIImageView alloc] initWithFrame:CGRectMake(12*_frameRadio, _commentDetail.frame.origin.y+1*_frameRadio, 11*_frameRadio, 9*_frameRadio)];
        _commentImage.image= [UIImage imageNamed:@"greycommenticon.png"];
        
        [_commentView addSubview:_commentImage];
        [_commentView addSubview:_commentDetail];
        
        
    }
    
    
    if (index==1) {
        
        _commentDetail1= [[UILabel alloc] initWithFrame:CGRectMake(30*_frameRadio, 5*_frameRadio+_commentDetail.frame.size.height+_commentDetail.frame.origin.y, 270*_frameRadio,22*_frameRadio)];

        
        [_commentDetail1 setAttributedText:attributedString];
        _commentDetail1.lineBreakMode= NSLineBreakByWordWrapping;
        
        _commentDetail1.numberOfLines=0;
        [_commentDetail1 sizeToFit];
        
        [_commentView addSubview:_commentDetail1];
        
        
    }
    
    if (index==2) {
        _commentDetail2= [[UILabel alloc] initWithFrame:CGRectMake(30*_frameRadio, 5*_frameRadio+_commentDetail1.frame.size.height+_commentDetail1.frame.origin.y, 270*_frameRadio,22*_frameRadio)];
        
        
        [_commentDetail2 setAttributedText:attributedString];
        _commentDetail2.lineBreakMode= NSLineBreakByWordWrapping;
        _commentDetail2.numberOfLines=0;
        [_commentDetail2 sizeToFit];
        
        
        [_commentView addSubview:_commentDetail2];
        
        
    }
    
    if (_homeFeed.total_comment.intValue>3) {
        _viewAllCommentButton.frame= CGRectMake(_commentDetail2.frame.origin.x, _commentDetail2.frame.origin.y+_commentDetail2.frame.size.height, _viewAllCommentButton.frame.size.width, _viewAllCommentButton.frame.size.height);
        [_commentView addSubview:_viewAllCommentButton];
    }
    
}



- (void) removeCommentView
{
    self.buttomView.frame= CGRectMake(self.buttomView.frame.origin.x, self.commentView.frame.origin.y+1, self.buttomView.frame.size.width, self.buttomView.frame.size.height);
    [_commentView removeFromSuperview];
}

- (void) removeViewsFromBodyView: (UIView *) removeView
{
    int frameHeight=_bodyView.frame.size.height-removeView.frame.size.height;
    self.bodyView.frame= CGRectMake(self.bodyView.frame.origin.x, self.bodyView.frame.origin.y, self.bodyView.frame.size.width, frameHeight);
    
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
    NSString *titletext=self.titleLabel.text;
    if (titletext==nil) {
        titletext=@"Fitmoo";
    }
    
    UIFont *font = [UIFont fontWithName:@"BentonSans-Medium" size:self.titleLabel.font.pointSize];
    NSMutableAttributedString *attributedString= [[NSMutableAttributedString alloc] initWithString:titletext attributes:@{NSFontAttributeName: font}  ];
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:3];
    [attributedString addAttribute:NSParagraphStyleAttributeName
                             value:style
                             range:NSMakeRange(0, self.titleLabel.text.length)];
    
    
    [self.titleLabel setAttributedText:attributedString];
    self.titleLabel.numberOfLines=0;
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


- (void) rebuiltHeaderViewFrame
{
  
    int maxHeight=0;
    for (UIView * subview in _headerView.subviews) {
        
        int temHeight= (subview.frame.size.height+subview.frame.origin.y+5);
        maxHeight= MAX(maxHeight, temHeight);
        
    }
    _headerView.frame=CGRectMake(0, _headerView.frame.origin.y, _headerView.frame.size.width, maxHeight);

    self.commentView.frame= CGRectMake(self.commentView.frame.origin.x, _headerView.frame.size.height+_headerView.frame.origin.y, self.commentView.frame.size.width, self.commentView.frame.size.height);
    
    self.buttomView.frame= CGRectMake(self.buttomView.frame.origin.x, self.commentView.frame.size.height+self.commentView.frame.origin.y+1, self.buttomView.frame.size.width, self.buttomView.frame.size.height);
    
}


- (void) setBodyShadowFrameForImagePost
{
    _bodyShadowView.frame=CGRectMake(0, _scrollView.frame.size.height+_scrollView.frame.origin.y-_bodyShadowView.frame.size.height, _bodyShadowView.frame.size.width, _bodyShadowView.frame.size.height);
    
}


- (void) initFrames
{
    
    self.contentView.frame=[[FitmooHelper sharedInstance] resizeFrameWithFrame:self.contentView respectToSuperFrame:nil];
    _topView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_topView respectToSuperFrame:nil];
    _topTitleLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_topTitleLabel respectToSuperFrame:nil];
    _topCategoryLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_topCategoryLabel respectToSuperFrame:nil];
    _topPriceLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_topPriceLabel respectToSuperFrame:nil];
    _variantsView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_variantsView respectToSuperFrame:nil];
    _variantsButton1.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_variantsButton1 respectToSuperFrame:nil];
    _variantsButton2.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_variantsButton2 respectToSuperFrame:nil];
    _variantsButton3.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_variantsButton3 respectToSuperFrame:nil];
    _variantsButton4.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_variantsButton4 respectToSuperFrame:nil];
    
    _variantsButton1.layer.cornerRadius=5;
    _variantsButton2.layer.cornerRadius=5;
    _variantsButton3.layer.cornerRadius=5;
    _variantsButton4.layer.cornerRadius=5;
    
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
    _commentName1.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_commentName1 respectToSuperFrame:nil];
    _commentDetail1.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_commentDetail1 respectToSuperFrame:nil];
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
    _scrollView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_scrollView respectToSuperFrame:nil];
    _bodyShadowView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_bodyShadowView respectToSuperFrame:nil];
    _bodyLikeButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_bodyLikeButton respectToSuperFrame:nil];
    _bodyCommentButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_bodyCommentButton respectToSuperFrame:nil];
    _bodyGradian.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_bodyGradian respectToSuperFrame:nil];
    _viewAllCommentButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_viewAllCommentButton respectToSuperFrame:nil];

    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//
//  ShopTableViewCell.h
//  fitmoo
//
//  Created by hongjian lin on 9/1/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeFeed.h"
#import "AsyncImageView.h"
@interface ShopTableViewCell : UITableViewCell<UIScrollViewDelegate>


@property (strong, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) IBOutlet UILabel *topTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *topCategoryLabel;
@property (strong, nonatomic) IBOutlet UILabel *topPriceLabel;

@property (strong, nonatomic) IBOutlet UIView *variantsView;
@property (strong, nonatomic) IBOutlet UIButton *variantsButton1;
@property (strong, nonatomic) IBOutlet UIButton *variantsButton2;
@property (strong, nonatomic) IBOutlet UIButton *variantsButton3;
@property (strong, nonatomic) IBOutlet UIButton *variantsButton4;


@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIButton *heanderImage1;
@property (strong, nonatomic) IBOutlet UIButton *headerImage2;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *dayLabel;
@property (strong, nonatomic) IBOutlet UIView *bodyView;
@property (strong, nonatomic) IBOutlet UILabel *bodyDetailLabel;
@property (strong, nonatomic) IBOutlet UIButton *bodyImage;

@property (strong, nonatomic) IBOutlet UIButton *likeButton;
@property (strong, nonatomic) IBOutlet UIButton *commentButton;
@property (strong, nonatomic) IBOutlet UIButton *shareButton;
@property (strong, nonatomic) IBOutlet UIButton *optionButton;
@property (strong, nonatomic) IBOutlet UIView *buttomView;
@property (strong, nonatomic) IBOutlet UIView *commentView;
@property (strong, nonatomic) IBOutlet UIImageView *commentImage;
@property (strong, nonatomic) IBOutlet UIButton *viewAllCommentButton;

@property (strong, nonatomic) IBOutlet UILabel *commentName;
@property (strong, nonatomic) IBOutlet UILabel *commentName1;
@property (strong, nonatomic) IBOutlet UILabel *commentName2;
@property (strong, nonatomic) IBOutlet UILabel *commentDetail;
@property (strong, nonatomic) IBOutlet UILabel *commentDetail1;
@property (strong, nonatomic) IBOutlet UILabel *commentDetail2;

@property (strong, nonatomic) IBOutlet UIView *bodyShadowView;
@property (strong, nonatomic) IBOutlet UIButton *bodyLikeButton;
@property (strong, nonatomic) IBOutlet UIButton *bodyCommentButton;
@property (strong, nonatomic) IBOutlet UIImageView *bodyGradian;
@property (strong, nonatomic)  IBOutlet UIScrollView *scrollView;


@property (strong, nonatomic)  NSMutableArray *viewArray;

@property (strong, nonatomic) HomeFeed *homeFeed;
@property (assign, nonatomic) double frameRadio;
@property (assign, nonatomic) double scrollViewWidth;
@property (assign, nonatomic) double scrollViewHeight;
@property (strong, nonatomic) UIView * scrollbelowFrame;

- (void) removeViewsFromBodyView: (UIView *) removeView;
- (void) reDefineHearderViewsFrame;
- (void) removeCommentView;

- (void) addCommentView: (UIView *) addView Atindex:(int) index;
- (void) loadHeaderImage1: (NSString *)url;
- (void) loadHeaderImage2: (NSString *)url;


- (void) addScrollView;
- (void) rebuiltBodyViewFrame;
- (void) rebuiltHeaderViewFrame;
- (void) rebuiltCommentViewFrame;
- (void) setTopViewFrameForProduct;
- (void) setBodyFrameForProduct;
- (void) setBodyShadowFrameForImagePost;
- (void) setVariantsFrame;
- (void) setTitleLabelForHeader;

@end

//
//  ShareTableViewCell.h
//  fitmoo
//
//  Created by hongjian lin on 4/9/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeFeed.h"
#import "AsyncImageView.h"
#import "RTLabel.h"
//#import "Comments.h"

@interface ShareTableViewCell : UITableViewCell <UIScrollViewDelegate,RTLabelDelegate>
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIButton *heanderImage1;
@property (strong, nonatomic) IBOutlet UIButton *headerImage2;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *dayLabel;
@property (strong, nonatomic) IBOutlet UIImageView *headerTag;

@property (strong, nonatomic) IBOutlet UIView *bodyView;
@property (strong, nonatomic) IBOutlet UILabel *bodyDetailLabel;
@property (strong, nonatomic) IBOutlet UIButton *bodyImage;
@property (strong, nonatomic) IBOutlet UILabel *bodyTitle;
@property (strong, nonatomic) IBOutlet UILabel *bodyLabel1;
@property (strong, nonatomic) IBOutlet UILabel *bodyLabel2;
@property (strong, nonatomic) IBOutlet UILabel *bodyLabel3;

@property (strong, nonatomic) IBOutlet UIView *bodyCastView;
@property (strong, nonatomic) IBOutlet UIButton *likeButton;
@property (strong, nonatomic) IBOutlet UIButton *commentButton;
@property (strong, nonatomic) IBOutlet UIButton *shareButton;
@property (strong, nonatomic) IBOutlet UIButton *optionButton;
@property (strong, nonatomic) IBOutlet UIView *buttomView;

@property (strong, nonatomic) IBOutlet UIView *commentView;
@property (strong, nonatomic) IBOutlet UIImageView *commentImage;
@property (strong, nonatomic) IBOutlet UIButton *ShadowBuyNowButton;

@property (strong, nonatomic) IBOutlet UIView *commentView1;
@property (strong, nonatomic) IBOutlet UIView *commentView2;

@property (strong, nonatomic) IBOutlet UILabel *commentName;
@property (strong, nonatomic) IBOutlet UILabel *commentName1;
@property (strong, nonatomic) IBOutlet UILabel *commentName2;
@property (strong, nonatomic) IBOutlet UILabel *commentDetail;
@property (strong, nonatomic) IBOutlet UILabel *commentDetail1;
@property (strong, nonatomic) IBOutlet UILabel *commentDetail2;
@property (strong, nonatomic) IBOutlet UILabel *workoutTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *workoutTypeLabel;


@property (strong, nonatomic) IBOutlet UIView *bodyShadowView;
@property (strong, nonatomic) IBOutlet UIButton *bodyLikeButton;
@property (strong, nonatomic) IBOutlet UIButton *bodyCommentButton;
@property (strong, nonatomic) IBOutlet UIButton *bodyShareButton;
@property (strong, nonatomic) IBOutlet UIImageView *bodyGradian;
@property (strong, nonatomic) IBOutlet UIButton *bodyYesButton;
@property (strong, nonatomic) IBOutlet UIButton *bodyMaybeButton;
@property (strong, nonatomic) IBOutlet UIImageView *bodyDateImage;
@property (strong, nonatomic) IBOutlet UIImageView *bodyBluePeopleImage;
@property (strong, nonatomic) IBOutlet UILabel *bodyMonthLabel;
@property (strong, nonatomic) IBOutlet UILabel *bodyDayLabel;


@property (strong, nonatomic)  NSMutableArray *viewArray;
@property (strong, nonatomic)  IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) HomeFeed *homeFeed;
@property (assign, nonatomic) double frameRadio;
@property (assign, nonatomic) double scrollViewWidth;
@property (assign, nonatomic) double scrollViewHeight;
@property (strong, nonatomic) UIView * scrollbelowFrame;

- (void) removeViewsFromBodyView: (UIView *) removeView;
- (void) reDefineHearderViewsFrame;
- (void) removeCommentView;
- (void) removeCommentView2;
- (void) removeCommentView1;
- (void) addCommentView: (UIView *) addView Atindex:(int) index;
- (void) loadHeaderImage1: (NSString *)url;
- (void) loadHeaderImage2: (NSString *)url;
- (void) loadCommentImage: (NSString *)url;
- (void) deleteViews:(UIView *)view;
- (void) addScrollView;
- (void) rebuiltBodyViewFrame;
- (void) rebuiltHeaderViewFrame;
- (void) rebuiltCommentViewFrame;
- (void) setBodyFrameForWorkout;
- (void) setBodyFrameForRegular;
- (void) setBodyFrameForNutrition;
- (void) setBodyFrameForEvent;
- (void) setBodyFrameForProduct;
- (void) setBodyShadowFrameForTextPost;
- (void) setBodyShadowFrameForImagePost;
- (void) setTitleLabelForHeader;

@property (nonatomic, strong) RTLabel *rtLabel;
@property (nonatomic, strong) RTLabel *rtLabel1;
@property (nonatomic, strong) RTLabel *rtLabel2;

@property (nonatomic, assign) bool showEventDetail;

@property (strong, nonatomic) IBOutlet UIButton *viewAllCommentButton;


@end

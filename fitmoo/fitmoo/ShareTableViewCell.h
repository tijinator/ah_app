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

@interface ShareTableViewCell : UITableViewCell <UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIView *bodyView;
@property (strong, nonatomic) IBOutlet UIView *commentView;
@property (strong, nonatomic) IBOutlet UIView *buttomView;
@property (strong, nonatomic) IBOutlet UIButton *heanderImage1;
@property (strong, nonatomic) IBOutlet UIButton *headerImage2;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *dayLabel;
@property (strong, nonatomic) IBOutlet UILabel *bodyDetailLabel;
@property (strong, nonatomic) IBOutlet UIButton *commentImage;
@property (strong, nonatomic) IBOutlet UILabel *commentName;
@property (strong, nonatomic) IBOutlet UILabel *commentDetail;

@property (strong, nonatomic) IBOutlet UIButton *likeButton;
@property (strong, nonatomic) IBOutlet UIButton *commentButton;
@property (strong, nonatomic) IBOutlet UIButton *shareButton;
@property (strong, nonatomic) IBOutlet UIButton *optionButton;
- (IBAction)likeClick:(id)sender;

@property (strong, nonatomic)  UIScrollView *scrollView;
@property (strong, nonatomic) HomeFeed *homeFeed;
@property (strong, nonatomic) IBOutlet UIButton *bodyImage;


- (void) addScrollView;

@end

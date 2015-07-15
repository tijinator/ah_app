//
//  CommunityTitileCell.h
//  fitmoo
//
//  Created by hongjian lin on 7/14/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeFeed.h"
#import "FitmooHelper.h"
#import "AsyncImageView.h"
#import <QuartzCore/QuartzCore.h>

@interface CommunityTitileCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *headerImage;

@property (strong, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) IBOutlet UIButton *editProfileButton;
@property (strong, nonatomic) IBOutlet UIView *buttonView;
@property (strong, nonatomic) IBOutlet UIButton *bioButton;
@property (strong, nonatomic) IBOutlet UILabel *bioLabel;

@property (strong, nonatomic) IBOutlet UIImageView *shadowImageView;

@property (strong, nonatomic) IBOutlet UIImageView *headerImage1;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *followCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *followerCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *communityCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *followingLabel;
@property (strong, nonatomic) IBOutlet UILabel *followerLabel;
@property (strong, nonatomic) IBOutlet UILabel *communityLabel;
@property (strong, nonatomic) IBOutlet UIButton *feedButton;
@property (strong, nonatomic) IBOutlet UIButton *scheduleButton;
@property (strong, nonatomic) IBOutlet UIView *buttomView;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UIView *view1;

- (void) setFrameForComunity;
- (void) loadHeaderImage: (NSString *)url;
- (void) loadHeader1Image: (NSString *)url;
@end

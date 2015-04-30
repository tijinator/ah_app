//
//  CommunityTableViewCell.h
//  fitmoo
//
//  Created by hongjian lin on 4/21/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeFeed.h"
#import "FitmooHelper.h"
#import "AsyncImageView.h"
#import <QuartzCore/QuartzCore.h>
@interface CommunityTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *headerImage;
@property (strong, nonatomic) IBOutlet UIButton *joinButton;
@property (strong, nonatomic) IBOutlet UILabel *memberCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UIButton *feedButton;
@property (strong, nonatomic) IBOutlet UIButton *scheduleButton;
@property (strong, nonatomic) IBOutlet UIView *buttomView;
@end

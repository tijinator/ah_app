//
//  FollowCollectionViewCell.h
//  fitmoo
//
//  Created by hongjian lin on 5/19/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FitmooHelper.h"
#import "AsyncImageView.h"
#import <QuartzCore/QuartzCore.h>

@interface FollowCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) IBOutlet UILabel *userLabel;
@property (strong, nonatomic) IBOutlet UIImageView *blackImage;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UIButton *followButton;

@end

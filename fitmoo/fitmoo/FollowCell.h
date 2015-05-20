//
//  FollowCell.h
//  fitmoo
//
//  Created by hongjian lin on 5/19/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FitmooHelper.h"
@interface FollowCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *image1;
@property (strong, nonatomic) IBOutlet UIImageView *image2;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel1;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel2;
@property (strong, nonatomic) IBOutlet UIImageView *userIconImage1;
@property (strong, nonatomic) IBOutlet UIImageView *userIconImage2;
@property (strong, nonatomic) IBOutlet UILabel *followLabel1;
@property (strong, nonatomic) IBOutlet UILabel *followLabel2;
@property (strong, nonatomic) IBOutlet UIButton *followButton1;
@property (strong, nonatomic) IBOutlet UIButton *followButton2;
@property (strong, nonatomic) IBOutlet UIView *view1;
@property (strong, nonatomic) IBOutlet UIView *view2;
@property (strong, nonatomic) IBOutlet UIButton *clickbutton1;
@property (strong, nonatomic) IBOutlet UIButton *clickbutton2;

@end

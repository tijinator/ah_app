//
//  PhotoCell.h
//  fitmoo
//
//  Created by hongjian lin on 5/12/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FitmooHelper.h"
#import "AsyncImageView.h"
@interface PhotoCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIView *view1;
@property (strong, nonatomic) IBOutlet UIView *view2;
@property (strong, nonatomic) IBOutlet UIView *view3;
@property (strong, nonatomic) IBOutlet UIButton *view1Button;
@property (strong, nonatomic) IBOutlet UIImageView *view1VideoIcon;
@property (strong, nonatomic) IBOutlet UIImageView *View1Gradiant;
@property (strong, nonatomic) IBOutlet UILabel *view1Label;
@property (strong, nonatomic) IBOutlet UILabel *view2Label;
@property (strong, nonatomic) IBOutlet UILabel *view3Label;

@property (strong, nonatomic) IBOutlet UIButton *view2Button;
@property (strong, nonatomic) IBOutlet UIImageView *view2VideoIcon;
@property (strong, nonatomic) IBOutlet UIImageView *View2Gradiant;

@property (strong, nonatomic) IBOutlet UIButton *view3Button;
@property (strong, nonatomic) IBOutlet UIImageView *view3VideoIcon;
@property (strong, nonatomic) IBOutlet UIImageView *View3Gradiant;
@property (strong, nonatomic) HomeFeed *homeFeed1;
@property (strong, nonatomic) HomeFeed *homeFeed2;
@property (strong, nonatomic) HomeFeed *homeFeed3;
- (void) setView1Item;
- (void) setView2Item;
- (void) setView3Item;
@end

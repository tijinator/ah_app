//
//  FollowPhotoCell.h
//  fitmoo
//
//  Created by hongjian lin on 8/5/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FollowPhotoCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIView *view1;
@property (strong, nonatomic) IBOutlet UIView *view2;
@property (strong, nonatomic) IBOutlet UIView *view3;
@property (strong, nonatomic) IBOutlet UIView *view4;
@property (strong, nonatomic) IBOutlet UIView *view5;
@property (strong, nonatomic) IBOutlet UIView *view6;
@property (strong, nonatomic) IBOutlet UIView *view7;
@property (strong, nonatomic) IBOutlet UIView *view8;
@property (strong, nonatomic) IBOutlet UIView *view9;


@property (strong, nonatomic) IBOutlet UIButton *view1Button;
@property (strong, nonatomic) IBOutlet UIImageView *view1VideoIcon;
@property (strong, nonatomic) IBOutlet UIButton *view2Button;
@property (strong, nonatomic) IBOutlet UIImageView *view2VideoIcon;
@property (strong, nonatomic) IBOutlet UIButton *view3Button;
@property (strong, nonatomic) IBOutlet UIImageView *view3VideoIcon;
@property (strong, nonatomic) IBOutlet UIButton *view4Button;
@property (strong, nonatomic) IBOutlet UIImageView *view4VideoIcon;
@property (strong, nonatomic) IBOutlet UIButton *view5Button;
@property (strong, nonatomic) IBOutlet UIImageView *view5VideoIcon;
@property (strong, nonatomic) IBOutlet UIButton *view6Button;
@property (strong, nonatomic) IBOutlet UIImageView *view6VideoIcon;
@property (strong, nonatomic) IBOutlet UIButton *view7Button;
@property (strong, nonatomic) IBOutlet UIImageView *view7VideoIcon;
@property (strong, nonatomic) IBOutlet UIButton *view8Button;
@property (strong, nonatomic) IBOutlet UIImageView *view8VideoIcon;
@property (strong, nonatomic) IBOutlet UIButton *view9Button;
@property (strong, nonatomic) IBOutlet UIImageView *view9VideoIcon;

@property (strong, nonatomic) NSMutableArray *cellArray;
@property (strong, nonatomic) NSString *cellType;
- (void) builtCells;
- (NSNumber *) CaculateCellHeight;
@end

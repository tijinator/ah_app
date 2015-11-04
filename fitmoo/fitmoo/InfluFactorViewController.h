//
//  InfluFactorViewController.h
//  fitmoo
//
//  Created by hongjian lin on 8/13/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FitmooHelper.h"
#import "InviteViewController.h"
#import "CameraViewController.h"
#import "ActionSheetViewController.h"
@interface InfluFactorViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIView *topView;
- (IBAction)backButtonClick:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
- (IBAction)InfoButtonClick:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIButton *infoButton;

@property (strong, nonatomic)  NSMutableArray * heighArray;

@property (strong, nonatomic) IBOutlet UIView *view1;
@property (strong, nonatomic) IBOutlet UIView *view2;
@property (strong, nonatomic) IBOutlet UIButton *okButton;
- (IBAction)okButtomClick:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *view3;
@property (strong, nonatomic) IBOutlet UILabel *infoLabel;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic)  NSDictionary * responseDic2;

@property (strong, nonatomic)  NSMutableArray * searchArrayLeader;
@property (strong, nonatomic) NSString *influence_factor;
@property (nonatomic, strong) NSString *profile_factor_status;
@property (nonatomic, strong) NSString *posts_factor_status;
@property (nonatomic, strong) NSString *follower_factor_status;
@property (strong, nonatomic) NSString *search_name;
@property (strong, nonatomic)  CameraViewController *overlay;
@property (strong, nonatomic)  UIImagePickerController *picker;


@property (assign, nonatomic)  int count;
@property (assign, nonatomic)  int limit;
@property (assign, nonatomic)  int offset;



@end

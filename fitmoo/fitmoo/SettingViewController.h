//
//  SettingViewController.h
//  fitmoo
//
//  Created by hongjian lin on 5/5/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FitmooHelper.h"
#import "UserManager.h"
#import "User.h"
#import "BaseViewController.h"
#import "AsyncImageView.h"
#import "AcountViewController.h"
@interface SettingViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UILabel *settingLabel;
- (IBAction)backButtonClick:(id)sender;
@property (strong, nonatomic) NSArray *heightArray;
@property (strong, nonatomic) NSArray *privacyArray;
@property (strong, nonatomic) NSMutableArray *privacyBoolArray;
@property (strong, nonatomic)  NSDictionary * responseDic;
@property (strong, nonatomic)  NSString * tabletype;
@property (strong, nonatomic)  User * tempUser;

@property (strong, nonatomic)  UIView *settingBottomView;





@end

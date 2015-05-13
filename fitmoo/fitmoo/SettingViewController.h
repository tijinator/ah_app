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
@interface SettingViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) NSArray *heightArray;
@property (strong, nonatomic) NSArray *privacyArray;
@property (strong, nonatomic) NSMutableArray *privacyBoolArray;
@property (strong, nonatomic)  NSDictionary * responseDic;
@property (strong, nonatomic)  NSString * tabletype;
@property (strong, nonatomic)  User * tempUser;

@property (strong, nonatomic)  UIView *settingBottomView;

@property (strong, nonatomic)  UITextField * nameTextfield;
@property (strong, nonatomic)  UITextView * bioTextview;
@property (strong, nonatomic)  UITextField * locationTextfield;
@property (strong, nonatomic)  UITextField * phoneTextfield;
@property (strong, nonatomic)  UITextField * websiteTextfield;

@property (nonatomic, strong) UIButton *settingButton;
@property (nonatomic, strong) UIButton *privacyButton;

@end

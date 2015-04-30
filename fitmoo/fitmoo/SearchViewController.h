//
//  SearchViewController.h
//  fitmoo
//
//  Created by hongjian lin on 4/17/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "FitmooHelper.h"
#import "AFNetworking.h"
#import "User.h"
#import "ShareTableViewCell.h"
#import "BaseViewController.h"
#import "UserManager.h"
#import "AsyncImageView.h"
#import "SpecialPageViewController.h"
#import "ActionSheetViewController.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "PeoplePageViewController.h"
#import "CreatedByCommunity.h"
@interface SearchViewController : BaseViewController <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIPickerViewDataSource, UIPickerViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableview;

@property (strong, nonatomic) IBOutlet UIButton *leftButton;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIButton *rightButton;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIView *pickerView;
- (IBAction)doneButtonClick:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *doneButton;
@property (strong, nonatomic) IBOutlet UIPickerView *pickerview;

@property (strong, nonatomic)  NSString * category;
@property (strong, nonatomic)  NSString * Category;
@property (strong, nonatomic)  NSString * searchterm;
@property (strong, nonatomic)  UITextField * searchTermField;
@property (strong, nonatomic)  NSDictionary * responseDic;
@property (strong, nonatomic)  NSMutableArray * searchArrayPeople;
@property (strong, nonatomic)  NSMutableArray * searchArrayCommunitiess;

@end

//
//  ShopCartViewController.h
//  fitmoo
//
//  Created by hongjian lin on 9/8/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FitmooHelper.h"
#import <Foundation/Foundation.h>
#import "User.h"
#import "ShopInfoCell.h"
#import "UserManager.h"
#import "ShopCart.h"
#import "ShopInfoTotalCell.h"
#import "ShopCheckoutViewController.h"
#import "ShopDetailViewController.h"
@interface ShopCartViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate>



@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIButton *leftButton;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *topView;

@property (strong, nonatomic) IBOutlet UIButton *BuyNowButton;
- (IBAction)BuyNowButtonClick:(id)sender;
@property (assign, nonatomic)  int count;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;

@property (strong, nonatomic)  NSDictionary * responseDic;
@property (strong, nonatomic)  ShopCart * shopCart;


@property (strong, nonatomic) IBOutlet UIPickerView *typePicker;
@property (strong, nonatomic) IBOutlet UIButton *doneButton;
- (IBAction)doneButtonClick:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *pickerBackView;
@property (strong, nonatomic) IBOutlet UIView *typePickerView;

@end

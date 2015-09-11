//
//  ShopCheckoutViewController.h
//  fitmoo
//
//  Created by hongjian lin on 9/9/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FitmooHelper.h"
#import "ShopInfoCell.h"
#import "UserManager.h"
#import "Address.h"
#import "UITableView+reloadData.h"
#import "CheckoutAddressCell.h"
#import "ShopPaymentInfoCell.h"
#import "State.h"
#import "CheckoutAdrPrefillCell.h"
#import "ShopAddressViewController.h"
@interface ShopCheckoutViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIButton *leftButton;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *topView;

@property (strong, nonatomic) IBOutlet UIButton *BuyNowButton;
- (IBAction)BuyNowButtonClick:(id)sender;

@property (strong, nonatomic)  NSDictionary * responseDic;
@property (strong, nonatomic)  NSString * sptoken;

@property (strong, nonatomic)  NSMutableArray * addressArray;
@property (strong, nonatomic)  NSMutableArray * pickerDisplayArray;
@property (strong, nonatomic)  UILabel * stateLabel;

@property (strong, nonatomic)  NSMutableArray * stateArray;
@property (strong, nonatomic)  NSString *pickerType;
@property (strong, nonatomic) IBOutlet UIPickerView *typePicker;
@property (strong, nonatomic) IBOutlet UIButton *doneButton;
- (IBAction)doneButtonClick:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *pickerBackView;
@property (strong, nonatomic) IBOutlet UIView *typePickerView;

@property (strong, nonatomic)  Address * billingAddress;
@property (strong, nonatomic)  Address * shippingAddress;


@end

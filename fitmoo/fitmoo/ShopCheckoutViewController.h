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
#import "ShopInfoTotalCell.h"
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
@property (strong, nonatomic)  NSMutableArray * addressBillingArray;
@property (strong, nonatomic)  NSMutableArray * addressShipingArray;
@property (strong, nonatomic)  NSMutableArray * pickerDisplayArray;
@property (strong, nonatomic)  UILabel * stateLabel;
@property (strong, nonatomic)  UILabel * stateLabel1;
@property (strong, nonatomic)  UILabel * monthLabel;
@property (strong, nonatomic)  UILabel * yearLabel;
@property (strong, nonatomic)  UILabel * cardTypeLabel;
@property (strong, nonatomic)  UITextField *cardNumberTextField;
@property (strong, nonatomic)  UITextField *cvcTextField;

@property (strong, nonatomic)  NSMutableArray * stateArray;
@property (strong, nonatomic)  NSString *pickerType;
@property (strong, nonatomic) IBOutlet UIPickerView *typePicker;
@property (strong, nonatomic) IBOutlet UIButton *doneButton;
- (IBAction)doneButtonClick:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *pickerBackView;
@property (strong, nonatomic) IBOutlet UIView *typePickerView;

@property (strong, nonatomic)  Address * billingAddress;
@property (strong, nonatomic)  Address * shippingAddress;

@property (strong, nonatomic)  UITextField *nameTextField;
@property (strong, nonatomic)  UITextField *AddressTextField;
@property (strong, nonatomic)  UITextField *cityTextField;
@property (strong, nonatomic)  UITextField *phoneTextField;
@property (strong, nonatomic)  UITextField *zipTextField;
@property (strong, nonatomic)  UITextField *Address2TextField;


@property (strong, nonatomic)  ShopCart * shopCart;

@property (strong, nonatomic)  UITextField *nameTextField1;
@property (strong, nonatomic)  UITextField *AddressTextField1;
@property (strong, nonatomic)  UITextField *cityTextField1;
@property (strong, nonatomic)  UITextField *phoneTextField1;
@property (strong, nonatomic)  UITextField *zipTextField1;
@property (strong, nonatomic)  UITextField *Address2TextField1;


@end

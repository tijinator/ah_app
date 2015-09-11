//
//  ShopAddAddressViewController.h
//  fitmoo
//
//  Created by hongjian lin on 9/11/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FitmooHelper.h"
#import "UserManager.h"
#import "Address.h"
#import "UITableView+reloadData.h"
#import "CheckoutAddressCell.h"
#import "State.h"


@interface ShopAddAddressViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIButton *leftButton;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *topView;

@property (strong, nonatomic) IBOutlet UIButton *BuyNowButton;
- (IBAction)BuyNowButtonClick:(id)sender;


@property (strong, nonatomic)  NSString * sptoken;

@property (strong, nonatomic)  Address * address;
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
@property (strong, nonatomic)  NSString * addreeType;


@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextField *AddressTextField;
@property (strong, nonatomic) IBOutlet UITextField *cityTextField;
@property (strong, nonatomic) IBOutlet UILabel *stateTextField;
@property (strong, nonatomic) IBOutlet UITextField *phoneTextField;
@property (strong, nonatomic) IBOutlet UITextField *zipTextField;
@property (strong, nonatomic) IBOutlet UITextField *Address2TextField;

@end

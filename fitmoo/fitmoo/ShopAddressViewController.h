//
//  ShopAddressViewController.h
//  fitmoo
//
//  Created by hongjian lin on 9/11/15.
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
#import "ShopAddAddressViewController.h"
@interface ShopAddressViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIButton *leftButton;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *topView;

@property (strong, nonatomic) IBOutlet UIButton *BuyNowButton;
- (IBAction)BuyNowButtonClick:(id)sender;

@property (strong, nonatomic)  NSDictionary * responseDic;
@property (strong, nonatomic)  NSString * sptoken;

@property (strong, nonatomic)  NSMutableArray * addressArray;

@property (strong, nonatomic)  UILabel * stateLabel;

@property (strong, nonatomic)  NSMutableArray * stateArray;

@property (strong, nonatomic)  NSString * addreeType;
@property (strong, nonatomic)  Address * billingAddress;
@property (strong, nonatomic)  Address * shippingAddress;

@end

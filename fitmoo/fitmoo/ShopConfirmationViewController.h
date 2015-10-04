//
//  ShopConfirmationViewController.h
//  fitmoo
//
//  Created by hongjian lin on 10/3/15.
//  Copyright © 2015 com.fitmoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FitmooHelper.h"
#import "ShopConfirmCell.h"
#import "ShopConfirmCell1.h"
#import "ShopCart.h"
#import "Address.h"
#import "RTLabel.h"
#import "ShopCartDetail.h"

@interface ShopConfirmationViewController : UIViewController


@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIButton *leftButton;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *topView;


@property (strong, nonatomic)  Address * billingAddress;
@property (strong, nonatomic)  Address * shippingAddress;
@property (strong, nonatomic)  ShopCart * shopCart;

@property (strong, nonatomic)  NSString * order_id;

@property (strong, nonatomic)  RTLabel * rtLabel;
@property (strong, nonatomic)  RTLabel * rtLabel1;

@end

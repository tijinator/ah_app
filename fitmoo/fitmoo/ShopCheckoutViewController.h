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

@end

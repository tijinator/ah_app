//
//  ShopEarningViewController.h
//  fitmoo
//
//  Created by hongjian lin on 9/17/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FitmooHelper.h"
#import "ShopEarningCell.h"
#import "UserManager.h"
#import "ShopRedemCell.h"
#import "Earning.h"
#import "BaseViewController.h"
@interface ShopEarningViewController : BaseViewController
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIButton *leftButton;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *topView;

@property (strong, nonatomic) IBOutlet UIButton *BuyNowButton;
- (IBAction)BuyNowButtonClick:(id)sender;
@property (strong, nonatomic) NSMutableArray *redeemArray;

@property (strong, nonatomic) NSString  *tableType;
@property (strong, nonatomic)  NSDictionary * responseDic;
@property (strong, nonatomic) Earning  *earning;

@end

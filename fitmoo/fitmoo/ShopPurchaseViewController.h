//
//  ShopPurchaseViewController.h
//  fitmoo
//
//  Created by hongjian lin on 9/17/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FitmooHelper.h"
#import "ShopPurchaseCell.h"
#import "UserManager.h"

@interface ShopPurchaseViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIButton *leftButton;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic)  NSDictionary * responseDic;
@property (strong, nonatomic)  NSMutableArray * orderArray;
@end

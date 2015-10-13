//
//  ShopOrderDetailViewController.h
//  fitmoo
//
//  Created by hongjian lin on 9/18/15.
//  Copyright © 2015 com.fitmoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FitmooHelper.h"
#import "ShopOrderDetailCell.h"
#import "ShopEventOrderCell.h"
#import "UserManager.h"
#import "ShopOrder.h"
#import "ShopDetailViewController.h"
@interface ShopOrderDetailViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIButton *leftButton;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic)  ShopOrder * order;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
- (IBAction)cancelButtonClick:(id)sender;

@end

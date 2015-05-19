//
//  SecondFollowViewController.h
//  fitmoo
//
//  Created by hongjian lin on 5/19/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "FitmooHelper.h"
#import "AFNetworking.h"
#import "User.h"
#import "ShareTableViewCell.h"
#import "BaseViewController.h"
#import "UserManager.h"
#import "AsyncImageView.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "FollowCell.h"

@interface SecondFollowViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIButton *leftButton;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic)  NSString *searchId;
@property (strong, nonatomic)  NSString * searchterm;
@property (strong, nonatomic)  UITextField * searchTermField;
@property (strong, nonatomic)  NSDictionary * responseDic;
@property (strong, nonatomic)  NSMutableArray * searchArrayPeople;
@property (strong, nonatomic)  NSMutableArray * heighArray;

- (IBAction)backButtonClick:(id)sender ;
@end

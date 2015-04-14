//
//  HomePageViewController.h
//  fitmoo
//
//  Created by hongjian lin on 4/8/15.
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
#import "SpecialPageViewController.h"
#import "ActionSheetViewController.h"

@interface HomePageViewController : BaseViewController <UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic)  NSDictionary * responseDic;
@property (strong, nonatomic)  NSMutableArray * homeFeedArray;
@property (assign, nonatomic)  int limit;
@property (assign, nonatomic)  int offset;
@property (assign, nonatomic)  int count;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIButton *leftButton;
@property (strong, nonatomic) IBOutlet UIButton *rightButton;
@property (strong, nonatomic) IBOutlet UIView *topView;


@end

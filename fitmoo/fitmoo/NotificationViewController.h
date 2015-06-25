//
//  NotificationViewController.h
//  fitmoo
//
//  Created by hongjian lin on 6/16/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeFeed.h"
#import "FitmooHelper.h"
#import "UserManager.h"
#import "AsyncImageView.h"
#import "SpecialPageViewController.h"
#import "User.h"
#import "BaseViewController.h"
@interface NotificationViewController : BaseViewController
@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) IBOutlet UIView *topView;
- (IBAction)backButtonClick:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) IBOutlet UILabel *notificationCountLabel;

@property (strong, nonatomic)  NSDictionary * responseDic;
@property (assign, nonatomic)  int limit;
@property (assign, nonatomic)  int offset;
@property (assign, nonatomic)  int count;
@property (strong, nonatomic)  NSMutableArray * notificArray;
@property (strong, nonatomic)  HomeFeed * homeFeed;
@property (strong, nonatomic)  NSMutableArray * heighArray;
@property (strong, nonatomic)  NSString * unread_count;

@end

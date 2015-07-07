//
//  ComposeViewController.h
//  fitmoo
//
//  Created by hongjian lin on 6/24/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Comments.h"
#import "FitmooHelper.h"
#import "UserManager.h"
#import "AsyncImageView.h"
#import "User.h"
#import "InviteViewController.h"
@interface ComposeViewController : UIViewController


@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) IBOutlet UIView *topView;
- (IBAction)backButtonClick:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) NSString *searchId;
@property (strong, nonatomic) NSString *searchType;
@property (strong, nonatomic) NSDictionary * responseDic;
@property (assign, nonatomic)  int limit;
@property (assign, nonatomic)  int offset;
@property (assign, nonatomic)  int count;
@property (strong, nonatomic) IBOutlet UIButton *addUserButton;
- (IBAction)addUserButtonClick:(id)sender;

@property (strong, nonatomic) NSMutableArray *likerArray;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;

@property (strong, nonatomic) Comments *comments;


@end

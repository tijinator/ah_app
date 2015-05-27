//
//  InterestViewController.h
//  fitmoo
//
//  Created by hongjian lin on 5/26/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FitmooHelper.h"
#import "AFNetworking.h"
#import "User.h"
#import <CoreData/CoreData.h>
#import "HomePageViewController.h"
#import "FollowHeaderCell.h"
#import "UserManager.h"

@interface InterestViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) IBOutlet UIButton *skipButton;
- (IBAction)skipButtonClick:(id)sender;

@property (strong, nonatomic)  NSMutableArray * heighArray;
@property (strong, nonatomic)  NSDictionary * responseDic1;
@property (strong, nonatomic)  NSMutableArray * searchArrayCategory;
@property (strong, nonatomic)  NSMutableArray * interestArray;
@property (strong, nonatomic)  User *localUser;
@end

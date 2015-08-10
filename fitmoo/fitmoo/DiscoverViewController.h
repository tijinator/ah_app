//
//  SearchViewController.h
//  fitmoo
//
//  Created by hongjian lin on 4/17/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "FitmooHelper.h"
#import "User.h"
#import "ShareTableViewCell.h"
#import "BaseViewController.h"
#import "UserManager.h"
#import "AsyncImageView.h"
#import "SpecialPageViewController.h"
#import "ActionSheetViewController.h"
#import "PeoplePageViewController.h"
#import "CreatedByCommunity.h"
#import "FollowCollectionViewCell.h"
#import "SecondFollowViewController.h"
#import "FollowHeaderCell.h"
#import "InviteViewController.h"
#import "Workout.h"
#import "Product.h"
#import "SeachInterestCell.h"
#import "FollowPhotoCell.h"
#import "FollowLeaderBoardCell.h"
@interface DiscoverViewController : BaseViewController <UICollectionViewDataSource,UICollectionViewDelegate,UITextFieldDelegate,UIScrollViewDelegate>


@property (strong, nonatomic) IBOutlet UIButton *leftButton;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *featerLabel;

@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIView *bodyView;
@property (strong, nonatomic)  NSMutableArray * heighArray;
- (IBAction)backButtonClick:(id)sender;

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UIView *buttomView;


@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) IBOutlet UILabel *lifestytleLabel;
@property (assign, nonatomic)  int count;
@property (assign, nonatomic)  int limit;
@property (assign, nonatomic)  int offset;

@property (assign, nonatomic)  int searchcount;
@property (assign, nonatomic)  int searchlimit;
@property (assign, nonatomic)  int searchoffset;

@property (strong, nonatomic)  NSString * searchterm;
@property (strong, nonatomic)  NSString * selectedKeywordId;
//@property (strong, nonatomic)  UITextField * searchTermField;
@property (strong, nonatomic)  NSDictionary * responseDic;
@property (strong, nonatomic)  NSDictionary * responseDic1;
@property (strong, nonatomic)  NSDictionary * responseDic2;
@property (strong, nonatomic)  NSMutableArray * searchArrayPeople;
@property (strong, nonatomic)  NSMutableArray * searchArrayPeople1;
@property (strong, nonatomic)  NSMutableArray * searchArrayCategory;
@property (strong, nonatomic)  NSMutableArray * searchArrayKeyword;
@property (strong, nonatomic)  NSMutableArray * searchArrayCommunity;
@property (strong, nonatomic)  NSMutableArray * searchArrayLeader;
@property (strong, nonatomic)  NSMutableArray * searchArrayProducts;
@property (strong, nonatomic)  NSMutableArray * searchArrayWorkouts;
@property (strong, nonatomic)  NSMutableArray * searchArrayTotalKeyword;

@property (strong, nonatomic)  NSMutableArray * searchArrayPeopleName;

@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) NSTimer *timerQueue;

@property (strong, nonatomic) IBOutlet UITextField * searchTermField;
@property (strong, nonatomic) IBOutlet UIButton *addUser;
- (IBAction)addUserButtonClick:(id)sender;


@end

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
#import "AFNetworking.h"
#import "User.h"
#import "ShareTableViewCell.h"
#import "BaseViewController.h"
#import "UserManager.h"
#import "AsyncImageView.h"
#import "SpecialPageViewController.h"
#import "ActionSheetViewController.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "PeoplePageViewController.h"
#import "CreatedByCommunity.h"
#import "FollowCollectionViewCell.h"
#import "SecondFollowViewController.h"

@interface SearchViewController : BaseViewController <UICollectionViewDataSource,UICollectionViewDelegate,UITextFieldDelegate,UIScrollViewDelegate>


@property (strong, nonatomic) IBOutlet UIButton *leftButton;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *featerLabel;

@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIView *bodyView;

- (IBAction)backButtonClick:(id)sender;

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UIView *buttomView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet UILabel *lifestytleLabel;

@property (strong, nonatomic)  NSString * searchterm;
@property (strong, nonatomic)  UITextField * searchTermField;
@property (strong, nonatomic)  NSDictionary * responseDic;
@property (strong, nonatomic)  NSDictionary * responseDic1;
@property (strong, nonatomic)  NSMutableArray * searchArrayPeople;
@property (strong, nonatomic)  NSMutableArray * searchArrayCategory;

@end

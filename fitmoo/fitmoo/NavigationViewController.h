//
//  NavigationViewController.h
//  fitmoo
//
//  Created by hongjian lin on 4/8/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "FitmooHelper.h"
#import "HomePageViewController.h"
#import "UserManager.h"
#import "User.h"
#import "PeoplePageViewController.h"
#import "ActionSheetViewController.h"
#import "HomeFeed.h"
#import "SearchViewController.h"
#import "RESideMenu.h"
#import "ShopViewController.h"
#import "SettingViewController.h"
#import "LocationViewController.h"

@interface NavigationViewController : UIViewController

@property (strong, nonatomic) UIViewController *baseView;
@property (strong, nonatomic) UINavigationController *nav;
@property (nonatomic, assign) BOOL allowRotation;

@property (strong, nonatomic) HomePageViewController *homePage;
@property (strong, nonatomic) PeoplePageViewController *peoplePage;
@property (strong, nonatomic) SearchViewController *searchPage;
@property (strong, nonatomic) SettingViewController *settingPage;
@property (strong, nonatomic)  ShopViewController *shopPage;
@property (strong, nonatomic)  LocationViewController *locationPage;

@end

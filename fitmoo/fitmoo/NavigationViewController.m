//
//  NavigationViewController.m
//  fitmoo
//
//  Created by hongjian lin on 4/8/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import "NavigationViewController.h"

@implementation NavigationViewController
{
    int currentPage;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    _baseView = [[self storyboard] instantiateViewControllerWithIdentifier:@"ViewController"];
    
    self.nav= [[UINavigationController alloc] initWithRootViewController:_baseView];
    self.nav.view.backgroundColor=[UIColor clearColor];
    _nav.view.frame= CGRectMake(0, 0, 320, self.view.frame.size.height);
    [[self nav] setNavigationBarHidden:YES animated:NO];
    [self initFrames];
    [self.view addSubview: self.nav.view];
 //   [self.view insertSubview:self.nav.view belowSubview:self.topView];
    _allowRotation=false;
   
    [self createObservers];
    
    [[UINavigationBar appearance]  setBarTintColor:[UIColor blackColor]];
    currentPage=0;
// [self addfootButtonsForThree];
}

-(void)createObservers{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(leftSideMenuAction:) name:@"leftSideMenuAction" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(swipeHandler:) name:@"swipeHandler" object:nil];
}



-(void)swipeHandler:(UISwipeGestureRecognizer *)recognizer {
    
    [self presentLeftMenuViewController:nil];
}

- (IBAction)footbuttonClick:(id)sender {
    
    
    switch (((UIButton*)sender).tag) {
        case 11:
            
            
            break;
        case 12:
            
            
            
            break;
        case 13:
            
            
            break;
        default:
            break;
            
            
    }
}
- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

-(void)leftSideMenuAction:(NSNotification*)note{
    
    NSString *key = [note object];


    if ([key isEqualToString:@"0"]) {
        if (currentPage!=0) {
            HomePageViewController *homePage = [[self storyboard] instantiateViewControllerWithIdentifier:@"HomePageViewController"];
       //      [[self nav] popViewControllerAnimated:NO];
            [[self nav] pushViewController:homePage animated:YES];

        }
             [[NSNotificationCenter defaultCenter] postNotificationName:@"hideSideMenu" object:Nil];
        currentPage=0;
    }else  if ([key isEqualToString:@"5"]) {
       
       
        [[self nav] popToRootViewControllerAnimated:YES];
//        _baseView = [[self storyboard] instantiateViewControllerWithIdentifier:@"ViewController"];
//        [[self nav] pushViewController:_baseView animated:YES];
  //      [[NSNotificationCenter defaultCenter] postNotificationName:@"openSideMenu" object:Nil];
         [[NSNotificationCenter defaultCenter] postNotificationName:@"hideSideMenu" object:Nil];
         currentPage=5;
    }else  if ([key isEqualToString:@"6"]) {
        
        if (currentPage!=6) {
            PeoplePageViewController *homePage = [[self storyboard] instantiateViewControllerWithIdentifier:@"PeoplePageViewController"];
       //     [[self nav] popViewControllerAnimated:NO];
            [[self nav] pushViewController:homePage animated:YES];
        //    currentPage=6;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hideSideMenu" object:Nil];
        currentPage=6;
    }else  if ([key isEqualToString:@"2"]) {
          if (currentPage!=2) {
        
              SearchViewController *searchPage = [[self storyboard] instantiateViewControllerWithIdentifier:@"SearchViewController"];
           //    [[self nav] popViewControllerAnimated:NO];
              [[self nav] pushViewController:searchPage animated:YES];
          }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hideSideMenu" object:Nil];
        currentPage=2;
    }else  if ([key isEqualToString:@"1"]) {
        if (currentPage!=1) {
            
            ShopViewController *shopPage = [[self storyboard] instantiateViewControllerWithIdentifier:@"ShopViewController"];
            //    [[self nav] popViewControllerAnimated:NO];
            [[self nav] pushViewController:shopPage animated:YES];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hideSideMenu" object:Nil];
        currentPage=1;
    }else  if ([key isEqualToString:@"3"]) {
        if (currentPage!=3) {
            
            SettingViewController *settingPage = [[self storyboard] instantiateViewControllerWithIdentifier:@"SettingViewController"];
            //    [[self nav] popViewControllerAnimated:NO];
            [[self nav] pushViewController:settingPage animated:YES];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hideSideMenu" object:Nil];
        currentPage=3;
    }
    
    
}




- (void) initFrames
{
   // _nav.view.frame= CGRectMake(0, 0, 320, 568);
    _nav.view.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_nav.view respectToSuperFrame:self.view];

    
}

@end

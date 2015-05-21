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
    bool blackStatusbar;
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
     blackStatusbar=false;
// [self addfootButtonsForThree];
}

-(void)createObservers{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(leftSideMenuAction:) name:@"leftSideMenuAction" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(swipeHandler:) name:@"swipeHandler" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showBlackStatusBarHandler:) name:@"showBlackStatusBarHandler" object:nil];
   
}
-(void)showBlackStatusBarHandler:(NSNotification*)note{
    
    NSString *key = [note object];
    if ([key isEqualToString:@"1"]) {
         blackStatusbar=true;
    }else
    {
          blackStatusbar=false;
    }
   
    [self setNeedsStatusBarAppearanceUpdate];
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

-(void)viewDidLayoutSubviews
{
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

- (UIStatusBarStyle) preferredStatusBarStyle {
    
    
    if(currentPage ==3||currentPage ==2||currentPage ==6)
    {
        if (blackStatusbar==true) {
     
            return UIStatusBarStyleDefault;
            
        }
        return UIStatusBarStyleLightContent;
    }
    return UIStatusBarStyleDefault;
}



-(void)leftSideMenuAction:(NSNotification*)note{
    
    NSString *key = [note object];


    if ([key isEqualToString:@"0"]) {
        if (currentPage!=0) {
            _homePage = [[self storyboard] instantiateViewControllerWithIdentifier:@"HomePageViewController"];
     
            [[self nav] pushViewController:_homePage animated:YES];

        }
             [[NSNotificationCenter defaultCenter] postNotificationName:@"hideSideMenu" object:Nil];
        currentPage=0;
    }else  if ([key isEqualToString:@"5"]) {
        [[self nav] popToRootViewControllerAnimated:YES];
         [[NSNotificationCenter defaultCenter] postNotificationName:@"hideSideMenu" object:Nil];
         currentPage=5;
    }else  if ([key isEqualToString:@"6"]) {
        
        if (currentPage!=6) {
            
       
            _peoplePage = [[self storyboard] instantiateViewControllerWithIdentifier:@"PeoplePageViewController"];
            [[self nav] pushViewController:_peoplePage animated:YES];
            currentPage=6;
            
         
           
        }else
        {
           
            _homePage = [[self storyboard] instantiateViewControllerWithIdentifier:@"HomePageViewController"];
            [[self nav] pushViewController:_homePage animated:YES];

            currentPage=0;
            
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hideSideMenu" object:Nil];
        
    }else  if ([key isEqualToString:@"2"]) {
          if (currentPage!=2) {
        
              _searchPage = [[self storyboard] instantiateViewControllerWithIdentifier:@"SearchViewController"];
              [[self nav] pushViewController:_searchPage animated:YES];
          }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hideSideMenu" object:Nil];
        currentPage=2;
    }else  if ([key isEqualToString:@"1"]) {
        if (currentPage!=1) {
            
            _shopPage = [[self storyboard] instantiateViewControllerWithIdentifier:@"ShopViewController"];
       
            [[self nav] pushViewController:_shopPage animated:YES];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hideSideMenu" object:Nil];
        currentPage=1;
    }else  if ([key isEqualToString:@"3"]) {
        if (currentPage!=3) {
            
            _settingPage = [[self storyboard] instantiateViewControllerWithIdentifier:@"SettingViewController"];
            //    [[self nav] popViewControllerAnimated:NO];
            [[self nav] pushViewController:_settingPage animated:YES];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hideSideMenu" object:Nil];
        currentPage=3;

    
    
    }else  if (key.intValue>10) {

     
            _peoplePage = [[self storyboard] instantiateViewControllerWithIdentifier:@"PeoplePageViewController"];
            _peoplePage.searchId=key;
            [[self nav] pushViewController:_peoplePage animated:YES];
            currentPage=6;

    
    }
    [self setNeedsStatusBarAppearanceUpdate];
    
}




- (void) initFrames
{
   // _nav.view.frame= CGRectMake(0, 0, 320, 568);
    _nav.view.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_nav.view respectToSuperFrame:self.view];

    
}

@end

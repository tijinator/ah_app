//
//  NavigationViewController.m
//  fitmoo
//
//  Created by hongjian lin on 4/8/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import "NavigationViewController.h"
#import "Reachability.h"
@implementation NavigationViewController
{
    int currentPage;
    int prePage;
    int blackStatusbar;
   
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated {

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
    currentPage=1000;
     blackStatusbar=0;
    _Pagestuck= [[NSMutableArray alloc] init];
// [self addfootButtonsForThree];
}

-(void)createObservers{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(leftSideMenuAction:) name:@"leftSideMenuAction" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(swipeHandler:) name:@"swipeHandler" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showBlackStatusBarHandler:) name:@"showBlackStatusBarHandler" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shopAction:) name:@"shopAction" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterForeground:) name:UIApplicationDidBecomeActiveNotification object:nil];
   
}

- (void)appWillEnterForeground:(NSNotification *)notification {
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        NSLog(@"There IS NO internet connection");
        UIAlertView *alert = [[ UIAlertView alloc ] initWithTitle : @"Offline"
                                                          message : @"You appear to be offline. Please connect to the internet to continue." delegate : nil cancelButtonTitle : @"OK"
                                                otherButtonTitles : nil ];
        [alert show ];
        
        [self.nav popToRootViewControllerAnimated:YES];
    
        
    } else {
        NSLog(@"There IS internet connection");
        
    }
}

-(void)shopAction:(NSNotification*)note{
    
    NSString *key = [note object];
    if (currentPage!=1) {
        
        _shopPage = [[self storyboard] instantiateViewControllerWithIdentifier:@"ShopViewController"];
        _shopPage.shoplink=key;
        [[self nav] pushViewController:_shopPage animated:YES];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hideSideMenu" object:Nil];
    prePage=currentPage;
    currentPage=1;

    
}


-(void)showBlackStatusBarHandler:(NSNotification*)note{
    
    NSString *key = [note object];
    if ([key isEqualToString:@"1"]) {
         blackStatusbar=1;
    }else if([key isEqualToString:@"0"])
    {
          blackStatusbar=0;
    }else  if([key isEqualToString:@"2"])
    {
        blackStatusbar=2;
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

-(BOOL)prefersStatusBarHidden{
    if (blackStatusbar!=2) {
        return NO;
    }
    return YES;
}

- (UIStatusBarStyle) preferredStatusBarStyle {
    
    
    if(currentPage ==3||currentPage ==2||currentPage ==6||currentPage ==1||currentPage ==4||currentPage>10)
    {
        if (blackStatusbar==1) {
     
            return UIStatusBarStyleDefault;
            
        }else if (blackStatusbar==0)
        {
             return UIStatusBarStyleLightContent;
        }else if (blackStatusbar==2)
        {
         
        }
       
    }
    return UIStatusBarStyleDefault;
}



-(void)leftSideMenuAction:(NSNotification*)note{
    
    NSString *key = [note object];

    
    if ([key isEqualToString:@"1"]) {
        if (currentPage!=1) {
            _searchPage = [[self storyboard] instantiateViewControllerWithIdentifier:@"SearchViewController"];
            
            [[self nav] pushViewController:_searchPage animated:YES];
        //    prePage=currentPage;
            currentPage=1;
            [_Pagestuck addObject:@"1"];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hideSideMenu" object:Nil];
       
    }else if ([key isEqualToString:@"0"]) {
        if (currentPage!=0) {
            _homePage = [[self storyboard] instantiateViewControllerWithIdentifier:@"HomePageViewController"];
            [[self nav] pushViewController:_homePage animated:YES];
         //   prePage=currentPage;
            currentPage=0;
            [_Pagestuck addObject:@"0"];
        }
             [[NSNotificationCenter defaultCenter] postNotificationName:@"hideSideMenu" object:Nil];
      
    }else  if ([key isEqualToString:@"5"]) {
        [[self nav] popToRootViewControllerAnimated:YES];
         [[NSNotificationCenter defaultCenter] postNotificationName:@"hideSideMenu" object:Nil];
      //  prePage=currentPage;
         currentPage=1000;
        _Pagestuck=[[NSMutableArray alloc] init];
    }else  if ([key isEqualToString:@"6"]) {
        
        if (currentPage!=6) {
            
       
            _peoplePage = [[self storyboard] instantiateViewControllerWithIdentifier:@"PeoplePageViewController"];
            [[self nav] pushViewController:_peoplePage animated:YES];
        //    prePage=currentPage;
            currentPage=6;
            [_Pagestuck addObject:@"6"];

        }

        [[NSNotificationCenter defaultCenter] postNotificationName:@"hideSideMenu" object:Nil];
        
    }else  if ([key isEqualToString:@"6.1"]) {
        

        [[self nav] popViewControllerAnimated:YES];
       
        [_Pagestuck removeLastObject];
        NSString *page=[_Pagestuck lastObject];
        currentPage=page.intValue;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hideSideMenu" object:Nil];
        
    }else  if ([key isEqualToString:@"3"]) {
          if (currentPage!=3) {
        
              _followPage = [[self storyboard] instantiateViewControllerWithIdentifier:@"FollowViewController"];
              [[self nav] pushViewController:_followPage animated:YES];
           //   prePage=currentPage;
              currentPage=3;
              [_Pagestuck addObject:@"3"];
          }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hideSideMenu" object:Nil];
        
    }else  if ([key isEqualToString:@"2"]) {
        if (currentPage!=2) {
            
            _shopPage = [[self storyboard] instantiateViewControllerWithIdentifier:@"ShopViewController"];
            [[self nav] pushViewController:_shopPage animated:YES];
//            _notificationPage = [[self storyboard] instantiateViewControllerWithIdentifier:@"NotificationViewController"];
//             [[self nav] pushViewController:_notificationPage animated:YES];
          //  prePage=currentPage;
            currentPage=2;
            [_Pagestuck addObject:@"2"];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hideSideMenu" object:Nil];
     
    }else  if ([key isEqualToString:@"4"]) {
        if (currentPage!=4) {
            
            _settingPage = [[self storyboard] instantiateViewControllerWithIdentifier:@"SettingViewController"];
            //    [[self nav] popViewControllerAnimated:NO];
            [[self nav] pushViewController:_settingPage animated:YES];
         //   prePage=currentPage;
            currentPage=4;
            [_Pagestuck addObject:@"4"];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hideSideMenu" object:Nil];
       

    
    
    }else  if ([key isEqualToString:@"7"]) {
        if (currentPage!=7) {
            
            _locationPage = [[self storyboard] instantiateViewControllerWithIdentifier:@"LocationViewController"];
            //    [[self nav] popViewControllerAnimated:NO];
            [[self nav] pushViewController:_locationPage animated:YES];
          //  prePage=currentPage;
            currentPage=7;
            [_Pagestuck addObject:@"7"];
        }
       // [[NSNotificationCenter defaultCenter] postNotificationName:@"hideSideMenu" object:Nil];
        
        
        
        
    }else  if (key.intValue>10) {

     
            _peoplePage = [[self storyboard] instantiateViewControllerWithIdentifier:@"PeoplePageViewController"];
        key= [NSString stringWithFormat:@"%d",key.intValue-100];
            _peoplePage.searchId=key;
            [[self nav] pushViewController:_peoplePage animated:YES];
        //    prePage=currentPage;
            currentPage=key.intValue;
            [_Pagestuck addObject:key];
    
    }
    [self setNeedsStatusBarAppearanceUpdate];
    
}




- (void) initFrames
{
   // _nav.view.frame= CGRectMake(0, 0, 320, 568);
    _nav.view.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_nav.view respectToSuperFrame:self.view];

    
}

@end

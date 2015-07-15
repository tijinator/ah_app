//
//  NavigationViewController.m
//  fitmoo
//
//  Created by hongjian lin on 4/8/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import "NavigationViewController.h"
#import "Reachability.h"
#import "AFNetworking.h"
@implementation NavigationViewController
{
 //   int currentPage;
    int prePage;
    int blackStatusbar;
    NSString *currentPage;
   
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
    currentPage=@"login";
     blackStatusbar=0;
    _Pagestuck= [[NSMutableArray alloc] init];
    
//    self.navigationController.navigationBar.translucent = NO;
//    self.nav.navigationBar.translucent=NO;
//    [self setEdgesForExtendedLayout:UIRectEdgeNone];
//    [self.nav setEdgesForExtendedLayout:UIRectEdgeNone];
//    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
//        self.edgesForExtendedLayout = UIRectEdgeNone;
// [self addfootButtonsForThree];
}

- (void) viewDidAppear:(BOOL)animated
{
      [self createNotificationTimer];
}



- (void) createNotificationTimer
{
 //    _timer = [NSTimer scheduledTimerWithTimeInterval:300 target:self selector:@selector(checkNotification:) userInfo:nil repeats:YES];
}

- (void)checkNotification:(NSTimer *)timer
{
    User *localUser= [[FitmooHelper sharedInstance] getUserLocally];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:localUser.secret_id, @"secret_id", localUser.auth_token, @"auth_token", @"true", @"mobile",@"true", @"ios_app",nil];
    
    NSString * url= [NSString stringWithFormat: @"%@%@", [[UserManager sharedUserManager] clientUrl],@"/api/notifications/unread_count"];
    
    [manager GET:url parameters:jsonDict success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        _responseDic= responseObject;
        NSNumber *unread=[_responseDic objectForKey:@"unread_count"];
        if (unread.intValue>0) {
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            [prefs setObject:@"1" forKey:@"fitmooNotification"];

        }else
        {
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            [prefs setObject:@"0" forKey:@"fitmooNotification"];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateNotificationStatus" object:Nil];
        } // success callback block
         failure:^(AFHTTPRequestOperation *operation, NSError *error){
             NSLog(@"Error: %@", error);
         } // failure callback block
     
     ];

   
}

-(void)createObservers{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(leftSideMenuAction:) name:@"leftSideMenuAction" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(swipeHandler:) name:@"swipeHandler" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showBlackStatusBarHandler:) name:@"showBlackStatusBarHandler" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shopAction:) name:@"shopAction" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterForeground:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNotification:) name:@"checkNotification" object:nil];
   
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
    if (![currentPage isEqualToString:@"shop"]) {
        
        _shopPage = [[self storyboard] instantiateViewControllerWithIdentifier:@"ShopViewController"];
        _shopPage.shoplink=key;
        [[self nav] pushViewController:_shopPage animated:YES];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hideSideMenu" object:Nil];
     [_Pagestuck addObject:@"shop"];
    currentPage=@"shop";

    
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
    
    
    if(!([currentPage isEqualToString:@"home"]||[currentPage isEqualToString:@"login"]))
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

    
    if ([key isEqualToString:@"search"]) {
        if (![currentPage isEqualToString:key]) {
            _searchPage = [[self storyboard] instantiateViewControllerWithIdentifier:@"SearchViewController"];
            
            [[self nav] pushViewController:_searchPage animated:YES];
        //    prePage=currentPage;
            currentPage=key;
            [_Pagestuck addObject:key];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hideSideMenu" object:Nil];
       
    }else if ([key isEqualToString:@"home"]) {
        if (![currentPage isEqualToString:key]) {
            _homePage = [[self storyboard] instantiateViewControllerWithIdentifier:@"HomePageViewController"];
            [[self nav] pushViewController:_homePage animated:YES];
      
            currentPage=key;
            [_Pagestuck addObject:key];
        }
             [[NSNotificationCenter defaultCenter] postNotificationName:@"hideSideMenu" object:Nil];
      
    }else  if ([key isEqualToString:@"login"]) {
        [[self nav] popToRootViewControllerAnimated:YES];
         [[NSNotificationCenter defaultCenter] postNotificationName:@"hideSideMenu" object:Nil];
     
         currentPage=@"login";
        _Pagestuck=[[NSMutableArray alloc] init];
    }else  if ([key isEqualToString:@"profile"]) {
        
        if (![currentPage isEqualToString:key]) {
            
       
            _peoplePage = [[self storyboard] instantiateViewControllerWithIdentifier:@"PeoplePageViewController"];
            [[self nav] pushViewController:_peoplePage animated:YES];
       
            currentPage=key;
            [_Pagestuck addObject:key];

        }

        [[NSNotificationCenter defaultCenter] postNotificationName:@"hideSideMenu" object:Nil];
        
    }else  if ([key isEqualToString:@"back"]) {
        

        [[self nav] popViewControllerAnimated:YES];
       
        [_Pagestuck removeLastObject];
        NSString *page=[_Pagestuck lastObject];
        currentPage=page;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hideSideMenu" object:Nil];
        
    }else  if ([key isEqualToString:@"follow"]) {
          if (![currentPage isEqualToString:key]) {
        
              _followPage = [[self storyboard] instantiateViewControllerWithIdentifier:@"FollowViewController"];
              [[self nav] pushViewController:_followPage animated:YES];
        
              currentPage=key;
              [_Pagestuck addObject:key];
          }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hideSideMenu" object:Nil];
        
    }else  if ([key isEqualToString:@"notifications"]) {
        if (![currentPage isEqualToString:key]) {
            
          
            _notificationPage = [[self storyboard] instantiateViewControllerWithIdentifier:@"NotificationViewController"];
            [[self nav] pushViewController:_notificationPage animated:YES];
            
            currentPage=key;
            [_Pagestuck addObject:key];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hideSideMenu" object:Nil];
        
    }else  if ([key isEqualToString:@"shop"]) {
        if (![currentPage isEqualToString:key]) {
            
            _shopPage = [[self storyboard] instantiateViewControllerWithIdentifier:@"ShopViewController"];
            [[self nav] pushViewController:_shopPage animated:YES];
            currentPage=key;
            [_Pagestuck addObject:key];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hideSideMenu" object:Nil];
     
    }else  if ([key isEqualToString:@"settings"]) {
        if (![currentPage isEqualToString:key]) {
            
            _settingPage = [[self storyboard] instantiateViewControllerWithIdentifier:@"SettingViewController"];
            //    [[self nav] popViewControllerAnimated:NO];
            [[self nav] pushViewController:_settingPage animated:YES];

            currentPage=key;
            [_Pagestuck addObject:key];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hideSideMenu" object:Nil];
       

    
    
    }else  if ([key isEqualToString:@"location"]) {
        if (![currentPage isEqualToString:key]) {
            
            _locationPage = [[self storyboard] instantiateViewControllerWithIdentifier:@"LocationViewController"];
            //    [[self nav] popViewControllerAnimated:NO];
            [[self nav] pushViewController:_locationPage animated:YES];
    
            currentPage=key;
            [_Pagestuck addObject:key];
        }
       // [[NSNotificationCenter defaultCenter] postNotificationName:@"hideSideMenu" object:Nil];
        
        
        
        
    }else  if ([[key substringWithRange:NSMakeRange(0, 3)] isEqualToString:@"com"]) {
        
        NSString *com_id= [key substringFromIndex:3];
       
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main1" bundle:nil];
        _communityPage = [mainStoryboard instantiateViewControllerWithIdentifier:@"CommunityPageViewController"];
       
        _communityPage.searchCommunityId=com_id;
        [[self nav] pushViewController:_communityPage animated:YES];
        
        currentPage=key;
        [_Pagestuck addObject:key];
        
    }
    else  if (key.intValue>10) {

        
        _peoplePage = [[self storyboard] instantiateViewControllerWithIdentifier:@"PeoplePageViewController"];
        key= [NSString stringWithFormat:@"%d",key.intValue-100];
            _peoplePage.searchId=key;
            [[self nav] pushViewController:_peoplePage animated:YES];
     
            currentPage=key;
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

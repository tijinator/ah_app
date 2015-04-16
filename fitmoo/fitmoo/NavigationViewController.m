//
//  NavigationViewController.m
//  fitmoo
//
//  Created by hongjian lin on 4/8/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import "NavigationViewController.h"

@implementation NavigationViewController

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
    _nav.view.frame= CGRectMake(0, 0, 320, self.view.frame.size.height);
    [[self nav] setNavigationBarHidden:YES animated:NO];
    [self initFrames];
    [self.view addSubview: self.nav.view];
 //   [self.view insertSubview:self.nav.view belowSubview:self.topView];
    _allowRotation=false;
   
    [self createObservers];

}

-(void)createObservers{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(leftSideMenuAction:) name:@"leftSideMenuAction" object:nil];
    
}



-(void)leftSideMenuAction:(NSNotification*)note{
    
    NSString *key = [note object];


    if ([key isEqualToString:@"0"]) {
       HomePageViewController *homePage = [[self storyboard] instantiateViewControllerWithIdentifier:@"HomePageViewController"];
        [[self nav] pushViewController:homePage animated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"openSideMenu" object:Nil];
    }else  if ([key isEqualToString:@"5"]) {
       
        [[self nav] popToRootViewControllerAnimated:YES];
//        _baseView = [[self storyboard] instantiateViewControllerWithIdentifier:@"ViewController"];
//        [[self nav] pushViewController:_baseView animated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"openSideMenu" object:Nil];
    }else  if ([key isEqualToString:@"1"]) {
        
        
        PeoplePageViewController *homePage = [[self storyboard] instantiateViewControllerWithIdentifier:@"PeoplePageViewController"];
        [[self nav] pushViewController:homePage animated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"openSideMenu" object:Nil];
    }
    
    
}




- (void) initFrames
{
    _nav.view.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_nav.view respectToSuperFrame:self.view];

    
}

@end

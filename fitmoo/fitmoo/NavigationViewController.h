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

@interface NavigationViewController : UIViewController

@property (strong, nonatomic) UIViewController *baseView;
@property (strong, nonatomic) UINavigationController *nav;
@property (nonatomic, assign) BOOL allowRotation;




@end

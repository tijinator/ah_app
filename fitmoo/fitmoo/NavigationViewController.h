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


@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIButton *leftButton;
@property (strong, nonatomic) IBOutlet UIButton *rightButton;
@property (strong, nonatomic) IBOutlet UIView *topView;

@end

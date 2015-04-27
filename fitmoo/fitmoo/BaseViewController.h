//
//  BaseViewController.h
//  fitmoo
//
//  Created by hongjian lin on 4/10/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FitmooHelper.h"
#import "RESideMenu.h"
@interface BaseViewController : UIViewController

- (IBAction)openSideMenu:(id)sender;
@property (nonatomic, strong) UIButton *leftButton1;
@property (nonatomic, strong) UIButton *middleButton1;
@property (nonatomic, strong) UIButton *rightButton1;
@property (strong, nonatomic)  UIView *bottomView;
@end

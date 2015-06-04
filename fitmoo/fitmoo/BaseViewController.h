//
//  BaseViewController.h
//  fitmoo
//
//  Created by hongjian lin on 4/10/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import "FitmooHelper.h"
#import "RESideMenu.h"
#import "CameraViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "BasePostViewController.h"

@interface BaseViewController : UIViewController<UIApplicationDelegate>

- (IBAction)openSideMenu:(id)sender;
//- (void) addfootButtonsForSetting;
@property (nonatomic, strong) UIButton *leftButton1;
@property (nonatomic, strong) UIButton *middleButton1;
@property (nonatomic, strong) UIButton *rightButton1;
@property (strong, nonatomic)  UIView *bottomView;

@property (strong, nonatomic)  UIImageView *bottomImageView;


@property (nonatomic, strong) UIButton *postButton;
@property (nonatomic, strong) UIButton *videoButton;
@property (nonatomic, strong) UIButton *pictureButton;
@property (strong, nonatomic)  UIView *subBottomView;

@property (strong, nonatomic)  CameraViewController *overlay;
@property (strong, nonatomic)  UIImagePickerController *picker;
@property (strong, nonatomic)  BasePostViewController *postView;
@end

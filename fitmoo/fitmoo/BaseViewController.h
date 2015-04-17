//
//  BaseViewController.h
//  fitmoo
//
//  Created by hongjian lin on 4/10/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FitmooHelper.h"

@interface BaseViewController : UIViewController

- (IBAction)openSideMenu:(id)sender;
@property (nonatomic, strong) UIButton *postButton;
@property (nonatomic, strong) UIButton *postPhoto;
@property (nonatomic, strong) UIButton *postVideo;
@property (strong, nonatomic)  UIView *bottomView;
@end

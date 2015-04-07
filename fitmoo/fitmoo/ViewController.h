//
//  ViewController.h
//  fitmoo
//
//  Created by hongjian lin on 4/7/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FitmooHelper.h"

@interface ViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImage;

@property (strong, nonatomic) IBOutlet UIImageView *fitmooNameImage;
@property (strong, nonatomic) IBOutlet UIImageView *allRightImage;
@property (strong, nonatomic) IBOutlet UIButton *signUpButton;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;
- (IBAction)signupButtonClick:(id)sender;
- (IBAction)loginButtonClick:(id)sender;


@end


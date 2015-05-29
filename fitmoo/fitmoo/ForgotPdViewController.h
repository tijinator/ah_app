//
//  ForgotPdViewController.h
//  fitmoo
//
//  Created by hongjian lin on 5/28/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FitmooHelper.h"


#import "User.h"
#import <CoreData/CoreData.h>
#import "HomePageViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface ForgotPdViewController : UIViewController<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIButton *closeButton;
@property (strong, nonatomic)  NSDictionary * responseDic;
@property (strong, nonatomic) IBOutlet UILabel *dontWorryLabel;
@property (strong, nonatomic) IBOutlet UIButton *requestButton;
@property (strong, nonatomic) IBOutlet UILabel *forgotPdlabel;


- (IBAction)closeButtonClick:(id)sender;

- (IBAction)editingChanged;
@property (strong, nonatomic) IBOutlet UITextField *forgotPasswordEmail;
- (IBAction)requestButtonClick:(id)sender;


@end

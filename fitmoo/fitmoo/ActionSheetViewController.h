//
//  ActionSheetViewController.h
//  fitmoo
//
//  Created by hongjian lin on 4/14/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FitmooHelper.h"

@interface ActionSheetViewController : UIViewController
@property (strong, nonatomic) NSString * action;
@property (strong, nonatomic) NSString * postId;
-(void) performAnimation: (UIView *)view;
- (IBAction)endoseButtonClick:(id)sender;
- (IBAction)reportButtonClick:(id)sender;
- (IBAction)cancelButtonClick:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) IBOutlet UIButton *endorseButton;
@property (strong, nonatomic) IBOutlet UIButton *reportButton;
@property (strong, nonatomic) IBOutlet UIView *blackView;
@property (strong, nonatomic) IBOutlet UIView *buttomView;

@end

//
//  BioViewController.h
//  fitmoo
//
//  Created by hongjian lin on 5/12/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FitmooHelper.h"
@interface BioViewController : UIViewController
- (IBAction)backButtonClick:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UILabel *bioLabel;
@property (strong, nonatomic) IBOutlet UITextView *bioTextView;
@property (strong, nonatomic) IBOutlet UIView *topview;

@property (strong, nonatomic) NSString *bioText;

@end

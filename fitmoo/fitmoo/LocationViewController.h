//
//  LocationViewController.h
//  fitmoo
//
//  Created by hongjian lin on 5/22/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FitmooHelper.h"
#import "BaseViewController.h"
@interface LocationViewController : BaseViewController
@property (strong, nonatomic) IBOutlet UIImageView *commingSoonImage;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
- (IBAction)backButtonClick:(id)sender;
@end

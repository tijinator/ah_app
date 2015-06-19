//
//  ShopViewController.h
//  fitmoo
//
//  Created by hongjian lin on 5/5/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FitmooHelper.h"
#import "BaseViewController.h"
@interface ShopViewController : BaseViewController
@property (strong, nonatomic) IBOutlet UIImageView *commingSoonImage;
@property (strong, nonatomic) IBOutlet UIButton *shopButton;
- (IBAction)shopButtonClick:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
- (IBAction)backButtonClick:(id)sender;
@property (strong, nonatomic)  NSString *shoplink;
@end

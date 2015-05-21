//
//  SettingWebViewController.h
//  fitmoo
//
//  Created by hongjian lin on 5/21/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FitmooHelper.h"
@interface SettingWebViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UIWebView *webview;
@property (strong, nonatomic) NSString  *settingType;
@property (strong, nonatomic) NSString  *webviewLink;
- (IBAction)backButtonClick:(id)sender;

@end

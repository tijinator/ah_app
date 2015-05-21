//
//  SettingWebViewController.m
//  fitmoo
//
//  Created by hongjian lin on 5/21/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import "SettingWebViewController.h"

@interface SettingWebViewController ()

@end

@implementation SettingWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initFrames];
    
    [self displayWebview];
    // Do any additional setup after loading the view.
}

- (void) displayWebview
{
    
    _titleLabel.text= _settingType;
    

    NSURL *url = [NSURL URLWithString:_webviewLink];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];

    [_webview loadRequest:requestObj];

  
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initFrames
{
    //   _tableview.frame= CGRectMake(0, -20, 320, 490);
    _webview.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_webview respectToSuperFrame:self.view];
    _titleLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_titleLabel respectToSuperFrame:self.view];
    
    _topView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_topView respectToSuperFrame:self.view];
    _backButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_backButton respectToSuperFrame:self.view];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backButtonClick:(id)sender {
      [self.navigationController popViewControllerAnimated:YES];
}
@end

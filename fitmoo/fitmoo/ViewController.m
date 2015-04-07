//
//  ViewController.m
//  fitmoo
//
//  Created by hongjian lin on 4/7/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initFrames];
    [self showImagesWithDelay];
    
    // Do any additional setup after loading the view, typically from a nib.
}
int count=0;
- (void) showImagesWithDelay
{
    count=0;
    _loginButton.alpha=0;
    _signUpButton.alpha=0;
    _fitmooNameImage.alpha=0;
    _allRightImage.alpha=0;
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(displayPic:) userInfo:nil repeats:YES];
}

- (void) displayPic: (NSTimer *)timer {
    
    if (count==0) {
    [UIView animateWithDuration:.5 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
    _fitmooNameImage.alpha=1;
    }completion:^(BOOL finished){}];
    }
            
    if (count==1) {
    [UIView animateWithDuration:.5 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
    _allRightImage.alpha=1;
    }completion:^(BOOL finished){}];
    }
            
    if (count==2) {
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
    _loginButton.alpha=1;
    _signUpButton.alpha=1;
    _backgroundImage.image= [UIImage imageNamed:@"mobilelogin_screen2.png"];
    }completion:^(BOOL finished){}];
    }
    
    count++;
    if (count==3) {
        [timer invalidate];
    }
}

- (void) initFrames
{
    _loginButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_loginButton respectToSuperFrame:self.view];
    _signUpButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_signUpButton respectToSuperFrame:self.view];
    _fitmooNameImage.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_fitmooNameImage respectToSuperFrame:self.view];
    _allRightImage.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_allRightImage respectToSuperFrame:self.view];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signupButtonClick:(id)sender {
    
    
}

- (IBAction)loginButtonClick:(id)sender {
    
}
@end

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


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        _sighUpView=nil;
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initFrames];
    [self checkLogin];
  // [self showImagesWithDelay];
    
    [self createObservers];
    
    // Do any additional setup after loading the view, typically from a nib.
}

-(void) checkLogin
{
    User *localUser= [[UserManager sharedUserManager] getUserLocally];
    
    if (localUser.secret_id!=nil&&localUser.auth_token!=nil) {
        [[UserManager sharedUserManager] getUserProfile:localUser];
    }

}



-(void)createObservers{
  
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkLogin:) name:@"checkLogin" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openNextpage:) name:@"openNextpage" object:nil];
}


-(void)checkLogin:(NSNotification * )note
{
    User * user= [note object];
    if (user.user_id!=nil) {
        [self openHomePage];
    }
}

- (void) openHomePage
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    HomePageViewController * homepage = [mainStoryboard instantiateViewControllerWithIdentifier:@"HomePageViewController"];
    [self.navigationController pushViewController:homepage animated:YES];
}

-(void)openNextpage:(NSNotification * )note
{
    NSString *key= [note object];
    if ([key isEqualToString:@"login"]) {
        [self openLogingView];
    }else if ([key isEqualToString:@"signUp"]) {
        [self openSignUpView];
    }
}


-(void) viewWillAppear:(BOOL)animated
{
    if (_sighUpView!=nil) {
          _sighUpView=nil;
    }
    if (_loginView!=nil) {
        _loginView=nil;
    }
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
    _backgroundImage.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_backgroundImage respectToSuperFrame:self.view];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) openLogingView
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    _loginView = [mainStoryboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [self.navigationController pushViewController:_loginView animated:YES];
}

-(void) openSignUpView
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    _sighUpView = [mainStoryboard instantiateViewControllerWithIdentifier:@"SignUpViewController"];
    [self.navigationController pushViewController:_sighUpView animated:YES];
}

- (IBAction)signupButtonClick:(id)sender {
    [self openSignUpView];

}

- (IBAction)loginButtonClick:(id)sender {
    [self openLogingView];
}
@end

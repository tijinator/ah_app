//
//  ViewController.m
//  fitmoo
//
//  Created by hongjian lin on 4/7/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    double constentUp;
    double constentdown;
    bool loginExists;
}
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
    loginExists=false;
     [self checkLogin];
    
    _cachedUser= nil;
    self.facebookLoginView.delegate = self;
    self.facebookLoginView.readPermissions = @[@"public_profile", @"email", @"user_birthday"];

    
   
  // [self showImagesWithDelay];

    
    [self createObservers];
    
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

-(void) checkLogin
{
    
    self.facebookLoginView.frame = CGRectMake(25, 135, 270, 48);
    self.facebookLoginView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:self.facebookLoginView respectToSuperFrame:self.view];
    


    
    User *localUser= [[UserManager sharedUserManager] getUserLocally];
    
    if (localUser.secret_id!=nil&&localUser.auth_token!=nil) {
        [[UserManager sharedUserManager] getUserProfile:localUser];
        loginExists=true;
    }else
    {

     
    }

}

- (IBAction)forgotPasswordButtonClick:(id)sender {
    
        [self openLogingView];
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
    loginExists=false;
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
    [_activityIndicator stopAnimating];
    if (_sighUpView!=nil) {
          _sighUpView=nil;
    }
    if (_forgotPdView!=nil) {
        _forgotPdView=nil;
    }
    
    FBSession* session = [FBSession activeSession];
    [session closeAndClearTokenInformation];
    [session close];
    [FBSession setActiveSession:nil];
    
    NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray* facebookCookies = [cookies cookiesForURL:[NSURL         URLWithString:@"https://facebook.com/"]];
    
    for (NSHTTPCookie* cookie in facebookCookies) {
        [cookies deleteCookie:cookie];
    }

  //  loginExists =false;
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

-(BOOL) checkValidEmail: (UITextField *)textfield
{
    
    BOOL valid=true;
    
    if ([textfield.text isEqualToString:@""]) {
        return false;
    }
    
    if (![textfield.text containsString:@"@"]) {
        return false;
    }
    if (![textfield.text containsString:@".com"]) {
        return false;
    }
    
    return valid;
}

- (void) initFrames
{
    
  
    _loginButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_loginButton respectToSuperFrame:self.view];
    _signUpButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_signUpButton respectToSuperFrame:self.view];
    _fitmooNameImage.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_fitmooNameImage respectToSuperFrame:self.view];
    _allRightImage.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_allRightImage respectToSuperFrame:self.view];
    _backgroundImage.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_backgroundImage respectToSuperFrame:self.view];
   
   
    _emailTextField.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_emailTextField respectToSuperFrame:self.view];
    _passwordTextField.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_passwordTextField respectToSuperFrame:self.view];
    _forgotPasswordButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_forgotPasswordButton respectToSuperFrame:self.view];
    
    _orImage.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_orImage respectToSuperFrame:self.view];
    

    _backView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_backView respectToSuperFrame:self.view];
    
    constentUp=0;
    constentdown=168;
    
    _FacebookLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_FacebookLabel respectToSuperFrame:self.view];
    _FacebookLabel.userInteractionEnabled=NO;
    _FacebookLabel.exclusiveTouch=NO;
    [_facebookLoginView bringSubviewToFront:_FacebookLabel];
    
    //case iphone 4s
    if (self.view.frame.size.height<500) {
        constentUp=-100;
        constentdown=80;
        _backView.frame= CGRectMake(_backView.frame.origin.x,self.view.frame.size.height-_backView.frame.size.height, _backView.frame.size.width, _backView.frame.size.height);

    }
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    _emailTextField.leftView = paddingView;
    _emailTextField.leftViewMode = UITextFieldViewModeAlways;
    UIView *paddingView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    _passwordTextField.leftView = paddingView1;
    _passwordTextField.leftViewMode = UITextFieldViewModeAlways;

    
}


#pragma mark - FBLoginView Delegate method implementation

-(void)loginViewShowingLoggedInUser:(FBLoginView *)loginView{
    
    loginView.frame = CGRectMake(25, 135, 270, 48);
    loginView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:loginView respectToSuperFrame:self.view];
    
    
}

- (BOOL)isUser:(id<FBGraphUser>)firstUser equalToUser:(id<FBGraphUser>)secondUser {
    
    NSString *user_id1=firstUser[@"id"];
    NSString *user_id2=secondUser[@"id"];
    
    if (![user_id1 isEqual:user_id2]) {
        return false;
    }
    
    if (![firstUser.name isEqual:secondUser.name]) {
        return false;
    }
    
    if (![firstUser.name isEqual:secondUser.name]) {
        return false;
    }
    
    return true;
}

-(void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user{
    NSLog(@"%@", user);
    
    //if (![self isUser:_cachedUser equalToUser:user]) {
        
        User *localUser= [[User alloc] init];
        
        localUser.email= user[@"email"];
        localUser.gender=user[@"gender"];
        localUser.name= user[@"name"];
        localUser.day_of_birth= user[@"birthday"];
        localUser.facebook_uid=user[@"id"];
    
    
    if (loginExists ==false) {
        [[UserManager sharedUserManager] checkEmailExistFromFitmoo:localUser];
        _cachedUser = user;
    }
    
        
  //  }
    
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
  //  double radio= [[FitmooHelper sharedInstance] frameRadio];
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
        _backView.frame=CGRectMake(_backView.frame.origin.x, constentUp, _backView.frame.size.width, _backView.frame.size.height);
    }completion:^(BOOL finished){

    }];
    
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    double radio= [[FitmooHelper sharedInstance] frameRadio];
    [textField resignFirstResponder];
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
        _backView.frame=CGRectMake(_backView.frame.origin.x, constentdown*radio, _backView.frame.size.width, _backView.frame.size.height);
    }completion:^(BOOL finished){
        
    }];
    return YES;
}
-(void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView{
    loginView.frame = CGRectMake(25, 135, 270, 48);
    loginView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:loginView respectToSuperFrame:self.view];
    for (id obj in loginView.subviews)
    {
        
        
        if ([obj isKindOfClass:[UILabel class]])
        {
            UILabel * loginLabel =  obj;
            loginLabel.text = @"CONTINUE WITH FACEBOOK";
            loginLabel.textAlignment = NSTextAlignmentCenter;
            //    loginLabel.frame = CGRectMake(0, 0, 271, 37);
        }
    }
    
}


-(void)loginView:(FBLoginView *)loginView handleError:(NSError *)error{
    NSLog(@"%@", [error localizedDescription]);
}

- (void) addActivityIndicator
{
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [[FitmooHelper sharedInstance] resizeFrameWithFrame:_activityIndicator respectToSuperFrame:nil];
    _activityIndicator.center = CGPointMake(160*[[FitmooHelper sharedInstance] frameRadio], -20);
    _activityIndicator.hidesWhenStopped = YES;
    [self.view addSubview:_activityIndicator];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) openLogingView
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    _forgotPdView = [mainStoryboard instantiateViewControllerWithIdentifier:@"ForgotPdViewController"];
    [self.navigationController pushViewController:_forgotPdView animated:YES];
}

-(void) openSignUpView
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    _sighUpView = [mainStoryboard instantiateViewControllerWithIdentifier:@"SignUpViewController"];
    _sighUpView.Email= _emailTextField.text;
    _sighUpView.Password= _passwordTextField.text;
    [self.navigationController pushViewController:_sighUpView animated:YES];
}

- (IBAction)signupButtonClick:(id)sender {
    [self openSignUpView];

}



- (IBAction)loginButtonClick:(id)sender {
    User *localUser= [[User alloc] init];
      bool valiEmail= [self checkValidEmail:_emailTextField];
    if (!((valiEmail==false)||[_passwordTextField.text length]<6)) {
      
            localUser.email= _emailTextField.text;
            localUser.password=_passwordTextField.text;
            [[UserManager sharedUserManager] performLogin:localUser];
        [self addActivityIndicator];

    }else
    {

        [[FitmooHelper sharedInstance] showViewWithAnimation:@"Invalid username/password." withPareView:self.view];
    }
    

}
@end

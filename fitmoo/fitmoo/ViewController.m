//
//  ViewController.m
//  fitmoo
//
//  Created by hongjian lin on 4/7/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import "ViewController.h"
#import "Reachability.h"
@interface ViewController ()
{
    double constentUp;
    double constentdown;
    bool loginExists;
    UIView *indicatorView;
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
    
   // _cachedUser= nil;
    self.facebookLoginView.delegate = self;
    self.facebookLoginView.readPermissions = @[@"public_profile", @"email", @"user_birthday"];

    [self createObservers];
    [self showImagesWithDelay];
    
     [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(removeIndicator) userInfo:nil repeats:3];
    
 

 
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)removeIndicator
{
    [indicatorView removeFromSuperview];
 //   indicatorView.hidden=true;
}


- (void) addActivityIndicator1
{

  indicatorView= [[FitmooHelper sharedInstance] addActivityIndicatorView:indicatorView and:self.view];
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    _lanchScreen = [mainStoryboard instantiateViewControllerWithIdentifier:@"LanchScreen"];
    _lanchScreen.view.frame= CGRectMake(0, 0, 320*[[FitmooHelper sharedInstance] frameRadio], 569*[[FitmooHelper sharedInstance] frameRadio]);
    [self.view addSubview:_lanchScreen.view];
    [self.view bringSubviewToFront:_lanchScreen.view];
    _lanchScreen.view.alpha=1;
    
    [UIView animateWithDuration:4 delay:1 options:UIViewAnimationOptionTransitionNone animations:^{
        _lanchScreen.view.alpha=0;
    }completion:^(BOOL finished){
     
    
    }];
    
    
   
}

-(void) checkLogin
{
    
    self.facebookLoginView.frame = CGRectMake(25, 127, 270, 48);
    self.facebookLoginView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:self.facebookLoginView respectToSuperFrame:self.view];
    
   

    
    User *localUser= [[UserManager sharedUserManager] getUserLocally];
    
    if (localUser.secret_id!=nil&&localUser.auth_token!=nil) {
         [self addActivityIndicator1];
        [[UserManager sharedUserManager] getUserProfile:localUser];
        loginExists=true;
        
    }else
    {
      //  [self.lanchScreen.view removeFromSuperview];
     
    }

}

- (IBAction)forgotPasswordButtonClick:(id)sender {
    
        [self openLogingView];
}



-(void)createObservers{
  
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkLogin:) name:@"checkLogin" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openNextpage:) name:@"openNextpage" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginFailure:) name:@"loginFailure" object:nil];
}
-(void)loginFailure:(NSNotification * )note
{
    NSString *message= (NSString *)[note object];
    
    [[FitmooHelper sharedInstance] showViewWithAnimation:message withPareView:self.view];
 //   [_activityIndicator stopAnimating];
    [_lanchScreen.view removeFromSuperview];
    [indicatorView removeFromSuperview];
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

    [[NSNotificationCenter defaultCenter] postNotificationName:@"leftSideMenuAction" object:@"home"];
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
    //  [_lanchScreen.view removeFromSuperview];
    if (_sighUpView!=nil) {
        _sighUpView=nil;
    }
    if (_forgotPdView!=nil) {
        _forgotPdView=nil;
    }
    
//    FBSession* session = [FBSession activeSession];
//    [session closeAndClearTokenInformation];
//    [session close];
//    [FBSession setActiveSession:nil];
//
//    NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//    NSArray* facebookCookies = [cookies cookiesForURL:[NSURL         URLWithString:@"https://facebook.com/"]];
//
//    for (NSHTTPCookie* cookie in facebookCookies) {
//        [cookies deleteCookie:cookie];
//    }
//    if ([[FBSession activeSession] isOpen])
//    {
//        [[FBSession activeSession] close];
//        [FBSession.activeSession closeAndClearTokenInformation];
//    }
//
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        NSLog(@"There IS NO internet connection");
        [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(trackingInternet:) userInfo:nil repeats:YES];
        
        
    } else {
        
        
        NSLog(@"There IS internet connection");
        
    }
    
    
}


- (void)trackingInternet:(NSTimer *)timer
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        NSLog(@"There IS NO internet connection");
        
    } else {
        [timer invalidate];
        [self checkLogin];
        NSLog(@"There IS internet connection");
        
    }
    
}


- (void) showImagesWithDelay
{
    _backView.alpha=0;
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
        
        _backView.alpha=1;
    }completion:^(BOOL finished){}];
}



-(BOOL) checkValidEmail: (UITextField *)textfield
{
    
 //   BOOL valid=true;
    
    if ([textfield.text isEqualToString:@""]) {
        return false;
    }

    
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:textfield.text];
    
  //  return valid;
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
    
    _orLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_orLabel respectToSuperFrame:self.view];
    _separateView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_separateView respectToSuperFrame:self.view];
    _separateView1.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_separateView1 respectToSuperFrame:self.view];
    
    [_emailTextField setValue:[UIColor colorWithRed:153.0/255.0 green:154.0/255.0 blue:158.0/255.0 alpha:1.0] forKeyPath:@"_placeholderLabel.textColor"];
    [_passwordTextField setValue:[UIColor colorWithRed:153.0/255.0 green:154.0/255.0 blue:158.0/255.0 alpha:1.0] forKeyPath:@"_placeholderLabel.textColor"];
    
    constentUp=0;
    constentdown=168;
    
   // _FacebookLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_FacebookLabel respectToSuperFrame:self.view];
    _FacebookLabel.userInteractionEnabled=NO;
    _FacebookLabel.exclusiveTouch=NO;
    [_facebookLoginView bringSubviewToFront:_FacebookLabel];
    _facebookLoginView.layer.cornerRadius=3;
    
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

- (void)loginButton:(FBSDKLoginButton *)loginButton
didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result
              error:(NSError *)error {
    User *localUser= [[User alloc] init];
    
//    localUser.email = [result.token.permissions valueForKey:@"email"]
//    localUser.name= user.name;
//    localUser.day_of_birth= user.birthday;
//    localUser.facebook_uid=user.objectID;
}

//-(void)loginViewShowingLoggedInUser:(FBLoginView *)loginView{
//
//    loginView.frame = CGRectMake(25, 127, 270, 48);
//    loginView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:loginView respectToSuperFrame:self.view];
//    [self addActivityIndicator1];
//
//}
//
//- (BOOL)isUser:(id<FBGraphUser>)firstUser equalToUser:(id<FBGraphUser>)secondUser {
//
//    NSString *user_id1=firstUser.objectID;
//    NSString *user_id2=secondUser.objectID;
//
//    if (![user_id1 isEqual:user_id2]) {
//        return false;
//    }
//
//    if (![firstUser.name isEqual:secondUser.name]) {
//        return false;
//    }
//
//    if (![firstUser.name isEqual:secondUser.name]) {
//        return false;
//    }
//
//    return true;
//}
//
//-(void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user{
//    NSLog(@"%@", user);
//
//        User *localUser= [[User alloc] init];
//
//        localUser.email= user.username;
//        localUser.name= user.name;
//        localUser.day_of_birth= user.birthday;
//        localUser.facebook_uid=user.objectID;
//
//
//    if (loginExists ==false) {
//        [self addActivityIndicator];
//        [[UserManager sharedUserManager] checkEmailExistFromFitmoo:localUser];
//        _cachedUser = user;
//    }
//
//
//}

//-(void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView{
//    loginView.frame = CGRectMake(25, 127, 270, 48);
//    loginView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:loginView respectToSuperFrame:self.view];
//    for (id obj in loginView.subviews)
//    {
//
//
//        if ([obj isKindOfClass:[UILabel class]])
//        {
//            UILabel * loginLabel =  obj;
//            loginLabel.text = @"CONTINUE WITH FACEBOOK";
//            loginLabel.textAlignment = NSTextAlignmentCenter;
//            //    loginLabel.frame = CGRectMake(0, 0, 271, 37);
//        }
//    }
//
//}
//
//
//-(void)loginView:(FBLoginView *)loginView handleError:(NSError *)error{
//    NSLog(@"%@", [error localizedDescription]);
//}



- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    textField.spellCheckingType = UITextSpellCheckingTypeNo;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
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

- (void) addActivityIndicator
{
//    _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    _activityIndicator.center = CGPointMake(160*[[FitmooHelper sharedInstance] frameRadio],  240*[[FitmooHelper sharedInstance] frameRadio]);
//    _activityIndicator.hidesWhenStopped = YES;
//    [self.view addSubview:_activityIndicator];
//    [_activityIndicator startAnimating];

    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    _lanchScreen = [mainStoryboard instantiateViewControllerWithIdentifier:@"LanchScreen"];
    _lanchScreen.view.frame= CGRectMake(0, 0, 320*[[FitmooHelper sharedInstance] frameRadio], 569*[[FitmooHelper sharedInstance] frameRadio]);
    [self.view addSubview:_lanchScreen.view];
    [self.view bringSubviewToFront:_lanchScreen.view];
    _lanchScreen.view.alpha=0;
    
    [UIView animateWithDuration:.5 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
        _lanchScreen.view.alpha=1;
    }completion:^(BOOL finished){
        
        [UIView animateWithDuration:.5 delay:4 options:UIViewAnimationOptionTransitionNone animations:^{
            _lanchScreen.view.alpha=0;
        }completion:^(BOOL finished){
            
            
        }];
        
    }];

    
   // [self.view bringSubviewToFront:_activityIndicator];
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
        
        [self textFieldShouldReturn:_passwordTextField];

    }else
    {

        [[FitmooHelper sharedInstance] showViewWithAnimation:@"Invalid username/password." withPareView:self.view];
    }
    

}
@end

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
    
    _cachedUser= nil;
    self.facebookLoginView.delegate = self;
    
    self.facebookLoginView.readPermissions = @[@"public_profile", @"email", @"user_birthday"];
    
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
    
}


#pragma mark - FBLoginView Delegate method implementation

-(void)loginViewShowingLoggedInUser:(FBLoginView *)loginView{
    
    loginView.frame = CGRectMake(30, 135, 270, 48);
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
    
   // if (![self isUser:_cachedUser equalToUser:user]) {
        
        User *localUser= [[User alloc] init];
        
        localUser.email= user[@"email"];
        localUser.gender=user[@"gender"];
        localUser.name= user[@"name"];
        localUser.day_of_birth= user[@"birthday"];
        localUser.facebook_uid=user[@"id"];
        
        [[UserManager sharedUserManager] checkEmailExistFromFitmoo:localUser];
        _cachedUser = user;
        
  //  }
    
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    double radio= [[FitmooHelper sharedInstance] frameRadio];
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
        _backView.frame=CGRectMake(_backView.frame.origin.x, 0, _backView.frame.size.width, _backView.frame.size.height);
    }completion:^(BOOL finished){

    }];
    
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    double radio= [[FitmooHelper sharedInstance] frameRadio];
    [textField resignFirstResponder];
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
        _backView.frame=CGRectMake(_backView.frame.origin.x, 168*radio, _backView.frame.size.width, _backView.frame.size.height);
    }completion:^(BOOL finished){
        
    }];
    return YES;
}
-(void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView{
    loginView.frame = CGRectMake(30, 135, 270, 48);
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

    }else
    {
//        UIAlertView *alert = [[ UIAlertView alloc ] initWithTitle : @"Could not log in"
//                                                          message : @"Invalid username/password." delegate : nil cancelButtonTitle : @"OK"
//                                                otherButtonTitles : nil ];
//        [alert show ];
        [[FitmooHelper sharedInstance] showViewWithAnimation:@"Invalid username/password." withPareView:self.view];
    }
    

}
@end

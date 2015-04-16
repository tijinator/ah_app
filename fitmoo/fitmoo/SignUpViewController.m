//
//  SignUpViewController.m
//  fitmoo
//
//  Created by hongjian lin on 4/7/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import "SignUpViewController.h"

@implementation SignUpViewController
{
    @private BOOL _valEmail;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initFrames];
  
    _valEmail=false;
    self.facebookLoginView.delegate = self;
    self.facebookLoginView.readPermissions = @[@"public_profile", @"email"];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void) initFrames
{
    _loginButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_loginButton respectToSuperFrame:self.view];
    _closeButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_closeButton respectToSuperFrame:self.view];
    _emailTextField.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_emailTextField respectToSuperFrame:self.view];
    _sighUpButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_sighUpButton respectToSuperFrame:self.view];
    _backgroundImage.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_backgroundImage respectToSuperFrame:self.view];
    [_emailTextField setDelegate:self];
     [_datePicker setDatePickerMode:UIDatePickerModeDate];
}


#pragma mark - FBLoginView Delegate method implementation

-(void)loginViewShowingLoggedInUser:(FBLoginView *)loginView{
    
    loginView.frame = CGRectMake(24, 68, 270, 37);
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
    
    if (![self isUser:_cachedUser equalToUser:user]) {
        
        User *localUser= [[User alloc] init];
        
        localUser.email= user[@"email"];
        localUser.gender=user[@"gender"];
        localUser.name= user[@"name"];
        localUser.day_of_birth= user[@"birthday"];
        localUser.facebook_uid=user[@"id"];
        
        [[UserManager sharedUserManager] checkEmailExistFromFitmoo:localUser];
        _cachedUser = user;
        
    }
    
    
}


-(void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView{
    loginView.frame = CGRectMake(24, 68, 270, 37);
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


-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

-(void) showRestOfViews
{
    _emailTextField.userInteractionEnabled=false;
    
}

- (IBAction)signUpButtonClick:(id)sender {
    
    if (_valEmail==false) {
        NSString *email= _emailTextField.text;
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.securityPolicy.allowInvalidCertificates = YES;
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:email, @"email",@"true", @"mobile",nil];
        NSString *url= [NSString stringWithFormat:@"%@%@",[[UserManager sharedUserManager] homeFeedUrl], @"unique_email"];
        [manager GET: url parameters:jsonDict success:^(AFHTTPRequestOperation *operation, id responseObject){
            
            NSDictionary * _responseDic= responseObject;
            NSNumber *unique= [_responseDic objectForKey:@"is_unique"];
            if ([[unique stringValue] isEqualToString:@"1"]) {
                _valEmail=true;
                [self showRestOfViews];
            }else
            {
                _valEmail=false;
                UIAlertView *alert = [[ UIAlertView alloc ] initWithTitle : @"Could not create account."
                                                                  message : @"Email already taken" delegate : nil cancelButtonTitle : @"OK"
                                                        otherButtonTitles : nil ];
                [alert show ];
            }
            
        } // success callback block
             failure:^(AFHTTPRequestOperation *operation, NSError *error){
                 NSLog(@"Error: %@", error);} // failure callback block
         ];
        

    }else
    {
        
    }
}


#pragma mark - UIPickerViewDelegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
    if (row==1) {
        _genderLabel.text=@"Female";
    }else
        if (row==0) {
            _genderLabel.text=@"Male";
        }
    
    // Handle the selection
}

// tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSUInteger numRows = 2;
    return numRows;
}

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// tell the picker the title for a given component
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *title;
    if (row==0) {
        title=@"Male";
    }else if (row==1)
    {
        title=@"Female";
    }
    
    return title;
}

// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    int sectionWidth = 300;
    
    return sectionWidth;
}


#pragma mark - UIbutton functions
- (IBAction)dateBirthButtonClick:(id)sender {
    _pickerView.hidden=false;
}

- (IBAction)genderButtonClick:(id)sender {
    _pickerView2.hidden=false;
}

- (IBAction)doneButtonClick:(id)sender {
    UIButton *b= (UIButton *) sender;
    if (b.tag==1) {
        NSDate *pickerDate = [_datePicker date];
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        format.dateFormat = @"MM-dd-yyyy";
        _dateBirthLabel.text =  [format stringFromDate:pickerDate];
        _pickerView.hidden=true;
    }else if (b.tag==2)
    {
        _pickerView2.hidden=true;
    }else if (b.tag==3)
    {
        _emailTextField.userInteractionEnabled=true;
    }
}


- (IBAction)clearButtonClick:(id)sender {
    _dateBirthLabel.text = @"";
}

- (IBAction)closeButtonClick:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}


- (IBAction)loginButtonClick:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"openNextpage" object:@"login"];
    
}
@end

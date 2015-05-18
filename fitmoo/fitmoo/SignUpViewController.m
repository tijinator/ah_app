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
    @private BOOL _checkEmpty;
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
    _backgroundView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_backgroundView respectToSuperFrame:self.view];
    _nameField.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_nameField respectToSuperFrame:self.view];
    _passwordField.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_passwordField respectToSuperFrame:self.view];
    _dateBirthView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_dateBirthView respectToSuperFrame:self.view];
    _genderView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_genderView respectToSuperFrame:self.view];
    _backButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_backButton respectToSuperFrame:self.view];
    
    _pickerView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_pickerView respectToSuperFrame:self.view];
    _pickerView2.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_pickerView2 respectToSuperFrame:self.view];
    double x=(self.view.frame.size.width-_datePicker.frame.size.width)/2;
    _datePicker.frame= CGRectMake(_datePicker.frame.origin.x+x, _datePicker.frame.origin.y*[[FitmooHelper sharedInstance] frameRadio], _datePicker.frame.size.width, _datePicker.frame.size.height);

     double x1=(self.view.frame.size.width-_genderPickerView.frame.size.width)/2;
    _genderPickerView.frame= CGRectMake(_genderPickerView.frame.origin.x+x1, _genderPickerView.frame.origin.y*[[FitmooHelper sharedInstance] frameRadio], _genderPickerView.frame.size.width, _genderPickerView.frame.size.height);
    _doneButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_doneButton respectToSuperFrame:self.view];
    _doneButton1.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_doneButton1 respectToSuperFrame:self.view];
    _clearButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_clearButton respectToSuperFrame:self.view];

    
   // _loginButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_loginButton respectToSuperFrame:self.view];
    _closeButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_closeButton respectToSuperFrame:self.view];
    _emailTextField.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_emailTextField respectToSuperFrame:self.view];
  //  _sighUpButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_sighUpButton respectToSuperFrame:self.view];
    _backgroundImage.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_backgroundImage respectToSuperFrame:self.view];
    [_emailTextField setDelegate:self];
     [_datePicker setDatePickerMode:UIDatePickerModeDate];
    
    _sighUpButton.frame=CGRectMake(33, 197, 255, 44);
    _sighUpButton.frame=[[FitmooHelper sharedInstance] resizeFrameWithFrame:_sighUpButton respectToSuperFrame:self.view];
    _loginButton.frame=CGRectMake(25, 261, 270, 23);
    _loginButton.frame=[[FitmooHelper sharedInstance] resizeFrameWithFrame:_loginButton respectToSuperFrame:self.view];
}


#pragma mark - FBLoginView Delegate method implementation

-(void)loginViewShowingLoggedInUser:(FBLoginView *)loginView{
    
    loginView.frame = CGRectMake(33, 70, 255, 39);
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
    loginView.frame = CGRectMake(33, 70, 255, 39);
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


- (IBAction)signUpButtonClick:(id)sender {
    
    if ([self checkValidEmail]==false) {
        UIAlertView *alert = [[ UIAlertView alloc ] initWithTitle : @"Could not create account."
                                                          message : @"Enter Valid Email." delegate : nil cancelButtonTitle : @"OK"
                                                otherButtonTitles : nil ];
        [alert show ];
    }else
    {
    
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
        _checkEmpty=[self checkEmpty];
        
        if (_checkEmpty==false) {
            
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            manager.securityPolicy.allowInvalidCertificates = YES;
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
            
            User *localUser= [[User alloc] init];
            
            NSString *date= _dateBirthLabel.text;
            NSRange range = NSMakeRange(0,2);
            NSRange range1 = NSMakeRange(3,2);
            NSRange range2 = NSMakeRange(6,4);
            NSString *month= [date substringWithRange:range];
            NSString *day= [date substringWithRange:range1];
            NSString *year= [date substringWithRange:range2];
            
            NSDictionary * userData= [[NSDictionary alloc] initWithObjectsAndKeys:_emailTextField.text, @"email",_nameField.text, @"full_name",_passwordField.text, @"password",_genderLabel.text, @"gender",nil];
            
            NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:month, @"dob_month",day, @"dob_day",year, @"dob_year",userData, @"user",nil];
            NSString *url= [NSString stringWithFormat:@"%@%@",[[UserManager sharedUserManager] homeFeedUrl], @"create_user_from_mobile"];
            [manager POST: url parameters:jsonDict success:^(AFHTTPRequestOperation *operation, id responseObject){
                
                NSDictionary * _responseDic= responseObject;
                
                localUser.secret_id= [_responseDic objectForKey:@"secret_id"];
                localUser.auth_token= [_responseDic objectForKey:@"auth_token"];
                NSNumber * user_id=[_responseDic objectForKey:@"user_id"];
                localUser.user_id= [user_id stringValue];
                [[UserManager sharedUserManager] setLocalUser:localUser];
                [[UserManager sharedUserManager] saveLocalUser:localUser];
                [[UserManager sharedUserManager] getUserProfile:localUser];
                
                
              
            } // success callback block
                 failure:^(AFHTTPRequestOperation *operation, NSError *error){
                     NSLog(@"Error: %@", error);} // failure callback block
             ];
            

            
        }
    }
        
        
    }
}

-(BOOL) checkValidEmail
{
    
     BOOL valid=true;
    
    if ([_emailTextField.text isEqualToString:@""]) {
        return false;
    }
    
    if (![_emailTextField.text containsString:@"@"]) {
        return false;
    }
    if (![_emailTextField.text containsString:@".com"]) {
        return false;
    }
    
    return valid;
}

- (BOOL) checkEmpty
{
    NSString *emptyMessage;
    NSString *emptyMessage1;
    NSString *emptyMessage2;
    BOOL empty=false;
    
    if ([_nameField.text isEqualToString:@""]) {
        emptyMessage=@"Enter a full name.";
        empty=true;
    }else { emptyMessage=@""; }
    
    if ([_passwordField.text isEqualToString:@""]) {
        emptyMessage1=@"Enter a password.";
          empty=true;
    }else {emptyMessage1=@"";}
    
    if ([_dateBirthLabel.text isEqualToString:@""]) {
        emptyMessage2=@"Enter a birthday.";
          empty=true;
    }else {emptyMessage2=@"";}
    
    if (empty==true) {
        NSString *totaleMessage= [NSString stringWithFormat:@"%@\n%@\n%@", emptyMessage,emptyMessage1,emptyMessage2];
        
        _valEmail=false;
        UIAlertView *alert = [[ UIAlertView alloc ] initWithTitle : @"Could not create account."
                                                          message : totaleMessage delegate : nil cancelButtonTitle : @"OK"
                                                otherButtonTitles : nil ];
        [alert show];
    }
    
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
    [components setHour:10];
    NSDate *today10am = [calendar dateFromComponents:components];
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyy";
    NSString *thisYear=  [format stringFromDate:today10am];
    
    
    NSString *date= _dateBirthLabel.text;
    NSRange range2 = NSMakeRange(6,4);
    NSString *year= [date substringWithRange:range2];
    
    if ([thisYear integerValue]-[year integerValue]<=12) {
        
          empty=true;
        
        NSString *totaleMessage=@"You must be older than 13.";
        
        _valEmail=false;
        UIAlertView *alert = [[ UIAlertView alloc ] initWithTitle : @"Could not create account."
                                                          message : totaleMessage delegate : nil cancelButtonTitle : @"OK"
                                                otherButtonTitles : nil ];
        [alert show];

    }
    
    return empty;
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

- (IBAction)backButtonClick:(id)sender {
    
    _emailTextField.userInteractionEnabled=true;
    _backgroundView.hidden=true;
    _nameField.hidden=true;
    _passwordField.hidden=true;
    _dateBirthView.hidden=true;
    _genderView.hidden=true;
    _backButton.hidden=true;
    [_sighUpButton setTitle:@"SIGH UP" forState:UIControlStateNormal];
    
    _sighUpButton.frame=CGRectMake(33, 197, 255, 44);
    _sighUpButton.frame=[[FitmooHelper sharedInstance] resizeFrameWithFrame:_sighUpButton respectToSuperFrame:self.view];
    _loginButton.frame=CGRectMake(25, 261, 270, 23);
    _loginButton.frame=[[FitmooHelper sharedInstance] resizeFrameWithFrame:_loginButton respectToSuperFrame:self.view];
    _valEmail=false;
}

-(void) showRestOfViews
{
    _emailTextField.userInteractionEnabled=false;
    _backgroundView.hidden=false;
    _nameField.hidden=false;
    _passwordField.hidden=false;
    _dateBirthView.hidden=false;
    _genderView.hidden=false;
    _backButton.hidden=false;
    [_sighUpButton setTitle:@"GET STARTED" forState:UIControlStateNormal];
    
    _sighUpButton.frame=CGRectMake(33, 390, 255, 44);
    _sighUpButton.frame=[[FitmooHelper sharedInstance] resizeFrameWithFrame:_sighUpButton respectToSuperFrame:self.view];
    _loginButton.frame=CGRectMake(25, 495, 270, 23);
    _loginButton.frame=[[FitmooHelper sharedInstance] resizeFrameWithFrame:_loginButton respectToSuperFrame:self.view];
    
}

@end

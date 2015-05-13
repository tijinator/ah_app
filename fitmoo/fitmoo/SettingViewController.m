//
//  SettingViewController.m
//  fitmoo
//
//  Created by hongjian lin on 5/5/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initFrames];
    [self createObservers];
    self.tabletype=@"setting";
    [self.bottomView setHidden:true];
    double radio= [[FitmooHelper sharedInstance] frameRadio];
    
     _heightArray= [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithDouble:69*radio],[NSNumber numberWithDouble:143*radio],[NSNumber numberWithDouble:139*radio],[NSNumber numberWithDouble:68*radio],[NSNumber numberWithDouble:74*radio],[NSNumber numberWithDouble:66*radio],[NSNumber numberWithDouble:148*radio], nil];
    _privacyArray= [[NSMutableArray alloc] initWithObjects:@"Global Privacy",@"Hide Location",@"Hide Email",@"Hide Phone Info",@"Hide Website",@"Hide Facebook Info",@"Hide Twitter Info",@"Hide Linkedln Info",@"Hide Google Plus Info",@"Hide Instagram Info", nil];
    [self getSettingPageItems];
    
    [self addfootButtonsForSetting];
     self.tableview.tableFooterView = [[UIView alloc] init];
    // Do any additional setup after loading the view.
}

- (void) addfootButtonsForSetting
{
    double Radio= self.view.frame.size.width / 320;
    
    _settingBottomView= [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-Radio*60, 320*Radio, 60*Radio)];
    
    
    _settingButton= [[UIButton alloc] initWithFrame:CGRectMake(16, 7, 38,38)];
   
    _privacyButton= [[UIButton alloc] initWithFrame:CGRectMake(270, 7, 38,38)];
    
    
    _settingButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_settingButton respectToSuperFrame:self.view];

    _privacyButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_privacyButton respectToSuperFrame:self.view];
    
    
    _settingButton.tag=21;
    _privacyButton.tag=22;
    
    [_settingButton addTarget:self action:@selector(settingFootbuttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_privacyButton addTarget:self action:@selector(settingFootbuttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *im= [UIImage imageNamed:@"sidemenu_icon.png"];
    [_settingButton setBackgroundImage:im forState:UIControlStateNormal];

    UIImage *im2= [UIImage imageNamed:@"home_icon.png"];
    [_privacyButton setBackgroundImage:im2 forState:UIControlStateNormal];
    
    [self.settingBottomView addSubview:_settingButton];
    [self.settingBottomView addSubview:_privacyButton];
    
    [self.view addSubview:_settingBottomView];
    [self.view bringSubviewToFront:_settingBottomView];
    
    
    
}

- (IBAction)settingFootbuttonClick:(id)sender {
       UIButton *button = (UIButton *)sender;

    switch (button.tag) {
        case 21:
            self.tabletype=@"setting";
            [self.tableview reloadData];
            break;
        case 22:
            self.tabletype=@"privacy";
            [self.tableview reloadData];
            break;
            
        default:
            break;
    }
    
}


- (void) initFrames
{
 //   _tableview.frame= CGRectMake(0, -20, 320, 490);
    _tableview.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_tableview respectToSuperFrame:self.view];
    
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        //    _postText= textView.text;
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}
#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    if ([self.tabletype isEqualToString:@"privacy"]) {
        return 10;
    }
    return 7;
}
- (void)switchValueChanged:(UISwitch *)theSwitch
{
    BOOL flag = theSwitch.on;
    int index= theSwitch.tag-20;
    NSString *value;
    if (flag==true) {
        value=@"1";
    }else
    {
         value=@"0";
    }
    
    [_privacyBoolArray replaceObjectAtIndex:index withObject:value];
    
    switch (index) {
        case 0:
            _tempUser.hide_global_privacy=value;
            break;
        case 1:
             _tempUser.hide_location=value;
            break;
        case 2:
             _tempUser.hide_email=value;
            break;
        case 3:
             _tempUser.hide_phone=value;
            break;
        case 4:
             _tempUser.hide_website=value;
            break;
        case 5:
             _tempUser.hide_facebook=value;
            break;
        case 6:
             _tempUser.hide_twitter=value;
            break;
        case 7:
             _tempUser.hide_linkedin=value;
            break;
        case 8:
            _tempUser.hide_google=value;
            break;
        case 9:
             _tempUser.hide_instagram=value;
            break;


            
        default:
            break;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([self.tabletype isEqualToString:@"privacy"]) {
         UITableViewCell * cell=  [self.tableview cellForRowAtIndexPath:indexPath];
        if (cell == nil)
        {
             cell=[tableView dequeueReusableCellWithIdentifier:@"privacyCell"];
             UILabel *label= (UILabel *)[cell viewWithTag:20];
            label.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:label respectToSuperFrame:nil];
            label.text= [_privacyArray objectAtIndex:indexPath.row];
            UISwitch *sw= (UISwitch *) [cell viewWithTag:21];
            double frameradio= [[FitmooHelper sharedInstance] frameRadio];
            sw.frame= CGRectMake(sw.frame.origin.x*frameradio, sw.frame.origin.y*frameradio, sw.frame.size.width, sw.frame.size.height);
            sw.tag=indexPath.row+20;
            [sw addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
            NSString *on= [_privacyBoolArray objectAtIndex:indexPath.row];
            if ([on isEqualToString:@"0"]) {
                  [sw setOn:NO animated:YES];
            }else
            {
                [sw setOn:YES animated:YES];
            }
            
        }
        
        
        return cell;
    }
    
    
    UITableViewCell * cell=  [self.tableview cellForRowAtIndexPath:indexPath];
    
    if (indexPath.row==0) {
        if (cell == nil)
        {
            cell=[tableView dequeueReusableCellWithIdentifier:@"nameCell"];
            
            UILabel *nameLabel= (UILabel *)[cell viewWithTag:1];
            nameLabel.frame=CGRectMake(29, 8, 270, 21);
            nameLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:nameLabel respectToSuperFrame:self.view];
            
            UITextField *nameTextfield= (UITextField *)[cell viewWithTag:2];
            nameTextfield.frame=CGRectMake(29, 30, 270, 30);
            nameTextfield.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:nameTextfield respectToSuperFrame:self.view];
            nameTextfield.text=_tempUser.name;
            
            _nameTextfield=nameTextfield;
        }
    }else if (indexPath.row==1) {
        if (cell == nil)
        {
            cell=[tableView dequeueReusableCellWithIdentifier:@"pictureCell"];
            
            UILabel *profileLabel= (UILabel *)[cell viewWithTag:3];
            profileLabel.frame=CGRectMake(29, 8, 270, 21);
            profileLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:profileLabel respectToSuperFrame:self.view];
            
            UIButton *imageview=(UIButton *) [cell viewWithTag:4];
            imageview.frame= CGRectMake(29, 37, 80, 66);
            imageview.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:imageview respectToSuperFrame:self.view];
            
            UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, imageview.frame.size.width, imageview.frame.size.height)];
          //  view.clipsToBounds=YES;
          //  view.layer.cornerRadius=view.frame.size.width/2;
            
            AsyncImageView *userImage = [[AsyncImageView alloc] initWithFrame:CGRectMake(0, 0, imageview.frame.size.width, imageview.frame.size.height)];
            [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:userImage];
            userImage.imageURL =[NSURL URLWithString:_tempUser.profile_avatar_thumb];
         
            [view addSubview:userImage];
            [imageview addSubview:view];
            
            [imageview addTarget:self action:@selector(imageviewButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            UILabel *changeLabel= (UILabel *)[cell viewWithTag:5];
            changeLabel.frame=CGRectMake(29, 111, 161, 21);
            changeLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:changeLabel respectToSuperFrame:self.view];
        }
        
    }else if (indexPath.row==2) {
        if (cell == nil)
        {
            cell=[tableView dequeueReusableCellWithIdentifier:@"bioCell"];
            
            UILabel *bioLabel= (UILabel *)[cell viewWithTag:6];
            bioLabel.frame=CGRectMake(29, 8, 270, 21);
            bioLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:bioLabel respectToSuperFrame:self.view];
            
            UITextView *bioTextfield= (UITextView *)[cell viewWithTag:7];
            bioTextfield.frame=CGRectMake(29, 30, 266, 93);
            bioTextfield.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:bioTextfield respectToSuperFrame:self.view];
            bioTextfield.text=_tempUser.bio;
            
            _bioTextview=bioTextfield;
        }
        
    }else if (indexPath.row==3) {
        if (cell == nil)
        {
            cell=[tableView dequeueReusableCellWithIdentifier:@"locationCell"];
            
            UILabel *locationLabel= (UILabel *)[cell viewWithTag:8];
            locationLabel.frame=CGRectMake(29, 8, 270, 21);
            locationLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:locationLabel respectToSuperFrame:self.view];
            
            UITextField *locationTextfield= (UITextField *)[cell viewWithTag:9];
            locationTextfield.frame=CGRectMake(29, 30, 270, 30);
            locationTextfield.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:locationTextfield respectToSuperFrame:self.view];
            locationTextfield.text=_tempUser.location;
            
            _locationTextfield=locationTextfield;
        }
        
    }else if (indexPath.row==4) {
        if (cell == nil)
        {
            cell=[tableView dequeueReusableCellWithIdentifier:@"locationCell"];
         
            
            UILabel *phoneLabel= (UILabel *)[cell viewWithTag:8];
            phoneLabel.frame=CGRectMake(29, 8, 270, 21);
            phoneLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:phoneLabel respectToSuperFrame:self.view];
            phoneLabel.text=@"phone:";
            
            UITextField *phoneTextfield= (UITextField *)[cell viewWithTag:9];
            phoneTextfield.frame=CGRectMake(29, 30, 270, 30);
            phoneTextfield.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:phoneTextfield respectToSuperFrame:self.view];
            phoneTextfield.text=_tempUser.phone;
            
            _phoneTextfield=phoneTextfield;
            
        }
        
    }else if (indexPath.row==5) {
        if (cell == nil)
        {
            cell=[tableView dequeueReusableCellWithIdentifier:@"locationCell"];
            UILabel *websiteLabel= (UILabel *)[cell viewWithTag:8];
            websiteLabel.frame=CGRectMake(29, 8, 270, 21);
            websiteLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:websiteLabel respectToSuperFrame:self.view];
            websiteLabel.text= @"Website:";
            
            UITextField *websiteTextfield= (UITextField *)[cell viewWithTag:9];
            websiteTextfield.frame=CGRectMake(29, 30, 270, 30);
            websiteTextfield.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:websiteTextfield respectToSuperFrame:self.view];
            websiteTextfield.text=_tempUser.website;
            
            _websiteTextfield=websiteTextfield;
        }
        
    }else if (indexPath.row==6) {
        if (cell == nil)
        {
            cell=[tableView dequeueReusableCellWithIdentifier:@"saveCell"];
            UIButton *saveButton= (UIButton *) [cell viewWithTag:14];
            saveButton.frame=CGRectMake(17, 8, 287, 30);
            saveButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:saveButton respectToSuperFrame:self.view];
            [saveButton addTarget:self action:@selector(saveButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        
    }
    
    return cell;
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{

    [textField resignFirstResponder];
    return YES;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
}

// multy high table cell
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
  //  double Radio= self.view.frame.size.width / 320;
    if ([self.tabletype isEqualToString:@"privacy"]) {
        return 50*[[FitmooHelper sharedInstance] frameRadio];
    }
    NSNumber * height=(NSNumber *) [_heightArray objectAtIndex:indexPath.row];
    return  height.integerValue;
}

- (void) defineSettingObject
{
    _tempUser= [[User alloc] init];
    
    _tempUser.name= [_responseDic objectForKey:@"full_name"];
    _tempUser.user_id= [_responseDic objectForKey:@"id"];
    NSDictionary *profile= [_responseDic objectForKey:@"profile"];
    
    NSDictionary *avatars= [profile objectForKey:@"avatars"];
    _tempUser.profile_avatar_thumb=[avatars objectForKey:@"thumb"];
    _tempUser.bio= [profile objectForKey:@"bio"];
    if ([_tempUser.bio isEqual:[NSNull null]]) {
        _tempUser.bio=@"";
    }
    _tempUser.location= [profile objectForKey:@"location"];
    if ([_tempUser.location isEqual:[NSNull null]]) {
        _tempUser.location=@"";
    }
    _tempUser.phone=[profile objectForKey:@"phone"];
    if ([_tempUser.phone isEqual:[NSNull null]]) {
        _tempUser.phone=@"";
    }
    
    _tempUser.website=[profile objectForKey:@"website"];
    if ([_tempUser.website isEqual:[NSNull null]]) {
        _tempUser.website=@"";
    }
    
    NSDictionary *privacy= [_responseDic objectForKey:@"user_privacy"];
    
    NSNumber * num=[privacy objectForKey:@"global_privacy"];
    _tempUser.hide_global_privacy=num.stringValue;
   
    
    num=[privacy objectForKey:@"location"];
    _tempUser.hide_location=num.stringValue;
    num=[privacy objectForKey:@"email"];
    _tempUser.hide_email=num.stringValue;
    num=[privacy objectForKey:@"phone"];
    _tempUser.hide_phone=num.stringValue;
    num=[privacy objectForKey:@"website"];
    _tempUser.hide_website=num.stringValue;
    num=[privacy objectForKey:@"facebook"];
    _tempUser.hide_facebook=num.stringValue;
    num=[privacy objectForKey:@"twitter"];
    _tempUser.hide_twitter=num.stringValue;
    num=[privacy objectForKey:@"linkedin"];
    _tempUser.hide_linkedin=num.stringValue;
    num=[privacy objectForKey:@"google"];
    _tempUser.hide_google=num.stringValue;
    num=[privacy objectForKey:@"instagram"];
    _tempUser.hide_instagram=num.stringValue;
   
     _privacyBoolArray= [[NSMutableArray alloc] initWithObjects:_tempUser.hide_global_privacy,_tempUser.hide_location,_tempUser.hide_email,_tempUser.hide_phone,_tempUser.hide_website,_tempUser.hide_facebook,_tempUser.hide_twitter,_tempUser.hide_linkedin, _tempUser.hide_google,_tempUser.hide_instagram, nil];
    
    [_tableview reloadData];
}


- (IBAction)imageviewButtonClick:(id)sender {
    
    
}
- (IBAction)saveButtonClick:(id)sender {
 //   UIButton *button = (UIButton *)sender;
    
    _tempUser.bio= _bioTextview.text;
    _tempUser.name=_nameTextfield.text;
    _tempUser.location=_locationTextfield.text;
    _tempUser.phone=_phoneTextfield.text;
    _tempUser.website=_websiteTextfield.text;
     [[UserManager sharedUserManager] performUpdate:_tempUser ];
    
}

- (void) makeUpdateFinished: (NSNotification * ) note
{
    UIAlertView *alert = [[ UIAlertView alloc ] initWithTitle : @"Update account."
                                                      message : @"Information saved." delegate : nil cancelButtonTitle : @"OK"
                                            otherButtonTitles : nil ];
    [alert show ];
}

-(void)createObservers{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"makeUpdateFinished" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(makeUpdateFinished:) name:@"makeUpdateFinished" object:nil];
}

-(void) getSettingPageItems
{
    
    User *localUser= [[FitmooHelper sharedInstance] getUserLocally];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    

    
    NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:localUser.secret_id, @"secret_id", localUser.auth_token, @"auth_token",nil];
    
    NSString * url= [NSString stringWithFormat: @"%@%@", [[UserManager sharedUserManager] homeFeedUrl],localUser.user_id];
    

    [manager GET:url parameters:jsonDict success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        _responseDic= responseObject;
      
        [self defineSettingObject];
        
        NSLog(@"Submit response data: %@", responseObject);
    } // success callback block
     
         failure:^(AFHTTPRequestOperation *operation, NSError *error){
       
             NSLog(@"Error: %@", error);} // failure callback block
     ];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

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
    [self.bottomView setHidden:true];
    double radio= [[FitmooHelper sharedInstance] frameRadio];
    
     _heightArray= [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithDouble:69*radio],[NSNumber numberWithDouble:143*radio],[NSNumber numberWithDouble:139*radio],[NSNumber numberWithDouble:68*radio],[NSNumber numberWithDouble:74*radio],[NSNumber numberWithDouble:66*radio],[NSNumber numberWithDouble:148*radio], nil];
    [self getSettingPageItems];
    // Do any additional setup after loading the view.
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
    return 7;
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    _tempUser.hide_global_privacy=[privacy objectForKey:@"global_privacy"];
    _tempUser.hide_location=[privacy objectForKey:@"location"];
    _tempUser.hide_email=[privacy objectForKey:@"email"];
    _tempUser.hide_phone=[privacy objectForKey:@"phone"];
    _tempUser.hide_website=[privacy objectForKey:@"website"];
    _tempUser.hide_facebook=[privacy objectForKey:@"facebook"];
    _tempUser.hide_twitter=[privacy objectForKey:@"twitter"];
    _tempUser.hide_linkedin=[privacy objectForKey:@"linkedin"];
    _tempUser.hide_google=[privacy objectForKey:@"google"];
    _tempUser.hide_instagram=[privacy objectForKey:@"instagram"];
    
    
    [_tableview reloadData];
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

//
//  SettingViewController.m
//  fitmoo
//
//  Created by hongjian lin on 5/5/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import "SettingViewController.h"
#import "AFNetworking.h"
@interface SettingViewController ()

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initFrames];
   // [self createObservers];

   // [self.bottomView setHidden:true];
    double radio= [[FitmooHelper sharedInstance] frameRadio];
    
     _heightArray= [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithDouble:50*radio],[NSNumber numberWithDouble:55*radio],[NSNumber numberWithDouble:55*radio],[NSNumber numberWithDouble:50*radio],[NSNumber numberWithDouble:55*radio],[NSNumber numberWithDouble:55*radio],[NSNumber numberWithDouble:55*radio], nil];

    [self getSettingPageItems];
    

     self.tableview.tableFooterView = [[UIView alloc] init];
    // Do any additional setup after loading the view.
}




- (void) initFrames
{

    _tableview.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_tableview respectToSuperFrame:self.view];
    _settingLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_settingLabel respectToSuperFrame:self.view];
    
    _topView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_topView respectToSuperFrame:self.view];
    _backButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_backButton respectToSuperFrame:self.view];
    
    
    
    
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
            cell=[tableView dequeueReusableCellWithIdentifier:@"cell1"];
            
            UILabel *label= (UILabel *)[cell viewWithTag:1];
            label.frame=CGRectMake(20, 10, 200, 30);
            label.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:label respectToSuperFrame:self.view];
            
          
            
            cell.separatorInset = UIEdgeInsetsMake(0.f, cell.bounds.size.width*[[FitmooHelper sharedInstance] frameRadio], 0.f, 0.f);

        }
    }else if (indexPath.row==1) {
        if (cell == nil)
        {
            cell=[tableView dequeueReusableCellWithIdentifier:@"cell2"];
            
            UILabel *label= (UILabel *)[cell viewWithTag:2];
            label.frame=CGRectMake(20, 12, 200, 30);
            label.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:label respectToSuperFrame:self.view];
            
            UIImageView *Image= (UIImageView *)[cell viewWithTag:10];
            Image.frame=CGRectMake(285, 20, 11, 17);
            Image.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:Image respectToSuperFrame:self.view];
        }
        
    }else if (indexPath.row==2) {
        if (cell == nil)
        {
            cell=[tableView dequeueReusableCellWithIdentifier:@"cell3"];
            
            UILabel *label= (UILabel *)[cell viewWithTag:3];
            label.frame=CGRectMake(20, 12, 200, 30);
            label.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:label respectToSuperFrame:self.view];
            cell.separatorInset = UIEdgeInsetsMake(0.f, cell.bounds.size.width*[[FitmooHelper sharedInstance] frameRadio], 0.f, 0.f);
            
            UIImageView *Image= (UIImageView *)[cell viewWithTag:10];
            Image.frame=CGRectMake(285, 20, 11, 17);
            Image.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:Image respectToSuperFrame:self.view];
        }
        
    }else if (indexPath.row==3) {
        if (cell == nil)
        {
            cell=[tableView dequeueReusableCellWithIdentifier:@"cell4"];
            
            UILabel *label= (UILabel *)[cell viewWithTag:4];
            label.frame=CGRectMake(20, 10, 200, 30);
            label.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:label respectToSuperFrame:self.view];
            cell.separatorInset = UIEdgeInsetsMake(0.f, cell.bounds.size.width*[[FitmooHelper sharedInstance] frameRadio], 0.f, 0.f);
        }
        
    }else if (indexPath.row==5) {
        if (cell == nil)
        {
            cell=[tableView dequeueReusableCellWithIdentifier:@"cell5"];
            
            UILabel *label= (UILabel *)[cell viewWithTag:5];
            label.frame=CGRectMake(20, 12, 200, 30);
            label.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:label respectToSuperFrame:self.view];
            
            UIImageView *Image= (UIImageView *)[cell viewWithTag:10];
            Image.frame=CGRectMake(285, 20, 11, 17);
            Image.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:Image respectToSuperFrame:self.view];
        }
        
    }else if (indexPath.row==6) {
        if (cell == nil)
        {
            cell=[tableView dequeueReusableCellWithIdentifier:@"cell6"];
            
            UILabel *label= (UILabel *)[cell viewWithTag:6];
            label.frame=CGRectMake(20, 12, 200, 30);
            label.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:label respectToSuperFrame:self.view];
            cell.separatorInset = UIEdgeInsetsMake(0.f, cell.bounds.size.width*[[FitmooHelper sharedInstance] frameRadio], 0.f, 0.f);
            
            UIImageView *Image= (UIImageView *)[cell viewWithTag:10];
            Image.frame=CGRectMake(285, 20, 11, 17);
            Image.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:Image respectToSuperFrame:self.view];
        }
        
    }else if (indexPath.row==4) {
        if (cell == nil)
        {
            cell=[tableView dequeueReusableCellWithIdentifier:@"cell7"];
            
            UILabel *label= (UILabel *)[cell viewWithTag:5];
            label.frame=CGRectMake(20, 12, 200, 30);
            label.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:label respectToSuperFrame:self.view];
            
            UIImageView *Image= (UIImageView *)[cell viewWithTag:10];
            Image.frame=CGRectMake(285, 20, 11, 17);
            Image.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:Image respectToSuperFrame:self.view];
        }
        
    }
    
   
    
    return cell;
}



- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row==1) {
        AcountViewController *acountPage = [[self storyboard] instantiateViewControllerWithIdentifier:@"AcountViewController"];
        acountPage.tempUser=self.tempUser;
        acountPage.tabletype=@"setting";
        [self.navigationController pushViewController:acountPage animated:YES];

    }else if (indexPath.row==2) {
        AcountViewController *acountPage = [[self storyboard] instantiateViewControllerWithIdentifier:@"AcountViewController"];
        acountPage.tempUser=self.tempUser;
        acountPage.tabletype=@"privacy";
        [self.navigationController pushViewController:acountPage animated:YES];
        
    }else if (indexPath.row==4) {
       
        SettingWebViewController *webPage = [[self storyboard] instantiateViewControllerWithIdentifier:@"SettingWebViewController"];
        webPage.webviewLink=@"http://about.fitmoo.com/privacy-policy";
        webPage.settingType= @"PRIVACY POLICY";
        [self.navigationController pushViewController:webPage animated:YES];
        
    //    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://about.fitmoo.com/privacy-policy"]];
    }
    else if (indexPath.row==5) {
        SettingWebViewController *webPage = [[self storyboard] instantiateViewControllerWithIdentifier:@"SettingWebViewController"];
        webPage.webviewLink=@"http://about.fitmoo.com/terms-and-conditions";
        webPage.settingType= @"TERMS";
        [self.navigationController pushViewController:webPage animated:YES];
   //     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://about.fitmoo.com/terms-and-conditions"]];
    }else if (indexPath.row==6) {
        SettingWebViewController *webPage = [[self storyboard] instantiateViewControllerWithIdentifier:@"SettingWebViewController"];
        webPage.webviewLink=@"http://about.fitmoo.com";
        webPage.settingType= @"ABOUT";
        [self.navigationController pushViewController:webPage animated:YES];
    //    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://about.fitmoo.com"]];
    }
    
}



// multy high table cell
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{

    NSNumber * height=(NSNumber *) [_heightArray objectAtIndex:indexPath.row];
    return  height.integerValue;
}

- (void) defineSettingObject
{
    _tempUser= [[User alloc] init];
    
    _tempUser.name= [_responseDic objectForKey:@"full_name"];
    _tempUser.email= [_responseDic objectForKey:@"email"];
    _tempUser.user_id= [_responseDic objectForKey:@"id"];
    NSDictionary *profile= [_responseDic objectForKey:@"profile"];
    
    NSDictionary *avatars= [profile objectForKey:@"avatars"];
    _tempUser.profile_avatar_thumb=[avatars objectForKey:@"thumb"];
    _tempUser.profile_avatar_original=[avatars objectForKey:@"original"];
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
    

}




//- (void) makeUpdateFinished: (NSNotification * ) note
//{
//    UIAlertView *alert = [[ UIAlertView alloc ] initWithTitle : @"Update account."
//                                                      message : @"Information saved." delegate : nil cancelButtonTitle : @"OK"
//                                            otherButtonTitles : nil ];
//    [alert show ];
//}
//
//-(void)createObservers{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"makeUpdateFinished" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(makeUpdateFinished:) name:@"makeUpdateFinished" object:nil];
//}

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

- (IBAction)backButtonClick:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"swipeHandler" object:Nil];
}
@end

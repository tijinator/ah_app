//
//  SearchViewController.m
//  fitmoo
//
//  Created by hongjian lin on 4/17/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController ()

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initFrames];
    _Category=@"All";
    _category=@"";
    _searchterm=@"";
    [self.bottomView setHidden:true];
    // Do any additional setup after loading the view.
}

-(void)viewWillDisappear:(BOOL)animated
{
    
}

- (void) initFrames
{
    _tableview.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_tableview respectToSuperFrame:self.view];
    _leftButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_leftButton respectToSuperFrame:self.view];
    _rightButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_rightButton respectToSuperFrame:self.view];
    _headerView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_headerView respectToSuperFrame:self.view];
    _titleLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_titleLabel respectToSuperFrame:self.view];
    _pickerView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_pickerView respectToSuperFrame:self.view];
    _doneButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_doneButton respectToSuperFrame:self.view];
    _pickerview.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_pickerview respectToSuperFrame:self.view];

}

-(void) parseResponseDic: (NSString *) category
{
  
    NSDictionary *resultArray= [_responseDic objectForKey:@"results"];
    
    if ([category isEqualToString:@"People"]) {
        for (NSDictionary * result in resultArray) {
            User *tempUser= [[User alloc]  init];
            NSNumber * following=[result objectForKey:@"following"];
            tempUser.following= [following stringValue];
            NSNumber * followers=[result objectForKey:@"followers"];
            tempUser.followers= [followers stringValue];
            NSNumber * communities=[result objectForKey:@"communities"];
            tempUser.communities= [communities stringValue];
            
            NSDictionary * profile=[result objectForKey:@"profile"];
            tempUser.cover_photo_url=[profile objectForKey:@"cover_photo_url"];
            NSDictionary *avatar=[profile objectForKey:@"avatars"];
            tempUser.profile_avatar_thumb=[avatar objectForKey:@"thumb"];
            tempUser.name= [result objectForKey:@"full_name"];
            NSNumber * user_id=[result objectForKey:@"id"];
            tempUser.user_id= [user_id stringValue];
            
              [_searchArrayPeople addObject:tempUser];
        }

      
    }else if ([category isEqualToString:@"Communities"]) {
          for (NSDictionary * result in resultArray) {
            CreatedByCommunity *tempCommunity= [[CreatedByCommunity alloc]  init];
              NSNumber * com_id=[result objectForKey:@"id"];
              tempCommunity.created_by_community_id= [com_id stringValue];
              tempCommunity.name= [result objectForKey:@"name"];
              
              NSString *cover_photo_url=[result objectForKey:@"cover_photo_url"];
              if ([cover_photo_url isEqual:[NSNull null ]]) {
                  cover_photo_url= @"https://fitmoo.com/assets/group/cover-default.png";
              }
              tempCommunity.cover_photo_url= cover_photo_url;
              
              NSNumber * joiners_count=[result objectForKey:@"joiners_count"];
              tempCommunity.joiners_count=[joiners_count stringValue];
              NSNumber * is_member=[result objectForKey:@"is_member"];
              tempCommunity.is_member=[is_member stringValue];
              NSNumber * is_owner=[result objectForKey:@"is_owner"];
              tempCommunity.is_owner=[is_owner stringValue];
              
              [_searchArrayCommunitiess addObject:tempCommunity];
          }
    }

    
       [_tableview reloadData];
  
    
}



- (void) getSearchItemForPeople
{
      User *localUser= [[FitmooHelper sharedInstance] getUserLocally];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    
    NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:localUser.secret_id, @"secret_id", localUser.auth_token, @"auth_token",@"true", @"mobile",@"people", @"c",_searchTermField.text, @"q",@"10", @"limit",nil];
    NSString *url= [NSString stringWithFormat:@"%@%@",[[UserManager sharedUserManager] clientUrl],@"/api/global/search"];
    [manager GET: url parameters:jsonDict success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        _responseDic= responseObject;
        
        [self parseResponseDic:@"People"];
        
        if([_Category isEqualToString:@"All"])
        {
            [self getSearchItemForCommunity];
        }
    } // success callback block
     
         failure:^(AFHTTPRequestOperation *operation, NSError *error){
             NSLog(@"Error: %@", error);} // failure callback block
     ];

}

- (void) getSearchItemForCommunity
{
    User *localUser= [[FitmooHelper sharedInstance] getUserLocally];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    
    NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:localUser.secret_id, @"secret_id", localUser.auth_token, @"auth_token",@"true", @"mobile",@"communities", @"c",_searchTermField.text, @"q",@"10", @"limit",nil];
    NSString *url= [NSString stringWithFormat:@"%@%@",[[UserManager sharedUserManager] clientUrl],@"/api/global/search"];
    [manager GET: url parameters:jsonDict success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        _responseDic= responseObject;
        [self parseResponseDic:@"Communities"];
        
    } // success callback block
     
         failure:^(AFHTTPRequestOperation *operation, NSError *error){
             NSLog(@"Error: %@", error);} // failure callback block
     ];
    
    
}


#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([_category isEqualToString:@"all"]) {
        return 3;
    }else if ([_category isEqualToString:@"people"]) {
        return 2;
    }else if ([_category isEqualToString:@"communities"]) {
        return 2;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    
    if (section==0)
    {
        return 2;
    }
    else if (section==1){
        if ([_Category isEqualToString:@"People"]||[_Category isEqualToString:@"All"]) {
            return [_searchArrayPeople count];
        }else
        {
            return [_searchArrayCommunitiess count];
        }
       
    }else
    {
         return [_searchArrayCommunitiess count];
    }

    
}


- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
        return 1.0f;
    return 18.0f;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return nil;
    }
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
    /* Create custom view to display section header... */
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width, 18)];
    [label setFont:[UIFont boldSystemFontOfSize:12]];
    NSString *string;
    if (section==1) {
        if ([_Category isEqualToString:@"People"]||[_Category isEqualToString:@"All"]) {
            string= @"People";
        }else
        {
        string= @"Communities";
        }
    }else if (section ==2)
    {
         string= @"Communities";
    }
   
    /* Section header is in 0th index... */
    [label setText:string];
    [view addSubview:label];
    [view setBackgroundColor:[UIColor colorWithRed:166/255.0 green:177/255.0 blue:186/255.0 alpha:1.0]]; //your background color...
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     UITableViewCell * cell=  [self.tableview cellForRowAtIndexPath:indexPath];
    
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            if (cell == nil) {
                cell=[tableView dequeueReusableCellWithIdentifier:@"searchCell"];
                UIButton * searchButton=(UIButton *) [cell viewWithTag:2];
                searchButton.frame= CGRectMake(280, 16, 25, 25);
                searchButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:searchButton respectToSuperFrame:self.view];
                [searchButton addTarget:self action:@selector(searchButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                UITextField *searchBar=(UITextField *) [cell viewWithTag:1];
                searchBar.frame= CGRectMake(20, 14, 247, 30);
                searchBar.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:searchBar respectToSuperFrame:self.view];
                _searchTermField=searchBar;
                
            }
            
            
            return cell;
        }else if (indexPath.row==1) {
            if (cell == nil) {
                cell=[tableView dequeueReusableCellWithIdentifier:@"searchForCell"];
                UILabel *searchFor=(UILabel *) [cell viewWithTag:3];
                searchFor.frame= CGRectMake(19, 8, 115, 37);
                searchFor.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:searchFor respectToSuperFrame:self.view];
                UILabel *category=(UILabel *) [cell viewWithTag:4];
                category.frame= CGRectMake(231, 13, 68, 31);
                category.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:category respectToSuperFrame:self.view];
                category.text=_Category;
            }
            return cell;
        }

    }else
    {
        if (cell == nil)
        {
            cell=[tableView dequeueReusableCellWithIdentifier:@"resultCell"];
        }
        
        UIImageView *imageview=(UIImageView *) [cell viewWithTag:5];
        imageview.frame= CGRectMake(15, 15, 30, 30);
        imageview.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:imageview respectToSuperFrame:self.view];
        UILabel *nameLabel=(UILabel *) [cell viewWithTag:6];
        nameLabel.frame= CGRectMake(58, 20, 230, 21);
        nameLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:nameLabel respectToSuperFrame:self.view];
        
        
        
      
        if (indexPath.section==1) {
            if ([_Category isEqualToString:@"People"]||[_Category isEqualToString:@"All"]) {
                User *temUser= [_searchArrayPeople objectAtIndex:indexPath.row];
                nameLabel.text= temUser.name;
                AsyncImageView *userImage = [[AsyncImageView alloc] init];
                [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:userImage];
                userImage.imageURL =[NSURL URLWithString:temUser.profile_avatar_thumb];
                imageview.image= userImage.image;
            }else
            {
                CreatedByCommunity *temCom= [_searchArrayCommunitiess objectAtIndex:indexPath.row];
                nameLabel.text= temCom.name;
                AsyncImageView *comImage = [[AsyncImageView alloc] init];
                [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:comImage];
                comImage.imageURL =[NSURL URLWithString:temCom.cover_photo_url];
                imageview.image= comImage.image;
            }
            

            
        }else
        {
            CreatedByCommunity *temCom= [_searchArrayCommunitiess objectAtIndex:indexPath.row];
            nameLabel.text= temCom.name;
            AsyncImageView *comImage = [[AsyncImageView alloc] init];
            [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:comImage];
            comImage.imageURL =[NSURL URLWithString:temCom.cover_photo_url];
            imageview.image= comImage.image;
        }
        
        
        
        
    }
    
       return cell;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        if (indexPath.row==1) {
          
            
            _pickerView.hidden=false;
        }
    }else if (indexPath.section==1) {
        
        if ([_Category isEqualToString:@"People"]||[_Category isEqualToString:@"All"]) {
          
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            PeoplePageViewController *searchPeoplePage = [mainStoryboard instantiateViewControllerWithIdentifier:@"PeoplePageViewController"];
            User *temUser= [_searchArrayPeople objectAtIndex:indexPath.row];
            searchPeoplePage.searchId=temUser.user_id;
            searchPeoplePage.temSearchUser=temUser;
            [self.navigationController presentViewController:searchPeoplePage animated:YES completion:nil];
        }else
        {
            
        }
        
    }else if (indexPath.section==2)
    {
        
    }
    
    
}

// multy high table cell
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    double Radio= self.view.frame.size.width / 320;
    
    return 50*Radio;
}


- (IBAction)searchButtonClick:(id)sender {
    _searchArrayPeople= [[NSMutableArray alloc] init];
    _searchArrayCommunitiess= [[NSMutableArray alloc] init];
    
    if ([_Category isEqualToString:@"People"]) {
        [self getSearchItemForPeople];
        _category=@"people";
    }else if ([_Category isEqualToString:@"Communities"])
    {
        [self getSearchItemForCommunity];
        _category=@"communities";
    }else
    {
        [self getSearchItemForPeople];
        _category=@"all";
    }
    
  
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
   
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UIPickerViewDelegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
    if (row==0) {
        _Category= @"All";
        _category= @"all";
    }else if (row==1)
    {
       _Category=@"People";
       _category=@"people";
    }else if (row==2)
    {
        _Category=@"Communities";
        _category=@"communities";
    }

    
    // Handle the selection
}

// tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSUInteger numRows = 3;
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
        title=@"All";
    }else if (row==1)
    {
        title=@"People";
    }else if (row==2)
    {
        title=@"Communities";
    }
    
    return title;
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

- (IBAction)doneButtonClick:(id)sender {
    
    _pickerView.hidden=true;
    
    if (![_searchTermField.text isEqualToString:@""]) {
        _searchArrayPeople= [[NSMutableArray alloc] init];
        _searchArrayCommunitiess= [[NSMutableArray alloc] init];
        
        if ([_Category isEqualToString:@"People"]) {
            [self getSearchItemForPeople];
        }else if ([_Category isEqualToString:@"Communities"])
        {
            [self getSearchItemForCommunity];
        }else
        {
            [self getSearchItemForPeople];
        }

    }else
    {
    
        [_tableview reloadData];
    }
  
}
@end

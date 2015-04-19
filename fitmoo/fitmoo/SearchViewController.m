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
    _category=@"all";
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


- (void) getSearchItem
{
      User *localUser= [[FitmooHelper sharedInstance] getUserLocally];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    
    NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:localUser.secret_id, @"secret_id", localUser.auth_token, @"auth_token",@"true", @"mobile",_category, @"c",_searchTermField.text, @"q",@"10", @"limit",nil];
    NSString *url= [NSString stringWithFormat:@"%@%@",[[UserManager sharedUserManager] clientUrl],@"/api/global/search"];
    [manager GET: url parameters:jsonDict success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        _responseDic= responseObject;
        
        
    } // success callback block
     
         failure:^(AFHTTPRequestOperation *operation, NSError *error){
             NSLog(@"Error: %@", error);} // failure callback block
     ];
    

}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    
    return [_searchArray count]+2;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     UITableViewCell * cell=  [self.tableview cellForRowAtIndexPath:indexPath];
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
    
    
  
    if (cell == nil)
    {
         cell=[tableView dequeueReusableCellWithIdentifier:@"resultCell"];
    }
    
    
       return cell;
}

- (IBAction)searchButtonClick:(id)sender {
    
    [self getSearchItem];
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


- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row==1) {
  //    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"searchForCell"];
  //    UILabel *category=(UILabel *) [cell viewWithTag:4];
      
        _pickerView.hidden=false;
    }

    
}

// multy high table cell
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
     double Radio= self.view.frame.size.width / 320;
    
    return 50*Radio;
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
    [_tableview reloadData];
  
}
@end

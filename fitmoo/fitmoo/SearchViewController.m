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
    // Do any additional setup after loading the view.
}

- (void) initFrames
{
    _tableview.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_tableview respectToSuperFrame:self.view];
    _leftButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_leftButton respectToSuperFrame:self.view];
    _rightButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_rightButton respectToSuperFrame:self.view];
    _headerView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_headerView respectToSuperFrame:self.view];
    _titleLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_titleLabel respectToSuperFrame:self.view];

}


- (void) getSearchItem
{
      User *localUser= [[FitmooHelper sharedInstance] getUserLocally];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    
    NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:localUser.secret_id, @"secret_id", localUser.auth_token, @"auth_token",@"true", @"mobile",@"people", @"c",@"h", @"q",nil];
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
        cell=[tableView dequeueReusableCellWithIdentifier:@"searchCell"];
        UIButton * searchButton=(UIButton *) [cell viewWithTag:2];
        searchButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:searchButton respectToSuperFrame:self.view];
        [searchButton addTarget:self action:@selector(searchButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        UITextField *searchBar=(UITextField *) [cell viewWithTag:1];
        
        searchBar.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:searchBar respectToSuperFrame:self.view];
        
        return cell;
    }else if (indexPath.row==1) {
        cell=[tableView dequeueReusableCellWithIdentifier:@"searchForCell"];
        UILabel *searchFor=(UILabel *) [cell viewWithTag:3];
        searchFor.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:searchFor respectToSuperFrame:self.view];
        UILabel *category=(UILabel *) [cell viewWithTag:4];
        category.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:category respectToSuperFrame:self.view];
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

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row==1) {
      UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"searchForCell"];
      UILabel *category=(UILabel *) [cell viewWithTag:4];
      
      
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

@end

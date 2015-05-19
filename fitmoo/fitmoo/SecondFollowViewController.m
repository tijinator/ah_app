//
//  SecondFollowViewController.m
//  fitmoo
//
//  Created by hongjian lin on 5/19/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import "SecondFollowViewController.h"

@interface SecondFollowViewController ()

@end

@implementation SecondFollowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initFrames];
    [self getdiscoverItemForPeople];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    
    return [_searchArrayPeople count];
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    

    FollowCell *cell =(FollowCell *) [self.tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FollowCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }else
    {
        return cell;
    }
    
 
    return cell;
}


- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
}

//- (CGFloat)tableView:(UITableView *)tableView
//estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSNumber *height;
// 
//    return height.integerValue;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
//{
//    
//    NSNumber *height;
//
//    return height.integerValue;
//}


- (void) getdiscoverItemForPeople
{
    User *localUser= [[FitmooHelper sharedInstance] getUserLocally];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    
    NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:localUser.secret_id, @"secret_id", localUser.auth_token, @"auth_token",nil];
    NSString *url= [NSString stringWithFormat:@"%@%@%@%@",[[UserManager sharedUserManager] clientUrl],@"/api/interests/",_searchId,@"/associated_ambassadors"];
    [manager GET: url parameters:jsonDict success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        _responseDic= responseObject;
        
        [self parseResponseDicDiscover];
        
        
    } // success callback block
     
         failure:^(AFHTTPRequestOperation *operation, NSError *error){
             NSLog(@"Error: %@", error);} // failure callback block
     ];
    
}

-(void) parseResponseDicDiscover
{
    _searchArrayPeople= [[NSMutableArray alloc] init];
    
    for (NSDictionary * result in _responseDic) {
        User *tempUser= [[User alloc]  init];
        NSNumber * following=[result objectForKey:@"is_following"];
        tempUser.is_following= [following stringValue];
        //  NSNumber * followers=[result objectForKey:@"followers"];
        tempUser.followers= [result objectForKey:@"followers"];
        
        
        NSDictionary * profile=[result objectForKey:@"profile"];
        NSDictionary *avatar=[profile objectForKey:@"avatars"];
        tempUser.profile_avatar_thumb=[avatar objectForKey:@"thumb"];
        
        tempUser.name= [result objectForKey:@"full_name"];
        NSNumber * user_id=[result objectForKey:@"id"];
        tempUser.user_id= [user_id stringValue];
        
        [_searchArrayPeople addObject:tempUser];
    }
    [self.tableView reloadData];
    
}
- (void) initFrames
{
    double radio= self.view.frame.size.width/320;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(120*radio, 225*radio)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];

    

    _leftButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_leftButton respectToSuperFrame:self.view];
    _headerView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_headerView respectToSuperFrame:self.view];
    _titleLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_titleLabel respectToSuperFrame:self.view];

    _tableView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_tableView respectToSuperFrame:self.view];

    
}

- (IBAction)backButtonClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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

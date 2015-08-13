//
//  InfluFactorViewController.m
//  fitmoo
//
//  Created by hongjian lin on 8/13/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import "InfluFactorViewController.h"
#import "FollowLeaderBoardCell.h"
#import "InfluenceCell.h"
#import "AFNetworking.h"
#import "UserManager.h"
@interface InfluFactorViewController ()
{
    NSNumber * contentHight;
    UIView *indicatorView;
    User * tempUser1;
    UIButton *tempButton1;
    NSString *searchPeopleName;
  
}
@end

@implementation InfluFactorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initFrames];
    

    
    contentHight=[NSNumber numberWithInteger:270*[[FitmooHelper sharedInstance] frameRadio]];
    _heighArray= [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithDouble: 380*[[FitmooHelper sharedInstance] frameRadio]],contentHight,contentHight,contentHight,contentHight,contentHight,contentHight,contentHight,contentHight,contentHight, nil];
    
    [self getAlldiscoverBulk];
    // Do any additional setup after loading the view.
}

- (void) viewWillAppear:(BOOL)animated
{
    [FitmooHelper sharedInstance].firstTimeLoadingCircle1=0;
    [FitmooHelper sharedInstance].firstTimeLoadingCircle2=0;
    [FitmooHelper sharedInstance].firstTimeLoadingCircle3=0;
    [FitmooHelper sharedInstance].firstTimeLoadingCircle4=0;
  
}


-(void) parseResponseBulk
{

        _searchArrayLeader= [[NSMutableArray alloc] init];
        NSDictionary *bulk= [_responseDic2 objectForKey:@"leaders"];
        for (NSDictionary *leader in bulk) {
            User *temUser= [[User alloc] init];
            temUser.name= [leader objectForKey:@"full_name"];
            
            NSNumber *days_a_week= [leader objectForKey:@"days_a_week"];
            temUser.days_a_week= [days_a_week stringValue];
            
            NSNumber *workout_count= [leader objectForKey:@"workout_count"];
            temUser.workout_count= [workout_count stringValue];
            NSNumber *user_id= [leader objectForKey:@"id"];
            temUser.user_id=[user_id stringValue];
            
            NSNumber *nutrition_count= [leader objectForKey:@"nutrition_count"];
            temUser.nutrition_count= [nutrition_count stringValue];
            
            NSDictionary *profile= [leader objectForKey:@"profile"];
            
            NSDictionary *avatars= [profile objectForKey:@"avatars"];
            temUser.profile_avatar_thumb= [avatars objectForKey:@"thumb"];
            [_searchArrayLeader addObject:temUser];
            
        }
    
    
    [self.tableView reloadData];
}



- (void) getAlldiscoverBulk
{
   indicatorView= [[FitmooHelper sharedInstance] addActivityIndicatorView:indicatorView and:self.view];
    self.tableView.userInteractionEnabled=false;
    User *localUser= [[FitmooHelper sharedInstance] getUserLocally];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    
    NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:localUser.secret_id, @"secret_id", localUser.auth_token, @"auth_token", nil];
    NSString *url= [NSString stringWithFormat:@"%@%@",[[UserManager sharedUserManager] clientUrl],@"/api/discover/app_search_bulk"];
    
    
    [manager GET: url parameters:jsonDict success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        _responseDic2= responseObject;
        [self parseResponseBulk];
        
        self.tableView.userInteractionEnabled=true;
        [indicatorView removeFromSuperview];
        
    } // success callback block
     
         failure:^(AFHTTPRequestOperation *operation, NSError *error){
             NSLog(@"Error: %@", error);
             self.tableView.userInteractionEnabled=true;
             [indicatorView removeFromSuperview];
         } // failure callback block
     
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
    
    int count=1+(int)[_searchArrayLeader count];
    return count;
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    

    if (indexPath.row==0) {
        
        InfluenceCell *cell =(InfluenceCell *) [self.tableView cellForRowAtIndexPath:indexPath];
        if (cell==nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"InfluenceCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        cell.bodyButton1.text= _influence_factor;
        if (_search_name!=nil) {
            cell.bodyLabel1.text=@"THE INFLUENCE FACTOR IS";
        }
        
        contentHight=[NSNumber numberWithDouble:460*[[FitmooHelper sharedInstance]frameRadio]];
        [_heighArray replaceObjectAtIndex:0 withObject:contentHight];
        return cell;
    }
    
    
    FollowLeaderBoardCell *cell =(FollowLeaderBoardCell *) [self.tableView cellForRowAtIndexPath:indexPath];
    if (cell==nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FollowLeaderBoardCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    //   NSNumber *index= [NSNumber num];
    User *tempUser= [_searchArrayLeader objectAtIndex:(indexPath.row-1)];
    cell.tempUser= tempUser;
    
    [cell buildCell];
    cell.CountLabel.text=[NSString stringWithFormat:@"%ld",(long)indexPath.row];
    
    contentHight=[NSNumber numberWithDouble:75*[[FitmooHelper sharedInstance] frameRadio]];
    if (indexPath.row>=[_heighArray count]) {
        [_heighArray addObject:contentHight];
    }else
    {
        [_heighArray replaceObjectAtIndex:indexPath.row withObject:contentHight];
    }
    
    
    return cell;
    
}


- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row>0)
    {
        
        User *tempUser= [_searchArrayLeader objectAtIndex:(indexPath.row-1)];
        NSString* key=[NSString stringWithFormat:@"%ld", (long)tempUser.user_id.intValue+100];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"leftSideMenuAction" object:key];
        
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView
estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSNumber *height;
    if (indexPath.row<[_heighArray count]) {
        height= (NSNumber *)[_heighArray objectAtIndex:indexPath.row];
        
    }else
    {
        height=[NSNumber numberWithDouble:270*[[FitmooHelper sharedInstance] frameRadio]];
    }
    NSLog(@"%ld",(long)height.integerValue);
    return height.integerValue;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    NSNumber *height;
    if (indexPath.row<[_heighArray count]) {
        height= (NSNumber *)[_heighArray objectAtIndex:indexPath.row];
        
    }else
    {
        height=[NSNumber numberWithInt:contentHight.doubleValue];
    }
    return height.doubleValue;
    
}

- (void) initFrames
{

    _backButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_backButton respectToSuperFrame:self.view];
    _topView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_topView respectToSuperFrame:self.view];
    _titleLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_titleLabel respectToSuperFrame:self.view];
    
    _infoButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_infoButton respectToSuperFrame:self.view];
    
    _view1.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_view1 respectToSuperFrame:self.view];
    _view2.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_view2 respectToSuperFrame:self.view];
    _view3.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_view3 respectToSuperFrame:self.view];
    _okButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_okButton respectToSuperFrame:self.view];
    _infoLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_infoLabel respectToSuperFrame:self.view];
    _view1.hidden=true;


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

- (IBAction)backButtonClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)InfoButtonClick:(id)sender {
    
    _view1.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    _view1.hidden=false;
    _backButton.hidden=true;
    _infoButton.hidden=true;
    
    [self.view bringSubviewToFront:_view1];
    
}
- (IBAction)okButtomClick:(id)sender {
    _view1.hidden=true;
    _backButton.hidden=false;
    _infoButton.hidden=false;
}
@end

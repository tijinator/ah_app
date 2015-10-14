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
#import <SwipeBack/SwipeBack.h>
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
    
    [FitmooHelper sharedInstance].firstTimeLoadingCircle1=0;
    [FitmooHelper sharedInstance].firstTimeLoadingCircle2=0;
    [FitmooHelper sharedInstance].firstTimeLoadingCircle3=0;
    [FitmooHelper sharedInstance].firstTimeLoadingCircle4=0;
    
    contentHight=[NSNumber numberWithInteger:270*[[FitmooHelper sharedInstance] frameRadio]];
    _heighArray= [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithDouble: 380*[[FitmooHelper sharedInstance] frameRadio]],contentHight,contentHight,contentHight,contentHight,contentHight,contentHight,contentHight,contentHight,contentHight, nil];
    
    [self getAlldiscoverBulk];
    self.navigationController.swipeBackEnabled = YES;
    // Do any additional setup after loading the view.
}




-(void) parseResponseBulk
{

        _searchArrayLeader= [[NSMutableArray alloc] init];
    //    NSDictionary *bulk= [_responseDic2 objectForKey:@"leaders"];
        for (NSDictionary *leader in _responseDic2) {
            @try {
                
           
            
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
            @catch (NSException *exception) {
                
            }
            @finally {
                
            }
            
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
    
    
    NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:localUser.secret_id, @"secret_id", localUser.auth_token, @"auth_token",@"true", @"mobile", nil];
    NSString *url= [NSString stringWithFormat:@"%@%@",[[UserManager sharedUserManager] clientUrl],@"/api/discover/app_search_only_leaders"];
    
    
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

- (void) viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openInvite:) name:@"openInvite" object:nil];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"openInvite" object:nil];
}

- (void) openInvite: (NSNotification * ) note
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    InviteViewController * inviteView = [mainStoryboard instantiateViewControllerWithIdentifier:@"InviteViewController"];
    [self.navigationController pushViewController:inviteView animated:YES];
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
        cell.bodyButton2.text=[NSString stringWithFormat:@"%0.00f",[_profile_factor_status floatValue]];
        cell.bodyButton3.text=[NSString stringWithFormat:@"%0.00f",[_posts_factor_status floatValue]];
        cell.bodyButton4.text=[NSString stringWithFormat:@"%0.00f",[_follower_factor_status floatValue]];
        
        UITapGestureRecognizer *tapGestureRecognizer6 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(InviteButtonClick:)];
        tapGestureRecognizer6.numberOfTapsRequired = 1;
        [cell.bodyLabel7 addGestureRecognizer:tapGestureRecognizer6];
        cell.bodyLabel7.userInteractionEnabled=YES;
        
        UITapGestureRecognizer *tapGestureRecognizer5 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(WorkoutButtonClick:)];
        tapGestureRecognizer5.numberOfTapsRequired = 1;
        [cell.bodyLabel5 addGestureRecognizer:tapGestureRecognizer5];
        cell.bodyLabel5.userInteractionEnabled=YES;
        
        UITapGestureRecognizer *tapGestureRecognizer4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ProfileButtonClick:)];
        tapGestureRecognizer4.numberOfTapsRequired = 1;
        [cell.bodyLabel3 addGestureRecognizer:tapGestureRecognizer4];
        cell.bodyLabel3.userInteractionEnabled=YES;
        
        
        UITapGestureRecognizer *tapGestureRecognizer3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(InviteButtonClick:)];
        tapGestureRecognizer3.numberOfTapsRequired = 1;
        [cell.bodyButton4 addGestureRecognizer:tapGestureRecognizer3];
        cell.bodyButton4.userInteractionEnabled=YES;
        
        UITapGestureRecognizer *tapGestureRecognizer2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(WorkoutButtonClick:)];
        tapGestureRecognizer2.numberOfTapsRequired = 1;
        [cell.bodyButton3 addGestureRecognizer:tapGestureRecognizer2];
        cell.bodyButton3.userInteractionEnabled=YES;
        
        UITapGestureRecognizer *tapGestureRecognizer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ProfileButtonClick:)];
        tapGestureRecognizer1.numberOfTapsRequired = 1;
        [cell.bodyButton2 addGestureRecognizer:tapGestureRecognizer1];
        cell.bodyButton2.userInteractionEnabled=YES;
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(InfoButtonClick:)];
        tapGestureRecognizer.numberOfTapsRequired = 1;
        [cell.bodyButton1 addGestureRecognizer:tapGestureRecognizer];
        cell.bodyButton1.userInteractionEnabled=YES;

        
        if (_search_name!=nil) {
            NSArray * Name= [_search_name componentsSeparatedByString:@" "];
            NSString * firstName=[Name objectAtIndex:0];
            
            if(firstName.length>10)
            {
            cell.bodyLabel1.text=@"THE INFLUENCE FACTOR IS";
            }else
            {
                cell.bodyLabel1.text= [NSString stringWithFormat:@"%@%@",firstName.uppercaseString,@"'S INFLUENCE FACTOR IS"];
            }
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
    if (indexPath.row==0+(int)[_searchArrayLeader count]) {
        contentHight=[NSNumber numberWithDouble:165*[[FitmooHelper sharedInstance] frameRadio]];
    }
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

- (IBAction)InviteButtonClick:(id)sender {
    
//    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    InviteViewController * inviteView = [mainStoryboard instantiateViewControllerWithIdentifier:@"InviteViewController"];
//    
//    [self.navigationController pushViewController:inviteView animated:YES];
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ActionSheetViewController *ActionSheet = [mainStoryboard instantiateViewControllerWithIdentifier:@"ActionSheetViewController"];
    ActionSheet.action=@"invite";
    User *temUser;
    
    temUser= [[UserManager sharedUserManager] localUser];
    
    ActionSheet.ShareTitle=@"Follow me on Fitmoo.";
    ActionSheet.shareImage=temUser.profile_avatar_original_image.image;
    ActionSheet.profileId= temUser.user_id;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"openPopup" object:ActionSheet];

    
}

- (void) presentCameraView
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    _overlay = [mainStoryboard instantiateViewControllerWithIdentifier:@"CameraViewController"];
    
    CGRect windowFrame = _overlay.view.frame;
    if (windowFrame.origin.y!=0) {
        windowFrame.size.height=windowFrame.size.height+windowFrame.origin.y;
        windowFrame.origin.y=0;
        _overlay.view.frame=windowFrame;
    }
    
    _picker = [[UIImagePickerController alloc] init];
    _picker.allowsEditing = NO;
    
    _picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.picker.showsCameraControls = NO;
    self.picker.navigationBarHidden = YES;
    self.picker.toolbarHidden = YES;
    
    self.overlay.picker = self.picker;
    
    [self.picker.view addSubview:self.overlay.view];
    self.picker.delegate = self.overlay;
    
    [self presentViewController:_picker animated:YES completion:NULL];
    

}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
    if (buttonIndex == 1)
    {
        
        [self presentCameraView];
        
    }
    
    
}


- (IBAction)WorkoutButtonClick:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@""
                                                   message:@"Would you like to leave this page and post something?"
                                                  delegate:self
                                         cancelButtonTitle:@"No"
                                         otherButtonTitles:@"Yes",nil];
    [alert show];
    
    
    [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:@"HasSeenPopup"];
   
    
}

- (IBAction)ProfileButtonClick:(id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"leftSideMenuAction" object:@"settings"];
    
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

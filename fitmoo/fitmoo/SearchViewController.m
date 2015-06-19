//
//  SearchViewController.m
//  fitmoo
//
//  Created by hongjian lin on 4/17/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import "SearchViewController.h"
#import "AFNetworking.h"
@interface SearchViewController ()
{
    User * tempUser1;
    UIButton *tempButton1;
}
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initFrames];
    [self initValuable];
    _searchArrayPeople= [[NSMutableArray alloc] init];
    _tableview.separatorStyle= UITableViewCellSeparatorStyleNone;
    [self.bottomView setHidden:true];
    [self.subBottomView setHidden:true];
    // Do any additional setup after loading the view.
}



-(void) parseResponseDicDiscover: (NSString *) category
{
    
    NSDictionary *resultArray= [_responseDic objectForKey:@"all"];
    
   
        for (NSDictionary * result in resultArray) {
            User *tempUser= [[User alloc]  init];
            NSNumber * following=[result objectForKey:@"is_following"];
            tempUser.is_following= [following stringValue];
            NSNumber * followers=[result objectForKey:@"followers"];
            tempUser.followers= [followers stringValue];
           
            
            NSDictionary * profile=[result objectForKey:@"profile"];
            NSDictionary *avatar=[profile objectForKey:@"avatars"];
            tempUser.profile_avatar_thumb=[avatar objectForKey:@"thumb"];
            
            tempUser.name= [result objectForKey:@"full_name"];
            NSNumber * user_id=[result objectForKey:@"id"];
            tempUser.user_id= [user_id stringValue];
            
            [_searchArrayPeople addObject:tempUser];
        }

    
    [_tableview reloadData];
    
    
}

-(void) parseResponseDic: (NSString *) category
{
    
    NSDictionary *resultArray= [_responseDic objectForKey:@"results"];
    
    
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
        
   
    } // success callback block
     
         failure:^(AFHTTPRequestOperation *operation, NSError *error){
             NSLog(@"Error: %@", error);} // failure callback block
     ];
    
}


- (void) getdiscoverItemForPeople
{
      User *localUser= [[FitmooHelper sharedInstance] getUserLocally];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSString *lim= [NSString stringWithFormat:@"%i", _limit];
    NSString *ofs= [NSString stringWithFormat:@"%i", _offset];
    
    NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:localUser.secret_id, @"secret_id", localUser.auth_token, @"auth_token",_searchTermField.text, @"keyword",ofs, @"offset",lim, @"limit",@"any", @"gender",@"18", @"min",@"102", @"max",@"", @"lat",@"", @"lng",nil];
    NSString *url= [NSString stringWithFormat:@"%@%@",[[UserManager sharedUserManager] clientUrl],@"/api/users/discover"];
    [manager GET: url parameters:jsonDict success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        _responseDic= responseObject;
        
        [self parseResponseDicDiscover:@"People"];
        
       
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
    if ([_searchArrayPeople count]==0) {
        return 0;
    }

 return [_searchArrayPeople count]+1;
       
    
}


//- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//   if([_searchArrayPeople count]==0)
//   {
//       return 0;
//   }
//    return 60.0f;
//}
//
//
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//   
//    
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 60)];
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 25, tableView.frame.size.width, 20)];
//
//    NSString *string= @"PROFILES + BRANDS";
//    
//    [label setBackgroundColor:[UIColor clearColor]];
//    [label setText:string];
//    [label setTextColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1]];
//    UIFont *font = [UIFont fontWithName:@"BentonSans-Bold" size:12];
//    NSMutableAttributedString *attributedString= [[NSMutableAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName: font}  ];
//  
//    float spacing = 1.0f;
//    [attributedString addAttribute:NSKernAttributeName value:@(spacing) range:NSMakeRange(0, [string length])];
//
//    [label setAttributedText:attributedString];
//    
//    
//    [view addSubview:label];
//    
//    [view setBackgroundColor:[UIColor whiteColor]]; //your background color...
//    return view;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row==0) {
        UITableViewCell * cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell1"];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 60)];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 30, tableView.frame.size.width, 20)];
        
        NSString *string= @"PROFILES + BRANDS";
        
        [label setBackgroundColor:[UIColor clearColor]];
        [label setText:string];
        [label setTextColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1]];
        UIFont *font = [UIFont fontWithName:@"BentonSans-Bold" size:12];
        NSMutableAttributedString *attributedString= [[NSMutableAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName: font}  ];
        
        float spacing = 1.0f;
        [attributedString addAttribute:NSKernAttributeName value:@(spacing) range:NSMakeRange(0, [string length])];
        
        [label setAttributedText:attributedString];
        
        
        [view addSubview:label];
        
        [view setBackgroundColor:[UIColor whiteColor]];
        [cell.contentView addSubview:view];
        return cell;
        

    }
    
    
     UITableViewCell * cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell1"];
    UIButton *imageview=[[UIButton alloc] init];
    imageview.frame= CGRectMake(15, 15, 35, 35);
    imageview.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:imageview respectToSuperFrame:self.view];
    UILabel *nameLabel=[[UILabel alloc] init];
    nameLabel.frame= CGRectMake(63, 11, 125, 42);
    nameLabel.numberOfLines=2;
    nameLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:nameLabel respectToSuperFrame:self.view];
    
    UIButton * followButton= [[UIButton alloc] init];
    followButton.frame= CGRectMake(194, 14, 100, 31);
    followButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:followButton respectToSuperFrame:self.view];
    
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, imageview.frame.size.width, imageview.frame.size.height)];
    view.clipsToBounds=YES;
    view.layer.cornerRadius=view.frame.size.width/2;
    User *temUser= [_searchArrayPeople objectAtIndex:indexPath.row-1];
    nameLabel.text= temUser.name;
   // nameLabel.frame=[[FitmooHelper sharedInstance] caculateLabelHeight:nameLabel];
    UIFont *font = [UIFont fontWithName:@"BentonSans-Medium" size:14];
    NSMutableAttributedString *attributedString= [[NSMutableAttributedString alloc] initWithString:nameLabel.text attributes:@{NSFontAttributeName: font}  ];
    
    [nameLabel setAttributedText:attributedString];
    
    
    AsyncImageView *userImage = [[AsyncImageView alloc] initWithFrame:CGRectMake(0, 0, imageview.frame.size.width, imageview.frame.size.height)];
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:userImage];
    userImage.imageURL =[NSURL URLWithString:temUser.profile_avatar_thumb];
 
    [view addSubview:userImage];
    [imageview addSubview:view];
            
    [followButton setTag:indexPath.row*100+7];
    
    
    if ([temUser.is_following isEqualToString:@"0"]) {
        
        [followButton setBackgroundImage:[UIImage imageNamed:@"searchfollowbtn.png"] forState:UIControlStateNormal];
        
    }else
    {
        [followButton setBackgroundImage:[UIImage imageNamed:@"searchfollowingbtn.png"] forState:UIControlStateNormal];
    }
    [followButton addTarget:self action:@selector(followButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.contentView addSubview:imageview];
    [cell.contentView addSubview:followButton];
    [cell.contentView addSubview:nameLabel];
    cell.selectionStyle= UITableViewCellSelectionStyleNone;
    
    UIView *v= [[UIView alloc] initWithFrame:CGRectMake(55, 59, 270, 1)];
    v.backgroundColor=[UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1];
    v.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:v respectToSuperFrame:self.view];
    [cell.contentView addSubview:v];
    v.frame= CGRectMake(v.frame.origin.x, v.frame.origin.y, v.frame.size.width, 1);
       return cell;
}


- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

     User *temUser= [_searchArrayPeople objectAtIndex:indexPath.row-1];
    
     [[NSNotificationCenter defaultCenter] postNotificationName:@"leftSideMenuAction" object:temUser.user_id];
}

// multy high table cell
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    double Radio= self.view.frame.size.width / 320;
    
    return 60*Radio;
}
- (IBAction)followButtonClick:(id)sender {
    tempButton1 = (UIButton *)sender;
    NSInteger index=(NSInteger) tempButton1.tag/100-1;
    
    tempUser1= [_searchArrayPeople objectAtIndex:index];
    
    if ([tempUser1.is_following isEqualToString:@"0"]) {
        [[UserManager sharedUserManager] performFollow:tempUser1.user_id];
        tempUser1.is_following=@"1";
        [tempButton1 setBackgroundImage:[UIImage imageNamed:@"searchfollowingbtn.png"] forState:UIControlStateNormal];
    }else
    {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Unfollow"
                                                       message:@"Are you sure you want to Unfollow this person?"
                                                      delegate:self
                                             cancelButtonTitle:@"No"
                                             otherButtonTitles:@"Yes",nil];
        [alert show];
        
        
        [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:@"HasSeenPopup"];
        
        
    }
    
    
}

- (void)textFieldDidChange:(UITextField *)textField
{
    if ([textField.text isEqualToString:@""]) {
         [self initValuable];
        [self.tableview reloadData];
    }else
    {
    
    [self initValuable];
    [self getdiscoverItemForPeople];
     //   [self getSearchItemForPeople];
    }
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
   
    [textField resignFirstResponder];
    return YES;
}


- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
    if (buttonIndex == 1)
    {
        [[UserManager sharedUserManager] performUnFollow:tempUser1.user_id];
        tempUser1.is_following=@"0";
        [tempButton1 setBackgroundImage:[UIImage imageNamed:@"searchfollowbtn.png"] forState:UIControlStateNormal];
    }
    
    
}

- (IBAction)backButtonClick:(id)sender {
   
    [[NSNotificationCenter defaultCenter] postNotificationName:@"leftSideMenuAction" object:@"6.1"];
}

- (void) initFrames
{
    _tableview.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_tableview respectToSuperFrame:self.view];
    _backButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_backButton respectToSuperFrame:self.view];
    _topView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_topView respectToSuperFrame:self.view];
    
    _buttomLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_buttomLabel respectToSuperFrame:self.view];
    _buttomSeparaterView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_buttomSeparaterView respectToSuperFrame:self.view];
    _buttonView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_buttonView respectToSuperFrame:self.view];
    _inviteButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_inviteButton respectToSuperFrame:self.view];
    
   _searchTermField.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_searchTermField respectToSuperFrame:self.view];
    _searchTermField.layer.cornerRadius=3.0f;
    
    
    UIFont *font = [UIFont fontWithName:@"BentonSans-Bold" size:13];
    NSMutableAttributedString *attributedString= [[NSMutableAttributedString alloc] initWithString:@"SEARCH" attributes:@{NSFontAttributeName: font}  ];
    float spacing = 1.0f;
    [attributedString addAttribute:NSKernAttributeName value:@(spacing) range:NSMakeRange(0, @"SEARCH".length)];
    
   // _searchTermField.attributedPlaceholder =attributedString;
//    [_searchTermField setValue:attributedString
//                    forKeyPath:@"_placeholderLabel.attributedText"];
    [_searchTermField setValue:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1]
                    forKeyPath:@"_placeholderLabel.textColor"];
    [_searchTermField addTarget:self
                  action:@selector(textFieldDidChange:)
        forControlEvents:UIControlEventEditingChanged];
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 20)];
    paddingView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:paddingView respectToSuperFrame:self.view];
    UIImageView *image= [[UIImageView alloc] initWithFrame:CGRectMake(8, 4, 12, 12)];
    image.image=[UIImage imageNamed:@"greysearch.png"];
    image.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:image respectToSuperFrame:self.view];
    [paddingView addSubview:image];
    
    _searchTermField.leftView = paddingView;
    _searchTermField.leftViewMode = UITextFieldViewModeAlways;
     //[[NSNotificationCenter defaultCenter] postNotificationName:@"showBlackStatusBarHandler" object:@"1"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) initValuable
{
    _offset=0;
    _limit=15;
    _count=1;
    
    _searchArrayPeople= [[NSMutableArray alloc]init];
}

- (void)scrollViewDidScroll: (UIScrollView*)scroll {
    
    
    if(self.tableview.contentOffset.y<-75){
        if (_count==0) {
        }
        _count++;
        //it means table view is pulled down like refresh
        return;
    }
    else if(self.tableview.contentOffset.y >= (self.tableview.contentSize.height - self.tableview.bounds.size.height)) {
        
        
        if (_count==0) {
            if (self.tableview.contentOffset.y<0) {
                _offset =0;
            }else
            {
                _offset +=15;
                
            }
            [self getdiscoverItemForPeople];
          //  [self getSearchItemForPeople];
        }
        _count++;
        
        
    }else
    {
        _count=0;
    }
    
}


- (IBAction)InviteButtonClick:(id)sender {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    _inviteView = [mainStoryboard instantiateViewControllerWithIdentifier:@"InviteViewController"];

    [self.navigationController pushViewController:_inviteView animated:YES];
    
    
}
@end

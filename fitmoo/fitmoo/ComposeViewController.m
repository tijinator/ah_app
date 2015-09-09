//
//  ComposeViewController.m
//  fitmoo
//
//  Created by hongjian lin on 6/24/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import "ComposeViewController.h"
#import "AFNetworking.h"
#import <SwipeBack/SwipeBack.h>
@interface ComposeViewController ()
{
    double cellHeight;
    double frameRadio;
    Comments * tempUser1;
    UIButton *tempButton1;
     UIView *indicatorView;
}
@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initFrames];
    [self initValuable];
    _likerArray= [[NSMutableArray alloc] init];
    cellHeight=60;
    self.tableview.tableFooterView = [[UIView alloc] init];
    if ([_searchType isEqualToString:@"like"]) {
        [self getLikeItem];
        _titleLabel.text=@"LIKES";
    }else if ([_searchType isEqualToString:@"follower"])
    {
         _titleLabel.text=@"FOLLOWERS";
        [self getLikeItem];
    }else if ([_searchType isEqualToString:@"following"])
    {
         _titleLabel.text=@"FOLLOWING";
         [self getLikeItem];
    }else if ([_searchType isEqualToString:@"members"])
    {
        _titleLabel.text=@"MEMBERS";
        [self getLikeItem];
    }
     indicatorView=[[FitmooHelper sharedInstance] addActivityIndicatorView:indicatorView and:self.view];
    
     self.navigationController.swipeBackEnabled = YES;
}

-(void) initValuable
{
    _offset=0;
    _limit=50;
    _count=1;
    
    _likerArray= [[NSMutableArray alloc]init];

}


- (void) initFrames
{
    _tableview.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_tableview respectToSuperFrame:self.view];
    _backButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_backButton respectToSuperFrame:self.view];
    _topView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_topView respectToSuperFrame:self.view];
    _titleLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_titleLabel respectToSuperFrame:self.view];
    _addUserButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_addUserButton respectToSuperFrame:self.view];
}


- (void) parseLikerItem
{
    NSDictionary * likersArray= [_responseDic objectForKey:@"results"];
    if (![likersArray isEqual:[NSNull null ]]&&[likersArray count]>0) {
        
        for (NSDictionary *likerDic in likersArray) {
            _comments= [[Comments alloc] init];
            _comments.created_by_id= [likerDic objectForKey:@"id"];
            _comments.full_name=[likerDic objectForKey:@"full_name"];
            
            _comments.text=@"";
            NSNumber * isfollowing=[likerDic objectForKey:@"is_following"];
            _comments.is_following= [isfollowing stringValue];
            NSDictionary *profile=[likerDic objectForKey:@"profile"];
            NSDictionary *avatars=[profile objectForKey:@"avatars"];
            _comments.original=[avatars objectForKey:@"original"];
            _comments.thumb=[avatars objectForKey:@"thumb"];
            _comments.cover_photo_url=[profile objectForKey:@"cover_photo_url"];
            
            [_likerArray addObject:_comments];
        }
         [self.tableview reloadData];
    }
    
   

}



- (void) getLikeItem
{
    User *localUser= [[FitmooHelper sharedInstance] getUserLocally];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSString *lim= [NSString stringWithFormat:@"%i", _limit];
    NSString *ofs= [NSString stringWithFormat:@"%i", _offset];
    
    NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:localUser.secret_id, @"secret_id", localUser.auth_token, @"auth_token", @"true", @"mobile",ofs, @"offset", lim , @"limit",@"true", @"ios_app",nil];
    NSString * url;
    if ([_searchType isEqualToString:@"like"]) {
        
        url= [NSString stringWithFormat: @"%@%@%@%@", [[UserManager sharedUserManager] clientUrl],@"/api/feeds/",_searchId,@"/likers?"];
        
    }else if([_searchType isEqualToString:@"follower"]) {
        
        url= [NSString stringWithFormat: @"%@%@%@%@", [[UserManager sharedUserManager] clientUrl],@"/api/users/",_searchId,@"/followers?"];
        
    }else if([_searchType isEqualToString:@"following"]) {
        url= [NSString stringWithFormat: @"%@%@%@%@", [[UserManager sharedUserManager] clientUrl],@"/api/users/",_searchId,@"/following?"];
    }else if([_searchType isEqualToString:@"members"]) {
        url= [NSString stringWithFormat: @"%@%@%@%@", [[UserManager sharedUserManager] clientUrl],@"/api/communities/",_searchId,@"/all_members"];
    }
    
 
    
    [manager GET:url parameters:jsonDict success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        _responseDic= responseObject;
       
             [self parseLikerItem];
        
        [indicatorView removeFromSuperview];
        [_activityIndicator stopAnimating];
    } // success callback block
         failure:^(AFHTTPRequestOperation *operation, NSError *error){
             NSLog(@"Error: %@", error);
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

         return [_likerArray count];

}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell  = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell1"];
    
    
    _comments=[_likerArray objectAtIndex:indexPath.row];
    
    UIButton * followButton= [[UIButton alloc] init];
    followButton.frame= CGRectMake(210, 14, 100, 31);
    followButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:followButton respectToSuperFrame:self.view];
    [followButton setTag:indexPath.row*100+7];
    if ([_comments.is_following isEqualToString:@"0"]) {
        
        [followButton setBackgroundImage:[UIImage imageNamed:@"searchfollowbtn.png"] forState:UIControlStateNormal];
        
    }else
    {
        [followButton setBackgroundImage:[UIImage imageNamed:@"searchfollowingbtn.png"] forState:UIControlStateNormal];
    }
    [followButton addTarget:self action:@selector(followButtonClick:) forControlEvents:UIControlEventTouchUpInside];


    UIButton *imageButton= [[UIButton alloc] init];
    imageButton.frame= CGRectMake(15, 15, 30, 30);
    imageButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:imageButton respectToSuperFrame:self.view];
    
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, imageButton.frame.size.width, imageButton.frame.size.height)];
    view.layer.cornerRadius=view.frame.size.width/2;
    view.clipsToBounds=YES;
    view.userInteractionEnabled = NO;
    view.exclusiveTouch = NO;
    
    AsyncImageView *imageview=[[AsyncImageView alloc] initWithFrame:CGRectMake(0, 0, imageButton.frame.size.width, imageButton.frame.size.height)];
    imageview.userInteractionEnabled = NO;
    imageview.exclusiveTouch = NO;
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:imageview];
    imageview.imageURL =[NSURL URLWithString:_comments.thumb];
    
    [imageButton.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    [view addSubview:imageview];
    [imageButton addSubview:view];
    
    
    [imageButton setTag:_comments.created_by_id.intValue];
    [imageButton addTarget:self action:@selector(headerImageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //    UILabel *nameLabel=(UILabel *) [cell viewWithTag:6];
    UILabel *nameLabel=[[UILabel alloc] init];
    nameLabel.frame= CGRectMake(58, 16, 130, 41);
    nameLabel.numberOfLines=2;
    nameLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:nameLabel respectToSuperFrame:self.view];
    imageview.layer.cornerRadius=imageview.frame.size.width/2;
    UIColor *fontColor= [UIColor colorWithRed:87/255 green:93/255 blue:96/255 alpha:0.7];
    
    UIFont *font= [UIFont fontWithName:@"BentonSans" size:(CGFloat)(13)];
    UIFont *font1= [UIFont fontWithName:@"BentonSans-Medium" size:(CGFloat)(13)];
    NSString *string1=_comments.full_name;
    NSString *string2=_comments.text;
    
    
    
    NSString *string= [NSString stringWithFormat:@"%@ %@",string1,string2];
    
    NSMutableAttributedString *attributedString= [[NSMutableAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName: font} ];
    attributedString=(NSMutableAttributedString *) [[FitmooHelper sharedInstance] replaceAttributedString:attributedString Font:font1 range:string1 newString:string1];
    
    NSRange range= [string rangeOfString:string2];
    [attributedString addAttribute:NSForegroundColorAttributeName value:fontColor range:range];
    
    
    
    nameLabel.lineBreakMode= NSLineBreakByWordWrapping;
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:8];
    [attributedString addAttribute:NSParagraphStyleAttributeName
                             value:style
                             range:NSMakeRange(0, string.length)];
    [nameLabel setAttributedText:attributedString];
    //  nameLabel.textColor=fontColor;
    
    //  nameLabel.frame= [[FitmooHelper sharedInstance] caculateLabelHeight:nameLabel];
    nameLabel.numberOfLines=0;
    [nameLabel sizeToFit];
    cellHeight= nameLabel.frame.size.height+20;
    
    [cell.contentView addSubview:imageButton];
    [cell.contentView addSubview:nameLabel];
    [cell.contentView addSubview:followButton];
    cell.selectionStyle= UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
}

// multy high table cell
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    double Radio= self.view.frame.size.width / 320;
    
    return  MAX(60*Radio, cellHeight);
}





- (void)scrollViewDidScroll: (UIScrollView*)scroll {
    
    
    if(self.tableview.contentOffset.y<-75){
        if (_count==0) {
        }
        _count++;
        //it means table view is pulled down like refresh
        return;
    }
    else if(self.tableview.contentOffset.y >= (self.tableview.contentSize.height - self.tableview.bounds.size.height-300)) {
        
        
        if (_count==0) {
            if (self.tableview.contentOffset.y<0) {
                _offset =0;
            }else
            {
                _offset +=50;
                
            }
            
     
            [self getLikeItem];
            
           
            
        }
        _count++;
        
        
    }else
    {
        _count=0;
    }
    
}

- (IBAction)headerImageButtonClick:(id)sender {
    UIButton *button = (UIButton *)sender;
    NSString *key=[NSString stringWithFormat:@"%ld", (long)button.tag];
    User *tempUser= [[UserManager sharedUserManager] localUser];
    
    if ([key isEqualToString:tempUser.user_id]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"leftSideMenuAction" object:@"profile"];
    }else
    {
        key=[NSString stringWithFormat:@"%ld", (long)button.tag+100];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"leftSideMenuAction" object:key];
    }
    
    
}
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
    if (buttonIndex == 1)
    {
        [[UserManager sharedUserManager] performUnFollow:tempUser1.created_by_id];
        tempUser1.is_following=@"0";
        [tempButton1 setBackgroundImage:[UIImage imageNamed:@"searchfollowbtn.png"] forState:UIControlStateNormal];
    }
    
    
}

- (IBAction)followButtonClick:(id)sender {
    tempButton1 = (UIButton *)sender;
    NSInteger index=(NSInteger) tempButton1.tag/100;
    
    tempUser1= [_likerArray objectAtIndex:index];
    
    if ([tempUser1.is_following isEqualToString:@"0"]) {
        [[UserManager sharedUserManager] performFollow:tempUser1.created_by_id];
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

- (IBAction)backButtonClick:(id)sender
{
    [self.tableview removeFromSuperview];
     self.tableview=nil;
      [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)addUserButtonClick:(id)sender {
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    InviteViewController * inviteView = [mainStoryboard instantiateViewControllerWithIdentifier:@"InviteViewController"];
    
    [self.navigationController pushViewController:inviteView animated:YES];
}
@end

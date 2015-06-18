//
//  NotificationViewController.m
//  fitmoo
//
//  Created by hongjian lin on 6/16/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import "NotificationViewController.h"
#import "AFNetworking.h"
@interface NotificationViewController ()
{
    double cellHeight;
    CGRect keyboardFrame;
    double constentUp;
    double constentdown;
    double frameRadio;
}
@end

@implementation NotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initFrames];
    [self initValuable];
    self.tableview.tableFooterView = [[UIView alloc] init];
    cellHeight=60;
    [self getNotificationItem];

    // Do any additional setup after loading the view.
}
-(void) initValuable
{
    _offset=0;
    _limit=100;
    _count=1;
    
    _notificArray= [[NSMutableArray alloc]init];
}


- (void) parseNotificationDic
{
    NSDictionary * notificationArray= [_responseDic objectForKey:@"results"];
    if (![notificationArray isEqual:[NSNull null ]]) {
        
        for (NSDictionary *notificationDic in notificationArray) {
            _homeFeed= [[HomeFeed alloc] init];
            
            
            _homeFeed.created_at= [notificationDic objectForKey:@"created_at"];
            _homeFeed.feed_id=[notificationDic objectForKey:@"feed_id"];
            
            NSDictionary *sender= [notificationDic objectForKey:@"sender"];
            _homeFeed.created_by.full_name=[sender objectForKey:@"full_name"];
            _homeFeed.type= [notificationDic objectForKey:@"type"];
       
            
            _homeFeed.is_liked=[notificationDic objectForKey:@"unread"];
            
            
            
            
            NSDictionary *profile=[sender objectForKey:@"profile"];
            NSDictionary *avatars=[profile objectForKey:@"avatars"];
            _homeFeed.photos.stylesUrl=[avatars objectForKey:@"small"];
            
            if ([_homeFeed.type isEqualToString:@"LikeNotification"]) {
                _homeFeed.text=@"liked your post";
                  [_notificArray addObject:_homeFeed];
            }else if ([_homeFeed.type isEqualToString:@"EndorseFeedNotification"]) {
                _homeFeed.text=@"endorsed your post";
                  [_notificArray addObject:_homeFeed];
            }else if ([_homeFeed.type isEqualToString:@"CommentedFeedNotification"]) {
                _homeFeed.text=@"commented on your post";
                  [_notificArray addObject:_homeFeed];
            }else if ([_homeFeed.type isEqualToString:@"ShareFeedNotification"]) {
                _homeFeed.text=@"shared your post";
                  [_notificArray addObject:_homeFeed];
            }
            
          
        }
    }
    
    [self.tableview reloadData];
    
}

- (void) getNotificationItem
{
    User *localUser= [[FitmooHelper sharedInstance] getUserLocally];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSString *lim= [NSString stringWithFormat:@"%i", _limit];
    NSString *ofs= [NSString stringWithFormat:@"%i", _offset];
    
    NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:localUser.secret_id, @"secret_id", localUser.auth_token, @"auth_token", @"true", @"mobile",ofs, @"offset", lim , @"limit",@"true", @"ios_app",nil];
    
    NSString * url= [NSString stringWithFormat: @"%@%@%@%@", [[UserManager sharedUserManager] clientUrl],@"/api/users/",localUser.user_id,@"/notifications"];
    
    [manager GET:url parameters:jsonDict success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        _responseDic= responseObject;
        
        [self parseNotificationDic];
        //      NSLog(@"Submit response data: %@", responseObject);
    } // success callback block
         failure:^(AFHTTPRequestOperation *operation, NSError *error){
             NSLog(@"Error: %@", error);
         } // failure callback block
     
     ];
    
}

- (void) openSpecialPage
{

        User *localUser= [[FitmooHelper sharedInstance] getUserLocally];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.securityPolicy.allowInvalidCertificates = YES;
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        
        NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:localUser.secret_id, @"secret_id", localUser.auth_token, @"auth_token", @"179547", @"fa_id", @"true", @"mobile",@"true", @"ios_app",
                                  nil];
        
        NSString * url= [NSString stringWithFormat: @"%@%@%@", [[UserManager sharedUserManager] clientUrl],@"/api/feeds/",_homeFeed.feed_id];
        
        [manager GET:url parameters:jsonDict success:^(AFHTTPRequestOperation *operation, id responseObject){
            
            NSDictionary * resDic= responseObject;
            
            HomeFeed *feed= [[FitmooHelper sharedInstance] generateHomeFeed:resDic];
            
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            SpecialPageViewController *specialPage = [mainStoryboard instantiateViewControllerWithIdentifier:@"SpecialPageViewController"];
            
            specialPage.homeFeed=feed;
            
            [self.navigationController pushViewController:specialPage animated:YES];
            
            
            //      NSLog(@"Submit response data: %@", responseObject);
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
    return [_notificArray count];
}

- (void) initFrames
{
    _tableview.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_tableview respectToSuperFrame:self.view];
    _backButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_backButton respectToSuperFrame:self.view];
    _topView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_topView respectToSuperFrame:self.view];
    _titleLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_titleLabel respectToSuperFrame:self.view];
    
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell=  [self.tableview cellForRowAtIndexPath:indexPath];
    
    
    if (cell == nil)
    {
        //   cell=[tableView dequeueReusableCellWithIdentifier:@"cell1"];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell1"];
    }else
    {
        return cell;
    }
    
    _homeFeed=[_notificArray objectAtIndex:indexPath.row];
    
  //  UIButton *imageButton= (UIButton *) [cell viewWithTag:5];
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
    imageview.imageURL =[NSURL URLWithString:_homeFeed.photos.stylesUrl];
    
    [imageButton.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    [view addSubview:imageview];
    [imageButton addSubview:view];
    
    
    [imageButton setTag:_homeFeed.comments.created_by_id.intValue];
    [imageButton addTarget:self action:@selector(headerImageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
   // UILabel *nameLabel=(UILabel *) [cell viewWithTag:6];
    UILabel *nameLabel=[[UILabel alloc] init];
    nameLabel.frame= CGRectMake(58, 16, 230, 21);
    nameLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:nameLabel respectToSuperFrame:self.view];
    imageview.layer.cornerRadius=imageview.frame.size.width/2;
    UIColor *fontColor= [UIColor colorWithRed:87/255 green:93/255 blue:96/255 alpha:0.7];
    
    UIFont *font= [UIFont fontWithName:@"BentonSans" size:(CGFloat)(13)];
    UIFont *font1= [UIFont fontWithName:@"BentonSans-Medium" size:(CGFloat)(13)];
    NSString *string1=_homeFeed.created_by.full_name;
    NSString *string2=_homeFeed.text;
    
    
    
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
                _offset +=100;
                
            }
            [self getNotificationItem];
            
        }
        _count++;
        
        
    }else
    {
        _count=0;
    }
    
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

- (IBAction)headerImageButtonClick:(id)sender {
    UIButton *button = (UIButton *)sender;
    NSString *key=[NSString stringWithFormat:@"%ld", (long)button.tag];
    User *tempUser= [[UserManager sharedUserManager] localUser];
    
    if ([key isEqualToString:tempUser.user_id]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"leftSideMenuAction" object:@"6"];
    }else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"leftSideMenuAction" object:key];
    }
    
    
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

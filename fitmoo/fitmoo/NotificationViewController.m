//
//  NotificationViewController.m
//  fitmoo
//
//  Created by hongjian lin on 6/16/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import "NotificationViewController.h"
#import "AFNetworking.h"
#import <QuartzCore/QuartzCore.h>
@interface NotificationViewController ()
{
    NSNumber * contentHight;
    CGRect keyboardFrame;
    double constentUp;
    double constentdown;
    double frameRadio;
     UIView *indicatorView;
       bool pullDown;
}
@end

@implementation NotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initFrames];
    [self initValuable];
    _notificArray= [[NSMutableArray alloc]init];
    self.tableview.tableFooterView = [[UIView alloc] init];
    contentHight=[NSNumber numberWithInteger:60];
    _heighArray= [[NSMutableArray alloc] initWithObjects:contentHight,contentHight,contentHight,contentHight,contentHight,contentHight,contentHight,contentHight,contentHight,contentHight, nil];
    [self getNotificationItem];
   indicatorView=[[FitmooHelper sharedInstance] addActivityIndicatorView:indicatorView and:self.view];
    // Do any additional setup after loading the view.
}
-(void) initValuable
{
    _offset=0;
    _limit=100;
    _count=1;
    pullDown=false;
  
}


- (void) parseNotificationDic
{
    
    if (_offset==0) {
        _notificArray= [[NSMutableArray alloc]init];
    }
    NSDictionary * notificationArray= [_responseDic objectForKey:@"results"];
    if (![notificationArray isEqual:[NSNull null ]]) {
        
        for (NSDictionary *notificationDic in notificationArray) {
            
            @try {
                
            
            _homeFeed= [[HomeFeed alloc] init];
             NSNumber *notification_id= [notificationDic objectForKey:@"id"];
            _homeFeed.notification_id= [notification_id stringValue];
             NSNumber *created_at= [notificationDic objectForKey:@"created_at"];
            _homeFeed.created_at= [created_at stringValue];
            _homeFeed.feed_id=[notificationDic objectForKey:@"feed_id"];
            
            NSDictionary *sender= [notificationDic objectForKey:@"sender"];
            _homeFeed.created_by.full_name=[sender objectForKey:@"full_name"];
            
            NSNumber *created_by_id= [sender objectForKey:@"id"];
            _homeFeed.created_by.created_by_id=[created_by_id stringValue];
            _homeFeed.type= [notificationDic objectForKey:@"type"];
                
            if ([[notificationDic allKeys] containsObject:@"feed_action_id"]) {
                NSNumber *feed_action_id= [notificationDic objectForKey:@"feed_action_id"];
                if (![feed_action_id isEqual:[NSNull null]]) {
                     _homeFeed.feed_action.feed_action_id=[feed_action_id stringValue];
                }
               
            }
            
                
            NSDictionary *data= [notificationDic objectForKey:@"data"];
                
            if ([[data allKeys] containsObject:@"destination"]) {
                _homeFeed.destination= [data objectForKey:@"destination"];
            }
                
       
            NSNumber *unread= [notificationDic objectForKey:@"unread"];
            _homeFeed.is_liked=[unread stringValue];
            
            NSNumber *confirmation_id= [notificationDic objectForKey:@"confirmation_id"];
            if (![confirmation_id isEqual:[NSNull null]]) {
                 _homeFeed.confirmation_id=[confirmation_id stringValue];
            }
           

             _homeFeed.confirmation_token=[notificationDic objectForKey:@"confirmation_token"];
            
            NSDictionary *profile=[sender objectForKey:@"profile"];
            NSDictionary *avatars=[profile objectForKey:@"avatars"];
            _homeFeed.photos.stylesUrl=[avatars objectForKey:@"small"];
            
            _homeFeed.text=[notificationDic objectForKey:@"text_message"];
             [_notificArray addObject:_homeFeed];

            }
            @catch (NSException *exception) {
                
            }
            @finally {
                
            }
        }
        NSNumber *unread=[_responseDic objectForKey:@"unread_count"];
        _unread_count=[unread stringValue];
        [self updateLocateUnreadCount];
        [self.tableview reloadData];
        
        [self updateUnreadFeed];
        
    }
    

    
}




- (void) updateLocateUnreadCount
{
     _notificationCountLabel.text=_unread_count;
    if (_unread_count.intValue>99) {
        _notificationCountLabel.text=@"99+";
     
    }
    _notificationCountLabel.hidden=false;
    if (_unread_count.intValue<=0) {
        _notificationCountLabel.text=@"0";
        _notificationCountLabel.hidden=true;
        
    }
    
}

- (void) viewWillDisappear:(BOOL)animated
{
    if (_unread_count!=nil) {
        if (_unread_count.intValue==0) {
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            [prefs setObject:@"0" forKey:@"fitmooNotification"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateNotificationStatus" object:Nil];
        }
    }
    

   
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
        [indicatorView removeFromSuperview];
        
        if (pullDown==true) {
            [UIView animateWithDuration:0.5 delay:1 options:UIViewAnimationOptionTransitionNone animations:^{
                [_tableview setContentOffset:CGPointMake(0, -20) animated:YES];
                
            }completion:^(BOOL finished){}];
            pullDown=false;
        }

        //      NSLog(@"Submit response data: %@", responseObject);
    } // success callback block
         failure:^(AFHTTPRequestOperation *operation, NSError *error){
             NSLog(@"Error: %@", error);
         } // failure callback block
     
     ];
    
}

-(void) updateUnreadFeed
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
     User *localUser= [[FitmooHelper sharedInstance] getUserLocally];
    
    
    NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:localUser.secret_id, @"secret_id", localUser.auth_token, @"auth_token", nil];
    NSString * url= [NSString stringWithFormat: @"%@%@%@%@", [[UserManager sharedUserManager] clientUrl],@"/api/users/",localUser.user_id,@"/notifications/read_all"];
    
    [manager POST: url parameters:jsonDict success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"checkNotification" object:Nil];
        
    } // success callback block
     
          failure:^(AFHTTPRequestOperation *operation, NSError *error){
              NSLog(@"Error: %@", error);} // failure callback block
     ];
    
    
}

- (void) openSpecialPage
{

        User *localUser= [[FitmooHelper sharedInstance] getUserLocally];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.securityPolicy.allowInvalidCertificates = YES;
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        
        NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:localUser.secret_id, @"secret_id", localUser.auth_token, @"auth_token",  @"true", @"mobile",@"true", @"ios_app", nil];
    
        if (_homeFeed.feed_action.feed_action_id!=nil) {
            jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:localUser.secret_id, @"secret_id", localUser.auth_token, @"auth_token",@"true", @"mobile",_homeFeed.feed_action.feed_action_id, @"fa_id",@"true", @"ios_app", nil];
        }
        
        NSString * url= [NSString stringWithFormat: @"%@%@%@", [[UserManager sharedUserManager] clientUrl],@"/api/feeds/",_homeFeed.feed_id];
        
        [manager GET:url parameters:jsonDict success:^(AFHTTPRequestOperation *operation, id responseObject){
            
            NSDictionary * resDic= responseObject;
            
            HomeFeed *feed= [[FitmooHelper sharedInstance] generateHomeFeed:resDic];
            
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            SpecialPageViewController *specialPage = [mainStoryboard instantiateViewControllerWithIdentifier:@"SpecialPageViewController"];
            
            specialPage.homeFeed=feed;
            specialPage.searchId=@"64367575756868";
       //     specialPage.searchId=[NSString stringWithFormat:@"%@",feed.created_by.created_by_id ];
            [self.navigationController pushViewController:specialPage animated:YES];
            
            
            //      NSLog(@"Submit response data: %@", responseObject);
        } // success callback block
             failure:^(AFHTTPRequestOperation *operation, NSError *error){
                 NSLog(@"Error: %@", error);
             } // failure callback block
         
         ];

    
    
    
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView
estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    double Radio= self.view.frame.size.width / 320;
    NSNumber *height;
    if (indexPath.row<[_heighArray count]) {
        height= (NSNumber *)[_heighArray objectAtIndex:indexPath.row];
        
        return height.integerValue;
    }else
    {
        height=[NSNumber numberWithInt:60*Radio];
        return height.integerValue;
    }
    
    
    return height.integerValue;
}
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
    _notificationCountLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_notificationCountLabel respectToSuperFrame:self.view];
    _notificationCountLabel.layer.cornerRadius= _notificationCountLabel.frame.size.width/2;
    _notificationCountLabel.clipsToBounds=YES;
    
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                  willDecelerate:(BOOL)decelerate
{
    if(self.tableview.contentOffset.y<-75){
        
        [_activityIndicator startAnimating];
        
        
        
        [self initValuable];
        pullDown=true;
        [self getNotificationItem];
        
        //it means table view is pulled down like refresh
        return;
    }
    
}
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    if (pullDown==true) {
        [_tableview setContentOffset:CGPointMake(0, -60) animated:YES];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell  = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell1"];
    
    if (indexPath.row==0) {
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [[FitmooHelper sharedInstance] resizeFrameWithFrame:_activityIndicator respectToSuperFrame:nil];
        _activityIndicator.center = CGPointMake(160*[[FitmooHelper sharedInstance] frameRadio], -20);
        _activityIndicator.hidesWhenStopped = YES;
        [cell.contentView addSubview:_activityIndicator];
        cell.clipsToBounds=false;
    }
    
    _homeFeed=[_notificArray objectAtIndex:indexPath.row];

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
    [imageButton setTag:_homeFeed.created_by.created_by_id.intValue];
    [imageButton addTarget:self action:@selector(headerImageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    

    UILabel *nameLabel=[[UILabel alloc] init];
    nameLabel.frame= CGRectMake(58, 16, 230, 21);
    
    if ([_homeFeed.type isEqualToString:@"ConfirmationNotification"]) {
         nameLabel.frame= CGRectMake(58, 16, 170, 21);
        UIButton *acceptButton= [[UIButton alloc] init];
        acceptButton.frame= CGRectMake(240, 16, 70, 30);
        acceptButton.frame=[[FitmooHelper sharedInstance] resizeFrameWithFrame:acceptButton respectToSuperFrame:self.view];
        
        UIFont *font= [UIFont fontWithName:@"BentonSans" size:(CGFloat)(13)];
        [acceptButton setTitle:@"Accept" forState:UIControlStateNormal];
        acceptButton.titleLabel.font=font;
        acceptButton.backgroundColor=[UIColor blackColor];
        acceptButton.titleLabel.textColor=[UIColor whiteColor];
        acceptButton.layer.cornerRadius=5;
        acceptButton.tag= indexPath.row*100;
        [acceptButton addTarget:self action:@selector(AcceptButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.contentView addSubview:acceptButton];
        
    }
    
    nameLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:nameLabel respectToSuperFrame:self.view];
    imageview.layer.cornerRadius=imageview.frame.size.width/2;
    UIColor *fontColor= [UIColor colorWithRed:87/255 green:93/255 blue:96/255 alpha:0.7];
    
    UIFont *font= [UIFont fontWithName:@"BentonSans" size:(CGFloat)(13)];
    UIFont *font1= [UIFont fontWithName:@"BentonSans-Medium" size:(CGFloat)(13)];
    NSString *string1=_homeFeed.created_by.full_name;
    NSString *string=[_homeFeed.text substringFromIndex:0];
    
     NSMutableAttributedString *attributedString= [[NSMutableAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName: font} ];
    
    NSString *string2;
    NSRange range3=[string rangeOfString:string1];
    if (range3.length>1) {
         string2=[string substringFromIndex:[string rangeOfString:string1].length];
       
        attributedString=(NSMutableAttributedString *) [[FitmooHelper sharedInstance] replaceAttributedString:attributedString Font:font1 range:string1 newString:string1];
    }else
    {
         string2=string;
         string1=@"";
    }
   

    
    
    NSRange range= [string rangeOfString:string2];
    [attributedString addAttribute:NSForegroundColorAttributeName value:fontColor range:range];
    nameLabel.lineBreakMode= NSLineBreakByWordWrapping;
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:8];
    [attributedString addAttribute:NSParagraphStyleAttributeName
                             value:style
                             range:NSMakeRange(0, string.length)];
    [nameLabel setAttributedText:attributedString];
    nameLabel.numberOfLines=0;
    [nameLabel sizeToFit];
   
   
    UILabel *dayLabel=[[UILabel alloc] initWithFrame:CGRectMake(68, nameLabel.frame.size.height+nameLabel.frame.origin.y+3, 230, 20)];
    NSRange range1= NSMakeRange(0, _homeFeed.created_at.length-3);
    NSString * timestring= [_homeFeed.created_at substringWithRange:range1];
    NSTimeInterval time=(NSTimeInterval ) timestring.intValue;
    NSDate *dayBegin= [[NSDate alloc] initWithTimeIntervalSince1970:time];
    NSDate *today= [NSDate date];
    dayLabel.text= [[FitmooHelper sharedInstance] daysBetweenDate:dayBegin andDate:today];
    font = [UIFont fontWithName:@"BentonSans-Book" size:12];
    attributedString= [[NSMutableAttributedString alloc] initWithString:dayLabel.text attributes:@{NSFontAttributeName: font}  ];
    [dayLabel setAttributedText:attributedString];

    [cell.contentView addSubview:imageButton];
    [cell.contentView addSubview:nameLabel];
    [cell.contentView addSubview:dayLabel];
     cell.selectionStyle= UITableViewCellSelectionStyleNone;
    
    
   
    
    
    
    if(indexPath.row==[_notificArray count]-1)
    {
        contentHight=[NSNumber numberWithInteger: dayLabel.frame.origin.y + dayLabel.frame.size.height+105];
    }else
    {
        contentHight=[NSNumber numberWithInteger: dayLabel.frame.origin.y + dayLabel.frame.size.height+10];
    }
    
    if (indexPath.row>=[_heighArray count]) {
        [_heighArray addObject:contentHight];
    }else
    {
        [_heighArray replaceObjectAtIndex:indexPath.row withObject:contentHight];
    }
    
    // unread = 1, then unread
    if ([_homeFeed.is_liked isEqualToString:@"1"]) {
        cell.contentView.backgroundColor= [UIColor colorWithRed:235.0/255.0 green:238.0/255.0 blue:240.0/255.0 alpha:1];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    _homeFeed= [_notificArray objectAtIndex:indexPath.row];
    
    if ([_homeFeed.is_liked isEqualToString:@"1"]) {
        NSNumber * unread=[NSNumber numberWithInt:_unread_count.intValue-1];
        _unread_count=[unread stringValue];
        [self updateLocateUnreadCount];

    }
    
    if ([_homeFeed.destination isEqualToString:@"live"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"leftSideMenuAction" object:@"live"];
        
        
    }else if ((_homeFeed.feed_id!=nil)&&(![_homeFeed.feed_id isEqual:[NSNull null]])) {
        [self openSpecialPage];
    }else
    {
        NSString *key=_homeFeed.created_by.created_by_id;
        User *tempUser= [[UserManager sharedUserManager] localUser];
        
        if ([key isEqualToString:tempUser.user_id]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"leftSideMenuAction" object:@"profile"];
        }else
        {
            key=[NSString stringWithFormat:@"%d", key.intValue+100];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"leftSideMenuAction" object:key];
        }

    }
    
    _homeFeed.is_liked=@"0";
    [self.tableview reloadData];
  //  [self updateUnreadFeed:_homeFeed.notification_id];
    
    
  

}

// multy high table cell
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    double Radio= self.view.frame.size.width / 320;
    
    NSNumber *height;
    if (indexPath.row<[_heighArray count]) {
        height= (NSNumber *)[_heighArray objectAtIndex:indexPath.row];
        
    }else
    {
        height=[NSNumber numberWithInt:contentHight.intValue];
    }
    
    return  MAX(60*Radio, height.intValue);
}




- (void)scrollViewDidScroll: (UIScrollView*)scroll {
    
    
    if(self.tableview.contentOffset.y<-75){
        if (_count==0) {
       //      [self initValuable];
      //        indicatorView=[[FitmooHelper sharedInstance] addActivityIndicatorView:indicatorView and:self.view];
      //       [self getNotificationItem];
           
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


- (IBAction)AcceptButtonClick:(id)sender {
    UIButton *button = (UIButton *)sender;
    int index= button.tag/100;
   // NSString *key=[NSString stringWithFormat:@"%ld", (long)button.tag];
  //  User *tempUser= [[UserManager sharedUserManager] localUser];
    HomeFeed *temFeed= [_notificArray objectAtIndex:index];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
  
    User *localUser= [[FitmooHelper sharedInstance] getUserLocally];
    
    
    NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:localUser.secret_id, @"secret_id", localUser.auth_token, @"auth_token", nil];
    NSString * url= [NSString stringWithFormat: @"%@%@%@", [[UserManager sharedUserManager] clientUrl],@"/api/users/follow_request/", temFeed.confirmation_token];
    
    [manager GET: url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        button.hidden=true;
        
    } // success callback block
     
          failure:^(AFHTTPRequestOperation *operation, NSError *error){
              NSLog(@"Error: %@", error);
              button.hidden=true;
          } // failure callback block
     ];

       
    
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

- (IBAction)backButtonClick:(id)sender {
    [_tableview removeFromSuperview];
    _tableview=nil;
    self.backButtonClicked=true;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"leftSideMenuAction" object:@"back"];
    
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

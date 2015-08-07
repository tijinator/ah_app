//
//  SearchViewController.m
//  fitmoo
//
//  Created by hongjian lin on 4/17/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import "FollowViewController.h"
#import "AFNetworking.h"
#import "AFNetworkActivityIndicatorManager.h"

@interface FollowViewController ()
{
        NSNumber * contentHight;
        UIView *indicatorView;
        User * tempUser1;
        UIButton *tempButton1;
        NSString *searchPeopleName;
        BOOL sleep;
        double ticks;
}
@end

@implementation FollowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initFrames];
    [self initSearchValuable];
    contentHight=[NSNumber numberWithInteger:270*[[FitmooHelper sharedInstance] frameRadio]];
    _heighArray= [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithDouble: 380*[[FitmooHelper sharedInstance] frameRadio]],contentHight,contentHight,contentHight,contentHight,contentHight,contentHight,contentHight,contentHight,contentHight, nil];
    _searchterm=@"";
    UINib *cellNib = [UINib nibWithNibName:@"FollowCollectionViewCell" bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"FollowCollectionViewCell"];

    
    
    _searchArrayCategory= [[NSMutableArray alloc] init];
    _searchArrayPeople= [[NSMutableArray alloc] init];
    _searchArrayPeople1= [[NSMutableArray alloc] init];
    _searchArrayPeopleName= [[NSMutableArray alloc] init];
    sleep=false;

  //  [self addActivityIndicator];
  //  [self getdiscoverItemForPeople];
 //   [self getCategoryAndLife];
    [self getDiscoverKeywords];
    
     self.tableview.userInteractionEnabled=false;
    [self createObservers];
    // Do any additional setup after loading the view.
}

-(void)createObservers{

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cellAction:) name:@"cellAction" object:nil];
   
  
}

- (void) cellAction: (NSNotification * ) note
{
    _selectedKeywordId=(NSString *)[note object];
   // [self.tableview reloadData];
    [self initValuable];

    [self getdiscoverItemForPeople];
    [self getdiscoverBulk];
}

#pragma mark - text field delegate
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch * touch = [touches anyObject];
    if(touch.phase == UITouchPhaseBegan) {
        [_searchTermField resignFirstResponder];
        
    }
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    // [self moveUpView:_buttomView];
    textField.spellCheckingType = UITextSpellCheckingTypeNo;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    if (![textField.text isEqualToString:@""]) {
         [_searchArrayPeopleName addObject:searchPeopleName];
    }
   

    return YES;
}

- (void)callQueue
{
    if (sleep==false) {
        if ([_searchArrayPeopleName count]>0) {
            searchPeopleName= [_searchArrayPeopleName objectAtIndex:0];
            [_searchArrayPeopleName removeObjectAtIndex:0];
            
            if ([searchPeopleName isEqualToString:@""]) {
                [self initSearchValuable];
                [self.tableview reloadData];
                
            }else
            {
                [self initSearchValuable];
                [self getSearchItemForPeople];
                sleep=true;
            }
            
            
        }
        
    }
    
}

- (void)timerTick:(NSTimer *)timer
{
    
    ticks += 0.1;
    double seconds = fmod(ticks, 60.0);
    
    if (seconds>=0.5 && seconds<0.6) {
        [_searchArrayPeopleName addObject:searchPeopleName];
    }
}

- (void)textFieldDidChange:(UITextField *)textField
{
    [_timer invalidate];
    ticks=0;
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerTick:) userInfo:nil repeats:YES];
    searchPeopleName=textField.text;
    
    
}






- (void) viewWillAppear:(BOOL)animated
{
    
    _timerQueue= [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(callQueue) userInfo:nil repeats:YES];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [_timerQueue invalidate];
    [_timer invalidate];
}


- (void) initFrames
{
    double radio= self.view.frame.size.width/320;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(120*radio, 225*radio)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [self.collectionView setCollectionViewLayout:flowLayout];
    
    _collectionView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_collectionView respectToSuperFrame:self.view];
    _leftButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_leftButton respectToSuperFrame:self.view];
    _headerView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_headerView respectToSuperFrame:self.view];
    _titleLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_titleLabel respectToSuperFrame:self.view];
    _featerLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_featerLabel respectToSuperFrame:self.view];
    _buttomView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_buttomView respectToSuperFrame:self.view];
    _bodyView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_bodyView respectToSuperFrame:self.view];
    
    
    _scrollView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_scrollView respectToSuperFrame:self.view];
    _tableview.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_tableview respectToSuperFrame:self.view];
    _lifestytleLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_lifestytleLabel respectToSuperFrame:self.view];
    _addUser.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_addUser respectToSuperFrame:self.view];
    
    _searchTermField.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_searchTermField respectToSuperFrame:self.view];
    _searchTermField.layer.cornerRadius=3.0f;
    
    UIFont *font = [UIFont fontWithName:@"BentonSans-Bold" size:13];
    NSMutableAttributedString *attributedString= [[NSMutableAttributedString alloc] initWithString:@"SEARCH" attributes:@{NSFontAttributeName: font}  ];
    float spacing = 1.0f;
    [attributedString addAttribute:NSKernAttributeName value:@(spacing) range:NSMakeRange(0, @"SEARCH".length)];
    
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
    
    if (self.view.frame.size.height<500) {
        
        _tableview.frame= CGRectMake(_tableview.frame.origin.x,_tableview.frame.origin.y, _tableview.frame.size.width, _tableview.frame.size.height-88);
        
    }
    
 
    
    
}
#pragma mark - API CALL with parser

-(void) parseResponseDic: (NSString *) category
{
    
    NSDictionary *resultArray= [_responseDic objectForKey:@"results"];
    
    
    for (NSDictionary * result in resultArray) {
        User *tempUser= [[User alloc]  init];
        NSNumber * isfollowing=[result objectForKey:@"is_following"];
        tempUser.is_following= [isfollowing stringValue];
        
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
        
        [_searchArrayPeople1 addObject:tempUser];
    }
    
    
    
    [_tableview reloadData];
    
    
}
-(void) parseResponseDicDiscover
{
     if (_offset==0) {
     _searchArrayPeople= [[NSMutableArray alloc] init];
     }
        for (NSDictionary * result in _responseDic) {
            User *tempUser= [[User alloc]  init];
            NSNumber * following=[result objectForKey:@"is_following"];
            tempUser.is_following= [following stringValue];
            NSNumber * followers=[result objectForKey:@"follower_count"];
            tempUser.followers= [followers stringValue];
           
            
            NSDictionary * profile=[result objectForKey:@"profile"];
            NSDictionary *avatar=[profile objectForKey:@"avatars"];
            tempUser.profile_avatar_thumb=[avatar objectForKey:@"medium"];
            
            tempUser.name= [result objectForKey:@"full_name"];
            NSNumber * user_id=[result objectForKey:@"id"];
            tempUser.user_id= [user_id stringValue];
            
            [_searchArrayPeople addObject:tempUser];
        }
    [self.collectionView reloadData];
    [self.tableview reloadData];
}


-(void) parseResponseDic
{
  
   
    _searchArrayCategory= [[NSMutableArray alloc] init];
   
        for (NSDictionary * result in _responseDic1) {
            User *tempUser= [[User alloc]  init];
        
            tempUser.cover_photo_url=[result objectForKey:@"photo_url"];
            tempUser.name= [result objectForKey:@"text"];
            NSNumber * user_id=[result objectForKey:@"id"];
            tempUser.user_id= [user_id stringValue];
            
            [_searchArrayCategory addObject:tempUser];
        }
 //   [self addScrollView];
    [self.tableview reloadData];
}

-(void) parseResponseBulk
{
    
    
    _searchArrayLeader= [[NSMutableArray alloc] init];
    _searchArrayCommunity= [[NSMutableArray alloc] init];
    _searchArrayWorkouts= [[NSMutableArray alloc] init];
    _searchArrayProducts= [[NSMutableArray alloc] init];
    
    NSDictionary *leaderDic= [_responseDic1 objectForKey:@"leaders"];
    NSDictionary *communityDic= [_responseDic1 objectForKey:@"communities"];
    NSDictionary *workoutDic= [_responseDic1 objectForKey:@"workouts"];
    NSDictionary *productDic= [_responseDic1 objectForKey:@"products"];

    for (NSDictionary *wkDic in workoutDic) {
        Workout *wk= [[Workout alloc] init];
        NSNumber *wk_id= [wkDic objectForKey:@"id"];
        wk.workout_id= [wk_id stringValue];
        wk.title=[wkDic objectForKey:@"text"];
        
        NSDictionary *photo= [wkDic objectForKey:@"photo"];
        if (![photo isEqual:[NSNull null]]) {
            NSDictionary *style= [photo objectForKey:@"styles"];
            NSDictionary *slider=[style objectForKey:@"slider"];
            wk.style_url= [slider objectForKey:@"photo_url"];
            
        }

        NSDictionary *video= [wkDic objectForKey:@"video"];
        NSDictionary *video_serializer_mobile= [video objectForKey:@"video_serializer_mobile"];
        if (![video_serializer_mobile isEqual:[NSNull null]]) {
            NSDictionary *thumbnail= [video_serializer_mobile objectForKey:@"thumbnail"];
            wk.video_style_url=[thumbnail objectForKey:@"url"];
            
        }
        
        [_searchArrayWorkouts addObject:wk];
        
    }
    
    
    for (NSDictionary *pdDic in productDic) {
        Product *pd= [[Product alloc] init];
        NSNumber *pd_id= [pdDic objectForKey:@"id"];
        pd.product_id= [pd_id stringValue];
        pd.title=[pdDic objectForKey:@"text"];
        if ([pd.title isEqual:[NSNull null]]) {
            pd.title=@"";
        }
        
        NSDictionary *photo= [pdDic objectForKey:@"photo"];
        if (![photo isEqual:[NSNull null]]) {
            NSDictionary *style= [photo objectForKey:@"styles"];
            NSDictionary *slider=[style objectForKey:@"slider"];
            pd.photo= [slider objectForKey:@"photo_url"];
            
        }
        
        NSDictionary *video= [pdDic objectForKey:@"video"];
        NSDictionary *video_serializer_mobile= [video objectForKey:@"video_serializer_mobile"];
        if (![video_serializer_mobile isEqual:[NSNull null]]) {
            NSDictionary *thumbnail= [video_serializer_mobile objectForKey:@"thumbnail"];
            pd.videos=[thumbnail objectForKey:@"url"];
            
        }
         [_searchArrayProducts addObject:pd];
        
    }
    
    for (NSDictionary *leader in leaderDic) {
        User *temUser= [[User alloc] init];
        temUser.name= [leader objectForKey:@"full_name"];
        
        NSNumber *days_a_week= [leader objectForKey:@"days_a_week"];
        temUser.days_a_week= [days_a_week stringValue];
        
        NSNumber *workout_count= [leader objectForKey:@"workout_count"];
        temUser.workout_count= [workout_count stringValue];
        NSNumber *user_id= [leader objectForKey:@"id"];
        temUser.user_id=[user_id stringValue];
        
        NSDictionary *profile= [leader objectForKey:@"profile"];
     
        NSDictionary *avatars= [profile objectForKey:@"avatars"];
        temUser.profile_avatar_thumb= [avatars objectForKey:@"thumb"];
        [_searchArrayLeader addObject:temUser];
        
    }
    
    for (NSDictionary *community in communityDic) {
        CreatedByCommunity *temCom= [[CreatedByCommunity alloc] init];
        NSNumber *com_id= [community objectForKey:@"id"];
        temCom.created_by_community_id=[com_id stringValue];
        
        temCom.name=[community objectForKey:@"name"];
        temCom.cover_photo_url=[community objectForKey:@"cover_photo_url"];
        if ([temCom.cover_photo_url isEqual:[NSNull null]]) {
            temCom.cover_photo_url=@"https://fitmoo.com/assets/group/cover-default.png";
        }

        [_searchArrayCommunity addObject:temCom];
    }
    
    [self.tableview reloadData];
}


-(void) parseDiscoverKeywordDic
{
    
    
    _searchArrayKeyword= [[NSMutableArray alloc] init];
    
  
    
    for (NSDictionary * result in _responseDic2) {
        CreatedByCommunity *tempCom= [[CreatedByCommunity alloc]  init];
        
        tempCom.cover_photo_url=[result objectForKey:@"app_discover_photo_url"];
        tempCom.name= [result objectForKey:@"text"];
        NSNumber * Com_id=[result objectForKey:@"id"];
        tempCom.created_by_community_id= [Com_id stringValue];
        
        if ([tempCom.cover_photo_url isEqualToString:@" "]) {
            tempCom.cover_photo_url=@"https://fitmoo.com/assets/group/cover-default.png";
        }
        
        [_searchArrayKeyword addObject:tempCom];
    }
    
    CreatedByCommunity *temCom=[_searchArrayKeyword objectAtIndex:0];
    _selectedKeywordId=temCom.created_by_community_id;
    
    [self getdiscoverItemForPeople];
    [self getdiscoverBulk];
    //   [self addScrollView];
   // [self.tableview reloadData];
    
    
}

- (void) getSpecialPage: (NSString *) key
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
   
    User *localUser= [[FitmooHelper sharedInstance] getUserLocally];
    NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:localUser.secret_id, @"secret_id", localUser.auth_token, @"auth_token",  @"true", @"mobile",@"true", @"ios_app", nil];
    _tableview.userInteractionEnabled=NO;
    [self addActivityIndicator];
    NSString * url= [NSString stringWithFormat: @"%@%@%@", [[UserManager sharedUserManager] clientUrl],@"/api/feeds/",key];
    
    [manager GET:url parameters:jsonDict success:^(AFHTTPRequestOperation *operation, id responseObject){
        _tableview.userInteractionEnabled=YES;
        [indicatorView removeFromSuperview];
        
        NSDictionary * resDic= responseObject;
        
        HomeFeed *feed= [[FitmooHelper sharedInstance] generateHomeFeed:resDic];
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        SpecialPageViewController *specialPage = [mainStoryboard instantiateViewControllerWithIdentifier:@"SpecialPageViewController"];
        specialPage.homeFeed=feed;
        [self.navigationController pushViewController:specialPage animated:YES];
        
    } // success callback block
         failure:^(AFHTTPRequestOperation *operation, NSError *error){
             NSLog(@"Error: %@", error);
            _tableview.userInteractionEnabled=YES;
            [indicatorView removeFromSuperview];
         } // failure callback block
     
     ];

}

- (void) getSearchItemForPeople
{
    // [_activityIndicator startAnimating];
    [self addActivityIndicator];
    _tableview.userInteractionEnabled=NO;
    User *localUser= [[FitmooHelper sharedInstance] getUserLocally];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSString *lim= [NSString stringWithFormat:@"%i", _searchlimit];
    NSString *ofs= [NSString stringWithFormat:@"%i", _searchoffset];
    
    NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:localUser.secret_id, @"secret_id", localUser.auth_token, @"auth_token",ofs, @"offset",lim, @"limit",@"true", @"mobile",@"people", @"c",searchPeopleName, @"q",nil];
    NSString *url= [NSString stringWithFormat:@"%@%@",[[UserManager sharedUserManager] clientUrl],@"/api/global/search"];
    [manager GET: url parameters:jsonDict success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        _responseDic= responseObject;
        
        [self parseResponseDic:@"People"];
        _tableview.userInteractionEnabled=YES;
        sleep=false;
        [indicatorView removeFromSuperview];
       // [_activityIndicator stopAnimating];
    } // success callback block
     
         failure:^(AFHTTPRequestOperation *operation, NSError *error){
             sleep=false;
            _tableview.userInteractionEnabled=YES;
             NSLog(@"Error: %@", error);} // failure callback block
     ];
    
}


- (void) getDiscoverKeywords
{
    
    User *localUser= [[FitmooHelper sharedInstance] getUserLocally];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    
    NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:localUser.secret_id, @"secret_id", localUser.auth_token, @"auth_token",@"true", @"mobile",nil];
    NSString *url= [NSString stringWithFormat:@"%@%@",[[UserManager sharedUserManager] clientUrl],@"/api/discover/app_discover_keywords"];
    [manager GET: url parameters:jsonDict success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        _responseDic2= responseObject;
        
        [self parseDiscoverKeywordDic];
        self.tableview.userInteractionEnabled=true;
        
    } // success callback block
     
         failure:^(AFHTTPRequestOperation *operation, NSError *error){
              self.tableview.userInteractionEnabled=true;
             NSLog(@"Error: %@", error);} // failure callback block
     ];
    
}

- (void) getCategoryAndLife
{
    
    User *localUser= [[FitmooHelper sharedInstance] getUserLocally];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    
    NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:localUser.secret_id, @"secret_id", localUser.auth_token, @"auth_token",@"true", @"mobile",nil];
    NSString *url= [NSString stringWithFormat:@"%@%@",[[UserManager sharedUserManager] clientUrl],@"/api/interests"];
    [manager GET: url parameters:jsonDict success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        _responseDic1= responseObject;
        
       
        [self parseResponseDic];
        self.tableview.userInteractionEnabled=true;
    } // success callback block
     
         failure:^(AFHTTPRequestOperation *operation, NSError *error){
              self.tableview.userInteractionEnabled=true;
             NSLog(@"Error: %@", error);} // failure callback block
     ];
    
}

- (void) getdiscoverBulk
{
    
    User *localUser= [[FitmooHelper sharedInstance] getUserLocally];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
  
    NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:localUser.secret_id, @"secret_id", localUser.auth_token, @"auth_token", _selectedKeywordId, @"id",nil];
    NSString *url= [NSString stringWithFormat:@"%@%@",[[UserManager sharedUserManager] clientUrl],@"/api/discover/app_discover_bulk"];
    [manager GET: url parameters:jsonDict success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        _responseDic1= responseObject;
        [self parseResponseBulk];
      
        self.tableview.userInteractionEnabled=true;
     
        
    } // success callback block
     
         failure:^(AFHTTPRequestOperation *operation, NSError *error){
             NSLog(@"Error: %@", error);
             self.tableview.userInteractionEnabled=true;
         } // failure callback block
     
     ];
    
}



- (void) getdiscoverItemForPeople
{
    [self addActivityIndicator];
    _tableview.userInteractionEnabled=NO;
    User *localUser= [[FitmooHelper sharedInstance] getUserLocally];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    NSString *ofs= [NSString stringWithFormat:@"%i", _offset];
    
    NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:localUser.secret_id, @"secret_id", localUser.auth_token, @"auth_token",ofs, @"offset",@"10", @"limit",_selectedKeywordId, @"id",nil];
    NSString *url= [NSString stringWithFormat:@"%@%@",[[UserManager sharedUserManager] clientUrl],@"/api/discover/app_discover_users"];
    [manager GET: url parameters:jsonDict success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        _responseDic= responseObject;
        
        [self parseResponseDicDiscover];
        self.tableview.userInteractionEnabled=true;
        [indicatorView removeFromSuperview];
       
    } // success callback block
     
         failure:^(AFHTTPRequestOperation *operation, NSError *error){
             NSLog(@"Error: %@", error);
              self.tableview.userInteractionEnabled=true;
         } // failure callback block
     
     ];

}

- (void) addActivityIndicator
{
    indicatorView= [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-50, 160*[[FitmooHelper sharedInstance] frameRadio], 100, 100)];
    indicatorView.backgroundColor=[UIColor colorWithRed:174.0/255.0 green:182.0/255.0 blue:186.0/255.0 alpha:1];
    //  view.backgroundColor=[UIColor whiteColor];
    indicatorView.layer.cornerRadius=5;
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [[FitmooHelper sharedInstance] resizeFrameWithFrame:activityIndicator respectToSuperFrame:nil];
    activityIndicator.alpha = 1.0;
    activityIndicator.center = CGPointMake(50, 40);
    activityIndicator.hidesWhenStopped = YES;
    [activityIndicator setBackgroundColor:[UIColor clearColor]];
    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    [activityIndicator startAnimating];
    
    UILabel * postingLabel= [[UILabel alloc] initWithFrame: CGRectMake(0,60, 100, 30)];
    postingLabel.text= @"LOADING...";
    //  postingLabel.textColor=[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1];
    postingLabel.textColor=[UIColor whiteColor];
    UIFont *font = [UIFont fontWithName:@"BentonSans-Bold" size:13];
    [postingLabel setFont:font];
    postingLabel.textAlignment=NSTextAlignmentCenter;
    
    [indicatorView addSubview:activityIndicator];
    [indicatorView addSubview:postingLabel];
    [self.view addSubview:indicatorView];
    
    // self.view.userInteractionEnabled=NO;
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    if (![_searchTermField.text isEqualToString:@""]) {
        if ([_searchArrayPeople1 count]==0) {
            
            if (![searchPeopleName isEqualToString:@""]&&searchPeopleName!=nil) {
                return 1;
            }
            
            return 0;
        }
        return [_searchArrayPeople1 count]+2;

    }
    
    int count=9+(int)[_searchArrayLeader count];
    return count;
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
     if (![_searchTermField.text isEqualToString:@""]) {
         
         if (indexPath.row==0) {
             if ((![searchPeopleName isEqualToString:@""])&&[_searchArrayPeople1 count]==0) {
                 UITableViewCell *Cell= [tableView dequeueReusableCellWithIdentifier:@"cell3"];
                 
                 UILabel *text= (UILabel *) [Cell viewWithTag:1001];
                 text.frame=CGRectMake(0, 21, 320, 27);
                 text.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:text respectToSuperFrame:self.view];
                 
                 UIButton *inviteButton= (UIButton *) [Cell viewWithTag:1];
                 inviteButton.frame=CGRectMake(81, 56, 157, 30);
                 inviteButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:inviteButton respectToSuperFrame:self.view];
                 [inviteButton addTarget:self action:@selector(addUserButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                 return Cell;
                 
             }
             
             
             UITableViewCell * cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell4"];
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
             cell.selectionStyle= UITableViewCellSelectionStyleNone;
             
             [view addSubview:label];
             
             [view setBackgroundColor:[UIColor whiteColor]];
             [cell.contentView addSubview:view];
             return cell;
             
             
         }
         
         //last cell
         if (indexPath.row==[_searchArrayPeople1 count]+1) {
             UITableViewCell *Cell= [tableView dequeueReusableCellWithIdentifier:@"cell3"];
             
             UILabel *text= (UILabel *) [Cell viewWithTag:1001];
             text.frame=CGRectMake(0, 21, 320, 27);
             text.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:text respectToSuperFrame:self.view];
             
             UIButton *inviteButton= (UIButton *) [Cell viewWithTag:1];
             inviteButton.frame=CGRectMake(81, 56, 157, 30);
             inviteButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:inviteButton respectToSuperFrame:self.view];
             [inviteButton addTarget:self action:@selector(addUserButtonClick:) forControlEvents:UIControlEventTouchUpInside];
             return Cell;
         }
         
         
         UITableViewCell * cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell4"];
         @try {
             UIButton *imageview=[[UIButton alloc] init];
             imageview.frame= CGRectMake(15, 15, 35, 35);
             imageview.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:imageview respectToSuperFrame:self.view];
             UILabel *nameLabel=[[UILabel alloc] init];
             nameLabel.frame= CGRectMake(63, 11, 125, 42);
             nameLabel.numberOfLines=2;
             nameLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:nameLabel respectToSuperFrame:self.view];
             
             UIButton * followButton= [[UIButton alloc] init];
             followButton.frame= CGRectMake(210, 14, 100, 31);
             followButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:followButton respectToSuperFrame:self.view];
             
             UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, imageview.frame.size.width, imageview.frame.size.height)];
             view.clipsToBounds=YES;
             view.layer.cornerRadius=view.frame.size.width/2;
             User *temUser= [_searchArrayPeople1 objectAtIndex:indexPath.row-1];
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
             
             [followButton setTag:indexPath.row+100];
             
             
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
             if (indexPath.row==[_searchArrayPeople1 count]) {
                 v= [[UIView alloc] initWithFrame:CGRectMake(5, 59, 310, 1)];
             }
             
             v.backgroundColor=[UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1];
             v.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:v respectToSuperFrame:self.view];
             [cell.contentView addSubview:v];
             v.frame= CGRectMake(v.frame.origin.x, v.frame.origin.y, v.frame.size.width, 1);
         }
         @catch (NSException * e) {
             NSLog(@"Exception: %@", e);
         }
         
         
         
         return cell;

         
     }
    
    
    if (indexPath.row==0) {
        SeachInterestCell *cell =(SeachInterestCell *) [self.tableview cellForRowAtIndexPath:indexPath];
        
        if (cell==nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SeachInterestCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        cell.searchArrayKeyword=self.searchArrayKeyword;
        cell.selectedKeywordId=self.selectedKeywordId;
        [cell addScrollView];
        
        
        
        contentHight=[NSNumber numberWithDouble:cell.scrollView.frame.size.height];
        [_heighArray replaceObjectAtIndex:0 withObject:contentHight];

        return cell;
    }
    
    if (indexPath.row==1) {
        
         UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        [_bodyView removeFromSuperview];
        [cell.contentView addSubview:_bodyView];
        
        
        contentHight=[NSNumber numberWithDouble:_bodyView.frame.size.height];
         [_heighArray replaceObjectAtIndex:1 withObject:contentHight];
        return cell;
    }
    
    if (indexPath.row==2) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        
        UILabel *titleLabel= [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 226, 21)];
        titleLabel.frame=[[FitmooHelper sharedInstance] resizeFrameWithFrame:titleLabel respectToSuperFrame:nil];
        
        titleLabel.text=@"Trending Workouts".uppercaseString;
        UIFont *font= [UIFont fontWithName:@"BentonSans-Bold" size:(CGFloat)(11)];
        titleLabel.font= font;
        [cell.contentView addSubview:titleLabel];
        
        
        contentHight=[NSNumber numberWithDouble:50*[[FitmooHelper sharedInstance] frameRadio]];
        if ([_searchArrayWorkouts count]==0) {
            contentHight=[NSNumber numberWithDouble:0];
            cell.clipsToBounds=YES;
            cell.contentView.clipsToBounds=YES;
        }
        [_heighArray replaceObjectAtIndex:indexPath.row withObject:contentHight];
     
        return cell;

    }
    
    if (indexPath.row==3) {
        FollowPhotoCell *cell =(FollowPhotoCell *) [self.tableview cellForRowAtIndexPath:indexPath];
        if (cell==nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FollowPhotoCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        cell.cellArray=self.searchArrayWorkouts;
        cell.cellType=@"workout";
        [cell builtCells];
        
        [cell.view1Button addTarget:self action:@selector(workoutButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.view2Button addTarget:self action:@selector(workoutButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.view3Button addTarget:self action:@selector(workoutButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.view4Button addTarget:self action:@selector(workoutButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.view5Button addTarget:self action:@selector(workoutButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.view6Button addTarget:self action:@selector(workoutButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.view7Button addTarget:self action:@selector(workoutButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.view8Button addTarget:self action:@selector(workoutButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.view9Button addTarget:self action:@selector(workoutButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        contentHight=[cell CaculateCellHeight];
        [_heighArray replaceObjectAtIndex:indexPath.row withObject:contentHight];
        return cell;
    }
    
    if (indexPath.row==4) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        
        UILabel *titleLabel= [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 226, 21)];
        titleLabel.frame=[[FitmooHelper sharedInstance] resizeFrameWithFrame:titleLabel respectToSuperFrame:nil];
        
        titleLabel.text=@"Trending Products".uppercaseString;
        UIFont *font= [UIFont fontWithName:@"BentonSans-Bold" size:(CGFloat)(11)];
        titleLabel.font= font;
        [cell.contentView addSubview:titleLabel];
        contentHight=[NSNumber numberWithDouble:50*[[FitmooHelper sharedInstance] frameRadio]];
        if ([_searchArrayProducts count]==0) {
            contentHight=[NSNumber numberWithDouble:0];
            cell.clipsToBounds=YES;
            cell.contentView.clipsToBounds=YES;
        }
        [_heighArray replaceObjectAtIndex:indexPath.row withObject:contentHight];
        
     
        
        return cell;
        
    }
    
    if (indexPath.row==5) {
        FollowPhotoCell *cell =(FollowPhotoCell *) [self.tableview cellForRowAtIndexPath:indexPath];
        if (cell==nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FollowPhotoCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        cell.cellArray=self.searchArrayProducts;
        cell.cellType=@"product";
        [cell builtCells];
        
        [cell.view1Button addTarget:self action:@selector(productButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.view2Button addTarget:self action:@selector(productButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.view3Button addTarget:self action:@selector(productButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.view4Button addTarget:self action:@selector(productButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.view5Button addTarget:self action:@selector(productButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.view6Button addTarget:self action:@selector(productButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.view7Button addTarget:self action:@selector(productButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.view8Button addTarget:self action:@selector(productButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.view9Button addTarget:self action:@selector(productButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        contentHight=[cell CaculateCellHeight];
        [_heighArray replaceObjectAtIndex:indexPath.row withObject:contentHight];
        return cell;
    }
    
    if (indexPath.row==6) {
        
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        
        UILabel *titleLabel= [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 226, 21)];
        titleLabel.frame=[[FitmooHelper sharedInstance] resizeFrameWithFrame:titleLabel respectToSuperFrame:nil];
        
        titleLabel.text=@"Trending Communities".uppercaseString;
        UIFont *font= [UIFont fontWithName:@"BentonSans-Bold" size:(CGFloat)(11)];
        titleLabel.font= font;
        [cell.contentView addSubview:titleLabel];
        contentHight=[NSNumber numberWithDouble:50*[[FitmooHelper sharedInstance] frameRadio]];
        if ([_searchArrayCommunity count]==0) {
            contentHight=[NSNumber numberWithDouble:0];
            cell.clipsToBounds=YES;
            cell.contentView.clipsToBounds=YES;
        }
        [_heighArray replaceObjectAtIndex:indexPath.row withObject:contentHight];

        return cell;
        
    }
    
    if (indexPath.row==7) {
        FollowPhotoCell *cell =(FollowPhotoCell *) [self.tableview cellForRowAtIndexPath:indexPath];
        if (cell==nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FollowPhotoCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        cell.cellArray=self.searchArrayCommunity;
        cell.cellType=@"community";
        [cell builtCells];
        
        [cell.view1Button addTarget:self action:@selector(communityButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.view2Button addTarget:self action:@selector(communityButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.view3Button addTarget:self action:@selector(communityButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.view4Button addTarget:self action:@selector(communityButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.view5Button addTarget:self action:@selector(communityButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.view6Button addTarget:self action:@selector(communityButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.view7Button addTarget:self action:@selector(communityButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.view8Button addTarget:self action:@selector(communityButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.view9Button addTarget:self action:@selector(communityButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        contentHight=[cell CaculateCellHeight];
        [_heighArray replaceObjectAtIndex:indexPath.row withObject:contentHight];
        return cell;
    }
    
    if (indexPath.row==8) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
        
        UILabel *titleLabel= (UILabel *)[cell viewWithTag:1];
        titleLabel.text=@"Leaderboard".uppercaseString;
        
        UIView *v= [[UIView alloc] initWithFrame:CGRectMake(20, 49, 300, 1)];
        v.backgroundColor=[UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1];
        v.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:v respectToSuperFrame:self.view];
        [cell.contentView addSubview:v];
        
        contentHight=[NSNumber numberWithDouble:50*[[FitmooHelper sharedInstance] frameRadio]];
        [_heighArray replaceObjectAtIndex:indexPath.row withObject:contentHight];
        
        return cell;
        
    }
    
    FollowLeaderBoardCell *cell =(FollowLeaderBoardCell *) [self.tableview cellForRowAtIndexPath:indexPath];
    if (cell==nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FollowLeaderBoardCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
 //   NSNumber *index= [NSNumber num];
    User *tempUser= [_searchArrayLeader objectAtIndex:(indexPath.row-9)];
    cell.tempUser= tempUser;
    
    [cell buildCell];
    cell.CountLabel.text=[NSString stringWithFormat:@"%ld",indexPath.row-8];

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
    if(indexPath.row>8)
    {
      
        User *tempUser= [_searchArrayLeader objectAtIndex:(indexPath.row-9)];
        NSString* key=[NSString stringWithFormat:@"%ld", (long)tempUser.user_id.intValue+100];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"leftSideMenuAction" object:key];
       
    }
        
    
}

- (CGFloat)tableView:(UITableView *)tableView
estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![_searchTermField.text isEqualToString:@""]) {
        double Radio= self.view.frame.size.width / 320;
        
        if (indexPath.row==[_searchArrayPeople1 count]+1) {
            return 310*Radio;
        }
        if (indexPath.row==0) {
            if ((![searchPeopleName isEqualToString:@""])&&[_searchArrayPeople1 count]==0) {
                
                return 310*Radio;
            }
        }
        return 60*Radio;
    }
        
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
    if (![_searchTermField.text isEqualToString:@""]) {
    double Radio= self.view.frame.size.width / 320;
    
    if (indexPath.row==[_searchArrayPeople1 count]+1) {
        return 310*Radio;
    }
    if (indexPath.row==0) {
        if ((![searchPeopleName isEqualToString:@""])&&[_searchArrayPeople1 count]==0) {
            
            return 310*Radio;
        }
    }
    return 60*Radio;
    }

        NSNumber *height;
        if (indexPath.row<[_heighArray count]) {
            height= (NSNumber *)[_heighArray objectAtIndex:indexPath.row];
            
        }else
        {
            height=[NSNumber numberWithInt:contentHight.doubleValue];
        }
        return height.doubleValue;

}



#pragma mark - UICollectionCellDelegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_searchArrayPeople count];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FollowCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FollowCollectionViewCell" forIndexPath:indexPath];
 
    User *tempUser= [_searchArrayPeople objectAtIndex:indexPath.row];
    cell.userLabel.text= tempUser.followers;
    cell.nameLabel.text= tempUser.name;
    
    
    AsyncImageView *headerImage2 = [[AsyncImageView alloc] initWithFrame:CGRectMake(0, 0,cell.image.frame.size.width, cell.image.frame.size.height)];
    headerImage2.userInteractionEnabled = NO;
    headerImage2.exclusiveTouch = NO;
    headerImage2.layer.cornerRadius=headerImage2.frame.size.width/2;
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:headerImage2];
    
    headerImage2.imageURL =[NSURL URLWithString:tempUser.profile_avatar_thumb];
    [cell.image.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];

    [cell.image addSubview:headerImage2];
    
    if ([tempUser.is_following isEqualToString:@"0"]) {
         [cell.followButton setBackgroundImage:[UIImage imageNamed:@"followsection_smallfollowbtn.png"] forState:UIControlStateNormal];
        
    }else
    {
         [cell.followButton setBackgroundImage:[UIImage imageNamed:@"followsection_smallfollowingbtn.png"] forState:UIControlStateNormal];
    }
    
    
    cell.followButton.tag= indexPath.row+100;
    [cell.followButton addTarget:self action:@selector(followButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    

    
    return cell;
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger  selectedImageIndex = indexPath.row;
    User *tempUser= [_searchArrayPeople objectAtIndex:selectedImageIndex];
      NSString *key=[NSString stringWithFormat:@"%d", tempUser.user_id.intValue+100];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"leftSideMenuAction" object:key];
    
  //  [collectionView reloadData];
}





- (IBAction)categoryButtonClick:(id)sender {
    UIButton *button = (UIButton *)sender;
    NSInteger index= button.tag-10;
    User *user= [_searchArrayCategory objectAtIndex:index];
    NSString *key=user.user_id;
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SecondFollowViewController *secondFollowPage = [mainStoryboard instantiateViewControllerWithIdentifier:@"SecondFollowViewController"];
    secondFollowPage.searchId= key;
    
    [self.navigationController pushViewController:secondFollowPage animated:YES];
    
}




- (void) initSearchValuable
{
    _searchoffset=0;
    _searchlimit=15;
    _searchcount=1;
    
    _searchArrayPeople1= [[NSMutableArray alloc]init];
}

-(void) initValuable
{
    _offset=0;
    _limit=10;
    _count=1;
    
   
  
}
- (void)scrollViewDidScroll: (UIScrollView*)scroll {
    
    if (![_searchTermField.text isEqualToString:@""]) {
        if(self.tableview.contentOffset.y<-75){
            if (_count==0) {
            }
            _count++;
            
            return;
        }
        else if(self.tableview.contentOffset.y >= (self.tableview.contentSize.height - self.tableview.bounds.size.height)) {
            
            
            if (_count==0) {
                if (self.tableview.contentOffset.y<0) {
                    _searchoffset =0;
                }else
                {
                    _searchoffset +=15;
                    
                }
                [self getSearchItemForPeople];
            }
            _count++;
            
            
        }else
        {
            _count=0;
        }

    }else
    {
   
    
    if(self.collectionView.contentOffset.x<-75){
        if (_count==0) {
            [self initValuable];
            [self getdiscoverItemForPeople];
        }
        _count++;
        //it means table view is pulled down like refresh
        return;
    }
    else if(self.collectionView.contentOffset.x >= (self.collectionView.contentSize.width - self.collectionView.bounds.size.width+20)) {
        //   NSLog(@"bottom!");
        //   NSLog(@"%f",self.tableView.contentOffset.y );
        //   NSLog(@"%f",self.tableView.contentSize.height - self.tableView.bounds.size.height );
        
        if (_count==0) {
            if (self.collectionView.contentOffset.x<0) {
                _offset =0;
            }else
            {
                _offset +=10;
                
            }
            [self getdiscoverItemForPeople];
            
        }
        _count++;
    }else
    {
        _count=0;
    }
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

#pragma mark - Button functions

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
    if (buttonIndex == 1)
    {
        [[UserManager sharedUserManager] performUnFollow:tempUser1.user_id];
        tempUser1.is_following=@"0";
        
        
        if (![_searchTermField.text isEqualToString:@""]) {
            [tempButton1 setBackgroundImage:[UIImage imageNamed:@"searchfollowbtn.png"] forState:UIControlStateNormal];
        }else
        {
            [tempButton1 setBackgroundImage:[UIImage imageNamed:@"followsection_smallfollowbtn.png"] forState:UIControlStateNormal];
        }
    }
    
    
}

- (IBAction)workoutButtonClick:(id)sender {
    UIButton *tempButton = (UIButton *)sender;
    NSInteger index=(NSInteger) tempButton.tag-1;
    if (index<[_searchArrayWorkouts count]) {
        Workout *wk= [_searchArrayWorkouts objectAtIndex:index];
        [self getSpecialPage:wk.workout_id];
    }
  
}

- (IBAction)productButtonClick:(id)sender {
    UIButton *tempButton = (UIButton *)sender;
    NSInteger index=(NSInteger) tempButton.tag-1;
      if (index<[_searchArrayProducts count]) {
    Product *pd= [_searchArrayProducts objectAtIndex:index];
    [self getSpecialPage:pd.product_id];
      }
}

- (IBAction)communityButtonClick:(id)sender {
    UIButton *tempButton = (UIButton *)sender;
    NSInteger index=(NSInteger) tempButton.tag-1;
      if (index<[_searchArrayCommunity count]) {
    CreatedByCommunity *com= [_searchArrayCommunity objectAtIndex:index];
    
   NSString * key= [NSString stringWithFormat:@"%@%@",@"com",com.created_by_community_id];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"leftSideMenuAction" object:key];
      }
}

- (IBAction)followButtonClick:(id)sender {
    tempButton1 = (UIButton *)sender;
    NSInteger index=(NSInteger) tempButton1.tag-100;
    
    if (![_searchTermField.text isEqualToString:@""]) {
        tempUser1= [_searchArrayPeople1 objectAtIndex:(index-1)];
    }else
    {
        tempUser1= [_searchArrayPeople objectAtIndex:index];
    }
    
    if ([tempUser1.is_following isEqualToString:@"0"]) {
        [[UserManager sharedUserManager] performFollow:tempUser1.user_id];
        tempUser1.is_following=@"1";
        if (![_searchTermField.text isEqualToString:@""]) {
            [tempButton1 setBackgroundImage:[UIImage imageNamed:@"searchfollowingbtn.png"] forState:UIControlStateNormal];
        }else
        {
            [tempButton1 setBackgroundImage:[UIImage imageNamed:@"followsection_smallfollowingbtn.png"] forState:UIControlStateNormal];
        }
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

- (IBAction)backButtonClick:(id)sender {
    //  [[NSNotificationCenter defaultCenter] postNotificationName:@"swipeHandler" object:Nil];
       [[NSNotificationCenter defaultCenter] postNotificationName:@"leftSideMenuAction" object:@"back"];
}
- (IBAction)addUserButtonClick:(id)sender {
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    InviteViewController * inviteView = [mainStoryboard instantiateViewControllerWithIdentifier:@"InviteViewController"];
    
    [self.navigationController pushViewController:inviteView animated:YES];
}
@end

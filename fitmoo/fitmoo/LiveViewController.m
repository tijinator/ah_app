//
//  LiveViewController.m
//  fitmoo
//
//  Created by hongjian lin on 10/11/15.
//  Copyright © 2015 com.fitmoo. All rights reserved.
//

#import "LiveViewController.h"
#import "AFNetworking.h"
#import "YTPlayerView.h"
@interface LiveViewController ()
{
    NSNumber * contentHight;
    NSString *deleteCartId;
    UIView *indicatorView;
    double constentUp;
    double constentdown;
    double frameRadio;
    double difference;
}

@property(nonatomic, strong) IBOutlet YTPlayerView *playerView;
@end

@implementation LiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getLive];
    [self initFrames];
    [self createObservers];
    
    // Do any additional setup after loading the view.
}

-(void)createObservers{
 
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNotification:) name:@"getNotification" object:nil];

}

-(void)getNotification:(NSNotification*)note{
    _commentNoteDic= [note object];
    
 //   NSDictionary *created_by= [_commentNoteDic objectForKey:@"created_by"];
//    NSMutableDictionary * mutableDict = [NSMutableDictionary dictionary];
//    [mutableDict addEntriesFromDictionary:_commentNoteDic];
//    [self parseCommentDic:mutableDict];
    
    NSMutableArray * mutableDict = [[NSMutableArray alloc] init];
    [mutableDict addObject:_commentNoteDic];
    [self parseCommentDic:(NSDictionary *)mutableDict];

}


- (void) updatePlayerView
{
    
    if ([_liveFeed.live_stream_video_id isEqual:[NSNull null]]) {
        
        NSString *url= [NSString stringWithFormat:@"%@%@",_liveFeed.stream_url,@"&playsinline=1"];
        NSString *url1= [NSString stringWithFormat:@"%@",_liveFeed.stream_url];
        UIWebView *web=[[UIWebView alloc] initWithFrame:self.playerView.frame];
        NSString *html= [NSString stringWithFormat:@"<!DOCTYPE HTML><html><body><iframe webkit-playsinline src=\"%@\" width=\"%f\" height=\"%f\" playsinline=1 frameborder=\"0\" scrolling=\"no\"> </iframe></body></html>",url1,305*[[FitmooHelper sharedInstance] frameRadio],180*[[FitmooHelper sharedInstance] frameRadio]];

        
        [web loadHTMLString:html baseURL:nil];
        self.playerView.hidden=true;
        web.allowsInlineMediaPlayback = YES;
        web.mediaPlaybackRequiresUserAction=NO;

        [self.view addSubview:web];
      
        
       
       
     
    
    }else
    {
        NSDictionary *playerVars = @{ @"playsinline" : @1,};
        [self.playerView loadWithVideoId:_liveFeed.live_stream_video_id playerVars:playerVars];
    }
    

    
    [_bannerImageView removeFromSuperview];
    _bannerImageView = [[AsyncImageView alloc] initWithFrame:CGRectMake(0, 0, _advertiseButton.frame.size.width, _advertiseButton.frame.size.height)];
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:_bannerImageView];

    _bannerImageView.imageURL =[NSURL URLWithString:_liveFeed.app_banner_image_url];
    _bannerImageView.contentMode = UIViewContentModeScaleToFill;

    _bannerImageView.userInteractionEnabled=NO;
    _bannerImageView.exclusiveTouch=NO;
    
    [_advertiseButton addSubview:_bannerImageView];
    
    if (_liveFeed.banner_link_url==nil  ) {
        _advertiseButton.hidden=true;
        self.tableView.frame=CGRectMake(_advertiseButton.frame.origin.x, _advertiseButton.frame.origin.y, self.tableView.frame.size.width, self.tableView.frame.size.height+_advertiseButton.frame.size.height);
        difference=difference+_advertiseButton.frame.size.height-15*frameRadio;
    }
    
    if (_liveFeed.profile_id!=nil) {
        [_profileImageView removeFromSuperview];
        _profileImageView = [[AsyncImageView alloc] initWithFrame:CGRectMake(0, 0, _liveProfileButton.frame.size.width, _liveProfileButton.frame.size.height)];
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:_profileImageView];
        
        _profileImageView.imageURL =[NSURL URLWithString:_liveFeed.profile_image];
        _profileImageView.contentMode = UIViewContentModeScaleToFill;
        
        _profileImageView.userInteractionEnabled=NO;
        _profileImageView.exclusiveTouch=NO;
        _profileImageView.layer.cornerRadius=_profileImageView.frame.size.width/2;
        
        [_liveProfileButton addSubview:_profileImageView];
    }
    
}

- (void) parseLiveFeed
{
    
    @try {
        
  
    NSDictionary *live_feed=[_responseDic objectForKey:@"live_feed"];
    NSDictionary *comments=[_responseDic objectForKey:@"comments"];
    NSDictionary *advertisement=[_responseDic objectForKey:@"advertisement"];
    
   
    _liveFeed= [[LiveFeed alloc] init];
    
    _liveFeed.live_feed_id=[live_feed objectForKey:@"id"];
    _liveFeed.live_stream_video_id=[live_feed objectForKey:@"live_stream_video_id"];
    _liveFeed.text=[live_feed objectForKey:@"text"];
    _liveFeed.stream_start=[live_feed objectForKey:@"stream_start"];
    _liveFeed.stream_image_url=[live_feed objectForKey:@"stream_image_url"];
    _liveFeed.stream_url=[live_feed objectForKey:@"stream_url"];
        
     if ([[live_feed allKeys] containsObject:@"profile_id"]) {
         NSNumber *profile_id= [live_feed objectForKey:@"profile_id"];
         _liveFeed.profile_id= [profile_id stringValue];
     }else
     {
          _liveFeed.profile_id= @"8";
     }
        
     if ([[live_feed allKeys] containsObject:@"profile_image"]) {
         _liveFeed.profile_image= [live_feed objectForKey:@"profile_image"];
         
     }else
     {
         _liveFeed.profile_image= @"https://cdn.fitmoo.com/avatars/5ecbffe7-9e66-4a16-a9dc-56deba4caae1/medium.png";
     }
    
        if (![advertisement isEqual:[NSNull null]]) {
            _liveFeed.company=[advertisement objectForKey:@"company"];
            _liveFeed.advertisement_id=[advertisement objectForKey:@"advertisement_id"];
            _liveFeed.logo_image_url=[advertisement objectForKey:@"logo_image_url"];
            _liveFeed.tagline_text=[advertisement objectForKey:@"tagline_text"];
            _liveFeed.updated_at=[advertisement objectForKey:@"updated_at"];
            _liveFeed.logo_link_url=[advertisement objectForKey:@"logo_link_url"];
            
            _liveFeed.banner_link_url=[advertisement objectForKey:@"banner_link_url"];
            _liveFeed.app_banner_image_url=[advertisement objectForKey:@"app_banner_image_url"];
        }
 
    
    
    
    if ([comments count]>0) {
        _liveFeed.commentsArray=[[NSMutableArray alloc] init];
        [self parseCommentDic:comments];
        
    }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
   
    [self updatePlayerView];
    
}


- (void) parseCommentDic:(NSDictionary *)commentsArray
{
  
    if (![commentsArray isEqual:[NSNull null ]]) {
        
        for (NSDictionary *commentsDic in commentsArray) {
            [_liveFeed resetComments];
            _liveFeed.comments.comment_id= [commentsDic objectForKey:@"commentable_id"];
            _liveFeed.comments.text= [commentsDic objectForKey:@"text"];
            NSDictionary *created_by=[commentsDic objectForKey:@"created_by"];
            _liveFeed.comments.created_by_id= [created_by objectForKey:@"id"];
            _liveFeed.comments.full_name= [created_by objectForKey:@"full_name"];
            _liveFeed.comments.is_following= [created_by objectForKey:@"is_following"];
            NSDictionary *profile=[created_by objectForKey:@"profile"];
            NSDictionary *avatars=[profile objectForKey:@"avatars"];
            _liveFeed.comments.original=[avatars objectForKey:@"original"];
            _liveFeed.comments.thumb=[avatars objectForKey:@"thumb"];
            _liveFeed.comments.cover_photo_url=[profile objectForKey:@"cover_photo_url"];
            
            [_liveFeed.commentsArray addObject:_liveFeed.comments];
        }
    }
    
    [self.tableView reloadData];
    NSIndexPath* ipath = [NSIndexPath indexPathForRow: [_liveFeed.commentsArray count]-1 inSection: 0];
    [self.tableView scrollToRowAtIndexPath:ipath atScrollPosition: UITableViewScrollPositionTop animated:NO];
    
}


-(void) performComment
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    User *localUser= [[UserManager sharedUserManager] localUser];
    
    NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:localUser.secret_id, @"secret_id", localUser.auth_token, @"auth_token", _textField.text, @"text",@"true", @"live_stream", nil];
    NSString *url= [NSString stringWithFormat:@"%@%@%@",[[UserManager sharedUserManager] feedsUrl], _liveFeed.live_feed_id ,@"/comments" ];
    [manager POST: url parameters:jsonDict success:^(AFHTTPRequestOperation *operation, id responseObject){
        
      //  [self.tableView reloadData];
        
        //      NSLog(@"Submit response data: %@", responseObject);
    } // success callback block
     
          failure:^(AFHTTPRequestOperation *operation, NSError *error){
              NSLog(@"Error: %@", error);} // failure callback block
     ];
    
}

- (void) viewWillAppear:(BOOL)animated
{
    [self showLive:@"true"];
}

- (void) viewWillDisappear:(BOOL)animated
{
    
    [self showLive:@"false"];
}

- (void) showLive:(NSString *) flag
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
  
    User *localUser= [[UserManager sharedUserManager] localUser];
    NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:localUser.secret_id, @"secret_id", localUser.auth_token, @"auth_token",flag, @"on_app_live_page",nil];
    NSString *url= [NSString stringWithFormat:@"%@%@",[[UserManager sharedUserManager] clientUrl], @"/live_stream/on_app_live_page"];
    [manager POST: url parameters:jsonDict success:^(AFHTTPRequestOperation *operation, id responseObject){
     
        
    } // success callback block
         failure:^(AFHTTPRequestOperation *operation, NSError *error){
             NSLog(@"Error: %@", error);
             
             [indicatorView removeFromSuperview];} // failure callback block
     ];
    
}

- (void) getLive
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
   // manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    User *localUser= [[UserManager sharedUserManager] localUser];
    NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:localUser.secret_id, @"secret_id", localUser.auth_token, @"auth_token",nil];
    NSString *url= [NSString stringWithFormat:@"%@%@",[[UserManager sharedUserManager] clientUrl], @"/live_stream/live_feed"];
    [manager GET: url parameters:jsonDict success:^(AFHTTPRequestOperation *operation, id responseObject){
        _responseDic= responseObject;
        
        [self parseLiveFeed];
        
       // [self.tableView reloadData];
        
    } // success callback block
         failure:^(AFHTTPRequestOperation *operation, NSError *error){
             NSLog(@"Error: %@", error);
          
             [indicatorView removeFromSuperview];} // failure callback block
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
   
    NSInteger count=[_liveFeed.commentsArray count];
    
    if (count==0) {
        return 1;
    }
    return count;
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//        LiveCell *cell =(LiveCell *) [self.tableView cellForRowAtIndexPath:indexPath];
//        if (cell == nil)
//        {
//            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"LiveCell" owner:self options:nil];
//            cell = [nib objectAtIndex:0];
//        }
    
    UITableViewCell * cell  = [[UITableViewCell alloc] init];
    cell.selectionStyle= UITableViewCellSelectionStyleNone;
    
    
        RTLabel *rtLabel=[[RTLabel alloc] initWithFrame:CGRectMake(27*frameRadio, 10*frameRadio, 275*frameRadio,100)];
        rtLabel.delegate=self;
        rtLabel.lineSpacing=8;
        
        Comments *temCom=[_liveFeed.commentsArray objectAtIndex:indexPath.row];
        if ([_liveFeed.commentsArray count]>0) {
        [rtLabel setText:[NSString stringWithFormat:@"<a href='%@'><font face=BentonSans-Bold size=12 color=#000000>%@ </font></a><font face=BentonSans-Bold size=12 color=#8D9AA0>%@ </font>",temCom.created_by_id,temCom.full_name,temCom.text]];
        CGSize optimumSize =[rtLabel optimumSize];
        rtLabel.frame=CGRectMake(rtLabel.frame.origin.x, rtLabel.frame.origin.y, optimumSize.width, optimumSize.height+10);
        
        }
        
        [cell.contentView addSubview:rtLabel];
        
        
        contentHight=[NSNumber numberWithFloat:rtLabel.frame.size.height+rtLabel.frame.origin.y+10];
    
    
  

    return cell;
}



- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    
    
}

// multy high table cell
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    return contentHight.intValue;
}


- (void) initFrames
{
    
    _tableView.frame= CGRectMake(0, 300, 320, 218);
    _tableView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_tableView respectToSuperFrame:nil];
    
    _topView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_topView respectToSuperFrame:nil];
    _leftButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_leftButton respectToSuperFrame:nil];
    

    _liveProfileButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_liveProfileButton respectToSuperFrame:nil];
   
    _headerView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_headerView respectToSuperFrame:nil];
    _heanderImage1.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_heanderImage1 respectToSuperFrame:nil];
    _headerImage2.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_headerImage2 respectToSuperFrame:nil];
    _titleLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_titleLabel respectToSuperFrame:nil];
    _dayLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_dayLabel respectToSuperFrame:nil];
    
    _playerView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_playerView respectToSuperFrame:nil];
    
    
    constentdown=519;
    constentUp=300;
    difference=0;
    frameRadio=[[FitmooHelper sharedInstance] frameRadio];
    
    if (self.view.frame.size.height<500) {
        
        _tableView.frame= CGRectMake(_tableView.frame.origin.x,_tableView.frame.origin.y, _tableView.frame.size.width, _tableView.frame.size.height-88);
        
        _buttomView.frame= CGRectMake(_buttomView.frame.origin.x, self.view.frame.size.height-_buttomView.frame.size.height, _buttomView.frame.size.width, _buttomView.frame.size.height);
        
        constentdown=430;
        constentUp=222;
        difference=-88;
        
    }
    
    _textField.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_textField respectToSuperFrame:self.view];
    _textField.layer.cornerRadius=3;
    _postButton.layer.cornerRadius=3;
    _postButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_postButton respectToSuperFrame:self.view];
    _buttomView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_buttomView respectToSuperFrame:self.view];
    
    _advertiseButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_advertiseButton respectToSuperFrame:self.view];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
}



#pragma mark - textfield functions
- (void) moveUpView: (UIView *) moveView
{
    
    if (_textViewBackgroundView==nil) {
        _textViewBackgroundView= [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        _textViewBackgroundView.backgroundColor=[UIColor blackColor];
        _textViewBackgroundView.alpha=0.7;
        [self.view addSubview:_textViewBackgroundView];
    }
    
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
        moveView.frame=CGRectMake(0,constentdown*frameRadio-constentUp, moveView.frame.size.width, moveView.frame.size.height);
        
        _tableView.frame=CGRectMake(_tableView.frame.origin.x, (constentdown-218-difference)*frameRadio-constentUp, _tableView.frame.size.width, _tableView.frame.size.height);
        
    }completion:^(BOOL finished){}];
    [self.view bringSubviewToFront:_tableView];
    [self.view bringSubviewToFront:moveView];
    
}

- (void) movedownView:(UIView *) moveView
{
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
        moveView.frame=CGRectMake(0, constentdown*frameRadio, moveView.frame.size.width, moveView.frame.size.height);
        _tableView.frame=CGRectMake(_tableView.frame.origin.x, (constentdown-218-difference)*frameRadio, _tableView.frame.size.width, _tableView.frame.size.height);
        
    }completion:^(BOOL finished){}];
    [_textViewBackgroundView removeFromSuperview];
    _textViewBackgroundView=nil;
   // [self.view bringSubviewToFront:_tableView];
    
}
-(void)keyboardDidShow:(NSNotification*)notification
{
    CGFloat height = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey ] CGRectValue].size.height;
    
    constentUp = height;
    [self moveUpView:_buttomView];
    // [self.view layoutIfNeeded];
}



- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    // [self moveUpView:_buttomView];
    //    textField.spellCheckingType = UITextSpellCheckingTypeNo;
    //    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    //    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    [self movedownView:_buttomView];
    
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch * touch = [touches anyObject];
    if(touch.phase == UITouchPhaseBegan) {
        //   [self disableViews];
        
        [_textField resignFirstResponder];
        
    }
}


#pragma mark RTLabel delegate

- (void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL*)url
{
   
    NSString *key=[NSString stringWithFormat:@"%d", [url absoluteString].intValue+100];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"leftSideMenuAction" object:key];
    
    
}

- (IBAction)backButtonClick:(id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"leftSideMenuAction" object:@"back"];

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

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
    if (buttonIndex == 1)
    {
        
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_liveFeed.banner_link_url]];
        
    }
    
    
}

- (IBAction)postButtonClick:(id)sender {
    if (![_textField.text isEqualToString:@""]) {
        [_textField resignFirstResponder];
        [self movedownView:_buttomView];
        [self performComment];
        _textField.text=@"";
    
    }else
    {
      
        UIAlertView *alert = [[ UIAlertView alloc ] initWithTitle : @"Oops!"
        message : @"Please say something." delegate : nil cancelButtonTitle : @"OK"
        otherButtonTitles : nil ];
        [alert show ];
         
        
    }
    
    
}
- (IBAction)adverButonClick:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@""
                                                   message:@"The link will take your outside the Fitmoo app, would you like to continue?"
                                                  delegate:self
                                         cancelButtonTitle:@"No"
                                         otherButtonTitles:@"Yes",nil];
    [alert show];
    
    
    [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:@"HasSeenPopup"];
    
    
}
- (IBAction)profileButtonClick:(id)sender {
    if (_liveFeed.profile_id!=nil) {
        NSString *key=[NSString stringWithFormat:@"%d", _liveFeed.profile_id.intValue+100];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"leftSideMenuAction" object:key];
    }
    
    
}
@end

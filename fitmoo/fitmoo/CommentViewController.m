//
//  CommentViewController.m
//  fitmoo
//
//  Created by hongjian lin on 5/4/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import "CommentViewController.h"
#import "AFNetworking.h"
#import <SwipeBack/SwipeBack.h>
@interface CommentViewController ()
{
     NSNumber * contentHight;
    CGRect keyboardFrame;
    double constentUp;
    double constentdown;
    double frameRadio;
}
@end

@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initFrames];
    [self initValuable];
    self.tableview.tableFooterView = [[UIView alloc] init];
    contentHight=[NSNumber numberWithInteger:60];
    _heighArray= [[NSMutableArray alloc] initWithObjects:contentHight,contentHight,contentHight,contentHight,contentHight,contentHight,contentHight,contentHight,contentHight,contentHight, nil];
    [_homeFeed resetCommentsArray];
    [self getCommentItem];
    [self createObservers];
     self.navigationController.swipeBackEnabled = YES;
    // Do any additional setup after loading the view.
}
-(void) initValuable
{
    _offset=0;
    _limit=100;
    _count=1;
  
    //   _homeFeedArray= [[NSMutableArray alloc]init];
}


- (void) parseCommentDic
{
    NSDictionary * commentsArray= [_responseDic objectForKey:@"comments"];
    if (![commentsArray isEqual:[NSNull null ]]) {
     
        for (NSDictionary *commentsDic in commentsArray) {
            @try {
                
            
            [_homeFeed resetComments];
            _homeFeed.comments.comment_id= [commentsDic objectForKey:@"id"];
            _homeFeed.comments.text= [commentsDic objectForKey:@"text"];
            NSDictionary *created_by=[commentsDic objectForKey:@"created_by"];
            _homeFeed.comments.created_by_id= [created_by objectForKey:@"id"];
            _homeFeed.comments.full_name= [created_by objectForKey:@"full_name"];
            _homeFeed.comments.is_following= [created_by objectForKey:@"is_following"];
            NSDictionary *profile=[created_by objectForKey:@"profile"];
            NSDictionary *avatars=[profile objectForKey:@"avatars"];
            _homeFeed.comments.original=[avatars objectForKey:@"original"];
            _homeFeed.comments.thumb=[avatars objectForKey:@"thumb"];
            _homeFeed.comments.cover_photo_url=[profile objectForKey:@"cover_photo_url"];
            
            [_homeFeed.commentsArray addObject:_homeFeed.comments];
            }
            @catch (NSException *exception) {
                
            }
            @finally {
                
            }
        }
    }
    
    [self.tableview reloadData];
    
}

- (void) getCommentItem
{
    User *localUser= [[FitmooHelper sharedInstance] getUserLocally];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSString *lim= [NSString stringWithFormat:@"%i", _limit];
    NSString *ofs= [NSString stringWithFormat:@"%i", _offset];
    
    NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:localUser.secret_id, @"secret_id", localUser.auth_token, @"auth_token", @"true", @"mobile",ofs, @"offset", lim , @"limit",@"true", @"ios_app",nil];
    
    NSString * url= [NSString stringWithFormat: @"%@%@%@%@", [[UserManager sharedUserManager] clientUrl],@"/api/feeds/",_homeFeed.feed_id,@"/comments?"];
    
    [manager GET:url parameters:jsonDict success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        _responseDic= responseObject;
    
        [self parseCommentDic];
        //      NSLog(@"Submit response data: %@", responseObject);
    } // success callback block
         failure:^(AFHTTPRequestOperation *operation, NSError *error){
             NSLog(@"Error: %@", error);
         } // failure callback block
     
     ];

}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch * touch = [touches anyObject];
    if(touch.phase == UITouchPhaseBegan) {
        //   [self disableViews];
        
        [_textField resignFirstResponder];
     
    }
}


- (void) initFrames
{
    _tableview.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_tableview respectToSuperFrame:self.view];
    _backButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_backButton respectToSuperFrame:self.view];
    _topView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_topView respectToSuperFrame:self.view];
    
    _textField.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_textField respectToSuperFrame:self.view];
    _textField.layer.cornerRadius=3;
    _postButton.layer.cornerRadius=3;
    _postButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_postButton respectToSuperFrame:self.view];
    _buttomView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_buttomView respectToSuperFrame:self.view];
    _titleLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_titleLabel respectToSuperFrame:self.view];
    
    constentdown=519;
    constentUp=300;
    frameRadio=[[FitmooHelper sharedInstance] frameRadio];
    //case iphone 4s
    if (self.view.frame.size.height<500) {
        
        _buttomView.frame= CGRectMake(_buttomView.frame.origin.x, self.view.frame.size.height-_buttomView.frame.size.height, _buttomView.frame.size.width, _buttomView.frame.size.height);
        
        constentdown=430;
        constentUp=222;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    

    
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
        return [_homeFeed.commentsArray count];
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
    
    _homeFeed.comments=[_homeFeed.commentsArray objectAtIndex:indexPath.row];
    
 //   UIButton *imageButton= (UIButton *) [cell viewWithTag:5];
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
    imageview.imageURL =[NSURL URLWithString:_homeFeed.comments.thumb];
    
    [imageButton.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    [view addSubview:imageview];
    [imageButton addSubview:view];

    
    [imageButton setTag:_homeFeed.comments.created_by_id.intValue];
    [imageButton addTarget:self action:@selector(headerImageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
//    UILabel *nameLabel=(UILabel *) [cell viewWithTag:6];
    UILabel *nameLabel=[[UILabel alloc] init];
    nameLabel.frame= CGRectMake(58, 16, 230, 21);
    nameLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:nameLabel respectToSuperFrame:self.view];
    imageview.layer.cornerRadius=imageview.frame.size.width/2;
    UIColor *fontColor= [UIColor colorWithRed:87/255 green:93/255 blue:96/255 alpha:0.7];
    
    UIFont *font= [UIFont fontWithName:@"BentonSans" size:(CGFloat)(13)];
    UIFont *font1= [UIFont fontWithName:@"BentonSans-Medium" size:(CGFloat)(13)];
    NSString *string1=_homeFeed.comments.full_name;
    NSString *string2=_homeFeed.comments.text;
    
   
    
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
    contentHight=[NSNumber numberWithInteger:nameLabel.frame.size.height+20];
   
    
    [cell.contentView addSubview:imageButton];
    [cell.contentView addSubview:nameLabel];
     cell.selectionStyle= UITableViewCellSelectionStyleNone;
    
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
-(void)createObservers{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"postFinished" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postFinished:) name:@"postFinished" object:nil];
}

- (void) postFinished: (NSNotification * ) note
{
    User *temuser= [[UserManager sharedUserManager] localUser];
    [_homeFeed resetComments];
    _homeFeed.comments.text= _textField.text;
    _homeFeed.comments.created_by_id= temuser.user_id;
    _homeFeed.comments.thumb= temuser.profile_avatar_thumb;
    _homeFeed.comments.full_name= temuser.name;
    NSNumber *total_comment=[NSNumber numberWithInt:_homeFeed.total_comment.intValue+1];
    _homeFeed.total_comment= total_comment.stringValue;
    [_homeFeed.commentsArray addObject:_homeFeed.comments];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didPostFinished" object:_homeFeed];
    
    [self.navigationController popViewControllerAnimated:YES];
}




#pragma mark - textfield functions
- (void) moveUpView: (UIView *) moveView
{

    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
        moveView.frame=CGRectMake(0,constentdown*frameRadio-constentUp, moveView.frame.size.width, moveView.frame.size.height);
    }completion:^(BOOL finished){}];
    
    
}

- (void) movedownView:(UIView *) moveView
{
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
        moveView.frame=CGRectMake(0, constentdown*frameRadio, moveView.frame.size.width, moveView.frame.size.height);
    }completion:^(BOOL finished){}];
    
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
            [self getCommentItem];
            
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
- (void) addActivityIndicator
{
    UIView *view= [[UIView alloc] initWithFrame:CGRectMake(110*[[FitmooHelper sharedInstance] frameRadio], 200*[[FitmooHelper sharedInstance] frameRadio], 100, 100)];
    view.backgroundColor=[UIColor colorWithRed:174.0/255.0 green:182.0/255.0 blue:186.0/255.0 alpha:1];
    //  view.backgroundColor=[UIColor whiteColor];
    view.layer.cornerRadius=5;
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [[FitmooHelper sharedInstance] resizeFrameWithFrame:activityIndicator respectToSuperFrame:nil];
    activityIndicator.alpha = 1.0;
    activityIndicator.center = CGPointMake(50, 40);
    activityIndicator.hidesWhenStopped = YES;
    [activityIndicator setBackgroundColor:[UIColor clearColor]];
    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    [activityIndicator startAnimating];
    
    UILabel * postingLabel= [[UILabel alloc] initWithFrame: CGRectMake(0,60, 100, 30)];
    postingLabel.text= @"POSTING...";
    //  postingLabel.textColor=[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1];
    postingLabel.textColor=[UIColor whiteColor];
    UIFont *font = [UIFont fontWithName:@"BentonSans-Bold" size:13];
    [postingLabel setFont:font];
    postingLabel.textAlignment=NSTextAlignmentCenter;
    
    [view addSubview:activityIndicator];
    [view addSubview:postingLabel];
    [self.view addSubview:view];
    
    self.view.userInteractionEnabled=NO;
}

- (IBAction)backButtonClick:(id)sender {
    [self.tableview removeFromSuperview];
    self.tableview=nil;
      [self.navigationController popViewControllerAnimated:YES];
 
}
- (IBAction)postButtonClick:(id)sender {
    if ([_textField.text isEqualToString:@""]) {
        UIAlertView *alert = [[ UIAlertView alloc ] initWithTitle : @"Oops"
                                                          message : @"Please write something." delegate : nil cancelButtonTitle : @"OK"
                                                otherButtonTitles : nil ];
        [alert show ];
    }else
    {
    [[UserManager sharedUserManager] performComment:_textField.text withId:_homeFeed.feed_id];
    self.postButton.userInteractionEnabled=NO;
    [self addActivityIndicator];
    }
    
}
@end

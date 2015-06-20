//
//  CommentViewController.m
//  fitmoo
//
//  Created by hongjian lin on 5/4/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import "CommentViewController.h"
#import "AFNetworking.h"
@interface CommentViewController ()
{
    double cellHeight;
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
    cellHeight=60;
    [_homeFeed resetCommentsArray];
    [self getCommentItem];
    [self createObservers];
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

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
        return [_homeFeed.commentsArray count];
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
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardDidHide:)
//                                                 name:UIKeyboardDidHideNotification
//                                               object:nil];
    
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

//- (void)keyboardWillChange:(NSNotification *)notification {
//    NSDictionary* keyboardInfo = [notification userInfo];
//    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameEndUserInfoKey];
//    keyboardFrame = [keyboardFrameBegin CGRectValue];
//    
//}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
   // [self moveUpView:_buttomView];
    textField.spellCheckingType = UITextSpellCheckingTypeNo;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
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
        key=[NSString stringWithFormat:@"%ld", (long)button.tag+100];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"leftSideMenuAction" object:key];
    }
   
    
}

- (IBAction)backButtonClick:(id)sender {
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
    }
    
}
@end

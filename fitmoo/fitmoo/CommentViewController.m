//
//  CommentViewController.m
//  fitmoo
//
//  Created by hongjian lin on 5/4/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import "CommentViewController.h"

@interface CommentViewController ()
{
    double cellHeight;
}
@end

@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initFrames];
    self.tableview.tableFooterView = [[UIView alloc] init];
    cellHeight=60;
    
    [self createObservers];
    // Do any additional setup after loading the view.
}

#pragma mark - UItextFieldDelegate

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

//#define kOFFSET_FOR_KEYBOARD 80.0
//
//-(void)keyboardWillShow {
//    // Animate the current view out of the way
//    if (self.view.frame.origin.y >= 0)
//    {
//        [self setViewMovedUp:YES];
//    }
//    else if (self.view.frame.origin.y < 0)
//    {
//        [self setViewMovedUp:NO];
//    }
//}
//
//-(void)keyboardWillHide {
//    if (self.view.frame.origin.y >= 0)
//    {
//        [self setViewMovedUp:YES];
//    }
//    else if (self.view.frame.origin.y < 0)
//    {
//        [self setViewMovedUp:NO];
//    }
//}
//
//-(void)textFieldDidBeginEditing:(UITextField *)sender
//{
//   
//            [self setViewMovedUp:YES];
//    
//}
//
////method to move the view up/down whenever the keyboard is shown/dismissed
//-(void)setViewMovedUp:(BOOL)movedUp
//{
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
//    
//    CGRect rect = self.view.frame;
//    if (movedUp)
//    {
//        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
//        // 2. increase the size of the view so that the area behind the keyboard is covered up.
//        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
//        rect.size.height += kOFFSET_FOR_KEYBOARD;
//    }
//    else
//    {
//        // revert back to the normal state.
//        rect.origin.y += kOFFSET_FOR_KEYBOARD;
//        rect.size.height -= kOFFSET_FOR_KEYBOARD;
//    }
//    self.view.frame = rect;
//    
//    [UIView commitAnimations];
//}



//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
//{
//    UIView *v= [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//    [v setBackgroundColor:[UIColor colorWithRed:0/255 green:0/255 blue:0/255 alpha:0.7f]];
//    [self.view addSubview:v];
//    [self.view bringSubviewToFront:_buttomView];
//    
//    
//    
//    return true;
//}

//- (void)textViewDidBeginEditing:(UITextView *)textView
//{
//    [self animateTextView: YES];
//}
//
//- (void)textViewDidEndEditing:(UITextView *)textView
//{
//    [self animateTextView:NO];
//}
//#define kOFFSET_FOR_KEYBOARD 80.0
//- (void) animateTextView:(BOOL) up
//{
//    const int movementDistance =kOFFSET_FOR_KEYBOARD; // tweak as needed
//    const float movementDuration = 0.3f; // tweak as needed
//    int movement= movement = (up ? -movementDistance : movementDistance);
//    NSLog(@"%d",movement);
//    
//    [UIView beginAnimations: @"anim" context: nil];
//    [UIView setAnimationBeginsFromCurrentState: YES];
//    [UIView setAnimationDuration: movementDuration];
//    self.view.frame = CGRectOffset(self.inputView.frame, 0, movement);
//    [UIView commitAnimations];
//}

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
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell=  [self.tableview cellForRowAtIndexPath:indexPath];
    
    
    if (cell == nil)
    {
        cell=[tableView dequeueReusableCellWithIdentifier:@"cell1"];
    }
    
    _homeFeed.comments=[_homeFeed.commentsArray objectAtIndex:indexPath.row];
    
    UIButton *imageButton= (UIButton *) [cell viewWithTag:5];
    imageButton.frame= CGRectMake(15, 15, 30, 30);
    imageButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:imageButton respectToSuperFrame:self.view];
    
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, imageButton.frame.size.width, imageButton.frame.size.height)];
    view.layer.cornerRadius=view.frame.size.width/2;
    view.clipsToBounds=YES;

    
    AsyncImageView *imageview=[[AsyncImageView alloc] initWithFrame:CGRectMake(0, 0, imageButton.frame.size.width, imageButton.frame.size.height)];
    imageview.userInteractionEnabled = NO;
    imageview.exclusiveTouch = NO;
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:imageview];
    imageview.imageURL =[NSURL URLWithString:_homeFeed.comments.thumb];
    
    [imageButton.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    [view addSubview:imageview];
    [imageButton addSubview:view];

    
    
    
    UILabel *nameLabel=(UILabel *) [cell viewWithTag:6];
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
    cellHeight= nameLabel.frame.size.height+10;
    
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

- (IBAction)backButtonClick:(id)sender {
      [self.navigationController popViewControllerAnimated:YES];
 
}
- (IBAction)postButtonClick:(id)sender {
    [[UserManager sharedUserManager] performComment:_textField.text withId:_homeFeed.feed_id];
    
}
@end

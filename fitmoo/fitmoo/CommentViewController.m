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
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didPostFinished" object:nil];
    
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

//
//  SpecialPageViewController.m
//  fitmoo
//
//  Created by hongjian lin on 4/12/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import "SpecialPageViewController.h"

@interface SpecialPageViewController ()

@end

@implementation SpecialPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initFrames];
    [self createObservers];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initFrames
{
    _tableView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_tableView respectToSuperFrame:self.view];
    _titleLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_titleLabel respectToSuperFrame:self.view];
    _backButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_backButton respectToSuperFrame:self.view];
}



#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
    
}


int contentHight1=50;
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShareTableViewCell *cell = [tableView
                                dequeueReusableCellWithIdentifier:@"ShareTableViewCell"];
    
    if (cell!=nil) {
        cell=nil;
    }
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ShareTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
   
    
    AsyncImageView *headerImage2 = [[AsyncImageView alloc] init];
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:headerImage2];
    headerImage2.imageURL =[NSURL URLWithString:_homeFeed.created_by.thumb];
    [cell.headerImage2 setBackgroundImage:headerImage2.image forState:UIControlStateNormal];
    
    
    cell.titleLabel.text= _homeFeed.title_info.avatar_title;
    cell.bodyDetailLabel.text= _homeFeed.text;
    
    if (_homeFeed.commentsArray!=nil) {
        
        for (int i=0; i<[_homeFeed.commentsArray count]; i++) {
            AsyncImageView *commentImage = [[AsyncImageView alloc] init];
            [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:commentImage];
            _homeFeed.Comments= [_homeFeed.commentsArray objectAtIndex:0];
            commentImage.imageURL =[NSURL URLWithString:_homeFeed.comments.thumb];
            [cell.commentImage setBackgroundImage:commentImage.image forState:UIControlStateNormal];
            
            cell.commentName.text=_homeFeed.comments.full_name;
            cell.commentDetail.text= _homeFeed.comments.text;
        }
        
    }
    
    if ([_homeFeed.photoArray count]!=0) {
        _homeFeed.photos= [_homeFeed.photoArray objectAtIndex:0];
        
        if (![_homeFeed.photos.stylesUrl isEqual:@""]) {
            
            AsyncImageView *bodyImage = [[AsyncImageView alloc] init];
            [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:bodyImage];
            bodyImage.imageURL =[NSURL URLWithString:_homeFeed.photos.stylesUrl];
            [cell.bodyImage setBackgroundImage:bodyImage.image forState:UIControlStateNormal];
            cell.bodyImage.hidden=false;
        }else
        {
            AsyncImageView *bodyImage = [[AsyncImageView alloc] init];
            [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:bodyImage];
            bodyImage.imageURL =[NSURL URLWithString:_homeFeed.photos.originalUrl];
            [cell.bodyImage setBackgroundImage:bodyImage.image forState:UIControlStateNormal];
            cell.bodyImage.hidden=false;
        }
        
    }else
    {
        cell.bodyImage.hidden=true;
    }
    
     _textView = [[UITextView alloc] initWithFrame:CGRectMake(10, cell.buttomView.frame.origin.y+20, self.view.frame.size.width-20, 80)];
    [_textView setDelegate:self];
    
    
    
    cell.contentView.frame=CGRectMake(cell.contentView.frame.origin.x, cell.contentView.frame.origin.y, cell.contentView.frame.size.width, _textView.frame.size.height+_textView.frame.origin.y+150);
    
    [cell.contentView addSubview:_textView ];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self action:@selector(postButtonClick:)
     forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundColor:[UIColor blueColor]];
    [button setTintColor:[UIColor whiteColor]];
    [button setTitle:_action forState:UIControlStateNormal];
    button.frame = CGRectMake(self.view.frame.size.width-80,_textView.frame.size.height+30+_textView.frame.origin.y , 60.0, 48.0);
    [cell.contentView addSubview:button];
    
    contentHight1=button.frame.size.height+ button.frame.origin.y+30 ;
     [cell.buttomView removeFromSuperview];
    return cell;
}






- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
}

// multy high table cell
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    return contentHight1;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
    //    _postText= textView.text;
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (IBAction)postButtonClick:(id)sender {
    
    if ([_action isEqualToString:@"Post"]) {
        
         [[UserManager sharedUserManager] performComment:_textView.text withId:_homeFeed.feed_id];
        
    }else if ([_action isEqualToString:@"Share"])
    {
         [[UserManager sharedUserManager] performShare:_textView.text withId:_homeFeed.feed_id];

    }
    
   
    
}

-(void)createObservers{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"postFinished" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postFinished:) name:@"postFinished" object:nil];
}


- (void) postFinished: (NSNotification * ) note
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didPostFinished" object:nil];
    
    [self dismissViewControllerAnimated:YES completion:nil];
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
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end

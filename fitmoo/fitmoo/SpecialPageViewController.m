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
    ShareTableViewCell *cell =(ShareTableViewCell *) [self.tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ShareTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
   
    cell.homeFeed=_homeFeed;
    
    if ([_homeFeed.feed_action.action isEqualToString:@"post"]) {
        cell.heanderImage1.hidden=true;
        [cell reDefineHearderViewsFrame];
    }else
    {
        cell.heanderImage1.hidden=false;
        AsyncImageView *headerImage1 = [[AsyncImageView alloc] initWithFrame:CGRectMake(0, 0, cell.heanderImage1.frame.size.width, cell.heanderImage1.frame.size.height)];
        headerImage1.userInteractionEnabled = NO;
        headerImage1.exclusiveTouch = NO;
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:headerImage1];
        if ([_homeFeed.feed_action.community_id isEqual:[NSNull null]])
        {
            headerImage1.imageURL =[NSURL URLWithString:_homeFeed.feed_action.created_by.thumb];
        }else
        {
            headerImage1.imageURL =[NSURL URLWithString:_homeFeed.feed_action.created_by_community.cover_photo_url];
        }
        [cell.heanderImage1.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
        [cell.heanderImage1 addSubview:headerImage1];
        
    }
    
    AsyncImageView *headerImage2 = [[AsyncImageView alloc] initWithFrame:CGRectMake(0, 0, cell.headerImage2.frame.size.width, cell.headerImage2.frame.size.height)];
    headerImage2.userInteractionEnabled = NO;
    headerImage2.exclusiveTouch = NO;
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:headerImage2];
    if ([_homeFeed.community_id isEqual:[NSNull null]])
    {
        headerImage2.imageURL =[NSURL URLWithString:_homeFeed.created_by.thumb];
    }else
    {
        headerImage2.imageURL =[NSURL URLWithString:_homeFeed.created_by_community.cover_photo_url];
    }
    [cell.headerImage2.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    [cell.headerImage2 addSubview:headerImage2];
    
    
    cell.titleLabel.text= _homeFeed.title_info.avatar_title;
    NSTimeInterval time=(NSTimeInterval ) ([_homeFeed.created_at integerValue]/1000);
    NSDate *dayBegin= [[NSDate alloc] initWithTimeIntervalSince1970:time];
    NSDate *today= [NSDate date];
    cell.dayLabel.text= [[FitmooHelper sharedInstance] daysBetweenDate:dayBegin andDate:today];
    
    
    if ([_homeFeed.type isEqualToString:@"regular"]) {
        [cell setBodyFrameForRegular];
    }else if ([_homeFeed.type isEqualToString:@"workout"])
    {
        [cell setBodyFrameForWorkout];
    }else if ([_homeFeed.type isEqualToString:@"nutrition"])
    {
        [cell setBodyFrameForNutrition];
    }else if ([_homeFeed.type isEqualToString:@"product"])
    {
        [cell setBodyFrameForProduct];
    }
    else if ([_homeFeed.type isEqualToString:@"event"])
    {
        [cell setBodyFrameForEvent];
    }
    if ([_homeFeed.photoArray count]!=0||[_homeFeed.videosArray count]!=0) {
        [cell addScrollView];
        
        NSString * url= _homeFeed.videos.video_url;
        if ([url rangeOfString:@"youtube.com"].location != NSNotFound){
            NSRange range= [url rangeOfString:@"v="];
            double ran=range.length+range.location;
            NSRange range1=NSMakeRange(ran, url.length-ran);
            NSString *video_id= [url substringWithRange:range1];
            NSString *videoString=[NSString stringWithFormat:@"%@%@%@", @"http://www.youtube.com/embed/", video_id, @"?showinfo=0&fs=0&rel=0"];
            self.videoURL =[NSURL URLWithString:videoString];
            cell.scrollbelowFrame.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:cell.scrollbelowFrame respectToSuperFrame:nil];
            UIWebView *  videoView = [[UIWebView alloc] initWithFrame:cell.scrollbelowFrame.frame];
            [cell.bodyView addSubview:videoView];
            NSURLRequest *request= [[NSURLRequest alloc] initWithURL:self.videoURL];
            [videoView loadRequest:request];
            
        }
        
    }else
    {
        [cell removeViewsFromBodyView:cell.scrollbelowFrame];
    }
    [cell rebuiltBodyViewFrame];
    
    
    
//    if ([_homeFeed.commentsArray count]!=0) {
//        [cell.commentButton setTitle:_homeFeed.total_comment  forState:UIControlStateNormal];
//        for (int i=0; i<[_homeFeed.commentsArray count]; i++) {
//            cell.homeFeed=_homeFeed;
//            [cell addCommentView:cell.commentView Atindex:i];
//        }
//        if ([_homeFeed.commentsArray count]==1) {
//            [cell removeCommentView2];
//            [cell removeCommentView1];
//        }
//        if ([_homeFeed.commentsArray count]==2) {
//            [cell removeCommentView2];
//        }
//    }else
//    {
//        [cell removeCommentView2];
//        [cell removeCommentView1];
//        [cell removeCommentView];
//    }
    
    
    if ([_action isEqualToString:@"playVideo"]) {
        
         contentHight1=  cell.buttomView.frame.origin.y + cell.buttomView.frame.size.height+10;
        [cell.bodyImage addTarget:self action:@selector(bodyImageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }else
    {
    
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
    }
   
    
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
- (IBAction)bodyImageButtonClick:(id)sender{

    NSString * url= _homeFeed.videos.video_url;
    
    if ([url rangeOfString:@"vimeo.com"].location != NSNotFound) {

       
        [YTVimeoExtractor fetchVideoURLFromURL:url quality:YTVimeoVideoQualityMedium referer:@"http://www.fitmoo.com"  completionHandler:^(NSURL *videoURL, NSError *error, YTVimeoVideoQuality quality) {
            if (error) {
                NSLog(@"Error : %@", [error localizedDescription]);
            } else if (videoURL) {
                NSLog(@"Extracted url : %@", [videoURL absoluteString]);
                
                _playerView = [[MPMoviePlayerViewController alloc] initWithContentURL:videoURL];
                [self.playerView.moviePlayer prepareToPlay];
                [self presentViewController:self.playerView animated:YES completion:^(void) {
                    self.playerView = nil;
                }];
            }
        }];
        

    } else
    {
        self.videoURL= [NSURL URLWithString:url];
        MPMoviePlayerViewController*  movieController = [[MPMoviePlayerViewController alloc] initWithContentURL:self.videoURL];
        [self presentMoviePlayerViewControllerAnimated:movieController];
        [movieController.moviePlayer play];
    }
    

}

- (void)finishedGetVimeoURL:(NSString *)url
{
   MPMoviePlayerViewController * _moviePlayerController = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:url]];
    [self presentViewController:_moviePlayerController animated:NO completion:nil];
}


- (void) moviePlayBackDidFinish:(NSNotification*)notification {
    MPMoviePlayerController *player = [notification object];
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:MPMoviePlayerPlaybackDidFinishNotification
     object:player];
    
    if ([player
         respondsToSelector:@selector(setFullscreen:animated:)])
    {
        [player.view removeFromSuperview];
    }
}

- (IBAction)backButtonClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end

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
    
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ShareTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    [cell.commentView removeFromSuperview];
    
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
            cell.bodyImage.hidden=true;
        }
        
    }else
    {
        cell.bodyImage.hidden=true;
    }
    

    
    
    contentHight1= cell.contentView.frame.size.height;
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

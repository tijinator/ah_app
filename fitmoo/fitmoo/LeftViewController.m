//
//  LeftViewController.m
//  fitmoo
//
//  Created by hongjian lin on 4/8/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import "LeftViewController.h"

@implementation LeftViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initFrames];
    _imageArray= [[NSArray alloc] initWithObjects: @"home.png",@"profile.png",@"shop.png",@"search.png",@"settings.png",@"logout.png", nil];
    _textArray= [[NSArray alloc] initWithObjects: @"HOME",@"PROFILE",@"FIT STORE",@"SEARCH",@"SETTINGS",@"LOGOUT", nil];
    
    [_leftTableView reloadData];
}

- (void) initFrames
{
    _leftTableView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_leftTableView respectToSuperFrame:self.view];
    _topView.frame= CGRectMake(0, 0, 275, 50);
    _topView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_topView respectToSuperFrame:self.view];
    
}


#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    
    return 6;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView
                                dequeueReusableCellWithIdentifier:@"leftCell"];
    

    UIImageView * imageView=(UIImageView *) [cell viewWithTag:3];
 //   imageView.frame= CGRectMake(25, 20, 20, 20);
    
    
    imageView.image= [UIImage imageNamed:[_imageArray objectAtIndex:indexPath.row]];
    
    UILabel *label= (UILabel *) [cell viewWithTag:2];
    label.text=[_textArray objectAtIndex:indexPath.row];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSString * key= [NSString stringWithFormat:@"%li",indexPath.row];
    
    if (indexPath.row==5) {
        User *localUser= [[UserManager sharedUserManager] getUserLocally];
        [[UserManager sharedUserManager] performLogout:localUser];
    }else
    {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"leftSideMenuAction" object:key];
    }
    
}

//// multy high table cell
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    return 53;
}


@end

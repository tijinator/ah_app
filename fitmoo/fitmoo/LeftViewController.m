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
    _imageArray= [[NSArray alloc] initWithObjects: @"mainmenu_houseicon.png",@"mainmenu_storeicon.png",@"mainmenu_followicon.png",@"mainmenu_settingsicon.png",@"logouticon.png", nil];
    _textArray= [[NSArray alloc] initWithObjects: @"Home",@"Shop",@"Follow",@"Settings",@"Logout", nil];
    
 //   [_leftTableView reloadData];
    
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, (self.view.frame.size.height - 54 * 5) / 2.0f, self.view.frame.size.width, 54 * 5) style:UITableViewStylePlain];
        tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.opaque = NO;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.backgroundView = nil;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.bounces = NO;
        tableView.scrollsToTop = NO;
        tableView;
    });
    [self.view addSubview:self.tableView];
    
    [self createObservers];
    
}

-(void)createObservers{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTopImage:) name:@"updateTopImage" object:nil];
}


- (void) updateTopImage: (NSNotification * ) note
{
    User * localuser= (User *) [note object];
 
    
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, _humanImage.frame.size.width, _humanImage.frame.size.height)];
    view.layer.cornerRadius=view.frame.size.width/2;
    view.clipsToBounds=YES;
    
    
    AsyncImageView *imageview=[[AsyncImageView alloc] initWithFrame:CGRectMake(0, 0, _humanImage.frame.size.width, _humanImage.frame.size.height)];
    imageview.userInteractionEnabled = NO;
    imageview.exclusiveTouch = NO;

    imageview.imageURL =[NSURL URLWithString:localuser.profile_avatar_thumb];
    
    [_humanImage.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    [view addSubview:imageview];
    [_humanImage addSubview:view];
    
    _nameLabel.text= localuser.name.uppercaseString;
    
}
//Making an AsynchronousRequest to get the image download
- (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock
{
    NSMutableURLRequest *request1 = [NSMutableURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request1
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if ( !error )
                               {
                                   UIImage *image = [[UIImage alloc] initWithData:data];
                                   completionBlock(YES,image);
                               } else{
                                   completionBlock(NO,nil);
                               }
                           }];
}

- (void) initFrames
{
//    _leftTableView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_leftTableView respectToSuperFrame:self.view];
//
//    _topImage.frame=CGRectMake(0, 0, 275, 50);
//    _topImage.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_topImage respectToSuperFrame:self.view];
    
     _nameLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_nameLabel respectToSuperFrame:self.view];
     _humanImage.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_humanImage respectToSuperFrame:self.view];
}


#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    
    return 5;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UITableViewCell *cell = [tableView
//                                dequeueReusableCellWithIdentifier:@"leftCell"];
//    
//
//    UIImageView * imageView=(UIImageView *) [cell viewWithTag:3];
// //   imageView.frame= CGRectMake(25, 20, 20, 20);
//    
//    
//    imageView.image= [UIImage imageNamed:[_imageArray objectAtIndex:indexPath.row]];
//    
//    UILabel *label= (UILabel *) [cell viewWithTag:2];
//    label.text=[_textArray objectAtIndex:indexPath.row];
    
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont fontWithName:@"BentonSans-Regular" size:17];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.highlightedTextColor = [UIColor lightGrayColor];
        cell.selectedBackgroundView = [[UIView alloc] init];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    
    cell.textLabel.text = _textArray[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:_imageArray[indexPath.row]];
    
    return cell;

  
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // 0 = Tapped yes
    if (buttonIndex == 1)
    {
       
        User *localUser= [[UserManager sharedUserManager] getUserLocally];
        [[UserManager sharedUserManager] performLogout:localUser];
    }
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSString * key= [NSString stringWithFormat:@"%li",indexPath.row];
    
    if (indexPath.row==4) {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Logout"
                                                       message:@"Are you sure you want to logout?"
                                                      delegate:self
                                             cancelButtonTitle:@"No"
                                             otherButtonTitles:@"Yes",nil];
        [alert show];
        
         [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:@"HasSeenPopup"];
       
    }
    else
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

//
//  LeftViewController.m
//  fitmoo
//
//  Created by hongjian lin on 4/8/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import "LeftViewController.h"
#import "AFNetworking.h"
@implementation LeftViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initFrames];
    _notifucationStatus=@"0";
    _prenotifucationStatus=@"1";
    _imageArray= [[NSArray alloc] initWithObjects: @"home.png",@"search.png",@"notification.png",@"shop.png",@"follow.png",@"purchases.png",@"earnings.png", nil];
    _textArray= [[NSArray alloc] initWithObjects: @"Home",@"Search",@"Notifications",@"Shop",@"Discover",@"My Purchases",@"My Earnings", nil];
    
    
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, (self.view.frame.size.height+30 - 54 * [_textArray count]) / 2.0f, self.view.frame.size.width, 54 *  [_textArray count]) style:UITableViewStylePlain];
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateNotificationStatus:) name:@"updateNotificationStatus" object:nil];
}
- (void) updateNotificationStatus: (NSNotification * ) note
{
   
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    _notifucationStatus=[prefs stringForKey:@"fitmooNotification"];
    
   // if (![_prenotifucationStatus isEqualToString:_notifucationStatus]) {
   //     _prenotifucationStatus=_notifucationStatus;
           [_tableView reloadData];
   // }
    
 
}

- (void) updateCartCount
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    User *localUser= [[UserManager sharedUserManager] localUser];
    NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:localUser.secret_id, @"secret_id", localUser.auth_token, @"auth_token",@"true", @"mobile",nil];
    NSString *url= [NSString stringWithFormat:@"%@%@",[[UserManager sharedUserManager] clientUrl], @"/api/cart/item_count"];
    [manager GET: url parameters:jsonDict success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSDictionary * responseDic= responseObject;
        NSNumber *cartNumber= [responseDic objectForKey:@"count"];
       
        [_cartButton setTitle:cartNumber.stringValue forState:UIControlStateNormal];
        
    } // success callback block
         failure:^(AFHTTPRequestOperation *operation, NSError *error){
             NSLog(@"Error: %@", error);} // failure callback block
     ];
    

    
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
    view.userInteractionEnabled = NO;
    view.exclusiveTouch = NO;

    imageview.imageURL =[NSURL URLWithString:localuser.profile_avatar_thumb];
    
    [_humanImage.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    [view addSubview:imageview];
    [_humanImage addSubview:view];
    _my_id=localuser.user_id;
    _nameLabel.text= localuser.name.uppercaseString;
    
    [self updateCartCount];
    
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
     _cartButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_cartButton respectToSuperFrame:self.view];
}


#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    
    return [_textArray count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
      //  cell.textLabel.font = [UIFont fontWithName:@"BentonSans" size:12];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.highlightedTextColor = [UIColor lightGrayColor];
        cell.selectedBackgroundView = [[UIView alloc] init];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
     NSString *text= [_textArray objectAtIndex:indexPath.row];
    NSMutableAttributedString *attributedString= [[NSMutableAttributedString alloc] initWithString:text.uppercaseString attributes:@{NSFontAttributeName: [UIFont fontWithName:@"BentonSans-Medium" size:12.5]}  ];
   
    float spacing = 1.0f;
    [attributedString addAttribute:NSKernAttributeName value:@(spacing) range:NSMakeRange(0, text.length)];

    
    
    [cell.textLabel setAttributedText:attributedString];

    
    
   
    cell.textLabel.text = text.uppercaseString;
    cell.imageView.image = [UIImage imageNamed:_imageArray[indexPath.row]];
    
    if (indexPath.row==2) {
        if ([_notifucationStatus isEqualToString:@"1"]) {
          cell.imageView.image = [UIImage imageNamed:@"rednotification.png"];
        }else
        {
          cell.imageView.image = [UIImage imageNamed:_imageArray[indexPath.row]];
        }
    }
    
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
    
    if (indexPath.row==0) {
         [[NSNotificationCenter defaultCenter] postNotificationName:@"leftSideMenuAction" object:@"home"];
    }else if (indexPath.row==1) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"leftSideMenuAction" object:@"search"];
    }else if (indexPath.row==2) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"leftSideMenuAction" object:@"notifications"];
    }else if (indexPath.row==3) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"leftSideMenuAction" object:@"shop"];
    }else if (indexPath.row==4) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"leftSideMenuAction" object:@"follow"];
    }else if (indexPath.row==5) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"leftSideMenuAction" object:@"purchases"];
    }else if (indexPath.row==6) {
        
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Logout"
//                                                       message:@"Are you sure you want to logout?"
//                                                      delegate:self
//                                             cancelButtonTitle:@"No"
//                                             otherButtonTitles:@"Yes",nil];
//        [alert show];
//        
//         [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:@"HasSeenPopup"];
        
         [[NSNotificationCenter defaultCenter] postNotificationName:@"leftSideMenuAction" object:@"earnings"];
       
    }
//    else
//    {
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"leftSideMenuAction" object:key];
//       
//    }
    
}

//// multy high table cell
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    return 53;
}


- (IBAction)humanButtonClick:(id)sender {
     [[NSNotificationCenter defaultCenter] postNotificationName:@"leftSideMenuAction" object:@"profile"];
}
- (IBAction)cartButtonClick:(id)sender {
     [[NSNotificationCenter defaultCenter] postNotificationName:@"leftSideMenuAction" object:@"cart"];
    
    
}
@end

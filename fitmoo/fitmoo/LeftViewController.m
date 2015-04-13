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
    
    [self createObservers];
    
}

-(void)createObservers{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTopImage:) name:@"updateTopImage" object:nil];
}


- (void) updateTopImage: (NSNotification * ) note
{
//    NSString *imageUrl= (NSString *) [note object];
//      AsyncImageView *toImage = [[AsyncImageView alloc] init];
//     [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:toImage];
//    if (imageUrl!=nil) {
//        toImage.imageURL =[NSURL URLWithString:imageUrl];
//    }else
//    {
//        toImage.imageURL =[NSURL URLWithString:@"https://fitmoo.com/assets/cover/profile-cover.png"];
//     
//    }
//       _topImage.image=toImage.image;
     NSString *imageUrl= (NSString *) [note object];
     if (imageUrl==nil) {
         imageUrl= @"https://fitmoo.com/assets/cover/profile-cover.png";
         
     }
    [self downloadImageWithURL:[NSURL URLWithString:imageUrl] completionBlock:^(BOOL succeeded, UIImage *image) {
        if (succeeded) {
            
            if (image!=nil) {
                _topImage.image = image;
              
            }else
            {
             //   imageLabel.image= [UIImage imageNamed:@"images"];
            }
            
            
            
        }
    }];
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
    _leftTableView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_leftTableView respectToSuperFrame:self.view];
//    _topView.frame= CGRectMake(0, 0, 275, 50);
//    _topView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_topView respectToSuperFrame:self.view];
    
 //   _topImage= [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 275, 50)];
    _topImage.frame=CGRectMake(0, 0, 275, 50);
    _topImage.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_topImage respectToSuperFrame:self.view];
    
  //  [_topView insertSubview:_topImage atIndex:0];
 //   [self.view insertSubview:_topImage aboveSubview:_topView];
 //   [self.view addSubview:_topImage];
    
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

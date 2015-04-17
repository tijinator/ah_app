//
//  BaseViewController.m
//  fitmoo
//
//  Created by hongjian lin on 4/10/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addfootButtonsForThree];
   
}

- (IBAction)openSideMenu:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"openSideMenu" object:Nil];
    
    
}

-(void) addfootButtonsForThree
{
     double Radio= self.view.frame.size.width / 320;
    
    _bottomView= [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-Radio*60, 320*Radio, 60*Radio)];
    
    
    _postButton= [[UIButton alloc] initWithFrame:CGRectMake(103, 12, 115,35)];
    _postPhoto= [[UIButton alloc] initWithFrame:CGRectMake(226, 12, 83,35)];
    _postVideo= [[UIButton alloc] initWithFrame:CGRectMake(12, 12, 83,35)];
    
 //   _bottomView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_bottomView respectToSuperFrame:self.view];
    _postButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_postButton respectToSuperFrame:self.view];
    _postPhoto.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_postPhoto respectToSuperFrame:self.view];
    _postVideo.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_postVideo respectToSuperFrame:self.view];
    
    
    _postButton.tag=11;
    _postPhoto.tag=12;
    _postVideo.tag=13;
    
    [_postButton addTarget:self action:@selector(footbuttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_postPhoto addTarget:self action:@selector(footbuttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_postVideo addTarget:self action:@selector(footbuttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *im= [UIImage imageNamed:@"like.png"];
    [_postButton setBackgroundImage:im forState:UIControlStateNormal];
    UIImage *im1= [UIImage imageNamed:@"home.png"];
    [_postPhoto setBackgroundImage:im1 forState:UIControlStateNormal];
    UIImage *im2= [UIImage imageNamed:@"share.png"];
    [_postVideo setBackgroundImage:im2 forState:UIControlStateNormal];
    
    [self.bottomView addSubview:_postButton];
    [self.bottomView addSubview:_postPhoto];
    [self.bottomView addSubview:_postVideo];
    
    [self.view addSubview:_bottomView];
    [self.view bringSubviewToFront:_bottomView];
}


- (IBAction)footbuttonClick:(id)sender {
   

    switch (((UIButton*)sender).tag) {
        case 11:
        
        
            break;
        case 12:
            
        
            
            break;
        case 13:
        
            
            break;
        default:
            break;
            
            
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

@end

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
    [self.view setBackgroundColor:[UIColor clearColor]];
    [self addfootButtonsForThree];
   
}

- (IBAction)openSideMenu:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"openSideMenu" object:Nil];
    
    
}

-(void) addfootButtonsForThree
{
     double Radio= self.view.frame.size.width / 320;
    
    _bottomView= [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-Radio*60, 320*Radio, 60*Radio)];
    
  
    _leftButton1= [[UIButton alloc] initWithFrame:CGRectMake(16, 12, 40,40)];
    _middleButton1= [[UIButton alloc] initWithFrame:CGRectMake(138, 12, 40,40)];
    _rightButton1= [[UIButton alloc] initWithFrame:CGRectMake(272, 12, 40,40)];
    
 //   _bottomView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_bottomView respectToSuperFrame:self.view];
    _leftButton1.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_leftButton1 respectToSuperFrame:self.view];
    _middleButton1.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_middleButton1 respectToSuperFrame:self.view];
    _rightButton1.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_rightButton1 respectToSuperFrame:self.view];
    
    
    _leftButton1.tag=11;
    _middleButton1.tag=12;
    _rightButton1.tag=13;
    
    [_leftButton1 addTarget:self action:@selector(footbuttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_middleButton1 addTarget:self action:@selector(footbuttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_rightButton1 addTarget:self action:@selector(footbuttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *im= [UIImage imageNamed:@"like.png"];
    [_leftButton1 setBackgroundImage:im forState:UIControlStateNormal];
    UIImage *im1= [UIImage imageNamed:@"home.png"];
    [_middleButton1 setBackgroundImage:im1 forState:UIControlStateNormal];
    UIImage *im2= [UIImage imageNamed:@"share.png"];
    [_rightButton1 setBackgroundImage:im2 forState:UIControlStateNormal];
    
    [self.bottomView addSubview:_leftButton1];
    [self.bottomView addSubview:_middleButton1];
    [self.bottomView addSubview:_rightButton1];
    
    [self.view addSubview:_bottomView];
    [self.view bringSubviewToFront:_bottomView];
    
    UISwipeGestureRecognizer *gestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeHandler:)];
    [gestureRecognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:gestureRecognizer];
    
//    UISwipeGestureRecognizer *gestureRecognizer1 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeHandlerForRight:)];
//    [gestureRecognizer1 setDirection:(UISwipeGestureRecognizerDirectionLeft)];
//    [self.view addGestureRecognizer:gestureRecognizer1];

    
}

-(void)swipeHandler:(UISwipeGestureRecognizer *)recognizer {
   
  [[NSNotificationCenter defaultCenter] postNotificationName:@"swipeHandler" object:Nil];
}

- (IBAction)footbuttonClick:(id)sender {
   

    switch (((UIButton*)sender).tag) {
        case 11:
        
       [[NSNotificationCenter defaultCenter] postNotificationName:@"swipeHandler" object:Nil];
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

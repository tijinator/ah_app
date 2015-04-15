//
//  ActionSheetViewController.m
//  fitmoo
//
//  Created by hongjian lin on 4/14/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import "ActionSheetViewController.h"

@interface ActionSheetViewController ()

@end

@implementation ActionSheetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initFrames];
    
    if ([_action isEqualToString:@"delete"]) {
    [_reportButton setTitle:@"Delete" forState:UIControlStateNormal];
     [_endorseButton setHidden:true];
    }else if ([_action isEqualToString:@"report"])
    {
    [_reportButton setTitle:@"Report" forState:UIControlStateNormal];
       [_endorseButton setHidden:true];
    }else
    {
        [_endorseButton setHidden:false];
    }
    // Do any additional setup after loading the view.
}

- (void) initFrames
{
  
    
    _endorseButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_endorseButton respectToSuperFrame:self.view];
    _cancelButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_cancelButton respectToSuperFrame:self.view];
    _reportButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_reportButton respectToSuperFrame:self.view];
    _blackView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_blackView respectToSuperFrame:self.view];
    _buttomView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_buttomView respectToSuperFrame:self.view];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch * touch = [touches anyObject];
    if(touch.phase == UITouchPhaseBegan) {
     //   [self disableViews];
        [self.view removeFromSuperview];
        
         }
}

- (void) disableViews
{
    
    
//    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
//        
//        
//        
//    }completion:^(BOOL finished){}];
    
//        [UIView beginAnimations:nil context:nil];
//        [UIView setAnimationDuration:0.5];
//        [UIView setAnimationDelay:0];
//     //   [UIView setAnimationDidStopSelector:@selector(closeView)];
//     //   [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
//        
//   //     self.buttomView.frame = CGRectMake(0, 0-self.buttomView.frame.size.height, self.buttomView.frame.size.width, self.buttomView.frame.size.height);
//    
//        [UIView commitAnimations];
    
}

- (void) closeView
{
    [self.view removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void )performAnimation:(UIView *)view
{
    
}

- (IBAction)endoseButtonClick:(id)sender {
      [[UserManager sharedUserManager] performEndorse:_postId];
    
}

- (IBAction)reportButtonClick:(id)sender {
    if ([_action isEqualToString:@"delete"]) {
        [[UserManager sharedUserManager] performDelete:_postId];
    }else if([_action isEqualToString:@"report"]) {
        
        [[UserManager sharedUserManager] performReport:_postId];
    }
}

- (IBAction)cancelButtonClick:(id)sender {
      [self.view removeFromSuperview];
  //  [self disableViews];
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

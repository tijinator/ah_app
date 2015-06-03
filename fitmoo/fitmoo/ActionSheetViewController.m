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
    
    if ([_action isEqualToString:@"share"]) {
        [self showShareViews];
    }else
    if ([_action isEqualToString:@"delete"]) {
    [_reportButton setTitle:@"Delete" forState:UIControlStateNormal];
     [_endorseButton setHidden:true];
        [self showViews];
    }else if ([_action isEqualToString:@"report"])
    {
    [_reportButton setTitle:@"Report" forState:UIControlStateNormal];
       [_endorseButton setHidden:true];
        [self showViews];
    }else
    {
        [_endorseButton setHidden:false];
        [self showViews];
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
    
    _shareCancelButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_shareCancelButton respectToSuperFrame:self.view];
    _shareButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_shareButton respectToSuperFrame:self.view];
    _shareButtomView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_shareButtomView respectToSuperFrame:self.view];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch * touch = [touches anyObject];
    if(touch.phase == UITouchPhaseBegan) {
     //   [self disableViews];
        [self.view removeFromSuperview];
        
         }
}

- (void) showShareViews
{
    
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelay:0];
    
    
    self.shareButtomView.frame = CGRectMake(0, self.view.frame.size.height-self.shareButtomView.frame.size.height, self.shareButtomView.frame.size.width, self.shareButtomView.frame.size.height);
    
    [UIView commitAnimations];
    
}

- (void) showViews
{
    

        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationDelay:0];
    
        
        self.buttomView.frame = CGRectMake(0, self.view.frame.size.height-self.buttomView.frame.size.height, self.buttomView.frame.size.width, self.buttomView.frame.size.height);
    
        [UIView commitAnimations];
    
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
      [self.view removeFromSuperview];
}

- (IBAction)reportButtonClick:(id)sender {
    if ([_action isEqualToString:@"delete"]) {
        [[UserManager sharedUserManager] performDelete:_postId];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateTable" object:_postId];
    }else if([_action isEqualToString:@"report"]) {
      
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Report"
                                                           message:@"Are you sure you want to send a report?"
                                                          delegate:self
                                                 cancelButtonTitle:@"No"
                                                 otherButtonTitles:@"Yes",nil];
            [alert show];
        
        
            [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:@"HasSeenPopup"];
        
        
      
    }
      [self.view removeFromSuperview];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // 0 = Tapped yes
    if (buttonIndex == 1)
    {
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

- (IBAction)shareClick:(id)sender {
    
     [[UserManager sharedUserManager] performShare:@"" withId:_postId];
     [self.view removeFromSuperview];
}

- (IBAction)shareCancelClick:(id)sender {
    [self.view removeFromSuperview];
}
@end

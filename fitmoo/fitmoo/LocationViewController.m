//
//  LocationViewController.m
//  fitmoo
//
//  Created by hongjian lin on 5/22/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import "LocationViewController.h"

@interface LocationViewController ()

@end

@implementation LocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initFrames];
    // Do any additional setup after loading the view.
}
- (void) initFrames
{
    _commingSoonImage= [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
    
     _commingSoonImage.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_commingSoonImage respectToSuperFrame:self.view];
    
    _commingSoonImage.image=[UIImage imageNamed:@"checkinscreen.png"];
    [self.view insertSubview:_commingSoonImage atIndex:0];
      _backButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_backButton respectToSuperFrame:self.view];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backButtonClick:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"leftSideMenuAction" object:@"6.1"];
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

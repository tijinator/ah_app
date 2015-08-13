//
//  InfluFactorViewController.m
//  fitmoo
//
//  Created by hongjian lin on 8/13/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import "InfluFactorViewController.h"

@interface InfluFactorViewController ()

@end

@implementation InfluFactorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initFrames];
    
    // Do any additional setup after loading the view.
}

- (void) initFrames
{

    _backButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_backButton respectToSuperFrame:self.view];
    _topView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_topView respectToSuperFrame:self.view];
    _titleLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_titleLabel respectToSuperFrame:self.view];
    
    _infoButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_infoButton respectToSuperFrame:self.view];
    _bodyLabel1.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_bodyLabel1 respectToSuperFrame:self.view];
    _bodyLabel2.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_bodyLabel2 respectToSuperFrame:self.view];
    _bodyLabel3.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_bodyLabel3 respectToSuperFrame:self.view];
    _bodyLabel4.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_bodyLabel4 respectToSuperFrame:self.view];
    
    _bodyLabel5.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_bodyLabel5 respectToSuperFrame:self.view];
    _bodyLabel6.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_bodyLabel6 respectToSuperFrame:self.view];
    _bodyLabel7.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_bodyLabel7 respectToSuperFrame:self.view];
    
    _bodyButton1.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_bodyButton1 respectToSuperFrame:self.view];
    _bodyButton2.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_bodyButton2 respectToSuperFrame:self.view];
    _bodyButton3.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_bodyButton3 respectToSuperFrame:self.view];
    _bodyButton4.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_bodyButton4 respectToSuperFrame:self.view];
    
    
    _view1.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_view1 respectToSuperFrame:self.view];
    _view2.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_view2 respectToSuperFrame:self.view];
    _view3.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_view3 respectToSuperFrame:self.view];
    _okButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_okButton respectToSuperFrame:self.view];
    _infoLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_infoLabel respectToSuperFrame:self.view];
    _view1.hidden=true;


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

- (IBAction)backButtonClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)InfoButtonClick:(id)sender {
    _view1.hidden=false;
    _backButton.hidden=true;
    _infoButton.hidden=true;
    
    [self.view bringSubviewToFront:_view1];
    
}
- (IBAction)okButtomClick:(id)sender {
    _view1.hidden=true;
    _backButton.hidden=false;
    _infoButton.hidden=false;
}
@end

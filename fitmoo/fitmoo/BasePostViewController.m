//
//  BasePostViewController.m
//  fitmoo
//
//  Created by hongjian lin on 4/28/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import "BasePostViewController.h"

@interface BasePostViewController ()

@end

@implementation BasePostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initFrames];
    // Do any additional setup after loading the view.
}

-(void) setTextPostFrame
{

}

-(void) setPicturePostFrame
{
  
}

-(void) setVideoPostFrame
{

}

-(void) initFrames
{
    _normalPostView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_normalPostView respectToSuperFrame:self.view];
    _normalPostImage.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_normalPostImage respectToSuperFrame:self.view];
    _normalPostText.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_normalPostText respectToSuperFrame:self.view];
    _workoutView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_workoutView respectToSuperFrame:self.view];
    _workoutTitle.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_workoutTitle respectToSuperFrame:self.view];

    _workoutInstruction.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_workoutInstruction respectToSuperFrame:self.view];
    _nutritionView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_nutritionView respectToSuperFrame:self.view];
    _nutritionTitle.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_nutritionTitle respectToSuperFrame:self.view];
    _nutritionIngedients.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_nutritionIngedients respectToSuperFrame:self.view];
    _nutritionPreparation.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_nutritionPreparation respectToSuperFrame:self.view];
 
    _buttonView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_buttonView respectToSuperFrame:self.view];
    _NormalPostButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_NormalPostButton respectToSuperFrame:self.view];
    _WorkoutButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_WorkoutButton respectToSuperFrame:self.view];
    _NutritionButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_NutritionButton respectToSuperFrame:self.view];

    _topView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_topView respectToSuperFrame:self.view];
    _backButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_backButton respectToSuperFrame:self.view];
    _SubmitButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_SubmitButton respectToSuperFrame:self.view];

    

    
    
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

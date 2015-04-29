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
    [self defineTypeOfPost];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(presentCameraView) userInfo:nil repeats:NO];
    [self createObservers];
    
  //  [self presentCameraView];
    // Do any additional setup after loading the view.
}

-(void)createObservers{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateImages" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateImages:) name:@"updateImages" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"makePostFinished" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(makePostFinished:) name:@"makePostFinished" object:nil];
}

-(void) makePostFinished: (NSNotification * ) note
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) updateImages: (NSNotification * ) note
{
    _PostImage= (UIImage * ) [note object];
    [_normalPostImage setBackgroundImage:self.PostImage forState:UIControlStateNormal];
    [_workoutPostImage setBackgroundImage:self.PostImage forState:UIControlStateNormal];
    [_nutritionPostImage setBackgroundImage:self.PostImage forState:UIControlStateNormal];

}

//-(void)viewDidAppear:(BOOL)animated
//{
//    if (self.PostImage==nil) {
//        
//    }else
//    {
//        [self defineTypeOfPost];
//    }
//}

- (void) defineTypeOfPost
{
    if ([self.postType isEqualToString:@"post"]) {
        [self setPostFrame];
    }else  if ([self.postType isEqualToString:@"nutrition"]) {
        [self setNutritionFrame];
    }else  if ([self.postType isEqualToString:@"workout"]) {
        [self setWorkoutFrame];
    }
}

-(void) presentCameraView
{
 
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    _overlay = [mainStoryboard instantiateViewControllerWithIdentifier:@"CameraViewController"];
    
    _picker = [[UIImagePickerController alloc] init];
    _picker.allowsEditing = YES;
    _picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.picker.showsCameraControls = NO;
    self.picker.navigationBarHidden = YES;
    self.picker.toolbarHidden = YES;
    
    self.overlay.picker = self.picker;
    self.picker.cameraOverlayView = self.overlay.view;
    self.picker.delegate = self.overlay;
    
    [self presentViewController:_picker animated:YES completion:NULL];
    
 
}

-(void) setPostFrame
{
    _normalPostView.frame= CGRectMake(0, 127, _normalPostView.frame.size.width, _normalPostView.frame.size.height);
    _normalPostView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_normalPostView respectToSuperFrame:self.view];
    _normalPostView.hidden=false;
    _workoutView.hidden=true;
    _nutritionView.hidden=true;
    [_normalPostImage setBackgroundImage:self.PostImage forState:UIControlStateNormal];
 //   _normalPostImage.image= self.PostImage;
  //  [_normalPostText setp]
    
}

-(void) setWorkoutFrame
{
    _workoutView.frame= CGRectMake(0, 127, _workoutView.frame.size.width, _workoutView.frame.size.height);
    _workoutView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_workoutView respectToSuperFrame:self.view];
    [_workoutPostImage  setBackgroundImage:self.PostImage forState:UIControlStateNormal];
  //   _workoutPostImage.image= self.PostImage;
    _normalPostView.hidden=true;
    _workoutView.hidden=false;
    _nutritionView.hidden=true;
}

-(void) setNutritionFrame
{
    _nutritionView.frame= CGRectMake(0, 127, _nutritionView.frame.size.width, _nutritionView.frame.size.height);
    _nutritionView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_nutritionView respectToSuperFrame:self.view];
    _normalPostView.hidden=true;
    _workoutView.hidden=true;
    _nutritionView.hidden=false;
     [_nutritionPostImage  setBackgroundImage:self.PostImage forState:UIControlStateNormal];
  //  _nutritionPostImage.image= self.PostImage;
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



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch * touch = [touches anyObject];
    if(touch.phase == UITouchPhaseBegan) {
        //   [self disableViews];
     
        [_workoutTitle resignFirstResponder];
        [_workoutInstruction resignFirstResponder];
        [_normalPostText resignFirstResponder];
        [_nutritionTitle resignFirstResponder];
        [_nutritionIngedients resignFirstResponder];
        [_nutritionPreparation resignFirstResponder];
    }
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)postImageButtonClick:(id)sender {
    
    [self presentCameraView];
    
}

- (IBAction)cancelButtonClick:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)postButtonClick:(id)sender {
    
    if (self.PostImage==nil) {
        
        if ([self.postType isEqualToString:@"post"]) {
            if ([_normalPostText.text isEqualToString:@""]) {
                UIAlertView *alert = [[ UIAlertView alloc ] initWithTitle : @"Could not Post"
                                                                  message : @"text can not be empty" delegate : nil cancelButtonTitle : @"OK"
                                                        otherButtonTitles : nil ];
                [alert show ];
            }else
            {
            NSDictionary *photos_attributes= [[NSDictionary alloc] initWithObjectsAndKeys: nil];
            NSDictionary *feed= [[NSDictionary alloc] initWithObjectsAndKeys: _normalPostText.text, @"text",photos_attributes, @"photos_attributes", nil];
           
            [ [UserManager sharedUserManager] performPost:feed];
            }
            
        }else  if ([self.postType isEqualToString:@"nutrition"]) {
            if ([_nutritionTitle.text isEqualToString:@""]) {
                UIAlertView *alert = [[ UIAlertView alloc ] initWithTitle : @"Could not Post"
                                                                  message : @"title can not be empty" delegate : nil cancelButtonTitle : @"OK"
                                                        otherButtonTitles : nil ];
                [alert show ];
            }else
            {
                if ([_nutritionPreparation.text isEqualToString:@""]&&[_nutritionIngedients.text isEqualToString:@""]) {
                    UIAlertView *alert = [[ UIAlertView alloc ] initWithTitle : @"Could not Post"
                                                                      message : @"Ingrediens and Preparation can not be both empty" delegate : nil cancelButtonTitle : @"OK"
                                                            otherButtonTitles : nil ];
                    [alert show ];
                }else
                {
            NSDictionary *photos_attributes= [[NSDictionary alloc] initWithObjectsAndKeys: nil];
            NSDictionary *nutrition_attributes= [[NSDictionary alloc] initWithObjectsAndKeys: _nutritionTitle.text, @"title",_nutritionIngedients.text, @"ingredients",_nutritionPreparation.text, @"preparation", nil];
            NSDictionary *feed= [[NSDictionary alloc] initWithObjectsAndKeys: nutrition_attributes, @"nutrition_attributes",photos_attributes, @"photos_attributes", nil];
            [ [UserManager sharedUserManager] performPost:feed];
            }
            }
          
        }else  if ([self.postType isEqualToString:@"workout"]) {
            if ([_workoutTitle.text isEqualToString:@""]) {
                UIAlertView *alert = [[ UIAlertView alloc ] initWithTitle : @"Could not Post"
                                                                  message : @"title can not be empty" delegate : nil cancelButtonTitle : @"OK"
                                                        otherButtonTitles : nil ];
                [alert show ];
            }else
            {
                if ([_workoutInstruction.text isEqualToString:@""]) {
                    UIAlertView *alert = [[ UIAlertView alloc ] initWithTitle : @"Could not Post"
                                                                      message : @"Instruction can not be both empty" delegate : nil cancelButtonTitle : @"OK"
                                                            otherButtonTitles : nil ];
                    [alert show ];
                }else
                {
                    NSDictionary *photos_attributes= [[NSDictionary alloc] initWithObjectsAndKeys: nil];
                    NSDictionary *feed= [[NSDictionary alloc] initWithObjectsAndKeys: _workoutInstruction.text, @"text",_workoutTitle.text, @"workout_title",photos_attributes, @"photos_attributes", nil];
                    
                    [ [UserManager sharedUserManager] performPost:feed];
                }
            }
            
            
            
           
        }
        
    }else
    {
        if ([self.postType isEqualToString:@"post"]) {
            
            
          
        }else  if ([self.postType isEqualToString:@"nutrition"]) {
           
        }else  if ([self.postType isEqualToString:@"workout"]) {
          
        }
    }
    
  
}
- (IBAction)nutritionButtonClick:(id)sender {
    _postType=@"nutrition";
    [self defineTypeOfPost];
}

- (IBAction)normalPostButtonClick:(id)sender {
    
    _postType=@"post";
    [self defineTypeOfPost];
}

- (IBAction)workoutButtonClick:(id)sender {
    _postType=@"workout";
    [self defineTypeOfPost];
}


@end

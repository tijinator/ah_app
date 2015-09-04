//
//  WorkTypeViewController.m
//  fitmoo
//
//  Created by hongjian lin on 7/23/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import "WorkTypeViewController.h"

@interface WorkTypeViewController ()
{
      double frameRadio;
      double ticks;
}
@end

@implementation WorkTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initFrames];
    self.tableview.tableFooterView = [[UIView alloc] init];
   
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{

//    if ([_searchTypeArray count]>0) {
//        return [_searchTypeArray count]+1;
//    }
    
    if ([_searchTermField.text isEqualToString:@""]) {
        if ([_totalTypeArray count]>10) {
            return 11;
        }else
        {
            return [_totalTypeArray count]+1;
        }
    }
    
    return [_searchTypeArray count]+1;
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.row==0) {
         UITableViewCell * cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell1"];
        
        
        UILabel *nameLabel=[[UILabel alloc] init];
        nameLabel.frame= CGRectMake(10, 5, 300, 42);
        nameLabel.numberOfLines=2;
        nameLabel.textAlignment=NSTextAlignmentCenter;
        nameLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:nameLabel respectToSuperFrame:self.view];
        
        if ([_searchTermField.text isEqualToString:@""]) {
            nameLabel.text=@"SUGGESTED FOR YOU";
        }else
        {
        nameLabel.text=[NSString stringWithFormat:@"Don't see your workout? Use \"%@\"", _searchTermField.text];
            nameLabel.numberOfLines=1;
        }
        nameLabel.textColor= [UIColor colorWithRed:16.0/255.0 green:156.0/255.0 blue:251.0/255.0 alpha:1.0f];
        UIFont *font = [UIFont fontWithName:@"BentonSans-Medium" size:14];
        NSMutableAttributedString *attributedString= [[NSMutableAttributedString alloc] initWithString:nameLabel.text attributes:@{NSFontAttributeName: font}  ];
        
        [nameLabel setAttributedText:attributedString];
        
        [cell.contentView addSubview:nameLabel];
         cell.selectionStyle= UITableViewCellSelectionStyleNone;
        return cell;

        
    }
    
    
    
    
    
    UITableViewCell * cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell1"];
    
    UILabel *nameLabel=[[UILabel alloc] init];
    nameLabel.frame= CGRectMake(30, 5, 225, 42);
    nameLabel.numberOfLines=2;
    nameLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:nameLabel respectToSuperFrame:self.view];
    
    if ([_searchTermField.text isEqualToString:@""]) {
    
    Workout *workout=[_totalTypeArray objectAtIndex:indexPath.row-1];
    nameLabel.text= workout.workout_type;
    
    }else
    {
        Workout *workout=[_searchTypeArray objectAtIndex:indexPath.row-1];
        nameLabel.text= workout.workout_type;
    }
    
    UIFont *font = [UIFont fontWithName:@"BentonSans-Medium" size:14];
    NSMutableAttributedString *attributedString= [[NSMutableAttributedString alloc] initWithString:nameLabel.text attributes:@{NSFontAttributeName: font}  ];
    
    [nameLabel setAttributedText:attributedString];

    [cell.contentView addSubview:nameLabel];
     cell.selectionStyle= UITableViewCellSelectionStyleNone;
    return cell;

    
}


- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row==0) {
        
          if (![_searchTermField.text isEqualToString:@""]) {
        _workoutTypeLabel.text=_searchTermField.text;
        _workoutTypeLabel.textColor=[UIColor blackColor];
        [_searchTermField resignFirstResponder];
        [self.view removeFromSuperview];
          }
    }else
    {
        
        if ([_searchTermField.text isEqualToString:@""]) {
            Workout *tempWorkout=[_totalTypeArray objectAtIndex:indexPath.row-1];
            _workoutTypeLabel.text=tempWorkout.workout_type;
            _workoutTypeLabel.textColor=[UIColor blackColor];
            
            _workoutDetailTextview.text=tempWorkout.detail;
            [_searchTermField resignFirstResponder];
            [self.view removeFromSuperview];
        }else
        {
        
    Workout *tempWorkout=[_searchTypeArray objectAtIndex:indexPath.row-1];
    _workoutTypeLabel.text=tempWorkout.workout_type;
    _workoutTypeLabel.textColor=[UIColor blackColor];
        
    _workoutDetailTextview.text=tempWorkout.detail;
    [_searchTermField resignFirstResponder];
    [self.view removeFromSuperview];
        }
    }
}

// multy high table cell
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    

    return 45*frameRadio;
}


- (void) initFrames
{
 
    frameRadio=[[FitmooHelper sharedInstance] frameRadio];
    _tableview.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_tableview respectToSuperFrame:nil];
    _doneButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_doneButton respectToSuperFrame:nil];
    _doneButton.layer.cornerRadius=3.0f;
    _topView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_topView respectToSuperFrame:nil];
    
    
    _searchTermField.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_searchTermField respectToSuperFrame:self.view];
    _searchTermField.layer.cornerRadius=3.0f;
    
    _totalTypeArray=  [[UserManager sharedUserManager] workoutTypesArray];
    [_searchTermField addTarget:self
                         action:@selector(textFieldDidChange:)
               forControlEvents:UIControlEventEditingChanged];
}

- (void)timerTick:(NSTimer *)timer
{
    
    ticks += 0.1;
    double seconds = fmod(ticks, 60.0);
    
    if (seconds>=0.5 && seconds<0.6) {
        _searchTypeArray=[[NSMutableArray alloc] init];
        for (Workout *temworkout in _totalTypeArray) {
            if ([temworkout.workout_type.lowercaseString rangeOfString:_searchTypeName].location != NSNotFound) {
              
                  [_searchTypeArray addObject:temworkout];
            }
        }
        
        [self.tableview reloadData];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
   
    textField.spellCheckingType = UITextSpellCheckingTypeNo;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
 
    return YES;
}


- (void)textFieldDidChange:(UITextField *)textField
{
    [_timer invalidate];
    ticks=0;
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerTick:) userInfo:nil repeats:YES];
    _searchTypeName=textField.text;
    

    
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

- (IBAction)doneButtonClick:(id)sender {
     [_timer invalidate];
    _workoutTypeLabel.text=_searchTermField.text;
    _workoutTypeLabel.textColor=[UIColor blackColor];
    [_searchTermField resignFirstResponder];
    [self.view removeFromSuperview];

    
}
@end

//
//  BioViewController.m
//  fitmoo
//
//  Created by hongjian lin on 5/12/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import "BioViewController.h"

@interface BioViewController ()

@end

@implementation BioViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initFrames];
    
    UIFont *font = [UIFont fontWithName:@"BentonSans-Book" size:14];
    NSMutableAttributedString *attributedString= [[NSMutableAttributedString alloc] initWithString:_bioText attributes:@{NSFontAttributeName: font}  ];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:6];
    [attributedString addAttribute:NSParagraphStyleAttributeName
                             value:style
                             range:NSMakeRange(0, _bioText.length)];
    
  
    
    _bioTextView.attributedText=attributedString;
    _bioTextView.allowsEditingTextAttributes=false;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) initFrames
{
   
    _topview.frame= CGRectMake(0, 0, 320, 73);
    _topview.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_topview respectToSuperFrame:self.view];
    _bioLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_bioLabel respectToSuperFrame:self.view];
    _bioTextView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_bioTextView respectToSuperFrame:self.view];
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backButtonClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES ];
 //      [self dismissViewControllerAnimated:YES completion:nil];
}
@end

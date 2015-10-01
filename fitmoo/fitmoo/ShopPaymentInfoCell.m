//
//  ShopPaymentInfoCell.m
//  fitmoo
//
//  Created by hongjian lin on 9/10/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import "ShopPaymentInfoCell.h"
#import "FitmooHelper.h"
@implementation ShopPaymentInfoCell

- (void)awakeFromNib {
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField
{
    
     [[textField layer] setBorderWidth:0.0f];
    return YES;
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

- (void) resetCell
{
    _cardNumber.text=@"";
    _cvc.text= @"";
    _date.text=@"Month";
    _year.text=@"Year";
    _cardType.text=@"Card Type";
    [_editButton setTitle:@"USE EXISTING CARD" forState:UIControlStateNormal];
    
    UIColor *color= [UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0f];
    
    _date.textColor=color;
    _year.textColor=color;
    _cardType.textColor=color;
    _cvc.hidden=false;
    
}

- (void) initFrames
{
    
    self.contentView.frame=[[FitmooHelper sharedInstance] resizeFrameWithFrame:self.contentView respectToSuperFrame:nil];
    _cardNumber.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_cardNumber respectToSuperFrame:nil];
    _cardType.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_cardType respectToSuperFrame:nil];
    _date.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_date respectToSuperFrame:nil];
    _year.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_year respectToSuperFrame:nil];
    _cvc.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_cvc respectToSuperFrame:nil];
    _editButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_editButton respectToSuperFrame:nil];

     
}

@end

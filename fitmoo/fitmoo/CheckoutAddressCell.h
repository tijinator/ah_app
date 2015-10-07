//
//  CheckoutAddressCell.h
//  fitmoo
//
//  Created by hongjian lin on 9/10/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckoutAddressCell : UITableViewCell<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextField *AddressTextField;
@property (strong, nonatomic) IBOutlet UITextField *cityTextField;
@property (strong, nonatomic) IBOutlet UILabel *stateTextField;
@property (strong, nonatomic) IBOutlet UITextField *phoneTextField;
@property (strong, nonatomic) IBOutlet UITextField *zipTextField;
@property (strong, nonatomic) IBOutlet UITextField *Address2TextField;

@property (strong, nonatomic) IBOutlet UIButton *useShippingButton;


@end

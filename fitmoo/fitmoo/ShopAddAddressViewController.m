//
//  ShopAddAddressViewController.m
//  fitmoo
//
//  Created by hongjian lin on 9/11/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import "ShopAddAddressViewController.h"
#import <SwipeBack/SwipeBack.h>
#import "AFNetworking.h"
@interface ShopAddAddressViewController ()
{
    NSNumber * contentHight;
    NSInteger selectedIndex;
}
@end

@implementation ShopAddAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.swipeBackEnabled = YES;
    selectedIndex=0;
    contentHight=[NSNumber numberWithInteger:260*[[FitmooHelper sharedInstance] frameRadio]];
    [self initFrames];
    
    _pickerDisplayArray=[[NSMutableArray alloc] init];
 //   _stateArray=[[NSMutableArray alloc] init];
    [self createObservers];
   
    // Do any additional setup after loading the view.
}



-(void)createObservers{
  
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"hidePicker" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hidePicker:) name:@"hidePicker" object:nil];
}


- (void) hidePicker: (NSNotification * ) note
{
    
    _typePickerView.hidden=true;
    
}

#pragma mark - APICalls


- (void) updateAddress
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    User *localUser= [[UserManager sharedUserManager] localUser];
    NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:localUser.secret_id, @"secret_id", localUser.auth_token, @"auth_token",@"true", @"mobile",_address.full_name, @"full_name",_address.address1, @"address1",_address.address2, @"address2",_address.city, @"city",_address.city, @"zipcode",_address.state_id, @"state_id",_address.phone, @"phone",_address.address_id, @"id",nil];
    NSString *url= [NSString stringWithFormat:@"%@%@",[[UserManager sharedUserManager] clientUrl], @"/api/cart/address_edit"];
    [manager POST: url parameters:jsonDict success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        UIAlertView *alert = [[ UIAlertView alloc ] initWithTitle : @"Address Saved"
                                                          message : @"" delegate : nil cancelButtonTitle : @"OK"
                                                otherButtonTitles : nil ];
        [alert show ];
        
        
        [self.navigationController popViewControllerAnimated:YES];
    } // success callback block
          failure:^(AFHTTPRequestOperation *operation, NSError *error){
              NSLog(@"Error: %@", error);} // failure callback block
     ];

}

- (void) createAddress
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    NSString *address_type_id=@"1";
    if ([_addreeType isEqualToString:@"add shipping address"]) {
        address_type_id=@"2";
    }
    
    User *localUser= [[UserManager sharedUserManager] localUser];
    NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:localUser.secret_id, @"secret_id", localUser.auth_token, @"auth_token",@"true", @"mobile",_address.full_name, @"full_name",_address.address1, @"address1",_address.address2, @"address2",_address.city, @"city",_address.zipcode, @"zipcode",_address.phone, @"phone",_address.state_id, @"state_id",address_type_id, @"address_type_id",nil];
    NSString *url= [NSString stringWithFormat:@"%@%@",[[UserManager sharedUserManager] clientUrl], @"/api/cart/address_create"];
    [manager POST: url parameters:jsonDict success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        UIAlertView *alert = [[ UIAlertView alloc ] initWithTitle : @"Address Saved"
                                                          message : @"" delegate : nil cancelButtonTitle : @"OK"
                                                otherButtonTitles : nil ];
        [alert show ];
        NSDictionary *dic= (NSDictionary *) responseObject;
        
        Address *ad= [[FitmooHelper sharedInstance] parseAddress:dic];
        
        [_addressArray addObject:ad];
         [self.navigationController popViewControllerAnimated:YES];
    } // success callback block
          failure:^(AFHTTPRequestOperation *operation, NSError *error){
              NSLog(@"Error: %@", error);} // failure callback block
     ];
}




- (void) initFrames
{
    _tableView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_tableView respectToSuperFrame:self.view];
    _topView.frame= CGRectMake(0, 0, 320, 60);
    _topView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_topView respectToSuperFrame:self.view];
    _leftButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_leftButton respectToSuperFrame:self.view];
    
    _titleLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_titleLabel respectToSuperFrame:self.view];
    
    _BuyNowButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_BuyNowButton respectToSuperFrame:self.view];
    
    _typePickerView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_typePickerView respectToSuperFrame:nil];
    
    double x1=(self.view.frame.size.width-_typePicker.frame.size.width)/2;
    _typePicker.frame= CGRectMake(_typePicker.frame.origin.x+x1, _typePicker.frame.origin.y*[[FitmooHelper sharedInstance] frameRadio], _typePicker.frame.size.width, _typePicker.frame.size.height);
    _doneButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_doneButton respectToSuperFrame:nil];
    _pickerBackView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_pickerBackView respectToSuperFrame:nil];
    
    
    
    if (self.view.frame.size.height<500) {
        
        _tableView.frame= CGRectMake(_tableView.frame.origin.x,_tableView.frame.origin.y, _tableView.frame.size.width, _tableView.frame.size.height-88);
        
    }
    
    
    
    
}

#pragma mark - UIPickerViewDelegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
    
    if ([_pickerDisplayArray count]>0) {
        
        if ([_pickerType isEqualToString:@"state"]) {
            State *tempState= [_pickerDisplayArray objectAtIndex:row];
      //      _stateLabel.text= [NSString stringWithFormat:@"%@ - %@",tempState.abbr, tempState.name ];
            _stateLabel.text= [NSString stringWithFormat:@"%@",tempState.abbr];
            _stateLabel.textColor=[UIColor blackColor];
            
        }else
        {
            
        }
        
    }
    
    
    
    // Handle the selection
}

// tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSUInteger numRows = [_pickerDisplayArray count];
    return numRows;
}

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// tell the picker the title for a given component
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *title=@"";
    if ([_pickerDisplayArray count]>0) {
        
        if ([_pickerType isEqualToString:@"state"]) {
            State *tempState= [_pickerDisplayArray objectAtIndex:row];
            
         //   title= [NSString stringWithFormat:@"%@ - %@",tempState.abbr, tempState.name ];
            title=tempState.abbr;
        }else
        {
            title=[_pickerDisplayArray objectAtIndex:row];
        }
        
    }
    
    
    
    
    return title;
}

// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    int sectionWidth = 300;
    
    return sectionWidth;
}




#pragma mark - UITableViewDelegate


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{

    
    return 1;
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    

        CheckoutAddressCell *cell =(CheckoutAddressCell *) [self.tableView cellForRowAtIndexPath:indexPath];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CheckoutAddressCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        UITapGestureRecognizer *tapGestureRecognizer10 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(StateButtonClick:)];
        tapGestureRecognizer10.numberOfTapsRequired = 1;
        [cell.stateTextField addGestureRecognizer:tapGestureRecognizer10];
        cell.stateTextField.userInteractionEnabled=YES;
        _stateLabel= cell.stateTextField;
        
    
        if (_address!=nil) {
        
            cell.nameTextField.text=_address.full_name;
            cell.AddressTextField.text=_address.address1;
            cell.cityTextField.text=_address.city;
            
            if ([_address.state_name isEqual:[NSNull null]]) {
              
            cell.stateTextField.textColor=[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0f];
                
            }else {
            cell.stateTextField.text=_address.state_name;
            cell.stateTextField.textColor=[UIColor blackColor];
            }
            cell.phoneTextField.text=_address.phone;
            cell.zipTextField.text=_address.zipcode;
         
            
            cell.Address2TextField.text=_address.address2;
            
        }
    
        _nameTextField=cell.nameTextField;
        _AddressTextField=cell.AddressTextField;
        _cityTextField=cell.cityTextField;
        _stateTextField=cell.stateTextField;
        _phoneTextField=cell.phoneTextField;
        _zipTextField=cell.zipTextField;
        _stateTextField=cell.stateTextField;
        _Address2TextField=cell.Address2TextField;
    
    
        [cell.nameTextField setReturnKeyType:UIReturnKeyDone];
        [cell.AddressTextField setReturnKeyType:UIReturnKeyDone];
        [cell.Address2TextField setReturnKeyType:UIReturnKeyDone];
        [cell.cityTextField setReturnKeyType:UIReturnKeyDone];
        [cell.zipTextField setReturnKeyType:UIReturnKeyDone];
        [cell.phoneTextField setReturnKeyType:UIReturnKeyDone];
    
        
        contentHight=[NSNumber numberWithInt:cell.contentView.frame.size.height];
        
        return cell;
        
    
    
}



- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    
    
}

// multy high table cell
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    return contentHight.intValue;
}


-(void) resignFirstResps
{
   
    
    [_phoneTextField resignFirstResponder];
    [_zipTextField resignFirstResponder];
    [_Address2TextField resignFirstResponder];
    [_nameTextField resignFirstResponder];
    [_AddressTextField resignFirstResponder];
    [_cityTextField resignFirstResponder];
  
    
}



- (IBAction)BuyNowButtonClick:(id)sender
{
 //   [self createAddress];
    
    if ([self ValidateAllFields]==false) {
        return;
    }
    
    
    bool createNew=false;
    if (_address==nil) {
        createNew=true;
        _address=[[Address alloc] init];
    }else
    {
        createNew=false;
   
        
    }
    
    _address.full_name=_nameTextField.text;
    _address.city=_cityTextField.text;
    _address.phone=_phoneTextField.text;
    _address.state_name=_stateTextField.text;
    _address.zipcode=_zipTextField.text;
    _address.full_name=_nameTextField.text;
    _address.address1=_AddressTextField.text;
    _address.address2=_Address2TextField.text;
    
    
    
    _address.state_id=[[FitmooHelper sharedInstance] findStageId:_stateTextField.text withArray:_stateArray];
    
    if (createNew==false) {
        for (int i=0; i<[_addressArray count]; i++) {
            Address *ad= [_addressArray objectAtIndex:i];
        
            if ([_address.address_id isEqualToString:ad.address_id]) {
                [_addressArray replaceObjectAtIndex:i withObject:_address];
            }
        }
        
        [self updateAddress];
    }else
    {
      
         [self createAddress];
    }
   
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didPostAddressFinished" object:_addressArray];

}
- (IBAction)doneButtonClick:(id)sender
{
    _typePickerView.hidden=true;
}

- (IBAction)StateButtonClick:(id)sender {
    [self resignFirstResps];
    _typePickerView.hidden=false;
    _pickerType=@"state";
    _pickerDisplayArray=[_stateArray mutableCopy];
    [_typePicker reloadAllComponents];
    [self.view bringSubviewToFront:_typePickerView];
}

- (IBAction)sectionHeaderClick:(id)sender {
    UIView *v = (UIView *)[(UIGestureRecognizer *)sender view];
    
    selectedIndex= v.tag;
    
    [self.tableView reloadData:YES];
}





- (IBAction)backButtonClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL) ValidateAllFields
{
    
    
    if ([_nameTextField.text isEqualToString:@""]) {
        UIAlertView *alert = [[ UIAlertView alloc ] initWithTitle : @"Oops"
                                                          message : @"Please type your name." delegate : nil cancelButtonTitle : @"OK"
                                                otherButtonTitles : nil ];
        [alert show ];
        return false;
    }
    
    if ([_AddressTextField.text isEqualToString:@""]) {
        UIAlertView *alert = [[ UIAlertView alloc ] initWithTitle : @"Oops"
                                                          message : @"Please enter your address1." delegate : nil cancelButtonTitle : @"OK"
                                                otherButtonTitles : nil ];
        [alert show ];
        return false;
    }
    
    if ([_cityTextField.text isEqualToString:@""]) {
        UIAlertView *alert = [[ UIAlertView alloc ] initWithTitle : @"Oops"
                                                          message : @"Please enter your city." delegate : nil cancelButtonTitle : @"OK"
                                                otherButtonTitles : nil ];
        [alert show ];
        return false;
    }
    
    if ([_stateLabel.text isEqualToString:@"State"]) {
        UIAlertView *alert = [[ UIAlertView alloc ] initWithTitle : @"Oops"
                                                          message : @"Please select a state." delegate : nil cancelButtonTitle : @"OK"
                                                otherButtonTitles : nil ];
        [alert show ];
        return false;
    }
    
    if ([_zipTextField.text isEqualToString:@""]) {
        UIAlertView *alert = [[ UIAlertView alloc ] initWithTitle : @"Oops"
                                                          message : @"Please enter your zip code." delegate : nil cancelButtonTitle : @"OK"
                                                otherButtonTitles : nil ];
        [alert show ];
        return false;
    }
    
    if ([_phoneTextField.text isEqualToString:@""]) {
        UIAlertView *alert = [[ UIAlertView alloc ] initWithTitle : @"Oops"
                                                          message : @"Please enter your phone." delegate : nil cancelButtonTitle : @"OK"
                                                otherButtonTitles : nil ];
        [alert show ];
        return false;
    }
    
    
    if ([[FitmooHelper sharedInstance] checkStringIsNumberOnly:_zipTextField.text]==false) {
        UIAlertView *alert = [[ UIAlertView alloc ] initWithTitle : @"Oops"
                                                          message : @"Please enter number only for your zip code." delegate : nil cancelButtonTitle : @"OK"
                                                otherButtonTitles : nil ];
        [alert show ];
        return false;
    }
    
    
//    if ([[FitmooHelper sharedInstance] checkStringIsNumberOnly:_phoneTextField.text]==false) {
//        UIAlertView *alert = [[ UIAlertView alloc ] initWithTitle : @"Oops"
//                                                          message : @"Please enter number only for your phone number." delegate : nil cancelButtonTitle : @"OK"
//                                                otherButtonTitles : nil ];
//        [alert show ];
//        return false;
//    }
    
    return true;
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

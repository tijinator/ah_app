//
//  ShopCheckoutViewController.m
//  fitmoo
//
//  Created by hongjian lin on 9/9/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import "ShopCheckoutViewController.h"
#import <SwipeBack/SwipeBack.h>
#import "AFNetworking.h"
#import "Stripe.h"
#import "UserManager.h"
@interface ShopCheckoutViewController ()
{
      NSNumber * contentHight;
      NSInteger selectedIndex;
      UIView *indicatorView;
    
      bool validate;
}
@end

@implementation ShopCheckoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.swipeBackEnabled = YES;
    selectedIndex=0;
    contentHight=[NSNumber numberWithInteger:260*[[FitmooHelper sharedInstance] frameRadio]];
    [self initFrames];
    
    _pickerDisplayArray=[[NSMutableArray alloc] init];
    _stateArray=[[NSMutableArray alloc] init];
  
    [self getDefaultAddress];
    [self getStateList];
    [self createObservers];
    
    validate=true;
    // Do any additional setup after loading the view.
}




-(void)createObservers{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didEditAddressFinished" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEditAddressFinished:) name:@"didEditAddressFinished" object:nil];
}


- (void) didEditAddressFinished: (NSNotification * ) note
{
    
    NSArray *arrary= (NSArray *)[note object];
    NSString *type= [arrary objectAtIndex:0];
    Address *ad= [arrary objectAtIndex:1];
    
    if ([type isEqual:@"shipping address"]) {
        _shippingAddress=ad;
        
    }else if ([type isEqual:@"billing address"]) {
        _billingAddress=ad;
    }
 
    
    
    [self.tableView reloadData];
    
    
}


#pragma mark - APICalls
- (void) makeCheckout
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    User *localUser= [[UserManager sharedUserManager] localUser];
    NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:localUser.secret_id, @"secret_id", localUser.auth_token, @"auth_token",@"true", @"mobile",nil];
    NSString *url= [NSString stringWithFormat:@"%@%@",[[UserManager sharedUserManager] clientUrl], @"/api/cart/checkout"];
    [manager POST: url parameters:jsonDict success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        
        UIAlertView *alert = [[ UIAlertView alloc ] initWithTitle : @""
                                                          message : @"Your order has been placed." delegate : nil cancelButtonTitle : @"OK"
                                                otherButtonTitles : nil ];
        [alert show ];
        
    
        [indicatorView removeFromSuperview];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateTopImage" object:[[UserManager sharedUserManager] localUser]];
        _BuyNowButton.userInteractionEnabled=YES;
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } // success callback block
          failure:^(AFHTTPRequestOperation *operation, NSError *error){
              NSLog(@"Error: %@", error);
              _BuyNowButton.userInteractionEnabled=YES;
           [indicatorView removeFromSuperview];} // failure callback block
     
     ];
}

- (void) updateShippingAddressType:(NSString *)type_id with:(NSString *)address_id
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    User *localUser= [[UserManager sharedUserManager] localUser];
    NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:localUser.secret_id, @"secret_id", localUser.auth_token, @"auth_token",@"true", @"mobile",type_id, @"address_type_id",address_id, @"id",nil];
    NSString *url= [NSString stringWithFormat:@"%@%@",[[UserManager sharedUserManager] clientUrl], @"/api/cart/address"];
    [manager POST: url parameters:jsonDict success:^(AFHTTPRequestOperation *operation, id responseObject){
        [self updateBillingAddressType:@"1" with:_billingAddress.address_id];
        
    } // success callback block
          failure:^(AFHTTPRequestOperation *operation, NSError *error){
              NSLog(@"Error: %@", error);
              _BuyNowButton.userInteractionEnabled=YES;
              [indicatorView removeFromSuperview];} // failure callback block
     ];
    
}

- (void) updateBillingAddressType:(NSString *)type_id with:(NSString *)address_id
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    User *localUser= [[UserManager sharedUserManager] localUser];
    NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:localUser.secret_id, @"secret_id", localUser.auth_token, @"auth_token",@"true", @"mobile",type_id, @"address_type_id",address_id, @"id",nil];
    NSString *url= [NSString stringWithFormat:@"%@%@",[[UserManager sharedUserManager] clientUrl], @"/api/cart/address"];
    [manager POST: url parameters:jsonDict success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        [self validateCart];
    } // success callback block
          failure:^(AFHTTPRequestOperation *operation, NSError *error){
              NSLog(@"Error: %@", error);
              _BuyNowButton.userInteractionEnabled=YES;
              [indicatorView removeFromSuperview];} // failure callback block
     ];

}

- (void) createShipingAddress
{
    
  
    _shippingAddress=[[Address alloc] init];
 
    
    _shippingAddress.full_name=_nameTextField.text;
    _shippingAddress.city=_cityTextField.text;
    _shippingAddress.phone=_phoneTextField.text;
    _shippingAddress.state_name=_stateLabel.text;
    _shippingAddress.zipcode=_zipTextField.text;
    _shippingAddress.full_name=_nameTextField.text;
    _shippingAddress.address1=_AddressTextField.text;
    _shippingAddress.address2=_Address2TextField.text;
    
    
    
    _shippingAddress.state_id=[[FitmooHelper sharedInstance] findStageId:_stateLabel.text withArray:_stateArray];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    User *localUser= [[UserManager sharedUserManager] localUser];
    NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:localUser.secret_id, @"secret_id", localUser.auth_token, @"auth_token",@"true", @"mobile",_shippingAddress.full_name, @"full_name",_shippingAddress.address1, @"address1",_shippingAddress.address2, @"address2",_shippingAddress.city, @"city",_shippingAddress.zipcode, @"zipcode",_shippingAddress.phone, @"phone",_shippingAddress.state_id, @"state_id",@"2", @"address_type_id",nil];
    NSString *url= [NSString stringWithFormat:@"%@%@",[[UserManager sharedUserManager] clientUrl], @"/api/cart/address_create"];
    [manager POST: url parameters:jsonDict success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        [self createBillingAddress];
        
       
    } // success callback block
          failure:^(AFHTTPRequestOperation *operation, NSError *error){
              NSLog(@"Error: %@", error);
              _BuyNowButton.userInteractionEnabled=YES;
           [indicatorView removeFromSuperview];} // failure callback block
     ];
}

- (void) createBillingAddress
{
    _billingAddress=[[Address alloc] init];
    
    
    _billingAddress.full_name=_nameTextField1.text;
    _billingAddress.city=_cityTextField1.text;
    _billingAddress.phone=_phoneTextField1.text;
    _billingAddress.state_name=_stateLabel1.text;
    _billingAddress.zipcode=_zipTextField1.text;
    _billingAddress.full_name=_nameTextField1.text;
    _billingAddress.address1=_AddressTextField1.text;
    _billingAddress.address2=_Address2TextField1.text;
    
    
    
    _billingAddress.state_id=[[FitmooHelper sharedInstance] findStageId:_stateLabel1.text withArray:_stateArray];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    User *localUser= [[UserManager sharedUserManager] localUser];
    NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:localUser.secret_id, @"secret_id", localUser.auth_token, @"auth_token",@"true", @"mobile",_billingAddress.full_name, @"full_name",_billingAddress.address1, @"address1",_billingAddress.address2, @"address2",_billingAddress.city, @"city",_billingAddress.zipcode, @"zipcode",_billingAddress.phone, @"phone",_billingAddress.state_id, @"state_id",@"1", @"address_type_id",nil];
    NSString *url= [NSString stringWithFormat:@"%@%@",[[UserManager sharedUserManager] clientUrl], @"/api/cart/address_create"];
    [manager POST: url parameters:jsonDict success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        [self validateCart];
        
        
    } // success callback block
          failure:^(AFHTTPRequestOperation *operation, NSError *error){
              NSLog(@"Error: %@", error);
              _BuyNowButton.userInteractionEnabled=YES;
           [indicatorView removeFromSuperview];} // failure callback block
     ];
}

- (void) validateCart
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    User *localUser= [[UserManager sharedUserManager] localUser];
    NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:localUser.secret_id, @"secret_id", localUser.auth_token, @"auth_token",@"true", @"mobile",nil];
    NSString *url= [NSString stringWithFormat:@"%@%@",[[UserManager sharedUserManager] clientUrl], @"/api/cart/validate"];
    [manager POST: url parameters:jsonDict success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSDictionary *dic= (NSDictionary *) responseObject;
        
        NSNumber * good= [dic objectForKey:@"cart_is_good"];
        if (good!=nil) {
            if (good.intValue==1) {
                [self makeCheckout];
            }else
            {
                
            }

        }else
        {
            UIAlertView *alert = [[ UIAlertView alloc ] initWithTitle : @"Opps"
                                                              message : @"Your order infomation has been updated, review your cart again." delegate : nil cancelButtonTitle : @"OK"
                                                    otherButtonTitles : nil ];
            [alert show ];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
        
    } // success callback block
          failure:^(AFHTTPRequestOperation *operation, NSError *error){
              NSLog(@"Error: %@", error);
              _BuyNowButton.userInteractionEnabled=YES;
           [indicatorView removeFromSuperview];} // failure callback block
     ];
}

- (void) createCustomer
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    User *localUser= [[UserManager sharedUserManager] localUser];
    NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:localUser.secret_id, @"secret_id", localUser.auth_token, @"auth_token",@"true", @"mobile",_sptoken, @"token",nil];
    NSString *url= [NSString stringWithFormat:@"%@%@",[[UserManager sharedUserManager] clientUrl], @"/api/cart/customer_create"];
    [manager POST: url parameters:jsonDict success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        if (_shippingAddress!=nil&&_billingAddress!=nil) {
            [self updateShippingAddressType:@"2" with:_shippingAddress.address_id];
        }else
        {
            [self createShipingAddress];
        }
       
        
        
    } // success callback block
          failure:^(AFHTTPRequestOperation *operation, NSError *error){
              NSLog(@"Error: %@", error);
              _BuyNowButton.userInteractionEnabled=YES;
           [indicatorView removeFromSuperview];} // failure callback block
     ];
}




- (void) getDefaultAddress
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    User *localUser= [[UserManager sharedUserManager] localUser];
    NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:localUser.secret_id, @"secret_id", localUser.auth_token, @"auth_token",@"true", @"mobile",nil];
    NSString *url= [NSString stringWithFormat:@"%@%@",[[UserManager sharedUserManager] clientUrl], @"/api/cart/addresses"];
    [manager GET: url parameters:jsonDict success:^(AFHTTPRequestOperation *operation, id responseObject){
        _responseDic= responseObject;
        _addressArray=[[NSMutableArray alloc] init];
        _addressShipingArray=[[NSMutableArray alloc] init];
        _addressBillingArray=[[NSMutableArray alloc] init];
        for (NSDictionary * dic in _responseDic) {
            Address *ad= [[FitmooHelper sharedInstance] parseAddress:dic];
            if ([ad.is_default_billing isEqualToString:@"1"]) {
                _billingAddress=ad;
            }
            if ([ad.is_default_shipping isEqualToString:@"1"]) {
                _shippingAddress=ad;
            }
            
            
            if ([ad.address_type_id isEqualToString:@"2"]) {
                [_addressShipingArray addObject:ad];
            }
            if ([ad.address_type_id isEqualToString:@"1"]) {
                [_addressBillingArray addObject:ad];
            }
            

            [_addressArray addObject:ad];
        }
    
    
        
        [self.tableView reloadData];
        
    } // success callback block
         failure:^(AFHTTPRequestOperation *operation, NSError *error){
             NSLog(@"Error: %@", error);
             _BuyNowButton.userInteractionEnabled=YES;
          [indicatorView removeFromSuperview];} // failure callback block
     ];

}



- (void) getStateList
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    User *localUser= [[UserManager sharedUserManager] localUser];
    NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:localUser.secret_id, @"secret_id", localUser.auth_token, @"auth_token",@"true", @"mobile",nil];
    NSString *url= [NSString stringWithFormat:@"%@%@",[[UserManager sharedUserManager] clientUrl], @"/api/states"];
    [manager GET: url parameters:jsonDict success:^(AFHTTPRequestOperation *operation, id responseObject){
       NSDictionary * responseDic= responseObject;
        _stateArray=[[NSMutableArray alloc] init];
        for (NSDictionary *dic in responseDic) {
            State *st= [[State alloc] init];
            st.abbr= [dic objectForKey:@"abbr"];
            
            NSNumber *country_id=[dic objectForKey:@"country_id"];
            st.country_id=[country_id stringValue];
            
            NSNumber *state_id= [dic objectForKey:@"id"];
            st.state_id= [state_id stringValue];
            
            st.name=[dic objectForKey:@"name"];
            
            [_stateArray addObject:st];
        }
        
     
        
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
            _stateLabel.text= [NSString stringWithFormat:@"%@ - %@",tempState.abbr, tempState.name ];
            _stateLabel.textColor=[UIColor blackColor];
            
        }else if ([_pickerType isEqualToString:@"state1"]) {
            State *tempState= [_pickerDisplayArray objectAtIndex:row];
            _stateLabel1.text= [NSString stringWithFormat:@"%@ - %@",tempState.abbr, tempState.name ];
            _stateLabel1.textColor=[UIColor blackColor];
            
        }
        else if ([_pickerType isEqualToString:@"date"])
        {
            _monthLabel.text=[_pickerDisplayArray objectAtIndex:row];
            _monthLabel.textColor=[UIColor blackColor];
        }else if ([_pickerType isEqualToString:@"year"])
        {
             _yearLabel.text=[_pickerDisplayArray objectAtIndex:row];
             _yearLabel.textColor=[UIColor blackColor];
        }else if ([_pickerType isEqualToString:@"cardtype"])
        {
            _cardTypeLabel.text=[_pickerDisplayArray objectAtIndex:row];
            _cardTypeLabel.textColor=[UIColor blackColor];
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
            
            title= [NSString stringWithFormat:@"%@ - %@",tempState.abbr, tempState.name ];
            
        }else if ([_pickerType isEqualToString:@"state1"]) {
            State *tempState= [_pickerDisplayArray objectAtIndex:row];
            
            title= [NSString stringWithFormat:@"%@ - %@",tempState.abbr, tempState.name ];
            
        }
        else
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

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    return 45.0f;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{


    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 45)];

    view.tag= section;
    UITapGestureRecognizer *tapGestureRecognizer10 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionHeaderClick:)];
    tapGestureRecognizer10.numberOfTapsRequired = 1;
    [view addGestureRecognizer:tapGestureRecognizer10];
    view.userInteractionEnabled=YES;
    [view setBackgroundColor:[UIColor whiteColor]];
    
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 43)];
    [view1 setBackgroundColor:[UIColor colorWithRed:235.0/255.0 green:238.0/255.0 blue:240.0/255.0 alpha:1.0]];
    view1.userInteractionEnabled=NO;
    view1.exclusiveTouch=NO;
    
    UILabel *nameLabel=[[UILabel alloc] init];
    nameLabel.frame= CGRectMake(20, 7, 230, 21);
    nameLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:nameLabel respectToSuperFrame:self.view];
    UIColor *fontColor= [UIColor colorWithRed:84.0/255.0 green:94.0/255.0 blue:96.0/255.0 alpha:1.0];
    UIFont *font= [UIFont fontWithName:@"BentonSans-Bold" size:(CGFloat)(12)];
    nameLabel.font=font;
    nameLabel.textColor=fontColor;
    
    UILabel *nameLabel1=[[UILabel alloc] init];
    nameLabel1.frame= CGRectMake(280, 7, 30, 21);
    nameLabel1.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:nameLabel1 respectToSuperFrame:self.view];
    nameLabel1.font=font;
    nameLabel1.textColor=fontColor;
    nameLabel1.text=@"+";
    if (section==0) {
    
       nameLabel.text=@"SHIPPING ADDRESS";
      

    }else if (section==1)
    {
        nameLabel.text=@"BILLING ADDRESS";
       
    }else if (section==2)
    {
        nameLabel.text=@"PAYMENT INFO";
   
    }else if (section==3)
    {
        nameLabel.text=@"REVIEW AND SUBMIT ORDER";
      
    }
    
    if (selectedIndex==section) {
        nameLabel1.text=@"-";
    }
    
    [view1 addSubview:nameLabel];
    [view1 addSubview:nameLabel1];
    [view addSubview:view1];
    return view;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    if (section==selectedIndex) {
         return 1;
    }
    
    return 0;
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (indexPath.section==0) {
       
        
        CheckoutAddressCell *cell =(CheckoutAddressCell *) [self.tableView cellForRowAtIndexPath:indexPath];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CheckoutAddressCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        UITapGestureRecognizer *tapGestureRecognizer10 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(StateButtonClick:)];
        tapGestureRecognizer10.numberOfTapsRequired = 1;
        cell.stateTextField.tag=1;
        [cell.stateTextField addGestureRecognizer:tapGestureRecognizer10];
        cell.stateTextField.userInteractionEnabled=YES;
        
        if (_stateLabel!=nil) {
            cell.stateTextField.text=_stateLabel.text;
            if (![_stateLabel.text isEqualToString:@"State"]) {
                cell.stateTextField.textColor=[UIColor blackColor];
            }else
            {
                if (validate==false) {
                    [self highLightButtons:cell.stateTextField];
                }
            }

            
        }
        if (_nameTextField!=nil) {
            cell.nameTextField.text=_nameTextField.text;
            cell.nameTextField.textColor=[UIColor blackColor];
            if ([cell.nameTextField.text isEqualToString:@""]&&validate==false) {
                [self highLightButtons:cell.nameTextField];
            }
        }else
        {
            if (validate==false) {
                [self highLightButtons:cell.nameTextField];
            }
        }

        if (_AddressTextField!=nil) {
            cell.AddressTextField.text=_AddressTextField.text;
            cell.AddressTextField.textColor=[UIColor blackColor];
            if ([cell.AddressTextField.text isEqualToString:@""]&&validate==false) {
                [self highLightButtons:cell.AddressTextField];
            }
        }else
        {
            if (validate==false) {
                [self highLightButtons:cell.AddressTextField];
            }
        }

        if (_Address2TextField!=nil) {
            cell.Address2TextField.text=_Address2TextField.text;
            cell.Address2TextField.textColor=[UIColor blackColor];
        }
        if (_cityTextField!=nil) {
            cell.cityTextField.text=_cityTextField.text;
            cell.cityTextField.textColor=[UIColor blackColor];
            if ([cell.cityTextField.text isEqualToString:@""]&&validate==false) {
                [self highLightButtons:cell.cityTextField];
            }
        }else
        {
            if (validate==false) {
                [self highLightButtons:cell.cityTextField];
            }
        }

        if (_phoneTextField!=nil) {
            cell.phoneTextField.text=_phoneTextField.text;
            cell.phoneTextField.textColor=[UIColor blackColor];
            if ([cell.phoneTextField.text isEqualToString:@""]&&validate==false) {
                [self highLightButtons:cell.phoneTextField];
            }
        }else
        {
            if (validate==false) {
                [self highLightButtons:cell.phoneTextField];
            }
        }

        if (_zipTextField!=nil) {
            cell.zipTextField.text=_zipTextField.text;
            cell.zipTextField.textColor=[UIColor blackColor];
            if ([cell.zipTextField.text isEqualToString:@""]&&validate==false) {
                [self highLightButtons:cell.zipTextField];
            }
        }else
        {
            if (validate==false) {
                [self highLightButtons:cell.zipTextField];
            }
        }

        
        
        
        _stateLabel= cell.stateTextField;
        _nameTextField=cell.nameTextField;
        _AddressTextField=cell.AddressTextField;
        _cityTextField=cell.cityTextField;
        _phoneTextField=cell.phoneTextField;
        _zipTextField=cell.zipTextField;
        _Address2TextField=cell.Address2TextField;
        
        [cell.nameTextField setReturnKeyType:UIReturnKeyDone];
        [cell.AddressTextField setReturnKeyType:UIReturnKeyDone];
        [cell.Address2TextField setReturnKeyType:UIReturnKeyDone];
        [cell.cityTextField setReturnKeyType:UIReturnKeyDone];
        [cell.zipTextField setReturnKeyType:UIReturnKeyDone];
        [cell.phoneTextField setReturnKeyType:UIReturnKeyDone];
     
         if (_shippingAddress!=nil) {
             
             CheckoutAdrPrefillCell *cell =(CheckoutAdrPrefillCell *) [self.tableView cellForRowAtIndexPath:indexPath];
             if (cell == nil)
             {
                 NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CheckoutAdrPrefillCell" owner:self options:nil];
                 cell = [nib objectAtIndex:0];
             }
             
             cell.address=_shippingAddress;
             [cell builtCell];
             
             cell.editButton.tag=1;
            [cell.editButton addTarget:self action:@selector(editButtonClick:) forControlEvents:UIControlEventTouchUpInside];
             
             
             
            contentHight=[NSNumber numberWithInt:cell.contentView.frame.size.height];
              return cell;
         }

        
        
        contentHight=[NSNumber numberWithInt:cell.contentView.frame.size.height];
        
        return cell;
    } else if (indexPath.section==1)
    {
        CheckoutAddressCell *cell =(CheckoutAddressCell *) [self.tableView cellForRowAtIndexPath:indexPath];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CheckoutAddressCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        UITapGestureRecognizer *tapGestureRecognizer10 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(StateButtonClick:)];
        tapGestureRecognizer10.numberOfTapsRequired = 1;
         cell.stateTextField.tag=2;
        [cell.stateTextField addGestureRecognizer:tapGestureRecognizer10];
        cell.stateTextField.userInteractionEnabled=YES;
        
        if (_stateLabel1!=nil) {
            cell.stateTextField.text=_stateLabel1.text;
            if (![_stateLabel1.text isEqualToString:@"State"]) {
                cell.stateTextField.textColor=[UIColor blackColor];
            }else
            {
                if (validate==false) {
                    [self highLightButtons:cell.stateTextField];
                }
            }

        }
        if (_nameTextField1!=nil) {
            cell.nameTextField.text=_nameTextField1.text;
            cell.nameTextField.textColor=[UIColor blackColor];
            if ([cell.nameTextField.text isEqualToString:@""]&&validate==false) {
                [self highLightButtons:cell.nameTextField];
            }
        }else
        {
            if (validate==false) {
                [self highLightButtons:cell.nameTextField];
            }
        }

        if (_AddressTextField1!=nil) {
            cell.AddressTextField.text=_AddressTextField1.text;
            cell.AddressTextField.textColor=[UIColor blackColor];
            if ([cell.AddressTextField.text isEqualToString:@""]&&validate==false) {
                [self highLightButtons:cell.AddressTextField];
            }
        }else
        {
            if (validate==false) {
                [self highLightButtons:cell.AddressTextField];
            }
        }

        if (_Address2TextField1!=nil) {
            cell.Address2TextField.text=_Address2TextField1.text;
            cell.Address2TextField.textColor=[UIColor blackColor];
        }

        if (_cityTextField1!=nil) {
            cell.cityTextField.text=_cityTextField1.text;
            cell.cityTextField.textColor=[UIColor blackColor];
            if ([cell.cityTextField.text isEqualToString:@""]&&validate==false) {
                [self highLightButtons:cell.cityTextField];
            }
        }else
        {
            if (validate==false) {
                [self highLightButtons:cell.cityTextField];
            }
        }

        if (_phoneTextField1!=nil) {
            cell.phoneTextField.text=_phoneTextField1.text;
            cell.phoneTextField.textColor=[UIColor blackColor];
            if ([cell.phoneTextField.text isEqualToString:@""]&&validate==false) {
                [self highLightButtons:cell.phoneTextField];
            }
        }else
        {
            if (validate==false) {
                [self highLightButtons:cell.phoneTextField];
            }
        }
        if (_zipTextField1!=nil) {
            cell.zipTextField.text=_zipTextField1.text;
            cell.zipTextField.textColor=[UIColor blackColor];
            if ([cell.zipTextField.text isEqualToString:@""]&&validate==false) {
                [self highLightButtons:cell.zipTextField];
            }
        }else
        {
            if (validate==false) {
                [self highLightButtons:cell.zipTextField];
            }
        }
        
        
        [cell.nameTextField setReturnKeyType:UIReturnKeyDone];
        [cell.AddressTextField setReturnKeyType:UIReturnKeyDone];
        [cell.Address2TextField setReturnKeyType:UIReturnKeyDone];
        [cell.cityTextField setReturnKeyType:UIReturnKeyDone];
        [cell.zipTextField setReturnKeyType:UIReturnKeyDone];
        [cell.phoneTextField setReturnKeyType:UIReturnKeyDone];
        
        _stateLabel1= cell.stateTextField;
        _nameTextField1=cell.nameTextField;
        _AddressTextField1=cell.AddressTextField;
        _cityTextField1=cell.cityTextField;
        _phoneTextField1=cell.phoneTextField;
        _zipTextField1=cell.zipTextField;
        _Address2TextField1=cell.Address2TextField;
        
        if (_billingAddress!=nil) {
            
            CheckoutAdrPrefillCell *cell =(CheckoutAdrPrefillCell *) [self.tableView cellForRowAtIndexPath:indexPath];
            if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CheckoutAdrPrefillCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            
            cell.address=_billingAddress;
            [cell builtCell];
            cell.editButton.tag=2;
            [cell.editButton addTarget:self action:@selector(editButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            contentHight=[NSNumber numberWithInt:cell.contentView.frame.size.height];
             return cell;
        }
        
        
        
        contentHight=[NSNumber numberWithInt:cell.contentView.frame.size.height];
        
        return cell;
    }
    else if (indexPath.section==2)
    {
        ShopPaymentInfoCell *cell =(ShopPaymentInfoCell *) [self.tableView cellForRowAtIndexPath:indexPath];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ShopPaymentInfoCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        UITapGestureRecognizer *tapGestureRecognizer12 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(CardTypeButtonClick:)];
        tapGestureRecognizer12.numberOfTapsRequired = 1;
        [cell.cardType addGestureRecognizer:tapGestureRecognizer12];
        cell.cardType.userInteractionEnabled=YES;
        
        UITapGestureRecognizer *tapGestureRecognizer11 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(YearButtonClick:)];
        tapGestureRecognizer11.numberOfTapsRequired = 1;
        [cell.year addGestureRecognizer:tapGestureRecognizer11];
        cell.year.userInteractionEnabled=YES;
        
        UITapGestureRecognizer *tapGestureRecognizer10 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(DateButtonClick:)];
        tapGestureRecognizer10.numberOfTapsRequired = 1;
        [cell.date addGestureRecognizer:tapGestureRecognizer10];
        cell.date.userInteractionEnabled=YES;
      
        
        if (_monthLabel!=nil) {
            cell.date.text=_monthLabel.text;
            if (![_monthLabel.text isEqualToString:@"Month"]) {
                  cell.date.textColor=[UIColor blackColor];
                [self dehighLightButtons:cell.date];
            }else
            {
                if (validate==false) {
                    [self highLightButtons:cell.date];
                }
            }

          
        }else
        {
            if (validate==false) {
                [self highLightButtons:cell.date];
            }
        }
        
        
        if (_yearLabel!=nil) {
            cell.year.text=_yearLabel.text;
            if (![_yearLabel.text isEqualToString:@"Year"]) {
            cell.year.textColor=[UIColor blackColor];
                 [self dehighLightButtons:cell.year];
            }else
            {
                if (validate==false) {
                    [self highLightButtons:cell.year];
                }
            }

        }else
        {
            if (validate==false) {
                [self highLightButtons:cell.year];
            }
        }
        
        if (_cardTypeLabel!=nil) {
            cell.cardType.text=_cardTypeLabel.text;
            if (![_cardTypeLabel.text isEqualToString:@"Card Type"]) {
            cell.cardType.textColor=[UIColor blackColor];
                 [self dehighLightButtons:cell.cardType];
            }else
            {
                if (validate==false) {
                    [self highLightButtons:cell.cardType];
                }
            }

        }else
        {
            if (validate==false) {
                [self highLightButtons:cell.cardType];
            }

        }
        
        
        if (_cvcTextField!=nil) {
            cell.cvc.text=_cvcTextField.text;
            cell.cvc.textColor=[UIColor blackColor];
             [self dehighLightButtons:cell.cvc];
            
            if ([cell.cvc.text isEqualToString:@""]&&validate==false) {
                    [self highLightButtons:cell.cvc];
            }
        }else
        {
            if ([cell.cvc.text isEqualToString:@""]&&validate==false) {
                [self highLightButtons:cell.cvc];
            }
            
        }

        
        if (_cardNumberTextField!=nil) {
            cell.cardNumber.text=_cardNumberTextField.text;
            cell.cardNumber.textColor=[UIColor blackColor];
            [self dehighLightButtons:cell.cardNumber];
            if ([cell.cardNumber.text isEqualToString:@""]&&validate==false) {
                [self highLightButtons:cell.cardNumber];
            }
        }else
        {
            if ([cell.cardNumber.text isEqualToString:@""]&&validate==false) {
                [self highLightButtons:cell.cardNumber];
            }
            
        }
        [cell.cvc setReturnKeyType:UIReturnKeyDone];
        [cell.cardNumber setReturnKeyType:UIReturnKeyDone];
        
        _monthLabel=cell.date;
        _yearLabel=cell.year;
        _cardTypeLabel=cell.cardType;
        _cvcTextField=cell.cvc;
        _cardNumberTextField=cell.cardNumber;
        
        
        
        contentHight=[NSNumber numberWithInt:cell.contentView.frame.size.height];
        
        return cell;
    }
    
    
    ShopInfoTotalCell *cell =(ShopInfoTotalCell *) [self.tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ShopInfoTotalCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    
    if (_shopCart!=nil) {
        
        cell.label4.text=[NSString stringWithFormat:@"$%0.2f", _shopCart.subtotal.floatValue];
        cell.label5.text=[NSString stringWithFormat:@"$%0.2f", _shopCart.shipping.floatValue];
        cell.label6.text=[NSString stringWithFormat:@"$%0.2f", _shopCart.total.floatValue];
        cell.label7.text=[NSString stringWithFormat:@"$%0.2f", _shopCart.tax.floatValue];
        cell.checkoutButton.hidden=true;
  

      
    }
    
    UILabel *label= [[UILabel alloc] initWithFrame:CGRectMake(23, 100, 275, 90)];
    label.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:label respectToSuperFrame:nil];
    UIFont *font = [UIFont fontWithName:@"BentonSans-Bold" size:12.0f];

    label.text=@"By clicking “Place Order” you confirm that you have read, understood, and accept our Terms and Conditions, Refund Policy and Privacy Policy.";
    
    
    NSMutableAttributedString *attributedString= [[NSMutableAttributedString alloc] initWithString:label.text attributes:@{NSFontAttributeName: font}  ];
    label.numberOfLines=5;
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:8];
    

    
    [attributedString addAttribute:NSParagraphStyleAttributeName
                             value:style
                             range:NSMakeRange(0, label.text.length)];
    
    [label setAttributedText:attributedString];

    [cell.contentView addSubview:label];
    
    contentHight=[NSNumber numberWithInt:200*[[FitmooHelper sharedInstance] frameRadio]];
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



//checkout button
- (IBAction)BuyNowButtonClick:(id)sender
{
    if (_shippingAddress==nil&&_billingAddress==nil) {
        if ([self ValidateAllFields]==false) {
            validate=false;
            [self.tableView reloadData:YES];
            return;
        }
    }
   
    if ([self ValidateYourCard]==false) {
        validate=false;
          [self.tableView reloadData:YES];
        return;
    }
    indicatorView=[[FitmooHelper sharedInstance] addActivityIndicatorView:indicatorView and:self.view text:@"Processing..."];
    _BuyNowButton.userInteractionEnabled=NO;
    
    STPCard *card = [[STPCard alloc] init];
//    card.number = @"4111111111111111";
//    card.expMonth =1;
//    card.expYear = 2019;
//    card.cvc = @"123";
    
    card.number = _cardNumberTextField.text;
    card.expMonth =_monthLabel.text.integerValue;
    card.expYear = _yearLabel.text.integerValue;
    card.cvc=_cvcTextField.text;

    
    [[STPAPIClient sharedClient] createTokenWithCard:card
                                          completion:^(STPToken *token, NSError *error) {
                                              if (error) {
        UIAlertView *alert = [[ UIAlertView alloc ] initWithTitle : @"Oops"
        message :@"Your card looks invalid."  delegate : nil cancelButtonTitle : @"OK"
        otherButtonTitles : nil ];
        [alert show ];
        [indicatorView removeFromSuperview];
        _BuyNowButton.userInteractionEnabled=YES;
                                              } else {
                                                  _sptoken=token.tokenId;
                                                  [self createCustomer];
                                              }
                                          }];
}
- (IBAction)doneButtonClick:(id)sender
{
    _typePickerView.hidden=true;
}

- (IBAction)CardTypeButtonClick:(id)sender {
    _typePickerView.hidden=false;
    _pickerType=@"cardtype";
    _pickerDisplayArray=[@[@"Visa",@"MasterCard",@"American Experss",@"Discover",@"Dinner Club",@"JCB"] mutableCopy];
    [_typePicker reloadAllComponents];
    [self.view bringSubviewToFront:_typePickerView];
}


- (IBAction)DateButtonClick:(id)sender {
    _typePickerView.hidden=false;
    _pickerType=@"date";
    _pickerDisplayArray=[@[@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12"] mutableCopy];
    [_typePicker reloadAllComponents];
    [self.view bringSubviewToFront:_typePickerView];
}

- (IBAction)YearButtonClick:(id)sender {
    _typePickerView.hidden=false;
    _pickerType=@"year";
    _pickerDisplayArray=[[NSMutableArray alloc] init];
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger year = [components year];
    
    for (int i=0; i<8; i++) {
        NSString *y= [NSString stringWithFormat:@"%ld",year+i];
        [_pickerDisplayArray addObject:y];
    }
    
    [_typePicker reloadAllComponents];
    [self.view bringSubviewToFront:_typePickerView];
}

- (IBAction)StateButtonClick:(id)sender {
     UIView *v = (UIView *)[(UIGestureRecognizer *)sender view];
    
    
    
     _typePickerView.hidden=false;
    if (v.tag==1) {
          _pickerType=@"state";
    }else
    {
        _pickerType=@"state1";
    }
   
     _pickerDisplayArray=[_stateArray mutableCopy];
    [_typePicker reloadAllComponents];
    [self.view bringSubviewToFront:_typePickerView];
}

- (IBAction)sectionHeaderClick:(id)sender {
     UIView *v = (UIView *)[(UIGestureRecognizer *)sender view];
    
    selectedIndex= v.tag;
    
    [self.tableView reloadData:YES];
}



- (IBAction)editButtonClick:(id)sender {
    UIButton *b= (UIButton *) sender;
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main1" bundle:nil];
    ShopAddressViewController *AddressVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"ShopAddressViewController"];
    
   
    AddressVC.stateArray=_stateArray;
    if (b.tag==1) {
        
        AddressVC.addreeType=@"shipping address";
        AddressVC.addressArray= _addressShipingArray;
        
    }else
    {
        AddressVC.addreeType=@"billing address";
        AddressVC.addressArray=_addressBillingArray;
    }
    
    [self.navigationController pushViewController:AddressVC animated:YES];
}

- (IBAction)backButtonClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL) ValidateYourCard
{
        if ([_cardTypeLabel.text isEqualToString:@"Card Type"]) {
            UIAlertView *alert = [[ UIAlertView alloc ] initWithTitle : @"Oops"
                                                              message : @"Please select a type of card." delegate : nil cancelButtonTitle : @"OK"
                                                    otherButtonTitles : nil ];
            [alert show ];
            selectedIndex= 2;
          
            return false;
        }
    
        if ([_cardNumberTextField.text isEqualToString:@""]) {
            UIAlertView *alert = [[ UIAlertView alloc ] initWithTitle : @"Oops"
                                                              message : @"Please enter card number." delegate : nil cancelButtonTitle : @"OK"
                                                    otherButtonTitles : nil ];
            [alert show ];
            selectedIndex= 2;
          
    
            return false;
        }
    
        if ([_monthLabel.text isEqualToString:@"Month"]) {
            UIAlertView *alert = [[ UIAlertView alloc ] initWithTitle : @"Oops"
                                                              message : @"Please select a Month." delegate : nil cancelButtonTitle : @"OK"
                                                    otherButtonTitles : nil ];
            [alert show ];
            selectedIndex= 2;
         
    
            return false;
        }
    
        if ([_yearLabel.text isEqualToString:@"Year"]) {
            UIAlertView *alert = [[ UIAlertView alloc ] initWithTitle : @"Oops"
                                                              message : @"Please select a Year." delegate : nil cancelButtonTitle : @"OK"
                                                    otherButtonTitles : nil ];
            [alert show ];
            selectedIndex= 2;
          
            return false;
        }
    
        if ([_cvcTextField.text isEqualToString:@""]) {
            UIAlertView *alert = [[ UIAlertView alloc ] initWithTitle : @"Oops"
                                                              message : @"Please enter the card CVC." delegate : nil cancelButtonTitle : @"OK"
                                                    otherButtonTitles : nil ];
            [alert show ];
            selectedIndex= 2;
          
            return false;
        }
    
    
    if ([[FitmooHelper sharedInstance] checkStringIsNumberOnly:_cardNumberTextField.text]==false) {
        UIAlertView *alert = [[ UIAlertView alloc ] initWithTitle : @"Oops"
                                                          message : @"Please enter number only for your card number." delegate : nil cancelButtonTitle : @"OK"
                                                otherButtonTitles : nil ];
        [alert show ];
        selectedIndex= 2;
      
        return false;
    }
    
    if ([[FitmooHelper sharedInstance] checkStringIsNumberOnly:_cvcTextField.text]==false) {
        UIAlertView *alert = [[ UIAlertView alloc ] initWithTitle : @"Oops"
                                                          message : @"Please enter number only for your card CVC number." delegate : nil cancelButtonTitle : @"OK"
                                                otherButtonTitles : nil ];
        [alert show ];
        selectedIndex= 2;
      
        return false;
    }
    
    return true;
}

- (void) highLightButtons:(UIView *) button
{
    [[button layer] setBorderWidth:2.0f];
    [[button layer] setBorderColor:[UIColor redColor].CGColor];
}

- (void) dehighLightButtons:(UIView *) button
{
    [[button layer] setBorderWidth:0.0f];
    
}

- (BOOL) ValidateAllFields
{
    
    
    if ([_nameTextField.text isEqualToString:@""]) {
        UIAlertView *alert = [[ UIAlertView alloc ] initWithTitle : @"Oops"
                                                          message : @"Please type your name for shipping address." delegate : nil cancelButtonTitle : @"OK"
                                                otherButtonTitles : nil ];
        [alert show ];
        selectedIndex= 0;
   
        return false;
    }
    
    if ([_AddressTextField.text isEqualToString:@""]) {
        UIAlertView *alert = [[ UIAlertView alloc ] initWithTitle : @"Oops"
                                                          message : @"Please enter your address1 for shipping address." delegate : nil cancelButtonTitle : @"OK"
                                                otherButtonTitles : nil ];
        [alert show ];
        selectedIndex= 0;
    
        return false;
    }
    
    if ([_cityTextField.text isEqualToString:@""]) {
        UIAlertView *alert = [[ UIAlertView alloc ] initWithTitle : @"Oops"
                                                          message : @"Please enter your city for shipping address." delegate : nil cancelButtonTitle : @"OK"
                                                otherButtonTitles : nil ];
        [alert show ];
        selectedIndex= 0;
      
        return false;
    }
    
    if ([_stateLabel.text isEqualToString:@"State"]) {
        UIAlertView *alert = [[ UIAlertView alloc ] initWithTitle : @"Oops"
                                                          message : @"Please select a state for shipping address." delegate : nil cancelButtonTitle : @"OK"
                                                otherButtonTitles : nil ];
        [alert show ];
        selectedIndex= 0;
      
        return false;
    }
    
    if ([_zipTextField.text isEqualToString:@""]) {
        UIAlertView *alert = [[ UIAlertView alloc ] initWithTitle : @"Oops"
                                                          message : @"Please enter your zip code for shipping address." delegate : nil cancelButtonTitle : @"OK"
                                                otherButtonTitles : nil ];
        [alert show ];
        selectedIndex= 0;
   
        return false;
    }
    
    if ([_phoneTextField.text isEqualToString:@""]) {
        UIAlertView *alert = [[ UIAlertView alloc ] initWithTitle : @"Oops"
                                                          message : @"Please enter your phone for shipping address." delegate : nil cancelButtonTitle : @"OK"
                                                otherButtonTitles : nil ];
        [alert show ];
        selectedIndex= 0;
    
        return false;
    }
    
    
    if ([[FitmooHelper sharedInstance] checkStringIsNumberOnly:_zipTextField.text]==false) {
        UIAlertView *alert = [[ UIAlertView alloc ] initWithTitle : @"Oops"
                                                          message : @"Please enter number only for your zip code." delegate : nil cancelButtonTitle : @"OK"
                                                otherButtonTitles : nil ];
        [alert show ];
        selectedIndex= 0;
      
        return false;
    }
    

    if ([[FitmooHelper sharedInstance] checkStringIsNumberOnly:_phoneTextField.text]==false) {
        UIAlertView *alert = [[ UIAlertView alloc ] initWithTitle : @"Oops"
                                                          message : @"Please enter number only for your phone number." delegate : nil cancelButtonTitle : @"OK"
                                                otherButtonTitles : nil ];
        [alert show ];
        selectedIndex= 0;
       
        return false;
    }
    
    if ([_nameTextField1.text isEqualToString:@""]) {
        UIAlertView *alert = [[ UIAlertView alloc ] initWithTitle : @"Oops"
                                                          message : @"Please type your name for billing address." delegate : nil cancelButtonTitle : @"OK"
                                                otherButtonTitles : nil ];
        [alert show ];
        selectedIndex= 1;
      
        return false;
    }
    
    if ([_AddressTextField1.text isEqualToString:@""]) {
        UIAlertView *alert = [[ UIAlertView alloc ] initWithTitle : @"Oops"
                                                          message : @"Please enter your address1 for billing address." delegate : nil cancelButtonTitle : @"OK"
                                                otherButtonTitles : nil ];
        [alert show ];
        selectedIndex= 1;
     
        return false;
    }
    
    if ([_cityTextField1.text isEqualToString:@""]) {
        UIAlertView *alert = [[ UIAlertView alloc ] initWithTitle : @"Oops"
                                                          message : @"Please enter your city for billing address." delegate : nil cancelButtonTitle : @"OK"
                                                otherButtonTitles : nil ];
        [alert show ];
        selectedIndex= 1;
      
        return false;
    }
    
    if ([_stateLabel1.text isEqualToString:@"State"]) {
        UIAlertView *alert = [[ UIAlertView alloc ] initWithTitle : @"Oops"
                                                          message : @"Please select a state for billing address." delegate : nil cancelButtonTitle : @"OK"
                                                otherButtonTitles : nil ];
        [alert show ];
        selectedIndex= 1;
     
        return false;
    }
    
    if ([_zipTextField1.text isEqualToString:@""]) {
        UIAlertView *alert = [[ UIAlertView alloc ] initWithTitle : @"Oops"
                                                          message : @"Please enter your zip code for billing address." delegate : nil cancelButtonTitle : @"OK"
                                                otherButtonTitles : nil ];
        [alert show ];
        selectedIndex= 1;
     
        return false;
    }
    
    if ([_phoneTextField1.text isEqualToString:@""]) {
        UIAlertView *alert = [[ UIAlertView alloc ] initWithTitle : @"Oops"
                                                          message : @"Please enter your phone for billing address." delegate : nil cancelButtonTitle : @"OK"
                                                otherButtonTitles : nil ];
        [alert show ];
        selectedIndex= 1;
     
        return false;
    }
    
    
    if ([[FitmooHelper sharedInstance] checkStringIsNumberOnly:_zipTextField1.text]==false) {
        UIAlertView *alert = [[ UIAlertView alloc ] initWithTitle : @"Oops"
                                                          message : @"Please enter number only for your zip code." delegate : nil cancelButtonTitle : @"OK"
                                                otherButtonTitles : nil ];
        [alert show ];
        selectedIndex= 1;
      
        return false;
    }
    
    
    if ([[FitmooHelper sharedInstance] checkStringIsNumberOnly:_phoneTextField1.text]==false) {
        UIAlertView *alert = [[ UIAlertView alloc ] initWithTitle : @"Oops"
                                                          message : @"Please enter number only for your phone number." delegate : nil cancelButtonTitle : @"OK"
                                                otherButtonTitles : nil ];
        [alert show ];
        selectedIndex= 1;
      
        return false;
    }

    

    
    
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

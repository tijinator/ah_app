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
@interface ShopCheckoutViewController ()
{
      NSNumber * contentHight;
     NSInteger selectedIndex;
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
    // Do any additional setup after loading the view.
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
        
        
        
        
        
    } // success callback block
          failure:^(AFHTTPRequestOperation *operation, NSError *error){
              NSLog(@"Error: %@", error);} // failure callback block
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
        
        
        [self makeCheckout];
        
        
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
    
    User *localUser= [[UserManager sharedUserManager] localUser];
    NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:localUser.secret_id, @"secret_id", localUser.auth_token, @"auth_token",@"true", @"mobile",@"Hongjian Lin", @"full_name",@"743 38st", @"address1",@"", @"address2",@"toms river", @"city",@"10012", @"zipcode",@"45", @"state_id",@"1", @"address_type_id",nil];
    NSString *url= [NSString stringWithFormat:@"%@%@",[[UserManager sharedUserManager] clientUrl], @"/api/cart/address_create"];
    [manager POST: url parameters:jsonDict success:^(AFHTTPRequestOperation *operation, id responseObject){
    
        
        
        
        [self.tableView reloadData];
        
    } // success callback block
         failure:^(AFHTTPRequestOperation *operation, NSError *error){
             NSLog(@"Error: %@", error);} // failure callback block
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
        
        [self parseAddress:_responseDic];
        
        [self.tableView reloadData];
        
    } // success callback block
         failure:^(AFHTTPRequestOperation *operation, NSError *error){
             NSLog(@"Error: %@", error);} // failure callback block
     ];

}

- (void) parseAddress:(NSDictionary *)dic
{
    
    _addressArray= [[NSMutableArray alloc] init];
    
    for (NSDictionary *addressDic in dic) {
        Address *address= [[Address alloc] init];
        address.address1= [addressDic objectForKey:@"address1"];
        address.address2= [addressDic objectForKey:@"address2"];
        
        NSNumber *address_type_id=[addressDic objectForKey:@"address_type_id"];
        address.address_type_id= [address_type_id stringValue];
        address.city= [addressDic objectForKey:@"city"];
        
        NSNumber *country_id=[addressDic objectForKey:@"country_id"];
        address.country_id= [country_id stringValue];
        
        address.country_name= [addressDic objectForKey:@"country_name"];
        address.full_name= [addressDic objectForKey:@"full_name"];
        
        NSNumber *address_id=[addressDic objectForKey:@"id"];
        address.address_id= [address_id stringValue];
        
        NSNumber *is_default_billing=[addressDic objectForKey:@"is_default_billing"];
        address.is_default_billing= [is_default_billing stringValue];
        
        NSNumber *is_default_shipping=[addressDic objectForKey:@"is_default_shipping"];
        address.is_default_shipping= [is_default_shipping stringValue];
        
        NSNumber *order_total=[addressDic objectForKey:@"order_total"];
        address.order_total= [order_total stringValue];
        
        address.phone= [addressDic objectForKey:@"phone"];
        
        NSNumber *shipping_rate=[addressDic objectForKey:@"shipping_rate"];
        address.shipping_rate= [shipping_rate stringValue];
        
        NSNumber *state_id=[addressDic objectForKey:@"state_id"];
        address.state_id= [state_id stringValue];
        address.state_name= [addressDic objectForKey:@"state_name"];
        
        NSNumber *user_id=[addressDic objectForKey:@"user_id"];
        address.user_id= [user_id stringValue];
        address.zipcode= [addressDic objectForKey:@"zipcode"];
        
        
        [_addressArray addObject:address];
        
    }
    
    
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
            
            title= [NSString stringWithFormat:@"%@ - %@",tempState.abbr, tempState.name ];
            
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
    
    
    if (indexPath.section==0||indexPath.section==1) {
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
        
        return cell;
    }else if (indexPath.section==2)
    {
        ShopPaymentInfoCell *cell =(ShopPaymentInfoCell *) [self.tableView cellForRowAtIndexPath:indexPath];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ShopPaymentInfoCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        
        
        
        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
    UILabel *label= (UILabel *) [cell viewWithTag:1];
    label.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:label respectToSuperFrame:nil];
    
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




- (IBAction)BuyNowButtonClick:(id)sender
{
    
    
    STPCard *card = [[STPCard alloc] init];
    card.number = @"4111111111111111";
    card.expMonth =1;
    card.expYear = 2019;
    card.cvc = @"123";
    [[STPAPIClient sharedClient] createTokenWithCard:card
                                          completion:^(STPToken *token, NSError *error) {
                                              if (error) {
                                                 
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

- (IBAction)StateButtonClick:(id)sender {
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

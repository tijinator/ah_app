//
//  ShopAddressViewController.m
//  fitmoo
//
//  Created by hongjian lin on 9/11/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import "ShopAddressViewController.h"
#import <SwipeBack/SwipeBack.h>
#import "AFNetworking.h"
#import "Stripe.h"
@interface ShopAddressViewController ()
{
    NSNumber * contentHight;
    NSInteger selectedIndex;
}
@end

@implementation ShopAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.swipeBackEnabled = YES;
    selectedIndex=0;
    contentHight=[NSNumber numberWithInteger:260*[[FitmooHelper sharedInstance] frameRadio]];
    [self initFrames];
    
  
 //   _stateArray=[[NSMutableArray alloc] init];
    [self createObservers];
    // Do any additional setup after loading the view.
}


- (void) viewWillAppear:(BOOL)animated
{
    if (_addressArray!=nil) {
        [self.tableView reloadData];
    }
}

-(void)createObservers{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didPostAddressFinished" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didPostAddressFinished:) name:@"didPostAddressFinished" object:nil];
}


- (void) didPostAddressFinished: (NSNotification * ) note
{
    
    _addressArray= (NSMutableArray *)[note object];
    
    [self.tableView reloadData];
    
    
}





- (void) initFrames
{
    _tableView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_tableView respectToSuperFrame:self.view];
    _topView.frame= CGRectMake(0, 0, 320, 60);
    _topView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_topView respectToSuperFrame:self.view];
    _leftButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_leftButton respectToSuperFrame:self.view];
    
    _titleLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_titleLabel respectToSuperFrame:self.view];
    
    _BuyNowButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_BuyNowButton respectToSuperFrame:self.view];
    

    
    _titleLabel.text=_addreeType.uppercaseString;
    
    if (self.view.frame.size.height<500) {
        
        _tableView.frame= CGRectMake(_tableView.frame.origin.x,_tableView.frame.origin.y, _tableView.frame.size.width, _tableView.frame.size.height-88);
         _BuyNowButton.frame= CGRectMake(_BuyNowButton.frame.origin.x, _BuyNowButton.frame.origin.y-88, _BuyNowButton.frame.size.width, _BuyNowButton.frame.size.height);
        
    }
    
    
    
    
}



#pragma mark - UITableViewDelegate

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 45.0f;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 45)];
    [view setBackgroundColor:[UIColor whiteColor]];

    
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 45)];
    [view1 setBackgroundColor:[UIColor colorWithRed:235.0/255.0 green:238.0/255.0 blue:240.0/255.0 alpha:1.0]];
    
    view1.tag= section;
    UITapGestureRecognizer *tapGestureRecognizer10 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionHeaderClick:)];
    tapGestureRecognizer10.numberOfTapsRequired = 1;
    [view1 addGestureRecognizer:tapGestureRecognizer10];
    view1.userInteractionEnabled=YES;
  
    

    
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
    nameLabel1.text=@"Edit";

        
    nameLabel.text=[NSString stringWithFormat:@"ADDRESS"];
        
  
    nameLabel1.tag= section+10;
    UITapGestureRecognizer *tapGestureRecognizer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editButtonClick:)];
    tapGestureRecognizer1.numberOfTapsRequired = 1;
    [nameLabel1 addGestureRecognizer:tapGestureRecognizer1];
    nameLabel1.userInteractionEnabled=YES;
   
   
    
    [view1 addSubview:nameLabel];
    [view1 addSubview:nameLabel1];
    [view addSubview:view1];
    return view;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return [_addressArray count];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{

    
    return 1;
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
  
    CheckoutAdrPrefillCell *cell =(CheckoutAdrPrefillCell *) [self.tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CheckoutAdrPrefillCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
            
    cell.address=[_addressArray objectAtIndex:indexPath.section];
    [cell builtCell];
    cell.editButton.hidden=true;
    
    cell.useThisAddButton.hidden=false;
    cell.useThisAddButton.tag=indexPath.section;
    
    [cell.useThisAddButton addTarget:self action:@selector(useThisAddButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            
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


- (IBAction)editButtonClick:(id)sender
{
    UILabel *v = (UILabel *)[(UIGestureRecognizer *)sender view];
    UIButton *b=[[UIButton alloc] init];
    b.tag=v.tag;
    [self BuyNowButtonClick:b];
    
}

- (IBAction)BuyNowButtonClick:(id)sender
{
    
    UIButton *b= (UIButton *) sender;
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main1" bundle:nil];
    ShopAddAddressViewController *AddressVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"ShopAddAddressViewController"];
    

    if (b.tag==1000) {
        
        AddressVC.addreeType=[NSString stringWithFormat:@"add %@", _addreeType];
        
    }else if (b.tag<1000)
    {
        AddressVC.addreeType=[NSString stringWithFormat:@"edit %@", _addreeType];
        
        AddressVC.address=[_addressArray objectAtIndex:b.tag-10];
        
    }
    
    AddressVC.addressArray=_addressArray;
    AddressVC.stateArray=_stateArray;
   
    
    [self.navigationController pushViewController:AddressVC animated:YES];

 
}


- (IBAction)useThisAddButtonClick:(id)sender {
    UIButton *b=(UIButton *)sender;
    Address *addr= [_addressArray objectAtIndex:b.tag];
    NSArray *array= [[NSArray alloc] initWithObjects:_addreeType,addr, nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didEditAddressFinished" object:array];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)sectionHeaderClick:(id)sender {
    UIView *v = (UIView *)[(UIGestureRecognizer *)sender view];
    
    selectedIndex= v.tag;
    
    [self.tableView reloadData:YES];
}



- (IBAction)backButtonClick:(id)sender {
    int index=0;
    for (int i=0; i<[_addressArray count]; i++) {
        Address *ad= [_addressArray objectAtIndex:i];
        
        if ([ad.is_default_billing isEqualToString:@"1"]||[ad.is_default_shipping isEqualToString:@"1"]) {
            index=i;
        }
    }
    
    Address *addr= [_addressArray objectAtIndex:index];
    NSArray *array= [[NSArray alloc] initWithObjects:_addreeType,addr, nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didEditAddressFinished" object:array];
    
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

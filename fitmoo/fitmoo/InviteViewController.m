//
//  InviteViewController.m
//  fitmoo
//
//  Created by hongjian lin on 6/19/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import "InviteViewController.h"
#import "AFNetworking.h"
#import "UserManager.h"
#import "APAddressBook.h"
#import "APContact.h"
#import <SwipeBack/SwipeBack.h>
@interface InviteViewController ()
{
    NSArray *content;
    NSArray *indices;
}
@end

@implementation InviteViewController
static NSString *letters = @"#ABCDEFGHIJKLMNOPQRSTUVWXYZ";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initFrames];
    [self getAddressBook];
    
    indices= [self convertToArray];
    self.navigationController.swipeBackEnabled = YES;
    
 //  [self sendSMS:@"Body of SMS..." recipientList:[NSArray arrayWithObjects:@"+1-111-222-3333", @"111-333-4444", nil]];
}

-(NSArray *)convertToArray
{
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    for (int i=0; i < letters.length; i++) {
        NSString *tmp_str = [letters substringWithRange:NSMakeRange(i, 1)];
        [arr addObject:[tmp_str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    return arr;
}

#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 25;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[_contactsPymic objectAtIndex:section] count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([[_contactsPymic objectAtIndex:section] count]==0) {
        return 0;
    }
    return 27.0f;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell1"];
    APContact *contact;
    if ([[_contactsPymic objectAtIndex:indexPath.section] count]>0) {
        contact= [[_contactsPymic objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        }
        
        
    
 //   APContact *contact=[_contacts objectAtIndex:indexPath.row];
    
    UILabel *nameLabel=[[UILabel alloc] init];
    nameLabel.frame= CGRectMake(25, 5, 200, 42);
    nameLabel.numberOfLines=2;
    nameLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:nameLabel respectToSuperFrame:self.view];
    NSString *firstname=[NSString stringWithFormat:@"%@ ",contact.firstName];
    NSString *lastname=contact.lastName;
    if (contact.firstName==nil) {
        firstname=@"";
    }
    
    if (contact.lastName==nil) {
        lastname=@"";
    }
    
    nameLabel.text= [NSString stringWithFormat:@"%@%@",firstname, lastname ];
    
    UIFont *font = [UIFont fontWithName:@"BentonSans" size:16];
    NSMutableAttributedString *attributedString= [[NSMutableAttributedString alloc] initWithString:nameLabel.text attributes:@{NSFontAttributeName: font}  ];
    
    [nameLabel setAttributedText:attributedString];

    
    UIButton * followButton= [[UIButton alloc] init];
    followButton.frame= CGRectMake(270, 18, 16, 12);
    followButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:followButton respectToSuperFrame:self.view];
    
    
    if ([contact.accessibilityLabel isEqualToString:@"0"]) {
        
        [followButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        
    }else
    {
        [followButton setBackgroundImage:[UIImage imageNamed:@"bluecheck.png"] forState:UIControlStateNormal];
    }
   

    
    [cell .contentView addSubview:nameLabel];
    [cell .contentView addSubview:followButton];
    
    cell.selectionStyle= UITableViewCellSelectionStyleNone;
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{


    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 20)];
    UILabel *title= [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 20, 20)];
    title.textColor=[UIColor colorWithRed:121.0/255.0 green:134.0/255.0 blue:142.0/255.0 alpha:1.0];
    title.text=[indices objectAtIndex:section];
    
    UIFont *font = [UIFont fontWithName:@"BentonSans-Bold" size:14];
    NSMutableAttributedString *attributedString= [[NSMutableAttributedString alloc] initWithString:title.text attributes:@{NSFontAttributeName: font}  ];
    
    [title setAttributedText:attributedString];
    
    [view addSubview:title];
    [view setBackgroundColor:[UIColor colorWithRed:235.0/255.0 green:238.0/255.0 blue:240.0/255.0 alpha:1.0]];
    return view;
}

//- (NSString *)tableView:(UITableView *)aTableView titleForHeaderInSection:(NSInteger)section {
//    return [indices objectAtIndex:section];
//    
//}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return indices;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return [indices indexOfObject:title];
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    APContact *contact;
    if ([[_contactsPymic objectAtIndex:indexPath.section] count]>0) {
        contact= [[_contactsPymic objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    }

    if (contact!=nil) {
        if ([contact.accessibilityLabel isEqualToString:@"0"]) {
            
            [contact setAccessibilityLabel:@"1"];
            
        }else
        {
             [contact setAccessibilityLabel:@"0"];
        }
    }
    
    [self.tableview reloadData];
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    double Radio= self.view.frame.size.width / 320;
    return 50*Radio;
}


#pragma mark -
#pragma mark Send Message
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (result == MessageComposeResultCancelled)
        NSLog(@"Message cancelled");
    else if (result == MessageComposeResultSent)
        NSLog(@"Message sent");
    else
        NSLog(@"Message failed");
}

- (void)sendSMS:(NSString *)bodyOfMessage recipientList:(NSArray *)recipients
{
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    if([MFMessageComposeViewController canSendText])
    {
        controller.body = bodyOfMessage;
        controller.recipients = recipients;
        controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:nil];
    }    
}


#pragma mark -
#pragma mark getAddressBook
- (void) getAddressBook
{
    APAddressBook *addressBook = [[APAddressBook alloc] init];
    
    addressBook.filterBlock = ^BOOL(APContact *contact)
    {
        return contact.phones.count > 0;
    };
    
    addressBook.sortDescriptors = @[
    [NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:YES],
    [NSSortDescriptor sortDescriptorWithKey:@"lastName" ascending:YES]
                                    ];
   
    // don't forget to show some activity
    [addressBook loadContacts:^(NSArray *contacts, NSError *error)
    {
        // hide activity
        if (!error)
        {
            
            _contacts= contacts;
            [self convertObjects];
            [_tableview reloadData];
            // do something with contacts array
        }
        else
        {
            // show error
        }
    }];

    
    
}


- (void) convertObjects
{
    _contactsPymic=[[NSMutableArray alloc] initWithCapacity:25];
    
    for (int i=0; i<25; i++) {
        NSMutableArray *array= [[NSMutableArray alloc] init];
        [_contactsPymic addObject:array];
    }
    
    for (APContact *contact in _contacts) {
        [contact setAccessibilityLabel:@"0"];
        if (!(contact.firstName==nil&&contact.lastName==nil)) {
            if (contact.firstName==nil) {
                 [[_contactsPymic objectAtIndex:0] addObject:contact];
            }
           
        }
    }
    
    for (int i=1; i<25; i++) {
        
        for (APContact *contact in _contacts) {
              [contact setAccessibilityLabel:@"0"];
             if ([contact.firstName characterAtIndex:0]==[letters characterAtIndex:i])
             {
                 [[_contactsPymic objectAtIndex:i] addObject:contact];
             }
        }
        
    }
    
    
}

- (void) initFrames
{
    
    _topview.frame= CGRectMake(0, 0, 320, 60);
    _topview.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_topview respectToSuperFrame:self.view];
    _bioLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_bioLabel respectToSuperFrame:self.view];
    _backButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_backButton respectToSuperFrame:self.view];
    
    _bodyView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_bodyView respectToSuperFrame:self.view];
    _emailView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_emailView respectToSuperFrame:self.view];
    _messageView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_messageView respectToSuperFrame:self.view];
    _emailTextView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_emailTextView respectToSuperFrame:self.view];
    _messageTextView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_messageTextView respectToSuperFrame:self.view];
    
    _sendButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_sendButton respectToSuperFrame:self.view];
    
    _tableview.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_tableview respectToSuperFrame:self.view];
    
    UIFont *font = [UIFont fontWithName:@"BentonSans" size:19];
    _emailTextView.font=font;
    _messageTextView.font=font;
    
    _emailTextView.placeholder=@"Email (separated by commas)";
    _messageTextView.placeholder=@"Message";
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) getInviteCall
{
    User *localUser= [[FitmooHelper sharedInstance] getUserLocally];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    NSArray *emailAry = [_emailTextView.text componentsSeparatedByString:@","];
    
    
    NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:localUser.secret_id, @"secret_id", localUser.auth_token, @"auth_token",@"true", @"mobile",_messageTextView.text, @"comment",emailAry, @"emails_invite",nil];
    
    
    NSString *url= [NSString stringWithFormat:@"%@%@",[[UserManager sharedUserManager] clientUrl],@"/api/users/invite"];
    [manager POST: url parameters:jsonDict success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        _responseDic= responseObject;
        
        UIAlertView *alert = [[ UIAlertView alloc ] initWithTitle : @"Invited"
                                                          message : @"Your invitation has been sent." delegate : nil cancelButtonTitle : @"OK"
                                                otherButtonTitles : nil ];
        [alert show ];
        
        
        
    } // success callback block
     
         failure:^(AFHTTPRequestOperation *operation, NSError *error){
             UIAlertView *alert = [[ UIAlertView alloc ] initWithTitle : @"Oops!"
                                                               message : @"Please make sure to enter valid email addresses." delegate : nil cancelButtonTitle : @"OK"
                                                     otherButtonTitles : nil ];
             [alert show ];
             NSLog(@"Error: %@", error);} // failure callback block
     ];

}

-(BOOL) checkValidEmail: (NSString *)email
{
    
    //   BOOL valid=true;
    
    if ([email isEqualToString:@""]) {
        return false;
    }
    
    
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
    
    //  return valid;
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
- (IBAction)sendButtonClick:(id)sender {
//    if ([self checkValidEmail:_emailTextView.text]==true) {
//        [self getInviteCall];
//    }
    NSMutableArray *phoneArray=[[NSMutableArray alloc] init];
    
    for (int i=0; i<25; i++) {
        NSArray * childContactArray= [_contactsPymic objectAtIndex:i];
        
        for (APContact *contact in childContactArray) {
            if ([contact.accessibilityLabel isEqualToString:@"1"]) {
                NSString *phone=[contact.phones objectAtIndex:0];
                [phoneArray addObject:phone];
            }
        }
        
        
    }
    User *user= [[UserManager sharedUserManager] localUser];
    NSString * message=[NSString stringWithFormat:@"%@%@",@"Hi,\n \nI would like to invite you to join me on ActionHouse.com. A new platform for everything fitness, health & wellness.\n \nPlease click this link to follow me: ", user.vanity_url ];
    
    [self sendSMS:message recipientList:phoneArray];
    
}
@end

//
//  ActionSheetViewController.m
//  fitmoo
//
//  Created by hongjian lin on 4/14/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import "ActionSheetViewController.h"

@interface ActionSheetViewController ()

@end

@implementation ActionSheetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initFrames];
    [self hideRepostButton];
    if ([_action isEqualToString:@"share"]) {
        [self showShareViews];
    }else
        if ([_action isEqualToString:@"delete"]) {
            [_reportButton setTitle:@"Delete" forState:UIControlStateNormal];
            [_endorseButton setHidden:true];
            [self showViews];
        }else if ([_action isEqualToString:@"report"])
        {
            [_reportButton setTitle:@"Report Inappropriate" forState:UIControlStateNormal];
            [_reportButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [_endorseButton setHidden:true];
            [self showViews];
        }else if ([_action isEqualToString:@"invite"])
        {
            
            [self showInviteViews];
        }else if ([_action isEqualToString:@"menu"])
        {
            
            if (![_profileId isEqualToString:[[UserManager sharedUserManager] localUser].user_id]) {
                [_logoutButton setTitle:@"Copy Profile URL" forState:UIControlStateNormal];
                _settingButton.hidden=true;
                _menuView1.hidden=true;
            }
            
            
            
            [self showMenuViews];
        }else
        {
            [_endorseButton setHidden:false];
            [_shopButton setHidden:false];
            [_view2 setHidden:false];
            [_view4 setHidden:false];
            
            
            [self showViews];
        }
    
    if (_shareImage==nil||_hideInstegram==true) {
        //  _cpLinkButton.frame= _socialNetworkButton.frame;
        //  _socialNetworkButton.frame=_InstagramButton.frame;
        _InstagramButton.hidden=true;
        _view6.hidden=true;
        if (_hideRepost==true) {
            _view5.hidden=true;
        }
    }
    // Do any additional setup after loading the view.
}

- (void) initFrames
{
    
    
    _endorseButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_endorseButton respectToSuperFrame:self.view];
    _cancelButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_cancelButton respectToSuperFrame:self.view];
    _reportButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_reportButton respectToSuperFrame:self.view];
    _blackView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_blackView respectToSuperFrame:self.view];
    _buttomView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_buttomView respectToSuperFrame:self.view];
    
    _shareCancelButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_shareCancelButton respectToSuperFrame:self.view];
    _shareButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_shareButton respectToSuperFrame:self.view];
    _shareButtomView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_shareButtomView respectToSuperFrame:self.view];
    _socialNetworkButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_socialNetworkButton respectToSuperFrame:self.view];
    _view0.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_view0 respectToSuperFrame:self.view];
    _view1.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_view1 respectToSuperFrame:self.view];
    _view2.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_view2 respectToSuperFrame:self.view];
    _view3.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_view3 respectToSuperFrame:self.view];
    _view4.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_view4 respectToSuperFrame:self.view];
    _view5.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_view5 respectToSuperFrame:self.view];
    _view6.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_view6 respectToSuperFrame:self.view];
    
    _shopButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_shopButton respectToSuperFrame:self.view];
    _InstagramButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_InstagramButton respectToSuperFrame:self.view];
    _cpLinkButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_cpLinkButton respectToSuperFrame:self.view];
    
    
    _InviteView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_InviteView respectToSuperFrame:self.view];
    _IVView1.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_IVView1 respectToSuperFrame:self.view];
    _IVView2.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_IVView2 respectToSuperFrame:self.view];
    _IVView3.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_IVView3 respectToSuperFrame:self.view];
    _IVView4.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_IVView4 respectToSuperFrame:self.view];
    
    _InviteMyCTButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_InviteMyCTButton respectToSuperFrame:self.view];
    _CopyProfileLKButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_CopyProfileLKButton respectToSuperFrame:self.view];
    _InviteCancelButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_InviteCancelButton respectToSuperFrame:self.view];
    _ShareMyProfileButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_ShareMyProfileButton respectToSuperFrame:self.view];
    _InvitePostToInstagramButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_InvitePostToInstagramButton respectToSuperFrame:self.view];
    
    
    _menuView1.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_menuView1 respectToSuperFrame:self.view];
    _menuView2.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_menuView2 respectToSuperFrame:self.view];
    _menuBottomView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_menuBottomView respectToSuperFrame:self.view];
    _logoutButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_logoutButton respectToSuperFrame:self.view];
    _settingButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_settingButton respectToSuperFrame:self.view];
    _menuCancelButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_menuCancelButton respectToSuperFrame:self.view];
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch * touch = [touches anyObject];
    if(touch.phase == UITouchPhaseBegan) {
        //   [self disableViews];
        [self.view removeFromSuperview];
        
    }
}

- (void) showShareViews
{
    if ([_postType isEqualToString:@"workout"]) {
        [_shareButton setTitle:@"Save to my workouts" forState:UIControlStateNormal];
    }else if ([_postType isEqualToString:@"nutrition"])
    {
        [_shareButton setTitle:@"Save to my nutrition" forState:UIControlStateNormal];
    }else if ([_postType isEqualToString:@"product"])
    {
        [_shareButton setTitle:@"Repost" forState:UIControlStateNormal];
    }else
    {
        [_shareButton setTitle:@"Repost" forState:UIControlStateNormal];
        
    }
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelay:0];
    
    
    self.shareButtomView.frame = CGRectMake(0, self.view.frame.size.height-self.shareButtomView.frame.size.height, self.shareButtomView.frame.size.width, self.shareButtomView.frame.size.height);
    
    [UIView commitAnimations];
    
}

- (void) showMenuViews
{
    
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelay:0];
    
    
    self.menuBottomView.frame = CGRectMake(0, self.view.frame.size.height-self.menuBottomView.frame.size.height, self.menuBottomView.frame.size.width, self.menuBottomView.frame.size.height);
    
    [UIView commitAnimations];
    
}

- (void) showInviteViews
{
    
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelay:0];

    self.InviteView.frame = CGRectMake(0, self.view.frame.size.height-self.InviteView.frame.size.height, self.InviteView.frame.size.width, self.InviteView.frame.size.height);
    
    [UIView commitAnimations];
    
}

- (void) showViews
{

    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelay:0];

    self.buttomView.frame = CGRectMake(0, self.view.frame.size.height-self.buttomView.frame.size.height, self.buttomView.frame.size.width, self.buttomView.frame.size.height);
    
    [UIView commitAnimations];
    
}

- (void) closeView
{
    [self.view removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) InviteButtonFunction:(id)sender
{
   
    UIButton *b= (UIButton *) sender;
    switch (b.tag) {
        case 1:     //invite my friend
             [[NSNotificationCenter defaultCenter] postNotificationName:@"openInvite" object:nil];
            [self.view removeFromSuperview];
            break;
        case 2:      // post profile to instagram
            [self InstagramButtonClick:sender];
            break;
        case 3:     //share my profile
            [self socialNewworkButtonClick:sender];
            break;
        case 4:        //copyProfileLink
            [self copyLinkClick:sender];
            break;
            
        default:
            break;
    }
    
    
}

- (IBAction)logoutButtonClick:(id)sender {
    if (![_profileId isEqualToString:[[UserManager sharedUserManager] localUser].user_id]) {
        
        [self copyLinkClick:sender];
    }else
    {
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Logout"
                                                   message:@"Are you sure you want to logout?"
                                                  delegate:self
                                         cancelButtonTitle:@"No"
                                         otherButtonTitles:@"Yes",nil];
    [alert show];
    
    [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:@"HasSeenPopup"];
    }
}

- (IBAction)settingButtonClick:(id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"leftSideMenuAction" object:@"settings"];
    [self.view removeFromSuperview];
}



- (IBAction)endoseButtonClick:(id)sender {
    [[UserManager sharedUserManager] performEndorse:_postId];
    [self.view removeFromSuperview];
}

- (IBAction)reportButtonClick:(id)sender {
    if ([_action isEqualToString:@"delete"]) {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Delete"
                                                       message:@"Are you sure you want to delete this post?"
                                                      delegate:self
                                             cancelButtonTitle:@"No"
                                             otherButtonTitles:@"Yes",nil];
        [alert show];
        
        
        [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:@"HasSeenPopup"];
        
        
    }else if([_action isEqualToString:@"report"]) {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Report"
                                                       message:@"Are you sure you want to flag this post?"
                                                      delegate:self
                                             cancelButtonTitle:@"No"
                                             otherButtonTitles:@"Yes",nil];
        [alert show];
        
        
        [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:@"HasSeenPopup"];
        
        
        
    }
    [self.view removeFromSuperview];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // 0 = Tapped yes
    
    if([_action isEqualToString:@"report"])
    {
        if (buttonIndex == 1)
        {
            [[UserManager sharedUserManager] performReport:_postId];
        }
    }
    
    if([_action isEqualToString:@"delete"])
    {
        if (buttonIndex == 1)
        {
            [[UserManager sharedUserManager] performDelete:_postId];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateTable" object:_postId];
        }
    }
    
    if([_action isEqualToString:@"menu"])
    {
        if (buttonIndex == 1)
        {
            User *localUser= [[UserManager sharedUserManager] getUserLocally];
            [[UserManager sharedUserManager] performLogout:localUser];
            [self.view removeFromSuperview];
        }
    }
}
- (UIDocumentInteractionController *) setupControllerWithURL: (NSURL*) fileURL usingDelegate: (id <UIDocumentInteractionControllerDelegate>) interactionDelegate {
    UIDocumentInteractionController *interactionController = [UIDocumentInteractionController interactionControllerWithURL: fileURL];
    interactionController.delegate = interactionDelegate;
    return interactionController;
}
- (IBAction)cancelButtonClick:(id)sender {
    [self.view removeFromSuperview];
    //  [self disableViews];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)shareClick:(id)sender {
    
    [[UserManager sharedUserManager] performShare:@"" withId:_postId];
    [self.view removeFromSuperview];
}

- (IBAction)InstagramButtonClick:(id)sender {
    _shareImage= [[FitmooHelper sharedInstance] generateWatermarkForImage:_shareImage withType:_postType];
    NSData *imageData = UIImagePNGRepresentation(_shareImage); //convert image into .png format.
    
    NSFileManager *fileManager = [NSFileManager defaultManager];//create instance of NSFileManager
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //create an array and store result of our search for the documents directory in it
    
    NSString *documentsDirectory = [paths objectAtIndex:0]; //create NSString object, that holds our exact path to the documents directory
    
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"insta.igo"]]; //add our image to the path
    
    [fileManager createFileAtPath:fullPath contents:imageData attributes:nil]; //finally save the path (image)
    
    NSLog(@"image saved");
    
    
    CGRect rect = CGRectMake(0 ,0 , 0, 0);
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, self.view.opaque, 0.0);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIGraphicsEndImageContext();
    NSString *fileNameToSave = [NSString stringWithFormat:@"Documents/insta.igo"];
    NSString  *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:fileNameToSave];
    NSLog(@"jpg path %@",jpgPath);
    NSString *newJpgPath = [NSString stringWithFormat:@"file://%@",jpgPath]; //[[NSString alloc] initWithFormat:@"file://%@", jpgPath] ];
    NSLog(@"with File path %@",newJpgPath);
    NSURL *igImageHookFile = [[NSURL alloc] initFileURLWithPath:newJpgPath];
    NSLog(@"url Path %@",igImageHookFile);
    
    self.docFile.UTI = @"com.instagram.exclusivegram";
    self.docFile = [self setupControllerWithURL:igImageHookFile usingDelegate:self];
    self.docFile=[UIDocumentInteractionController interactionControllerWithURL:igImageHookFile];
    [self.docFile presentOpenInMenuFromRect: rect    inView: self.view animated: YES ];
    
    
}


- (NSString *) defineUrl
{
    
    if ([_action isEqualToString:@"invite"]||[_action isEqualToString:@"menu"]) {
        return [NSString stringWithFormat:@"%@%@", @"https://urlrouter.fitmoo.com/profile/", _profileId];
    }
    
    NSString *url;
    
    NSString *rootUrl;
    if (_communityId!=nil) {
        rootUrl=@"https://urlrouter.fitmoo.com/community/";
    }else
    {
        rootUrl=@"https://urlrouter.fitmoo.com/profile/";
    }
    
    if (_feedActionId!=nil) {
        url =[NSString stringWithFormat:@"%@%@%@%@%@%@",rootUrl, _profileId, @"/feed/",_postId,@"/fa/",_feedActionId];
    }else
    {
        url = [NSString stringWithFormat:@"%@%@%@%@",rootUrl, _profileId, @"/feed/",_postId];
    }
    
    return url;
}
- (IBAction)socialNewworkButtonClick:(id)sender {
    
    
    NSArray *activityItems;
    NSURL *url=[NSURL URLWithString:[self defineUrl]];
    
    
    if (_shareVideo!=nil) {
        NSURL *_URL=[NSURL URLWithString:_shareVideo];
        activityItems = @[_ShareTitle, _URL];
    }
    else if (_shareImage!=nil) {
        
        _shareImage= [[FitmooHelper sharedInstance] generateWatermarkForImage:_shareImage withType:_postType];
        activityItems = @[_ShareTitle, url, _shareImage];
    }else
    {
        activityItems = @[_ShareTitle, url];
    }
    
    UIActivityViewController *activityController =
    [[UIActivityViewController alloc]
     initWithActivityItems:activityItems
     applicationActivities:nil];
    
    [self presentViewController:activityController
                       animated:YES completion:nil];
    
    //      [self.view removeFromSuperview];
}

- (IBAction)shopButtonClick:(id)sender {
    if (_shoplink!=nil) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_shoplink]];
    }else
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://fitmoo.com/store/landing"]];
    }
    
    
}

- (void) hideRepostButton
{
    if (_hideRepost==true) {
        _shareButton.hidden=true;
        _view6.hidden=true;
        _InstagramButton.frame=_socialNetworkButton.frame;
        _socialNetworkButton.frame=_cpLinkButton.frame;
        _cpLinkButton.frame=_shareButton.frame;
        
    }
}

- (IBAction)shareCancelClick:(id)sender {
    [self.view removeFromSuperview];
}
- (IBAction)copyLinkClick:(id)sender {
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = [self defineUrl];
    
    UIAlertView *alert = [[ UIAlertView alloc ] initWithTitle : @"Copied"
                                                      message : @"Link copied successfully." delegate : nil cancelButtonTitle : @"OK"
                                            otherButtonTitles : nil ];
    [alert show ];
}
@end

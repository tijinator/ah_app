//
//  ShopDetailViewController.m
//  fitmoo
//
//  Created by hongjian lin on 9/1/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import "ShopDetailViewController.h"
#import "AFNetworking.h"
#import "FSBasicImage.h"
#import "FSBasicImageSource.h"
#import "FSImageViewerViewController.h"
#import "CommentViewController.h"
#import "ActionSheetViewController.h"
#import <SwipeBack/SwipeBack.h>
@interface ShopDetailViewController ()
{
    NSNumber * contentHight;
    bool bodyLikeAnimation;
    NSString *OriganlVariantsButtonsStrings;
}
@end

@implementation ShopDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initFrames];
    _pickerDisplayArray=[[NSMutableArray alloc] init];
    [self createObservers];
    self.navigationController.swipeBackEnabled = YES;
    // Do any additional setup after loading the view.
}

-(void)createObservers{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didPostFinished" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didPostFinished:) name:@"didPostFinished" object:nil];
}


- (void) didPostFinished: (NSNotification * ) note
{
    
    _homeFeed= (HomeFeed *)[note object];
    
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
    
    
    _typePickerView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_typePickerView respectToSuperFrame:nil];
    
    double x1=(self.view.frame.size.width-_typePicker.frame.size.width)/2;
    _typePicker.frame= CGRectMake(_typePicker.frame.origin.x+x1, _typePicker.frame.origin.y*[[FitmooHelper sharedInstance] frameRadio], _typePicker.frame.size.width, _typePicker.frame.size.height);
    _doneButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_doneButton respectToSuperFrame:nil];
    _pickerBackView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_pickerBackView respectToSuperFrame:nil];
    
    if (self.view.frame.size.height<500) {
        
        _tableView.frame= CGRectMake(_tableView.frame.origin.x,_tableView.frame.origin.y, _tableView.frame.size.width, _tableView.frame.size.height-88);
        
    }
    
    
    _titleLabel.text=_homeFeed.product.title;
    
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
    ShopTableViewCell *cell =(ShopTableViewCell *) [self.tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ShopTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    HomeFeed * tempHomefeed=_homeFeed;
    cell.homeFeed=_homeFeed;
    
    
    //case for topview
    [cell setTopViewFrameForProduct];
    
    //case for headerview
    if ([tempHomefeed.feed_action.action isEqualToString:@"post"]||tempHomefeed.feed_action.action==nil) {
        cell.heanderImage1.hidden=true;
        [cell reDefineHearderViewsFrame];
    }else
    {
        cell.heanderImage1.hidden=false;
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.heanderImage1.frame.size.width, cell.heanderImage1.frame.size.height)];
        view.layer.cornerRadius=view.frame.size.width/2;
        view.clipsToBounds=YES;
        view.userInteractionEnabled = NO;
        view.exclusiveTouch = NO;
        AsyncImageView *headerImage1 = [[AsyncImageView alloc] initWithFrame:CGRectMake(0, 0, cell.heanderImage1.frame.size.width, cell.heanderImage1.frame.size.height)];
        
        
        headerImage1.userInteractionEnabled = NO;
        headerImage1.exclusiveTouch = NO;
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:headerImage1];
        if ([tempHomefeed.feed_action.community_id isEqual:[NSNull null]])
        {
            headerImage1.imageURL =[NSURL URLWithString:tempHomefeed.feed_action.created_by.thumb];
            [cell.heanderImage1 setTag:tempHomefeed.feed_action.user_id.intValue];
        }else
        {
            headerImage1.imageURL =[NSURL URLWithString:tempHomefeed.feed_action.created_by_community.cover_photo_url];
            [cell.heanderImage1 setTag:tempHomefeed.feed_action.community_id.intValue];
        }
        [cell.heanderImage1.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
        [view addSubview:headerImage1];
        [cell.heanderImage1 addSubview:view];
        
        
        [cell.heanderImage1 addTarget:self action:@selector(headerImageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        if ([tempHomefeed.feed_action.action isEqualToString:@"share"]) {
            if (!(tempHomefeed.feed_action.community_id==nil||[tempHomefeed.feed_action.community_id isEqual:[NSNull null]])) {
                [cell.heanderImage1 removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
                [cell.heanderImage1 addTarget:self action:@selector(CommunityHeaderImageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
        
        
    }
    
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.headerImage2.frame.size.width, cell.headerImage2.frame.size.height)];
    view.clipsToBounds=YES;
    view.layer.cornerRadius=view.frame.size.width/2;
    view.userInteractionEnabled = NO;
    view.exclusiveTouch = NO;
    AsyncImageView *headerImage2 = [[AsyncImageView alloc] initWithFrame:CGRectMake(0, 0, cell.headerImage2.frame.size.width, cell.headerImage2.frame.size.height)];
    headerImage2.userInteractionEnabled = NO;
    headerImage2.exclusiveTouch = NO;
    headerImage2.layer.cornerRadius=headerImage2.frame.size.width/2;
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:headerImage2];
    if ([tempHomefeed.community_id isEqual:[NSNull null]])
    {
        headerImage2.imageURL =[NSURL URLWithString:tempHomefeed.created_by.thumb];
        [cell.headerImage2 setTag:tempHomefeed.created_by.created_by_id.intValue];
        [cell.titleLabel setTag:tempHomefeed.created_by.created_by_id.intValue];
        
    }else
    {
        headerImage2.imageURL =[NSURL URLWithString:tempHomefeed.created_by_community.cover_photo_url];
        [cell.headerImage2 setTag:tempHomefeed.created_by_community.created_by_community_id.intValue];
        [cell.titleLabel setTag:tempHomefeed.created_by_community.created_by_community_id.intValue];
    }
    [cell.headerImage2.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    [view addSubview:headerImage2];
    [cell.headerImage2 addSubview:view];
    
    if ([tempHomefeed.community_id isEqual:[NSNull null]]) {
        
        [cell.headerImage2 addTarget:self action:@selector(headerImageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        [cell.headerImage2 addTarget:self action:@selector(CommunityHeaderImageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    cell.titleLabel.text= tempHomefeed.title_info.avatar_title;
    [cell setTitleLabelForHeader];
    
    cell.dayLabel.frame= CGRectMake(cell.dayLabel.frame.origin.x, cell.titleLabel.frame.size.height+cell.titleLabel.frame.origin.y+3, cell.dayLabel.frame.size.width, cell.dayLabel.frame.size.height);
    NSRange range= NSMakeRange(0, tempHomefeed.created_at.length-3);
    NSString * timestring= [tempHomefeed.created_at substringWithRange:range];
    NSTimeInterval time=(NSTimeInterval ) timestring.intValue;
    NSDate *dayBegin= [[NSDate alloc] initWithTimeIntervalSince1970:time];
    NSDate *today= [NSDate date];
    cell.dayLabel.text= [[FitmooHelper sharedInstance] daysBetweenDate:dayBegin andDate:today];
    
    [cell rebuiltHeaderViewFrame];
    
    //case for photo and video exits, bodyview
    if ([tempHomefeed.photoArray count]!=0||[tempHomefeed.videosArray count]!=0) {
        
        
        if ([tempHomefeed.photoArray count]!=0&&[tempHomefeed.videosArray count]==0) {
            double maxHeightIndex=0;
            double radioBetweenWandH=0;
            for (int i=0; i<[tempHomefeed.photoArray count]; i++) {
                [tempHomefeed resetPhotos];
                tempHomefeed.photos= [tempHomefeed.photoArray objectAtIndex:i];
                double width= tempHomefeed.photos.stylesUrlWidth.doubleValue;
                double height= tempHomefeed.photos.stylesUrlHeight.doubleValue;
                if (width>height) {
                    if (radioBetweenWandH<(height/width)) {
                        radioBetweenWandH=height/width;
                        maxHeightIndex=i;
                    }
                }else
                {
                    radioBetweenWandH=1;
                    maxHeightIndex=i;
                }
            }
            [tempHomefeed resetPhotos];
            tempHomefeed.photos=[tempHomefeed.photoArray objectAtIndex:maxHeightIndex];
            if (radioBetweenWandH<1) {
                double width= 320;
                double height= tempHomefeed.photos.stylesUrlHeight.doubleValue*(320/tempHomefeed.photos.stylesUrlWidth.doubleValue);
                
                cell.scrollbelowFrame= [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
            }
            
        }
        
        [cell addScrollView];
        if (![tempHomefeed.type isEqualToString:@"event"])
        {
            [cell setBodyShadowFrameForImagePost];
        }
        
        
        
    }else
    {
        [cell removeViewsFromBodyView:cell.scrollbelowFrame];
    }
    
    [cell setBodyFrameForProduct];
    
    [cell rebuiltBodyViewFrame];
    
    [cell setVariantsFrame];
     OriganlVariantsButtonsStrings=[NSString stringWithFormat:@"%@+%@+%@+%@",cell.variantsButton1.titleLabel.text.uppercaseString,cell.variantsButton2.titleLabel.text.uppercaseString,cell.variantsButton3.titleLabel.text.uppercaseString,cell.variantsButton4.titleLabel.text.uppercaseString,nil];
    
    //built comment view
    if ([tempHomefeed.commentsArray count]!=0) {
        [cell.commentView.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
        NSString *totalCommment= [NSString stringWithFormat:@" %@",[[FitmooHelper sharedInstance] getTextForNumber:tempHomefeed.total_comment]];
        [cell.bodyCommentButton setTitle:totalCommment  forState:UIControlStateNormal];
        for (int i=0; i<[tempHomefeed.commentsArray count]; i++) {
            cell.homeFeed.comments=[tempHomefeed.commentsArray objectAtIndex:i];
            [cell addCommentView:cell.commentView Atindex:i];
        }
        [cell rebuiltCommentViewFrame];
    }else
    {
        [cell removeCommentView];
    }
    
    
    //built bottom view
    [cell.likeButton setTag:indexPath.row*100+4];
    [cell.commentButton setTag:indexPath.row*100+5];
    [cell.viewAllCommentButton setTag:indexPath.row*100+5];
    [cell.bodyCommentButton setTag:indexPath.row*100+5];
    [cell.shareButton setTag:indexPath.row*100+6];
    [cell.optionButton setTag:indexPath.row*100+7];
    [cell.bodyImage setTag:indexPath.row*100+8];
    [cell.bodyLikeButton setTag:indexPath.row*100+4];
    
    [cell.variantsButton1 setTag:indexPath.row*100+10];
    [cell.variantsButton2 setTag:indexPath.row*100+11];
    [cell.variantsButton3 setTag:indexPath.row*100+12];
    [cell.variantsButton4 setTag:indexPath.row*100+13];
    
    _variantButton1=cell.variantsButton1;
    _variantButton2=cell.variantsButton2;
    _variantButton3=cell.variantsButton3;
    _variantButton4=cell.variantsButton4;
    
    
    [cell.variantsButton1 addTarget:self action:@selector(variantsButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.variantsButton2 addTarget:self action:@selector(variantsButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.variantsButton3 addTarget:self action:@selector(variantsButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.variantsButton4 addTarget:self action:@selector(variantsButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *totalLike= [NSString stringWithFormat:@" %@",[[FitmooHelper sharedInstance] getTextForNumber:tempHomefeed.total_like]];
    [cell.bodyLikeButton setTitle:totalLike forState:UIControlStateNormal];
    if ([tempHomefeed.is_liked isEqualToString:@"1"]) {
        [cell.likeButton setImage:[UIImage imageNamed:@"blueheart.png"] forState:UIControlStateNormal];
        [cell.bodyLikeButton setImage:[UIImage imageNamed:@"blueheart100.png"] forState:UIControlStateNormal];
        [cell.likeButton addTarget:self action:@selector(likeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        if (bodyLikeAnimation==true) {
            [[FitmooHelper sharedInstance] likeButtonAnimation:cell.bodyLikeButton];
            bodyLikeAnimation=false;
        }
    }else
    {
        [cell.likeButton setImage:[UIImage imageNamed:@"hearticon.png"] forState:UIControlStateNormal];
        [cell.likeButton addTarget:self action:@selector(likeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    [cell.bodyLikeButton addTarget:self action:@selector(bodyLikeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.commentButton addTarget:self action:@selector(commentButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.bodyCommentButton addTarget:self action:@selector(commentButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.viewAllCommentButton addTarget:self action:@selector(commentButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.shareButton addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.optionButton addTarget:self action:@selector(optionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    //  [cell.bodyImage addTarget:self action:@selector(bodyImageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *tapGestureRecognizer10 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bodyImageTagClick:)];
    tapGestureRecognizer10.numberOfTapsRequired = 1;
    UITapGestureRecognizer *tapGestureRecognizer11 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(likeTagClick:)];
    tapGestureRecognizer11.numberOfTapsRequired = 2;
    [tapGestureRecognizer10 requireGestureRecognizerToFail:tapGestureRecognizer11];
    
    [cell.bodyImage addGestureRecognizer:tapGestureRecognizer10];
    [cell.bodyImage addGestureRecognizer:tapGestureRecognizer11];
    cell.bodyImage.userInteractionEnabled=YES;
    
    
    contentHight=[NSNumber numberWithInteger: cell.buttomView.frame.origin.y + cell.buttomView.frame.size.height+60] ;
    
    
    
    return cell;
}



- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *link;
    if ([_homeFeed.type isEqualToString:@"product"]) {
        if (_homeFeed.feed_action.feed_action_id!=nil) {
            link= [NSString stringWithFormat:@"%@%@%@%@%@%@",@"https://fitmoo.com/profile/",_homeFeed.feed_action.user_id,@"/feed/",_homeFeed.feed_id,@"/fa/",_homeFeed.feed_action.feed_action_id];
        }
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"shopAction" object:link];
    }
    
    
    
    
}

// multy high table cell
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    return contentHight.intValue;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        //    _postText= textView.text;
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)postButtonClick:(id)sender {
    
    if ([_action isEqualToString:@"Post"]) {
        
        [[UserManager sharedUserManager] performComment:_textView.text withId:_homeFeed.feed_id];
        
    }else if ([_action isEqualToString:@"Share"])
    {
        [[UserManager sharedUserManager] performShare:_textView.text withId:_homeFeed.feed_id];
        
    }
    
    
    
}
- (IBAction)CommunityHeaderImageButtonClick:(id)sender {
    UIButton *button = (UIButton *)sender;
    NSString *buttontag=[NSString stringWithFormat:@"%ld",((long)button.tag)];
    NSString *key=[NSString stringWithFormat:@"%@%ld",@"com",((long)button.tag)];
    if (![buttontag isEqualToString:_searchCommunityId]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"leftSideMenuAction" object:key];
    }else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
    
}




#pragma mark - UIPickerViewDelegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
    
    if ([_pickerDisplayArray count]>0) {
        NSString *selectedString=[_pickerDisplayArray objectAtIndex:row];
        [_SelectedVariantButton setTitle:selectedString forState:UIControlStateNormal];
        if ([selectedString isEqualToString:@"0"]) {
              [_SelectedVariantButton setTitle:@"Qty" forState:UIControlStateNormal];
        }
       
        
        for (int i=0; i<[_homeFeed.product.variant_matrix_array count]; i++) {
            [_homeFeed.product resetMatrixs];
            _homeFeed.product.variant_matrix= [_homeFeed.product.variant_matrix_array objectAtIndex:i];
            
            if ([selectedString isEqualToString:_homeFeed.product.variant_matrix.matrix_name]) {
                _selectedMatrixs=_homeFeed.product.variant_matrix;
            }
            
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
    NSString *title=[_pickerDisplayArray objectAtIndex:row];
    
    
    return title;
}

// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    int sectionWidth = 300;
    
    return sectionWidth;
}


//
//- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
//{
//    return 30;
//}

//- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
//{
//    UILabel *columnView = [[UILabel alloc] initWithFrame:CGRectMake(35, 0, self.view.frame.size.width/3 - 35, 30)];
//    columnView.text = [NSString stringWithFormat:@"%lu", (long) row];
//    columnView.textAlignment = NSTextAlignmentLeft;
//
//    return columnView;
//}




#pragma mark -buttomButton functions
- (IBAction)commentButtonClick:(id)sender {
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CommentViewController *commentPage = [mainStoryboard instantiateViewControllerWithIdentifier:@"CommentViewController"];
    commentPage.homeFeed= _homeFeed;
    
    [self.navigationController pushViewController:commentPage animated:YES];
    
}

- (IBAction)bodyLikeButtonClick:(id)sender {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main1" bundle:nil];
    ComposeViewController *composePage = [mainStoryboard instantiateViewControllerWithIdentifier:@"ComposeViewController"];
    composePage.searchId= _homeFeed.feed_id;
    composePage.searchType=@"like";
    [self.navigationController pushViewController:composePage animated:YES];
    
    
}

- (IBAction)doneButtonClick:(id)sender
{
    _typePickerView.hidden=true;
}


- (BOOL) checkeQTYButton:(UIButton *) QTYButton
{
    
    if ([_homeFeed.product.variant_options_array count]==0&&QTYButton.tag==10) {
        
        return true;
    }else if ([_homeFeed.product.variant_options_array count]==1&&QTYButton.tag==11) {
        
        return true;
    }else if ([_homeFeed.product.variant_options_array count]==2&&QTYButton.tag==12) {
        
        return true;
    }else if ([_homeFeed.product.variant_options_array count]==3&&QTYButton.tag==13) {
        
        return true;
    }
    
    
    
    
    return false;
}

- (IBAction)variantsButtonClick:(id)sender {
    UIButton *b=(UIButton *)sender;
    [self dehighLightButtons:b];
    _SelectedVariantButton=b;
    
    
    
    NSString *title=b.titleLabel.text;
    if ([self checkeQTYButton:b]==true) {
        if ([_homeFeed.product.variant_array count]==1) {
            [_homeFeed.product resetVariants];
            _homeFeed.product.variants=[_homeFeed.product.variant_array objectAtIndex:0];
            int quantity= _homeFeed.product.variants.quantity.intValue;
            _pickerDisplayArray=[[NSMutableArray alloc] init];
            for (int i=0; i<quantity; i++) {
                [_pickerDisplayArray addObject:[NSString stringWithFormat:@"%d",i]];
            }
            
            
            _selectedVariants= [_homeFeed.product.variant_array objectAtIndex:0];
            
        }else
        {
            //find variants
            _selectedVariants=[[Variants alloc] init];
            for (int i=0; i<[_homeFeed.product.variant_array count]; i++) {
                [_homeFeed.product resetVariants];
                _homeFeed.product.variants=[_homeFeed.product.variant_array objectAtIndex:i];
                if (![_homeFeed.product.variants.options isEqual:[NSNull null]]) {
                    //     NSArray *optionsArray= [_homeFeed.product.variants.options componentsSeparatedByString:@"/"];
                    
                    BOOL found=true;
                    NSString *checkString;
                    NSString *checkString1;
                    NSString *checkString2;
                    
                    
                    
                    
                    if ([_homeFeed.product.variant_options_array count]==1)//use button 1
                    {
                        checkString=[[FitmooHelper sharedInstance] checkStringIsANumeric:_variantButton1.titleLabel.text];
                        
                        if ([_homeFeed.product.variants.options rangeOfString:checkString].location == NSNotFound) {
                            found=false;
                        }
                        
                        
                    }else if ([_homeFeed.product.variant_options_array count]==2)//use button 1,2
                    {
                        
                        checkString=[[FitmooHelper sharedInstance] checkStringIsANumeric:_variantButton1.titleLabel.text];
                        checkString1=[[FitmooHelper sharedInstance] checkStringIsANumeric:_variantButton2.titleLabel.text];
                        
                        if ([_homeFeed.product.variants.options rangeOfString:checkString].location == NSNotFound) {
                            found=false;
                        }
                        if ([_homeFeed.product.variants.options rangeOfString:checkString1].location == NSNotFound) {
                            found=false;
                        }
                        
                    }else if ([_homeFeed.product.variant_options_array count]==3)//use button 1,2,3
                    {
                        
                        
                        checkString=[[FitmooHelper sharedInstance] checkStringIsANumeric:_variantButton1.titleLabel.text];
                        checkString1=[[FitmooHelper sharedInstance] checkStringIsANumeric:_variantButton2.titleLabel.text];
                        checkString2=[[FitmooHelper sharedInstance] checkStringIsANumeric:_variantButton3.titleLabel.text];
                        
                        if ([_homeFeed.product.variants.options rangeOfString:checkString].location == NSNotFound) {
                            found=false;
                        }
                        if ([_homeFeed.product.variants.options rangeOfString:checkString1].location == NSNotFound) {
                            found=false;
                        }
                        if ([_homeFeed.product.variants.options rangeOfString:checkString2].location == NSNotFound) {
                            found=false;
                        }
                    }
                    
                    
                    if (found==true) {
                        _selectedVariants= _homeFeed.product.variants;
                    }
                    
                }
                
                
                
                
            }
            
            _pickerDisplayArray=[[NSMutableArray alloc] init];
            if (_selectedVariants!=nil) {
                int quantity= _selectedVariants.quantity.intValue;
                for (int i=0; i<quantity; i++) {
                    [_pickerDisplayArray addObject:[NSString stringWithFormat:@"%d",i]];
                }
            }
            
            
            
        }
        
        
    }else
    {
        
        if (_selectedMatrixs==nil||[_homeFeed.product.variant_matrix_array count]==0) {
            for (int i=0; i<[_homeFeed.product.variant_options_array count]; i++) {
                [_homeFeed.product resetOptions];
                _homeFeed.product.variant_options=[_homeFeed.product.variant_options_array objectAtIndex:i];
                
                if ([title.uppercaseString isEqualToString:_homeFeed.product.variant_options.title.uppercaseString]) {
                    _pickerDisplayArray=_homeFeed.product.variant_options.optionArray;
                }
                
                for (int j=0; j<[_homeFeed.product.variant_options.optionArray count]; j++) {
                    if ([title isEqualToString:[_homeFeed.product.variant_options.optionArray objectAtIndex:j]]) {
                        _pickerDisplayArray=_homeFeed.product.variant_options.optionArray;
                    }
                }
                
            }
        }else
        {
            //selecting the button which is just selected
            if ([_selectedMatrixs.matrix_name isEqualToString:b.titleLabel.text]) {
                for (int i=0; i<[_homeFeed.product.variant_options_array count]; i++) {
                    [_homeFeed.product resetOptions];
                    _homeFeed.product.variant_options=[_homeFeed.product.variant_options_array objectAtIndex:i];
                    
                    if ([title.uppercaseString isEqualToString:_homeFeed.product.variant_options.title.uppercaseString]) {
                        _pickerDisplayArray=_homeFeed.product.variant_options.optionArray;
                    }
                    
                    for (int j=0; j<[_homeFeed.product.variant_options.optionArray count]; j++) {
                        if ([title isEqualToString:[_homeFeed.product.variant_options.optionArray objectAtIndex:j]]) {
                            _pickerDisplayArray=_homeFeed.product.variant_options.optionArray;
                        }
                    }
                    
                }
                
            }else //selecting other buttons
            {
                for (int i=0; i<[_selectedMatrixs.matrix_option_array count]; i++) {
                    
                    //other button not selected
                    if ([b.titleLabel.text.lowercaseString isEqualToString:[_selectedMatrixs.matrix_option_array objectAtIndex:i]]) {
                        _pickerDisplayArray=[_selectedMatrixs.matrix_data_array objectAtIndex:i];
                    }
                    
                    
                    //other button has previous selected
                    NSMutableArray *matrixsOptions=[_selectedMatrixs.matrix_data_array objectAtIndex:i];
                    for (int j=0; j<[matrixsOptions count]; j++) {
                        if ([b.titleLabel.text isEqualToString:[matrixsOptions objectAtIndex:j]]) {
                            _pickerDisplayArray=[_selectedMatrixs.matrix_data_array objectAtIndex:i];
                        }
                    }
                    
                }
            }
        }
        
    }
    
    [_typePicker reloadAllComponents];
    
    for (int i=0; i<[_pickerDisplayArray count]; i++) {
        if ([title.lowercaseString isEqualToString:[_pickerDisplayArray objectAtIndex:i]]) {
            [_typePicker selectRow:i inComponent:0 animated:NO];
        }
    }
    
    _typePickerView.hidden=false;
}

- (IBAction)likeButtonClick:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    if ([_homeFeed.is_liked isEqualToString:@"0"]) {
        NSNumber *totalLike=[NSNumber numberWithInt:1+_homeFeed.total_like.intValue];
        
        [button setImage:[UIImage imageNamed:@"blueheart.png"] forState:UIControlStateNormal];
        [[UserManager sharedUserManager] performLike:_homeFeed.feed_id];
        _homeFeed.is_liked=@"1";
        _homeFeed.total_like=totalLike.stringValue;
        
        
        [self.tableView reloadData];
        
    }else if ([_homeFeed.is_liked isEqualToString:@"1"])
    {
        NSNumber *totalLike=[NSNumber numberWithInt:_homeFeed.total_like.intValue-1];
        [button setImage:[UIImage imageNamed:@"hearticon.png"] forState:UIControlStateNormal];
        [[UserManager sharedUserManager] performUnLike:_homeFeed.feed_id];
        _homeFeed.is_liked=@"0";
        _homeFeed.total_like=totalLike.stringValue;
        
        [self.tableView reloadData];
        
    }
    
    
    
}
- (IBAction)optionButtonClick:(id)sender {
    
    HomeFeed *feed= _homeFeed;
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ActionSheetViewController *ActionSheet = [mainStoryboard instantiateViewControllerWithIdentifier:@"ActionSheetViewController"];
    
    if ([feed.action_sheet isEqualToString:@"endorse"]) {
        ActionSheet.action= @"endorse";
        NSString *link;
        if (feed.feed_action.feed_action_id!=nil) {
            link= [NSString stringWithFormat:@"%@%@%@%@%@%@",@"https://fitmoo.com/profile/",feed.feed_action.user_id,@"/feed/",feed.feed_id,@"/fa/",feed.feed_action.feed_action_id];
        }
        ActionSheet.shoplink= link;
    }else if ([feed.action_sheet isEqualToString:@"report"]) {
        ActionSheet.action= @"report";
        
    }else if ([feed.action_sheet isEqualToString:@"delete"]) {
        ActionSheet.action= @"delete";
        [ActionSheet.reportButton setTitle:@"Delete" forState:UIControlStateNormal];
        
    }
    ActionSheet.postId= feed.feed_id;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"openPopup" object:ActionSheet];
    
}


- (IBAction)bodyImageButtonClick:(id)sender{
    
    NSString * url= _homeFeed.videos.video_url;
    
    if(url==nil)
    {
        //    UIImage *image= (UIImage *)[note object];
        NSMutableArray *imageArray= [[NSMutableArray alloc] init];
        for (int i=0; i<[_homeFeed.photoArray count]; i++) {
            
            AsyncImageView *image = [_homeFeed.AsycImageViewArray objectAtIndex:i];
            FSBasicImage *firstPhoto = [[FSBasicImage alloc] initWithImage:image.image];
            
            
            [imageArray addObject:firstPhoto];
            
        }
        
        
        FSBasicImageSource *photoSource = [[FSBasicImageSource alloc] initWithImages:imageArray];
        FSImageViewerViewController *imageViewController = [[FSImageViewerViewController alloc] initWithImageSource:photoSource];
        imageViewController.backgroundColorVisible=[UIColor blackColor];
        imageViewController.sharingDisabled=true;
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imageViewController];
        [self presentViewController:navigationController animated:YES completion:nil];
        
    }
    
    
}

- (IBAction)headerImageButtonClick:(id)sender {
    UIButton *button = (UIButton *)sender;
    NSString *key=[NSString stringWithFormat:@"%ld", (long)button.tag];
    //  User *tempUser= [[UserManager sharedUserManager] localUser];
    
    if ([key isEqualToString:_searchId]) {
        //  [[NSNotificationCenter defaultCenter] postNotificationName:@"leftSideMenuAction" object:@"6"];
        [self.navigationController popViewControllerAnimated:YES];
    }else
    {
        key=[NSString stringWithFormat:@"%ld", ((long)button.tag+100)];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"leftSideMenuAction" object:key];
    }
    
}

- (IBAction)bodyImageTagClick:(id)sender {
    float tag=[(UIGestureRecognizer *)sender view].tag;
    UIButton *b= [[UIButton alloc] init];
    b.tag=tag;
    [self bodyImageButtonClick:b];
}

- (IBAction)likeTagClick:(id)sender {
    UIButton *myButton = (UIButton *)[(UIGestureRecognizer *)sender view];
    [self likeButtonClick:myButton];
    bodyLikeAnimation=true;
}

- (IBAction)shareButtonClick:(id)sender {
    
    User *localUser= [[UserManager sharedUserManager] localUser];
    //      if (![localUser.user_id isEqualToString:_searchId]) {
    HomeFeed *tempFeed= _homeFeed;
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ActionSheetViewController *ActionSheet = [mainStoryboard instantiateViewControllerWithIdentifier:@"ActionSheetViewController"];
    ActionSheet.action= @"share";
    
    if (_searchId==nil) {
        ActionSheet.hideRepost=true;
    }
    
    if ([tempFeed.AsycImageViewArray count]!=0) {
        AsyncImageView *image = [tempFeed.AsycImageViewArray objectAtIndex:0];
        ActionSheet.shareImage= image.image;
    }
    
    if ([localUser.user_id isEqualToString:_searchId]) {
        ActionSheet.hideRepost=true;
    }
    
    if ([tempFeed.videosArray count]!=0) {
        NSString * url= tempFeed.videos.video_url;
        if ([url rangeOfString:@"vimeo.com"].location == NSNotFound)
        {
            ActionSheet.hideInstegram= true;
        }
        
    }
    if ([tempFeed.type isEqualToString:@"regular"]) {
        ActionSheet.ShareTitle=tempFeed.text;
    }else if ([tempFeed.type isEqualToString:@"workout"])
    {
        ActionSheet.ShareTitle=tempFeed.workout_title;
    }else if ([tempFeed.type isEqualToString:@"nutrition"])
    {
        ActionSheet.ShareTitle=tempFeed.nutrition.title;
    }else if ([tempFeed.type isEqualToString:@"product"])
    {
        ActionSheet.ShareTitle=tempFeed.product.title;
    }
    
    ActionSheet.postType=tempFeed.type;
    ActionSheet.postId= tempFeed.feed_id;
    
    if (![tempFeed.feed_action.community_id isEqual:[NSNull null]]) {
        ActionSheet.communityId= tempFeed.feed_action.community_id;
        ActionSheet.profileId=tempFeed.feed_action.community_id;
    }else
    {
        ActionSheet.profileId= tempFeed.created_by.created_by_id;
        
    }
    if (tempFeed.feed_action!=nil||![tempFeed.feed_action isEqual:[NSNull null]]) {
        ActionSheet.feedActionId= tempFeed.feed_action.feed_action_id;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"openPopup" object:ActionSheet];
    
    
}


- (IBAction)backButtonClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void) openShopCartPage
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main1" bundle:nil];
    ShopCartViewController *ShopCartPage = [mainStoryboard instantiateViewControllerWithIdentifier:@"ShopCartViewController"];
    
    
    [self.navigationController pushViewController:ShopCartPage animated:YES];
}

- (void) highLightButtons:(UIButton *) button
{
    [[button layer] setBorderWidth:2.0f];
    [[button layer] setBorderColor:[UIColor redColor].CGColor];
}

- (void) dehighLightButtons:(UIButton *) button
{
    [[button layer] setBorderWidth:0.0f];
  
}

- (IBAction)BuyNowButtonClick:(id)sender {
    
//    [self openShopCartPage];
//    return;
    
    NSString *endorser_id;
    NSString *variant_id;
    NSString *type=@"Product";
    NSString *quantity;
    if ([_homeFeed.feed_action.action isEqualToString:@"endorse"]) {
        endorser_id= _homeFeed.feed_action.created_by.created_by_id;
    }
    if (_selectedVariants!=nil) {
        variant_id=_selectedVariants.variants_id;
    }else
    {
        UIAlertView *alert = [[ UIAlertView alloc ] initWithTitle : @"Oops"
                                                          message : @"Please select one of each option." delegate : nil cancelButtonTitle : @"OK"
                                                otherButtonTitles : nil ];
        [alert show ];
        NSString *checkString;
        NSString *checkString1;
        NSString *checkString2;
        NSString *checkString3; //qty
        
        
        if ([_homeFeed.product.variant_options_array count]==0)//use button 1
        {
            checkString3=[[FitmooHelper sharedInstance] checkStringIsANumeric:_variantButton1.titleLabel.text];
            if ([OriganlVariantsButtonsStrings rangeOfString:checkString3].location != NSNotFound) {
                [self highLightButtons:_variantButton1];
            }else
            {
                [self dehighLightButtons:_variantButton1];
            }
        }
       else if ([_homeFeed.product.variant_options_array count]==1)//use button 1 2
        {
            checkString=[[FitmooHelper sharedInstance] checkStringIsANumeric:_variantButton1.titleLabel.text];
            
            if ([OriganlVariantsButtonsStrings rangeOfString:checkString].location != NSNotFound) {
                [self highLightButtons:_variantButton1];
            }else
            {
                [self dehighLightButtons:_variantButton1];
            }
            
            checkString3=[[FitmooHelper sharedInstance] checkStringIsANumeric:_variantButton2.titleLabel.text];
            if ([OriganlVariantsButtonsStrings rangeOfString:checkString3].location != NSNotFound) {
                [self highLightButtons:_variantButton2];
            }else
            {
                [self dehighLightButtons:_variantButton2];
            }
            
            
        }else if ([_homeFeed.product.variant_options_array count]==2)//use button 1,2 3
        {
            
            checkString=[[FitmooHelper sharedInstance] checkStringIsANumeric:_variantButton1.titleLabel.text];
            checkString1=[[FitmooHelper sharedInstance] checkStringIsANumeric:_variantButton2.titleLabel.text];
            
            if ([OriganlVariantsButtonsStrings rangeOfString:checkString].location != NSNotFound) {
                  [self highLightButtons:_variantButton1];
            }else
            {
                [self dehighLightButtons:_variantButton1];
            }
            if ([OriganlVariantsButtonsStrings rangeOfString:checkString1].location != NSNotFound) {
                  [self highLightButtons:_variantButton2];
            }else
            {
                [self dehighLightButtons:_variantButton2];
            }
            
            checkString3=[[FitmooHelper sharedInstance] checkStringIsANumeric:_variantButton3.titleLabel.text];
            if ([OriganlVariantsButtonsStrings rangeOfString:checkString3].location != NSNotFound) {
                [self highLightButtons:_variantButton3];
            }else
            {
                [self dehighLightButtons:_variantButton3];
            }
            
        }else if ([_homeFeed.product.variant_options_array count]==3)//use button 1,2,3 4
        {
            
            
            checkString=[[FitmooHelper sharedInstance] checkStringIsANumeric:_variantButton1.titleLabel.text];
            checkString1=[[FitmooHelper sharedInstance] checkStringIsANumeric:_variantButton2.titleLabel.text];
            checkString2=[[FitmooHelper sharedInstance] checkStringIsANumeric:_variantButton3.titleLabel.text];
            
            if ([OriganlVariantsButtonsStrings rangeOfString:checkString].location != NSNotFound) {
                [self highLightButtons:_variantButton1];
            }else
            {
                [self dehighLightButtons:_variantButton1];
            }
            if ([OriganlVariantsButtonsStrings rangeOfString:checkString1].location != NSNotFound) {
                [self highLightButtons:_variantButton2];
            }else
            {
                [self dehighLightButtons:_variantButton2];
            }
            if ([OriganlVariantsButtonsStrings rangeOfString:checkString2].location != NSNotFound) {
                [self highLightButtons:_variantButton3];
            }else
            {
                [self dehighLightButtons:_variantButton3];
            }
            
            checkString3=[[FitmooHelper sharedInstance] checkStringIsANumeric:_variantButton4.titleLabel.text];
            if ([OriganlVariantsButtonsStrings rangeOfString:checkString3].location != NSNotFound) {
                [self highLightButtons:_variantButton4];
            }else
            {
                [self dehighLightButtons:_variantButton4];
            }
        }
        

        return;
    }
    
    
    if ([_homeFeed.product.variant_options_array count]==0) {
        
        quantity=_variantButton1.titleLabel.text;
    }else if ([_homeFeed.product.variant_options_array count]==1) {
        quantity=_variantButton2.titleLabel.text;
        
    }else if ([_homeFeed.product.variant_options_array count]==2) {
        
        quantity=_variantButton3.titleLabel.text;
    }else if ([_homeFeed.product.variant_options_array count]==3) {
        
        quantity=_variantButton4.titleLabel.text;
    }
    
    if ([quantity isEqualToString:@"Qty"]) {
        UIAlertView *alert = [[ UIAlertView alloc ] initWithTitle : @"Oops"
                                                          message : @"please select Qty." delegate : nil cancelButtonTitle : @"OK"
                                                otherButtonTitles : nil ];
        [alert show ];
        return;
    }
    
    User *localUser=[[UserManager sharedUserManager] localUser];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSDictionary *jsonDict;
    if (endorser_id==nil) {
        jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:localUser.secret_id, @"secret_id", localUser.auth_token, @"auth_token",type, @"type",quantity, @"quantity",variant_id, @"variant_id",nil];
    }else
    {
        jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:localUser.secret_id, @"secret_id", localUser.auth_token, @"auth_token",endorser_id, @"endorser_id",type, @"type",quantity, @"quantity",variant_id, @"variant_id",nil];
    }
    
    
    NSString *url= [NSString stringWithFormat:@"%@%@",[[UserManager sharedUserManager] clientUrl],@"/api/cart/add" ];
    [manager POST: url parameters:jsonDict success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        [self openShopCartPage];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateTopImage" object:[[UserManager sharedUserManager] localUser]];
        //      NSLog(@"Submit response data: %@", responseObject);
    } // success callback block
     
          failure:^(AFHTTPRequestOperation *operation, NSError *error){
              NSLog(@"Error: %@", error);} // failure callback block
     ];
    
    
}
@end

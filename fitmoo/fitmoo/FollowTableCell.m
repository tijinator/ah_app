//
//  FollowTableCell.m
//  fitmoo
//
//  Created by hongjian lin on 6/18/17.
//  Copyright © 2017 com.fitmoo. All rights reserved.
//

#import "FollowTableCell.h"
#import "FollowCollectionViewCell.h"
@implementation FollowTableCell 

- (void)awakeFromNib {
    [super awakeFromNib];
    self.totalArray = [[NSArray alloc] init];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    UINib *cellNib = [UINib nibWithNibName:@"FollowCollectionViewCell" bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"FollowCollectionViewCell"];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(100*SCREEN_RATIO_IPHONE, 205*SCREEN_RATIO_IPHONE)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [flowLayout setSectionInset:UIEdgeInsetsMake(0, 15*SCREEN_RATIO_IPHONE, 0, 0)];
    [self.collectionView setCollectionViewLayout:flowLayout];
    
    _collectionView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_collectionView respectToSuperFrame:nil];

    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



#pragma mark - UICollectionCellDelegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.totalArray count];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FollowCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FollowCollectionViewCell" forIndexPath:indexPath];
    
    User *tempUser= [self.totalArray objectAtIndex:indexPath.row];
    cell.userLabel.text=[[FitmooHelper sharedInstance] getTextForNumber:tempUser.followers];
    cell.nameLabel.text= tempUser.name;
    
    
    AsyncImageView *headerImage2 = [[AsyncImageView alloc] initWithFrame:CGRectMake(0, 0,cell.image.frame.size.width, cell.image.frame.size.height)];
    headerImage2.userInteractionEnabled = NO;
    headerImage2.exclusiveTouch = NO;
    //  headerImage2.layer.cornerRadius=headerImage2.frame.size.width/2;
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:headerImage2];
    
    headerImage2.imageURL =[NSURL URLWithString:tempUser.profile_avatar_thumb];
    [cell.image.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    
    [cell.image addSubview:headerImage2];
    
    if ([tempUser.is_following isEqualToString:@"0"]) {
        [cell.followButton setBackgroundImage:[UIImage imageNamed:@"followsection_smallfollowbtn.png"] forState:UIControlStateNormal];
        
    }else
    {
        [cell.followButton setBackgroundImage:[UIImage imageNamed:@"followsection_smallfollowingbtn.png"] forState:UIControlStateNormal];
    }
    
    
    cell.followButton.tag= indexPath.row+100;
    [cell.followButton addTarget:self action:@selector(followButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    return cell;
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger  selectedImageIndex = indexPath.row;
    User *tempUser= [self.totalArray objectAtIndex:selectedImageIndex];
    NSString *key=[NSString stringWithFormat:@"%d", tempUser.user_id.intValue+100];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"leftSideMenuAction" object:key];
    
    
}


//- (CGSize)collectionView:(UICollectionView *)collectionView
//                  layout:(UICollectionViewLayout *)collectionViewLayout
//  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//
//    return CGSizeMake(100.f, 205.f);
//}



- (IBAction)followButtonClick:(id)sender {
    self.tempButton1 = (UIButton *)sender;
    NSInteger index=(NSInteger) self.tempButton1.tag-100;
    
    self.tempUser1= [self.totalArray objectAtIndex:index];
    
    
    if ([self.tempUser1.is_following isEqualToString:@"0"]) {
        [[UserManager sharedUserManager] performFollow:self.tempUser1.user_id];
        self.tempUser1.is_following=@"1";
        
        [self.tempButton1 setBackgroundImage:[UIImage imageNamed:@"followsection_smallfollowingbtn.png"] forState:UIControlStateNormal];
        
    }else
    {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Unfollow"
                                                       message:@"Are you sure you want to Unfollow this person?"
                                                      delegate:self
                                             cancelButtonTitle:@"No"
                                             otherButtonTitles:@"Yes",nil];
        [alert show];
        
        
        [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:@"HasSeenPopup"];
        
        
    }
    
    
}


- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
    if (buttonIndex == 1)
    {
        [[UserManager sharedUserManager] performUnFollow:self.tempUser1.user_id];
        self.tempUser1.is_following=@"0";
        [self.tempButton1 setBackgroundImage:[UIImage imageNamed:@"followsection_smallfollowbtn.png"] forState:UIControlStateNormal];
    }
    
    
}





@end

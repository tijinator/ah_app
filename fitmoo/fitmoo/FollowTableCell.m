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
    self.service = [[PeoplePageService alloc] init];
    UINib *cellNib = [UINib nibWithNibName:@"FollowCollectionViewCell" bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"FollowCollectionViewCell"];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(100*SCREEN_RATIO_IPHONE, 205*SCREEN_RATIO_IPHONE)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [flowLayout setSectionInset:UIEdgeInsetsMake(0, 15*SCREEN_RATIO_IPHONE, 0, 0)];
    [self.collectionView setCollectionViewLayout:flowLayout];
    
    _collectionView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_collectionView respectToSuperFrame:nil];
    _titleLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_titleLabel respectToSuperFrame:nil];
    [self initValuable];
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
    
    if ([self.cellType isEqualToString:@"product"]) {
        Product *temProd = [self.totalArray objectAtIndex:indexPath.row];
        cell.nameLabel.text = temProd.title;
        AsyncImageView *headerImage2 = [[AsyncImageView alloc] initWithFrame:CGRectMake(0, 0,cell.image.frame.size.width, cell.image.frame.size.height)];
        headerImage2.userInteractionEnabled = NO;
        headerImage2.exclusiveTouch = NO;
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:headerImage2];
        
        headerImage2.imageURL =[NSURL URLWithString:temProd.photo];
        [cell.image.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
        cell.userLabel.hidden = true;
        cell.blackImage.hidden = true;
        cell.nameLabel.numberOfLines = 4;
        
        [cell.image addSubview:headerImage2];
        //[cell.followButton setTitle:@"Buy" forState:UIControlStateNormal];
        [cell.followButton setBackgroundImage:[UIImage imageNamed:@"productBuy.png"] forState:UIControlStateNormal];
        cell.followButton.transform = CGAffineTransformTranslate(cell.followButton.transform, 0, -10);
        cell.followButton.tag= temProd.feed_id.integerValue;
        [cell.followButton addTarget:self action:@selector(buyButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    
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
    if ([self.cellType isEqualToString:@"product"]) {
        Product *temprod = [self.totalArray objectAtIndex:indexPath.row];
        [self.celldelegate getSpecialPage:temprod.feed_id];
    }else{
        NSInteger  selectedImageIndex = indexPath.row;
        User *tempUser= [self.totalArray objectAtIndex:selectedImageIndex];
        NSString *key=[NSString stringWithFormat:@"%d", tempUser.user_id.intValue+100];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"leftSideMenuAction" object:key];
    }
    
    
    
}


- (IBAction)buyButtonClick:(id)sender {
    UIButton *tempButton = (UIButton *)sender;
    NSInteger index=(NSInteger) tempButton.tag;
    NSString * key= [NSString stringWithFormat:@"%ld",(long)index];
    [self.celldelegate getSpecialPage:key];
    
}


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

-(void) initValuable
{
    _offset=8;
    _limit=10;
    _count=1;
    
}


- (void)scrollViewDidScroll: (UIScrollView*)scroll {

  if(self.collectionView.contentOffset.x >= (self.collectionView.contentSize.width - self.collectionView.bounds.size.width+20)) {
 
        if (_count==0) {
            if (self.collectionView.contentOffset.x<0) {
                _offset =18;
            }else
            {
                _offset +=10;
                
            }
            
            if ([self.titleLabel.text isEqualToString:@"FEATURED"] && ![self.cellType isEqualToString:@"product"]) {
                PeopleRequest *request = [PeopleRequest requestWithOffsetPeople:_offset];
                
                [self.service getFeatureUserRequest:request success:^(NSArray * _Nullable results) {
                    NSMutableArray *tempArray = [self.totalArray mutableCopy];
                    [tempArray addObjectsFromArray:results];
                    self.totalArray = [tempArray copy];
                    [self.collectionView reloadData];
                } failure:^(NSError * _Nonnull error) {
                    
                }];

            }else if ([self.titleLabel.text isEqualToString:@"ACTIVE"]) {
                PeopleRequest *request = [PeopleRequest requestWithOffsetPeople:_offset];
                
                [self.service getActiveUserRequest:request success:^(NSArray * _Nullable results) {
                    NSMutableArray *tempArray = [self.totalArray mutableCopy];
                    [tempArray addObjectsFromArray:results];
                    self.totalArray = [tempArray copy];
                    [self.collectionView reloadData];
                } failure:^(NSError * _Nonnull error) {
                    
                }];
                
            }
            
         //   [self getdiscoverItemForPeople];
            
        }
        _count++;
    }else
    {
        _count=0;
    }
    
    
}




@end

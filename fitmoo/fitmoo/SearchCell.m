//
//  SearchCell.m
//  fitmoo
//
//  Created by hongjian lin on 8/18/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import "SearchCell.h"
#import "FitmooHelper.h"
#import "AsyncImageView.h"
@implementation SearchCell

- (void)awakeFromNib {
    // Initialization code
    [self initFrames];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) builtWkSearchCell
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, _imageview.frame.size.width, _imageview.frame.size.height)];
    view.clipsToBounds=YES;
    view.layer.cornerRadius=view.frame.size.width/2;
    view.backgroundColor=[UIColor blackColor];
    _nameLabel.text= _temWk.title;
    // nameLabel.frame=[[FitmooHelper sharedInstance] caculateLabelHeight:nameLabel];
    UIFont *font = [UIFont fontWithName:@"BentonSans-Medium" size:14];
    NSMutableAttributedString *attributedString= [[NSMutableAttributedString alloc] initWithString:_nameLabel.text attributes:@{NSFontAttributeName: font}  ];
    
    [_nameLabel setAttributedText:attributedString];
    
    
    AsyncImageView *userImage = [[AsyncImageView alloc] initWithFrame:CGRectMake(0, 0, _imageview.frame.size.width, _imageview.frame.size.height)];
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:userImage];
    userImage.imageURL =[NSURL URLWithString:_temWk.style_url];
    
    if (![_temWk.time isEqualToString:@""]) {
          _label1.text=[[FitmooHelper sharedInstance] generateTimeString:_temWk.time];
    }
  
    
    [view addSubview:userImage];
    [_imageview addSubview:view];
    
    _label1.hidden=false;
    _followButton.hidden=true;
}

- (void) builtPdSearchCell
{
    _label1.hidden=false;
    _followButton.hidden=true;
    
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, _imageview.frame.size.width, _imageview.frame.size.height)];
    view.clipsToBounds=YES;
    view.layer.cornerRadius=view.frame.size.width/2;
    view.backgroundColor=[UIColor blackColor];
    
    _nameLabel.text= _temPd.title;
    // nameLabel.frame=[[FitmooHelper sharedInstance] caculateLabelHeight:nameLabel];
    UIFont *font = [UIFont fontWithName:@"BentonSans-Medium" size:14];
    NSMutableAttributedString *attributedString= [[NSMutableAttributedString alloc] initWithString:_nameLabel.text attributes:@{NSFontAttributeName: font}  ];
    
    [_nameLabel setAttributedText:attributedString];
    
    
    AsyncImageView *userImage = [[AsyncImageView alloc] initWithFrame:CGRectMake(0, 0, _imageview.frame.size.width, _imageview.frame.size.height)];
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:userImage];
    userImage.imageURL =[NSURL URLWithString:_temPd.photo];
    
    
    _label1.text=[NSString stringWithFormat:@"%@%0.02f",@"$", _temPd.original_price.doubleValue/100];
    
    [view addSubview:userImage];
    [_imageview addSubview:view];

}

- (void) builtSearchCell
{
    
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, _imageview.frame.size.width, _imageview.frame.size.height)];
    view.clipsToBounds=YES;
    view.layer.cornerRadius=view.frame.size.width/2;
   
    _nameLabel.text= _temUser.name;
    // nameLabel.frame=[[FitmooHelper sharedInstance] caculateLabelHeight:nameLabel];
    UIFont *font = [UIFont fontWithName:@"BentonSans-Medium" size:14];
    NSMutableAttributedString *attributedString= [[NSMutableAttributedString alloc] initWithString:_nameLabel.text attributes:@{NSFontAttributeName: font}  ];
    
    [_nameLabel setAttributedText:attributedString];
    
    
    AsyncImageView *userImage = [[AsyncImageView alloc] initWithFrame:CGRectMake(0, 0, _imageview.frame.size.width, _imageview.frame.size.height)];
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:userImage];
    userImage.imageURL =[NSURL URLWithString:_temUser.profile_avatar_thumb];
    
    [view addSubview:userImage];
    [_imageview addSubview:view];
    
    if ([_temUser.is_following isEqualToString:@"0"]) {
        [_followButton setBackgroundImage:[UIImage imageNamed:@"searchfollowbtn.png"] forState:UIControlStateNormal];
    }else
    {
        [_followButton setBackgroundImage:[UIImage imageNamed:@"searchfollowingbtn.png"] forState:UIControlStateNormal];
    }


}

- (void) initFrames
{
    
    self.nameLabel.frame=[[FitmooHelper sharedInstance] resizeFrameWithFrame:_nameLabel respectToSuperFrame:nil];
    self.imageview.frame=[[FitmooHelper sharedInstance] resizeFrameWithFrame:_imageview respectToSuperFrame:nil];
    self.followButton.frame=[[FitmooHelper sharedInstance] resizeFrameWithFrame:_followButton respectToSuperFrame:nil];
    self.label1.frame=[[FitmooHelper sharedInstance] resizeFrameWithFrame:_label1 respectToSuperFrame:nil];
    
    _imageview.exclusiveTouch=NO;
    _imageview.userInteractionEnabled=NO;

}
@end

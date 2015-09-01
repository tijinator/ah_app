//
//  ShopTableViewCell.m
//  fitmoo
//
//  Created by hongjian lin on 9/1/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import "ShopTableViewCell.h"
#import "FitmooHelper.h"
@implementation ShopTableViewCell

- (void)awakeFromNib {
    // Initialization code
}


- (void) initFrames
{
    
    self.contentView.frame=[[FitmooHelper sharedInstance] resizeFrameWithFrame:self.contentView respectToSuperFrame:nil];
    _topView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_topView respectToSuperFrame:nil];
    _topTitleLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_topTitleLabel respectToSuperFrame:nil];
    _topCategoryLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_topCategoryLabel respectToSuperFrame:nil];
    _topPriceLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_topPriceLabel respectToSuperFrame:nil];
    _variantsView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_variantsView respectToSuperFrame:nil];
    _variantsButton1.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_variantsButton1 respectToSuperFrame:nil];
    _variantsButton2.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_variantsButton2 respectToSuperFrame:nil];
    _variantsButton3.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_variantsButton3 respectToSuperFrame:nil];
    
    
    _headerView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_headerView respectToSuperFrame:nil];
    _bodyView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_bodyView respectToSuperFrame:nil];
    _buttomView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_buttomView respectToSuperFrame:nil];
    _heanderImage1.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_heanderImage1 respectToSuperFrame:nil];
    _headerImage2.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_headerImage2 respectToSuperFrame:nil];
    _titleLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_titleLabel respectToSuperFrame:nil];
    _dayLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_dayLabel respectToSuperFrame:nil];
    _bodyDetailLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_bodyDetailLabel respectToSuperFrame:nil];
    _commentView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_commentView respectToSuperFrame:nil];
    _commentName.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_commentName respectToSuperFrame:nil];
    _commentDetail.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_commentDetail respectToSuperFrame:nil];
    _commentName1.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_commentName1 respectToSuperFrame:nil];
    _commentDetail1.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_commentDetail1 respectToSuperFrame:nil];
    _commentName2.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_commentName2 respectToSuperFrame:nil];
    _commentDetail2.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_commentDetail2 respectToSuperFrame:nil];
    

    
    UIView *v= [[UIView alloc] initWithFrame:CGRectMake(14,33,14,33)];
    v.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:v respectToSuperFrame:nil];
    _likeButton.imageEdgeInsets = UIEdgeInsetsMake(v.frame.origin.x,v.frame.origin.y,v.frame.size.width,v.frame.size.height);
    _likeButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_likeButton respectToSuperFrame:nil];
    _shareButton.imageEdgeInsets = UIEdgeInsetsMake(v.frame.origin.x,v.frame.origin.y,v.frame.size.width,v.frame.size.height);
    _shareButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_shareButton respectToSuperFrame:nil];
    _commentButton.imageEdgeInsets = UIEdgeInsetsMake(v.frame.origin.x,v.frame.origin.y,v.frame.size.width,v.frame.size.height);
    _commentButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_commentButton respectToSuperFrame:nil];
    _optionButton.imageEdgeInsets = UIEdgeInsetsMake(v.frame.origin.x,v.frame.origin.y,v.frame.size.width,v.frame.size.height);
    _optionButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_optionButton respectToSuperFrame:nil];
    _scrollView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_scrollView respectToSuperFrame:nil];
    _bodyShadowView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_bodyShadowView respectToSuperFrame:nil];
    _bodyLikeButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_bodyLikeButton respectToSuperFrame:nil];
    _bodyCommentButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_bodyCommentButton respectToSuperFrame:nil];
    _bodyGradian.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_bodyGradian respectToSuperFrame:nil];
    _viewAllCommentButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_viewAllCommentButton respectToSuperFrame:nil];

    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

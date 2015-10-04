//
//  ShopPurchaseCell.m
//  fitmoo
//
//  Created by hongjian lin on 9/17/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import "ShopPurchaseCell.h"
#import "FitmooHelper.h"
#import "AsyncImageView.h"
@implementation ShopPurchaseCell

- (void)awakeFromNib {
    
    [self initFrames];
    // Initialization code
}

- (void) buildCell
{
    _itemLabel.text=_order.title;
    
    AsyncImageView *headerImage = [[AsyncImageView alloc] initWithFrame:CGRectMake(0, 0, _ImageButton.frame.size.width, _ImageButton.frame.size.height)];
    headerImage.userInteractionEnabled = NO;
    headerImage.exclusiveTouch = NO;
    
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:headerImage];
    
    
    if (_order.image_url==nil||[_order.image_url isEqualToString:@""]) {
        headerImage.image=[UIImage imageNamed:@"defaultprofilepic.png"];
    }else
    {
    headerImage.imageURL =[NSURL URLWithString:_order.image_url];
    }
    
    [_ImageButton.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    _ImageButton.clipsToBounds=YES;
    [_ImageButton addSubview:headerImage];

    
    UIFont *font= [UIFont fontWithName:@"BentonSans" size:(CGFloat)(10)];
    UIFont *font1= [UIFont fontWithName:@"BentonSans-Bold" size:(CGFloat)(10)];

    
    
    
    NSString *string= [NSString stringWithFormat:@"ENDORSED BY %@",_order.endorser_name.uppercaseString];
    NSString *string1= [NSString stringWithFormat:@"SOLD BY %@",_order.seller_name.uppercaseString];
    NSString *string2= [NSString stringWithFormat:@"STATUS %@",_order.status.uppercaseString];
    
    NSMutableAttributedString *attributedString= [[NSMutableAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName: font1} ];
    attributedString=(NSMutableAttributedString *) [[FitmooHelper sharedInstance] replaceAttributedString:attributedString Font:font range:@"ENDORSED BY" newString:@"ENDORSED BY"];

    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:8];
    [attributedString addAttribute:NSParagraphStyleAttributeName
                             value:style
                             range:NSMakeRange(0, string.length)];
    [_label1 setAttributedText:attributedString];
    
    
   attributedString= [[NSMutableAttributedString alloc] initWithString:string1 attributes:@{NSFontAttributeName: font1} ];
    attributedString=(NSMutableAttributedString *) [[FitmooHelper sharedInstance] replaceAttributedString:attributedString Font:font range:@"SOLD BY" newString:@"SOLD BY"];
    
    
  
    [attributedString addAttribute:NSParagraphStyleAttributeName
                             value:style
                             range:NSMakeRange(0, string1.length)];
    [_label2 setAttributedText:attributedString];
    
    attributedString= [[NSMutableAttributedString alloc] initWithString:string2 attributes:@{NSFontAttributeName: font1} ];
    attributedString=(NSMutableAttributedString *) [[FitmooHelper sharedInstance] replaceAttributedString:attributedString Font:font range:@"STATUS" newString:@"STATUS"];
    
    [attributedString addAttribute:NSParagraphStyleAttributeName
                             value:style
                             range:NSMakeRange(0, string2.length)];
    [_label3 setAttributedText:attributedString];


    
}


- (void) initFrames
{
    
    self.contentView.frame=[[FitmooHelper sharedInstance] resizeFrameWithFrame:self.contentView respectToSuperFrame:nil];
    _ImageButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_ImageButton respectToSuperFrame:nil];
    _itemLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_itemLabel respectToSuperFrame:nil];
    
    _label1.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_label1 respectToSuperFrame:nil];
    _label2.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_label2 respectToSuperFrame:nil];
    _label3.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_label3 respectToSuperFrame:nil];
    
    double radio= [[FitmooHelper sharedInstance] frameRadio];
    _seprelatorView.frame=CGRectMake(8*radio, 105*radio, 302*radio, 1);

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

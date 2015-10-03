//
//  ShopInfoCell.m
//  fitmoo
//
//  Created by hongjian lin on 9/4/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import "ShopInfoCell.h"
#import "FitmooHelper.h"
@implementation ShopInfoCell

- (void)awakeFromNib {
     [self initFrames];
    // Initialization code
}

- (void) buildCell
{
    _ItemTitleLabel.text=_shopCartDetail.title;
    _ItemDetailLabel.text=_shopCartDetail.item_details;
    
    _ItemTitleLabel.frame=[[FitmooHelper sharedInstance] caculateLabelHeight:_ItemTitleLabel];
    _ItemDetailLabel.frame=[[FitmooHelper sharedInstance] caculateLabelHeight:_ItemDetailLabel];
    
    
//    _ItemPriceLabel.text=[NSString stringWithFormat:@"Qty %@ @ $%@", _shopCartDetail.quantity, _shopCartDetail.price];
    
    RTLabel *priceLabel= [[RTLabel alloc] initWithFrame:_ItemPriceLabel.frame];
    priceLabel.delegate=self;
      [priceLabel setText:[NSString stringWithFormat:@"<a href='%@'><font face=BentonSans-Bold size=12 color=#109CFB>Qty %@ </font></a><font face=BentonSans-Bold size=12 color=#000000> @ $%@</font>",_shopCartDetail.shop_cart_detail_id ,_shopCartDetail.quantity, _shopCartDetail.price ]];
    
    [self.contentView addSubview:priceLabel];
    
   
    
    
    _detailLabel1.text= _shopCartDetail.item_price;
    _detailLabel2.text= _shopCartDetail.seller_name.uppercaseString;
    
    if (_shopCartDetail.endorser.integerValue>0 ) {
        _detailLabel3.text= _shopCartDetail.endorser_name.uppercaseString;
    }else
    {
        _detailLabel3.hidden=true;
        _label3.hidden=true;
    }
 
    
    AsyncImageView *headerImage = [[AsyncImageView alloc] initWithFrame:CGRectMake(0, 0, _itemImage.frame.size.width, _itemImage.frame.size.height)];
    headerImage.userInteractionEnabled = NO;
    headerImage.exclusiveTouch = NO;
    headerImage.contentMode=UIViewContentModeScaleToFill;
 
    
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:headerImage];
  
    headerImage.imageURL =[NSURL URLWithString:_shopCartDetail.item_photo_url];

    [_itemImage.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    _itemImage.clipsToBounds=YES;
    [_itemImage addSubview:headerImage];

    _DeleteButton.tag=_shopCartDetail.shop_cart_detail_id.intValue;
    
}


- (void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL*)url
{
    NSLog(@"did select url %@", url);
    NSString *key=[NSString stringWithFormat:@"%@", [url absoluteString]];
    
    NSString *key1=_shopCartDetail.count_on_hand;
    NSString *key2=_shopCartDetail.quantity;
    
    NSArray *array= @[key,key1,key2];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"shopCartQtyClick" object:array];
}

- (void) initFrames
{
    
    self.contentView.frame=[[FitmooHelper sharedInstance] resizeFrameWithFrame:self.contentView respectToSuperFrame:nil];
    _itemImage.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_itemImage respectToSuperFrame:nil];
    _ItemTitleLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_ItemTitleLabel respectToSuperFrame:nil];
    _ItemDetailLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_ItemDetailLabel respectToSuperFrame:nil];

  
    
    _ItemPriceLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_ItemPriceLabel respectToSuperFrame:nil];
    _label1.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_label1 respectToSuperFrame:nil];
    _label2.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_label2 respectToSuperFrame:nil];
    _label3.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_label3 respectToSuperFrame:nil];
    _detailLabel1.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_detailLabel1 respectToSuperFrame:nil];
    _detailLabel2.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_detailLabel2 respectToSuperFrame:nil];
    _detailLabel3.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_detailLabel3 respectToSuperFrame:nil];
    _infoButton1.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_infoButton1 respectToSuperFrame:nil];
    _infoButtons2.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_infoButtons2 respectToSuperFrame:nil];
    
    _buttonView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_buttonView respectToSuperFrame:nil];

    
    _DeleteButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_DeleteButton respectToSuperFrame:nil];
    
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

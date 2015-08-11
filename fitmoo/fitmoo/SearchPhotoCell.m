//
//  SearchPhotoCell.m
//  fitmoo
//
//  Created by hongjian lin on 8/11/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import "SearchPhotoCell.h"

@implementation SearchPhotoCell

- (void)awakeFromNib {
    [self initFrames];
    // Initialization code
}

- (void) setView1Item
{
    if ([self.searchType isEqualToString:@"community"]) {
        [self setViewItemWith:_com1.name photo:_com1.cover_photo_url video:nil button:_view1Button Icon:_view1VideoIcon];
        _view1Label.text=_com1.name;
        _View1CountLabel.text=[[FitmooHelper sharedInstance] getTextForNumber:_com1.joiners_count];
    }
    if ([self.searchType isEqualToString:@"people"]) {
        [self setViewItemWith:_user1.name photo:_user1.profile_avatar_thumb video:nil button:_view1Button Icon:_view1VideoIcon];
        _view1Label.text= _user1.name;
        
        
        _View1CountLabel.text=[[FitmooHelper sharedInstance] getTextForNumber:_user1.followers];
        
    }

}
- (void) setView2Item
{
    
      if ([self.searchType isEqualToString:@"community"]) {
       [self setViewItemWith:_com2.name photo:_com2.cover_photo_url video:nil button:_view2Button Icon:_view2VideoIcon];
           _view2Label.text=_com2.name;
          _View2CountLabel.text=[[FitmooHelper sharedInstance] getTextForNumber:_com2.joiners_count];
      }
    
     if ([self.searchType isEqualToString:@"people"]) {
        [self setViewItemWith:_user2.name photo:_user2.profile_avatar_thumb video:nil button:_view2Button Icon:_view2VideoIcon];
         _view2Label.text= _user2.name;
         _View2CountLabel.text=[[FitmooHelper sharedInstance] getTextForNumber:_user2.followers];
     }
    
}
- (void) setView3Item
{
     if ([self.searchType isEqualToString:@"community"]) {
     [self setViewItemWith:_com3.name photo:_com3.cover_photo_url video:nil button:_view3Button Icon:_view3VideoIcon];
         _view3Label.text=_com3.name;
        _View3CountLabel.text=[[FitmooHelper sharedInstance] getTextForNumber:_com3.joiners_count];
     }
    
     if ([self.searchType isEqualToString:@"people"]) {
        [self setViewItemWith:_user3.name photo:_user3.profile_avatar_thumb video:nil button:_view3Button Icon:_view3VideoIcon];
         _view3Label.text= _user3.name;
         _View3CountLabel.text=[[FitmooHelper sharedInstance] getTextForNumber:_user3.followers];
     }
}

- (void) initFrames
{
    
    self.contentView.frame=[[FitmooHelper sharedInstance] resizeFrameWithFrame:self.contentView respectToSuperFrame:nil];
    
    _view1.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_view1 respectToSuperFrame:nil];
    
    _view2.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_view2 respectToSuperFrame:nil];
    _view3.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_view3 respectToSuperFrame:nil];
    _view1Button.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_view1Button respectToSuperFrame:nil];
    _view2Button.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_view2Button respectToSuperFrame:nil];
    _view3Button.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_view3Button respectToSuperFrame:nil];
    _View1Gradiant.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_View1Gradiant respectToSuperFrame:nil];
    
    _View2Gradiant.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_View2Gradiant respectToSuperFrame:nil];
    _View3Gradiant.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_View3Gradiant respectToSuperFrame:nil];
    _view1Label.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_view1Label respectToSuperFrame:nil];
    
    _view2Label.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_view2Label respectToSuperFrame:nil];
    _view3Label.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_view3Label respectToSuperFrame:nil];
    
    _view1VideoIcon.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_view1VideoIcon respectToSuperFrame:nil];
    _view2VideoIcon.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_view2VideoIcon respectToSuperFrame:nil];
    _view3VideoIcon.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_view3VideoIcon respectToSuperFrame:nil];
    
    _View1CountLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_View1CountLabel respectToSuperFrame:nil];
    _View2CountLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_View2CountLabel respectToSuperFrame:nil];
    _View3CountLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_View3CountLabel respectToSuperFrame:nil];
    
    _View1BlackImage.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_View1BlackImage respectToSuperFrame:nil];
    _View2BlackImage.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_View2BlackImage respectToSuperFrame:nil];
    _View3BlackImage.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_View3BlackImage respectToSuperFrame:nil];
    
    
}

- (void) setViewItemWith:(NSString *)text photo:(NSString *)photo video:(NSString *) video button:(UIButton *)button Icon:(UIImageView *) videoIcon
{
    if (photo==nil&&video==nil)
    {
        UILabel *label= [[UILabel alloc] initWithFrame:CGRectMake(20,20,button.frame.size.width-40 , button.frame.size.height-40)];
        label.userInteractionEnabled = NO;
        label.exclusiveTouch = NO;
        label.textAlignment= NSTextAlignmentCenter;
        label.numberOfLines=3;
        label.text=text;
        
        UIFont *font = [UIFont fontWithName:@"BentonSans" size:12];
        NSMutableAttributedString *attributedString= [[NSMutableAttributedString alloc] initWithString:label.text attributes:@{NSFontAttributeName: font}  ];
        
        [label setAttributedText:attributedString];
        
        [button.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
        [button addSubview:label];
    }else
    {
        AsyncImageView *headerImage = [[AsyncImageView alloc] initWithFrame:CGRectMake(0, 0, button.frame.size.width, button.frame.size.height)];
        headerImage.userInteractionEnabled = NO;
        headerImage.exclusiveTouch = NO;
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:headerImage];
        
        if (photo!=nil) {
            
            headerImage.imageURL =[NSURL URLWithString:photo];
            
        }else
        {
            
            headerImage.imageURL =[NSURL URLWithString:video];
            videoIcon.hidden=false;
            
        }
        [button.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
        [button addSubview:headerImage];
    }
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

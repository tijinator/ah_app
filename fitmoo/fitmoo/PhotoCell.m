//
//  PhotoCell.m
//  fitmoo
//
//  Created by hongjian lin on 5/12/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import "PhotoCell.h"

@implementation PhotoCell

- (void)awakeFromNib {
    [self initFrames];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setView1Item
{
    _view1Label.text= _homeFeed1.type.uppercaseString;
    
    if ([_homeFeed1.type isEqualToString:@"regular"]) {
       
        _view1Label.text=@"POST";
    }else if ([_homeFeed1.type isEqualToString:@"workout"])
    {
     
        _view1Label.text=@"WORKOUT";
    }else if ([_homeFeed1.type isEqualToString:@"nutrition"])
    {
   
        _view1Label.text=@"NUTRITION";
    }else if ([_homeFeed1.type isEqualToString:@"product"])
    {
       
        _view1Label.text=@"PRODUCT";
    }
    else if ([_homeFeed1.type isEqualToString:@"event"])
    {
        _view1Label.text=@"EVENT";
      
    }
    
    
    if ([_homeFeed1.photoArray count]==0&&[_homeFeed1.videosArray count]==0)
    {
        UILabel *label= [[UILabel alloc] initWithFrame:CGRectMake(20,20,_view1Button.frame.size.width-40 , _view1Button.frame.size.height-40)];
        label.userInteractionEnabled = NO;
        label.exclusiveTouch = NO;
        label.textAlignment= NSTextAlignmentCenter;
        label.numberOfLines=3;
       // [label sizeToFit];
        if ([_homeFeed1.type isEqualToString:@"regular"]) {
            label.text= _homeFeed1.text;
        
        }else if ([_homeFeed1.type isEqualToString:@"workout"])
        {
            label.text= _homeFeed1.workout_title;
           
        }else if ([_homeFeed1.type isEqualToString:@"nutrition"])
        {
            label.text=_homeFeed1.nutrition.title;
          
        }else if ([_homeFeed1.type isEqualToString:@"product"])
        {
           label.text=_homeFeed1.product.title;
           
        }
        else if ([_homeFeed1.type isEqualToString:@"event"])
        {
         
            label.text=_homeFeed1.event.name;
        }
        
        UIFont *font = [UIFont fontWithName:@"BentonSans" size:12];
        NSMutableAttributedString *attributedString= [[NSMutableAttributedString alloc] initWithString:label.text attributes:@{NSFontAttributeName: font}  ];
        
        [label setAttributedText:attributedString];
      
        [_view1Button.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
        [_view1Button addSubview:label];
    }else
    {
        AsyncImageView *headerImage = [[AsyncImageView alloc] initWithFrame:CGRectMake(0, 0, _view1Button.frame.size.width, _view1Button.frame.size.height)];
        headerImage.userInteractionEnabled = NO;
        headerImage.exclusiveTouch = NO;
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:headerImage];
        
        if ([_homeFeed1.photoArray count]>0) {
            [_homeFeed1 resetPhotos];
            _homeFeed1.photos=[_homeFeed1.photoArray objectAtIndex:0];
            headerImage.imageURL =[NSURL URLWithString:_homeFeed1.photos.smallUrl];
            
        }else
        {
            if (![_homeFeed1.videos.thumbnail_url isEqual:[NSNull null]]) {
                headerImage.imageURL =[NSURL URLWithString:_homeFeed1.videos.thumbnail_url];
            }
            _view1VideoIcon.hidden=false;
            
        }
        [_view1Button.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
        [_view1Button addSubview:headerImage];
    }
    
}
- (void) setView2Item
{
     _view2Label.text= _homeFeed2.type.uppercaseString;
    
    if ([_homeFeed2.type isEqualToString:@"regular"]) {
        
        _view2Label.text=@"POST";
    }else if ([_homeFeed2.type isEqualToString:@"workout"])
    {
        
        _view2Label.text=@"WORKOUT";
    }else if ([_homeFeed2.type isEqualToString:@"nutrition"])
    {
        
        _view2Label.text=@"NUTRITION";
    }else if ([_homeFeed2.type isEqualToString:@"product"])
    {
        
        _view2Label.text=@"PRODUCT";
    }
    else if ([_homeFeed2.type isEqualToString:@"event"])
    {
        _view2Label.text=@"EVENT";
        
    }
    
    
     if ([_homeFeed2.photoArray count]==0&&[_homeFeed2.videosArray count]==0)
     {
         UILabel *label= [[UILabel alloc] initWithFrame:CGRectMake(20,20,_view2Button.frame.size.width-40 , _view2Button.frame.size.height-40)];
         label.userInteractionEnabled = NO;
         label.exclusiveTouch = NO;
         label.textAlignment= NSTextAlignmentCenter;
         label.numberOfLines=3;
         
      
         
         // [label sizeToFit];
         if ([_homeFeed2.type isEqualToString:@"regular"]) {
             label.text= _homeFeed2.text;
         }else if ([_homeFeed2.type isEqualToString:@"workout"])
         {
             label.text= _homeFeed2.workout_title;
             
         }else if ([_homeFeed2.type isEqualToString:@"nutrition"])
         {
             label.text=_homeFeed2.nutrition.title;
         }else if ([_homeFeed2.type isEqualToString:@"product"])
         {
             label.text=_homeFeed2.product.title;
         }
         else if ([_homeFeed2.type isEqualToString:@"event"])
         {
             label.text=_homeFeed2.event.name;
         }
         
         UIFont *font = [UIFont fontWithName:@"BentonSans" size:12];
         NSMutableAttributedString *attributedString= [[NSMutableAttributedString alloc] initWithString:label.text attributes:@{NSFontAttributeName: font}  ];

         [label setAttributedText:attributedString];
         
         [_view2Button.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
         [_view2Button addSubview:label];

     }else
     {
         AsyncImageView *headerImage = [[AsyncImageView alloc] initWithFrame:CGRectMake(0, 0, _view2Button.frame.size.width, _view2Button.frame.size.height)];
         headerImage.userInteractionEnabled = NO;
         headerImage.exclusiveTouch = NO;
         [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:headerImage];
         
         if ([_homeFeed2.photoArray count]>0) {
             [_homeFeed2 resetPhotos];
             _homeFeed2.photos=[_homeFeed2.photoArray objectAtIndex:0];
             headerImage.imageURL =[NSURL URLWithString:_homeFeed2.photos.smallUrl];
             
         }else
         {
             if (![_homeFeed2.videos.thumbnail_url isEqual:[NSNull null]]) {
                   headerImage.imageURL =[NSURL URLWithString:_homeFeed2.videos.thumbnail_url];
             }
       
              _view2VideoIcon.hidden=false;
         }
         [_view2Button.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
         [_view2Button addSubview:headerImage];
     }
    
   
}
- (void) setView3Item
{
     _view3Label.text= _homeFeed3.type.uppercaseString;
    
    if ([_homeFeed3.type isEqualToString:@"regular"]) {
        
        _view3Label.text=@"POST";
    }else if ([_homeFeed3.type isEqualToString:@"workout"])
    {
        
        _view3Label.text=@"WORKOUT";
    }else if ([_homeFeed3.type isEqualToString:@"nutrition"])
    {
        
        _view3Label.text=@"NUTRITION";
    }else if ([_homeFeed3.type isEqualToString:@"product"])
    {
        
        _view3Label.text=@"PRODUCT";
    }
    else if ([_homeFeed3.type isEqualToString:@"event"])
    {
        _view3Label.text=@"EVENT";
        
    }
    
    
    if ([_homeFeed3.photoArray count]==0&&[_homeFeed3.videosArray count]==0)
    {
        UILabel *label= [[UILabel alloc] initWithFrame:CGRectMake(20,20,_view3Button.frame.size.width-40 , _view3Button.frame.size.height-40)];
        label.userInteractionEnabled = NO;
        label.exclusiveTouch = NO;
        label.textAlignment= NSTextAlignmentCenter;
        label.numberOfLines=3;
        // [label sizeToFit];
        if ([_homeFeed3.type isEqualToString:@"regular"]) {
            label.text= _homeFeed3.text;
        }else if ([_homeFeed3.type isEqualToString:@"workout"])
        {
            label.text= _homeFeed3.workout_title;
            
        }else if ([_homeFeed3.type isEqualToString:@"nutrition"])
        {
            label.text=_homeFeed3.nutrition.title;
        }else if ([_homeFeed3.type isEqualToString:@"product"])
        {
            label.text=_homeFeed3.product.title;
        }
        else if ([_homeFeed3.type isEqualToString:@"event"])
        {
            label.text=_homeFeed3.event.name;
        }
        
        UIFont *font = [UIFont fontWithName:@"BentonSans" size:12];
        NSMutableAttributedString *attributedString= [[NSMutableAttributedString alloc] initWithString:label.text attributes:@{NSFontAttributeName: font}  ];
        
        [label setAttributedText:attributedString];
        
        [_view3Button.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
        [_view3Button addSubview:label];

    }else
    {
        AsyncImageView *headerImage = [[AsyncImageView alloc] initWithFrame:CGRectMake(0, 0, _view3Button.frame.size.width, _view3Button.frame.size.height)];
        headerImage.userInteractionEnabled = NO;
        headerImage.exclusiveTouch = NO;
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:headerImage];
        
        if ([_homeFeed3.photoArray count]>0) {
            [_homeFeed3 resetPhotos];
            _homeFeed3.photos=[_homeFeed3.photoArray objectAtIndex:0];
            headerImage.imageURL =[NSURL URLWithString:_homeFeed3.photos.smallUrl];
            
        }else
        {
            if (![_homeFeed3.videos.thumbnail_url isEqual:[NSNull null]]) {
                headerImage.imageURL =[NSURL URLWithString:_homeFeed3.videos.thumbnail_url];
            }
            
             _view3VideoIcon.hidden=false;
        }
        [_view3Button.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
        [_view3Button addSubview:headerImage];
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


}


@end

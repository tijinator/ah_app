//
//  FollowPhotoCell.m
//  fitmoo
//
//  Created by hongjian lin on 8/5/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import "FollowPhotoCell.h"
#import "FitmooHelper.h"
#import "Workout.h"
#import "AsyncImageView.h"
#import "Product.h"
#import "CreatedByCommunity.h"
#import "User.h"
@implementation FollowPhotoCell

- (void)awakeFromNib {
    [self initFrames];
    // Initialization code
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
        label.backgroundColor=[UIColor clearColor];
        
        UIFont *font = [UIFont fontWithName:@"BentonSans" size:12];
        NSMutableAttributedString *attributedString= [[NSMutableAttributedString alloc] initWithString:label.text attributes:@{NSFontAttributeName: font}  ];
        
        [label setAttributedText:attributedString];
        
        [button.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
        [button setBackgroundImage:[UIImage imageNamed:@"cement.png"] forState:UIControlStateNormal];
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

- (NSNumber *) CaculateCellHeight
{
    self.contentView.clipsToBounds=YES;
    self.clipsToBounds=YES;
    if ([_cellArray count]==0) {
    
         return [NSNumber numberWithInt:0];
        
    }
    if ([_cellArray count]<4) {
        return [NSNumber numberWithInt:(106* [[FitmooHelper sharedInstance] frameRadio])];
    }else if ([_cellArray count]<7) {
        return [NSNumber numberWithInt:(214* [[FitmooHelper sharedInstance] frameRadio])];
    }else
    {
        return [NSNumber numberWithInt:(320* [[FitmooHelper sharedInstance] frameRadio])];
    }
}

- (void) builtCells
{
    for (int i=0; i<[_cellArray count]; i++) {
        
        if ([_cellType isEqualToString:@"workout"]) {
            if (i==0) {
                Workout *wk= [_cellArray objectAtIndex:i];
                [self setViewItemWith:wk.title photo:wk.style_url video:wk.video_style_url button:_view1Button Icon:_view1VideoIcon];
              
            }else if (i==1) {
                Workout *wk= [_cellArray objectAtIndex:i];
                [self setViewItemWith:wk.title photo:wk.style_url video:wk.video_style_url button:_view2Button Icon:_view2VideoIcon];
            
            }else if (i==2) {
                Workout *wk= [_cellArray objectAtIndex:i];
                [self setViewItemWith:wk.title photo:wk.style_url video:wk.video_style_url button:_view3Button Icon:_view3VideoIcon];
            }else if (i==3) {
                Workout *wk= [_cellArray objectAtIndex:i];
                [self setViewItemWith:wk.title photo:wk.style_url video:wk.video_style_url button:_view4Button Icon:_view4VideoIcon];
               
            }else if (i==4) {
                Workout *wk= [_cellArray objectAtIndex:i];
                [self setViewItemWith:wk.title photo:wk.style_url video:wk.video_style_url button:_view5Button Icon:_view5VideoIcon];
               
            }else if (i==5) {
                Workout *wk= [_cellArray objectAtIndex:i];
                [self setViewItemWith:wk.title photo:wk.style_url video:wk.video_style_url button:_view6Button Icon:_view6VideoIcon];
                
            }else if (i==6) {
                Workout *wk= [_cellArray objectAtIndex:i];
                [self setViewItemWith:wk.title photo:wk.style_url video:wk.video_style_url button:_view7Button Icon:_view7VideoIcon];
                
            }else if (i==7) {
                Workout *wk= [_cellArray objectAtIndex:i];
                [self setViewItemWith:wk.title photo:wk.style_url video:wk.video_style_url button:_view8Button Icon:_view8VideoIcon];
              
            }else if (i==8) {
                Workout *wk= [_cellArray objectAtIndex:i];
                [self setViewItemWith:wk.title photo:wk.style_url video:wk.video_style_url button:_view9Button Icon:_view9VideoIcon];
                
            }

        }
        
        if ([_cellType isEqualToString:@"product"]) {
            if (i==0) {
                Product *pd= [_cellArray objectAtIndex:i];
                [self setViewItemWith:pd.title photo:pd.photo video:pd.videos button:_view1Button Icon:_view1VideoIcon];
              
            }else if (i==1) {
                Product *pd= [_cellArray objectAtIndex:i];
                [self setViewItemWith:pd.title photo:pd.photo video:pd.videos button:_view2Button Icon:_view2VideoIcon];
              
            }else if (i==2) {
                Product *pd= [_cellArray objectAtIndex:i];
                [self setViewItemWith:pd.title photo:pd.photo video:pd.videos button:_view3Button Icon:_view3VideoIcon];
               
            }else if (i==3) {
                Product *pd= [_cellArray objectAtIndex:i];
                [self setViewItemWith:pd.title photo:pd.photo video:pd.videos button:_view4Button Icon:_view4VideoIcon];
              
            }else if (i==4) {
                Product *pd= [_cellArray objectAtIndex:i];
                [self setViewItemWith:pd.title photo:pd.photo video:pd.videos button:_view5Button Icon:_view5VideoIcon];
             
            }else if (i==5) {
                Product *pd= [_cellArray objectAtIndex:i];
                [self setViewItemWith:pd.title photo:pd.photo video:pd.videos button:_view6Button Icon:_view6VideoIcon];
              
            }else if (i==6) {
                Product *pd= [_cellArray objectAtIndex:i];
                [self setViewItemWith:pd.title photo:pd.photo video:pd.videos button:_view7Button Icon:_view7VideoIcon];
              
            }else if (i==7) {
                Product *pd= [_cellArray objectAtIndex:i];
                [self setViewItemWith:pd.title photo:pd.photo video:pd.videos button:_view8Button Icon:_view8VideoIcon];
              
            }else if (i==8) {
                Product *pd= [_cellArray objectAtIndex:i];
                [self setViewItemWith:pd.title photo:pd.photo video:pd.videos button:_view9Button Icon:_view9VideoIcon];
               
            }
            
        }

        if ([_cellType isEqualToString:@"community"]) {
            if (i==0) {
                CreatedByCommunity *com= [_cellArray objectAtIndex:i];
                [self setViewItemWith:com.name photo:com.cover_photo_url video:nil button:_view1Button Icon:_view1VideoIcon];
            }else if (i==1) {
                CreatedByCommunity *com= [_cellArray objectAtIndex:i];
                [self setViewItemWith:com.name photo:com.cover_photo_url video:nil button:_view2Button Icon:_view2VideoIcon];
            }else if (i==2) {
                CreatedByCommunity *com= [_cellArray objectAtIndex:i];
                [self setViewItemWith:com.name photo:com.cover_photo_url video:nil button:_view3Button Icon:_view3VideoIcon];
            }else if (i==3) {
                CreatedByCommunity *com= [_cellArray objectAtIndex:i];
                [self setViewItemWith:com.name photo:com.cover_photo_url video:nil button:_view4Button Icon:_view4VideoIcon];
            }else if (i==4) {
                CreatedByCommunity *com= [_cellArray objectAtIndex:i];
                [self setViewItemWith:com.name photo:com.cover_photo_url video:nil button:_view5Button Icon:_view5VideoIcon];
            }else if (i==5) {
                CreatedByCommunity *com= [_cellArray objectAtIndex:i];
                [self setViewItemWith:com.name photo:com.cover_photo_url video:nil button:_view6Button Icon:_view6VideoIcon];
            }else if (i==6) {
                CreatedByCommunity *com= [_cellArray objectAtIndex:i];
                [self setViewItemWith:com.name photo:com.cover_photo_url video:nil button:_view7Button Icon:_view7VideoIcon];
            }else if (i==7) {
                CreatedByCommunity *com= [_cellArray objectAtIndex:i];
                [self setViewItemWith:com.name photo:com.cover_photo_url video:nil button:_view8Button Icon:_view8VideoIcon];
            }else if (i==8) {
                CreatedByCommunity *com= [_cellArray objectAtIndex:i];
                [self setViewItemWith:com.name photo:com.cover_photo_url video:nil button:_view9Button Icon:_view9VideoIcon];
            }
            
        }
        
        if ([_cellType isEqualToString:@"people"]) {
            if (i==0) {
                User *tempUser= [_cellArray objectAtIndex:i];
                [self setViewItemWith:tempUser.name photo:tempUser.profile_avatar_thumb video:nil button:_view1Button Icon:_view1VideoIcon];
            }else if (i==1) {
                User *tempUser= [_cellArray objectAtIndex:i];
                [self setViewItemWith:tempUser.name photo:tempUser.profile_avatar_thumb video:nil button:_view2Button Icon:_view2VideoIcon];
            }else if (i==2) {
                User *tempUser= [_cellArray objectAtIndex:i];
                [self setViewItemWith:tempUser.name photo:tempUser.profile_avatar_thumb video:nil button:_view3Button Icon:_view3VideoIcon];
            }else if (i==3) {
                User *tempUser= [_cellArray objectAtIndex:i];
                [self setViewItemWith:tempUser.name photo:tempUser.profile_avatar_thumb video:nil button:_view4Button Icon:_view4VideoIcon];
            }else if (i==4) {
                User *tempUser= [_cellArray objectAtIndex:i];
                [self setViewItemWith:tempUser.name photo:tempUser.profile_avatar_thumb video:nil button:_view5Button Icon:_view5VideoIcon];
            }else if (i==5) {
                User *tempUser= [_cellArray objectAtIndex:i];
                [self setViewItemWith:tempUser.name photo:tempUser.profile_avatar_thumb video:nil button:_view6Button Icon:_view6VideoIcon];
            }else if (i==6) {
                User *tempUser= [_cellArray objectAtIndex:i];
                [self setViewItemWith:tempUser.name photo:tempUser.profile_avatar_thumb video:nil button:_view7Button Icon:_view7VideoIcon];
            }else if (i==7) {
                User *tempUser= [_cellArray objectAtIndex:i];
                [self setViewItemWith:tempUser.name photo:tempUser.profile_avatar_thumb video:nil button:_view8Button Icon:_view8VideoIcon];
            }else if (i==8) {
                User *tempUser= [_cellArray objectAtIndex:i];
                [self setViewItemWith:tempUser.name photo:tempUser.profile_avatar_thumb video:nil button:_view9Button Icon:_view9VideoIcon];
            }
            
        }


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
    _view1VideoIcon.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_view1VideoIcon respectToSuperFrame:nil];
    _view2VideoIcon.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_view2VideoIcon respectToSuperFrame:nil];
    _view3VideoIcon.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_view3VideoIcon respectToSuperFrame:nil];
    
    _view4.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_view4 respectToSuperFrame:nil];
    _view5.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_view5 respectToSuperFrame:nil];
    _view6.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_view6 respectToSuperFrame:nil];
    _view4Button.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_view4Button respectToSuperFrame:nil];
    _view5Button.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_view5Button respectToSuperFrame:nil];
    _view6Button.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_view6Button respectToSuperFrame:nil];
    _view4VideoIcon.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_view4VideoIcon respectToSuperFrame:nil];
    _view5VideoIcon.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_view5VideoIcon respectToSuperFrame:nil];
    _view6VideoIcon.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_view6VideoIcon respectToSuperFrame:nil];
    
    _view7.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_view7 respectToSuperFrame:nil];
    _view8.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_view8 respectToSuperFrame:nil];
    _view9.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_view9 respectToSuperFrame:nil];
    _view7Button.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_view7Button respectToSuperFrame:nil];
    _view8Button.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_view8Button respectToSuperFrame:nil];
    _view9Button.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_view9Button respectToSuperFrame:nil];
    _view7VideoIcon.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_view7VideoIcon respectToSuperFrame:nil];
    _view8VideoIcon.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_view8VideoIcon respectToSuperFrame:nil];
    _view9VideoIcon.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_view9VideoIcon respectToSuperFrame:nil];
    
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//
//  SeachInterestCell.m
//  fitmoo
//
//  Created by hongjian lin on 8/4/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import "SeachInterestCell.h"
#import "AsyncImageView.h"
@implementation SeachInterestCell

- (void)awakeFromNib {
    
    UIColor * color1=[UIColor colorWithRed:205.0/255.0 green:103.0/255.0 blue:239.0/255.0 alpha:1];
    UIColor * color2=[UIColor colorWithRed:247.0/255.0 green:147.0/255.0 blue:30.0/255.0 alpha:1];
    UIColor * color3=[UIColor colorWithRed:16.0/255.0 green:156.0/255.0 blue:251.0/255.0 alpha:1];
    
    _colorArray= [[NSMutableArray alloc] initWithObjects:color2,color1,color3,color2,  nil];
    // Initialization code
}





- (void) addScrollView
{
    if (_scrollView!=nil) {
        [_scrollView removeFromSuperview];
        _scrollView=nil;
    }
  
    _scrollView= [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 140)];
    _scrollView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_scrollView respectToSuperFrame:nil];
    
    _scrollView.delegate = self;
    _scrollView.pagingEnabled=YES;
    
    
    int x =0;
    int scrollToX=0;
    double frameRadio= [[FitmooHelper sharedInstance] frameRadio];
    if ([self.searchType isEqualToString:@"discover"]) {
        for (int i=0; i<[_searchArrayKeyword count]; i++) {
            CreatedByCommunity *keyword= [_searchArrayKeyword objectAtIndex:i];
            _scrollView.backgroundColor=[UIColor blackColor];
            UILabel *titleLabel= [[UILabel alloc] initWithFrame:CGRectMake(x+(35*frameRadio), 70*frameRadio, 250*frameRadio, 30*frameRadio)];
            titleLabel.text=keyword.name;
            
            UIColor *color= [_colorArray objectAtIndex:i];
            titleLabel.textColor=color;
            titleLabel.numberOfLines=3;
            titleLabel.textAlignment=NSTextAlignmentCenter;
            
            UIFont *font = [UIFont fontWithName:@"BentonSans-Bold" size:18];
            NSString *string= titleLabel.text;
            NSMutableAttributedString *attributedString= [[NSMutableAttributedString alloc] initWithString:string.uppercaseString attributes:@{NSFontAttributeName: font}  ];
            float spacing = 1.5f;
            [attributedString addAttribute:NSKernAttributeName value:@(spacing) range:NSMakeRange(0, [titleLabel.text length])];
            [titleLabel setAttributedText:attributedString];
            
            [_scrollView addSubview:titleLabel];
            
            UILabel *titleLabel1= [[UILabel alloc] initWithFrame:CGRectMake(x+(35*frameRadio), 50*frameRadio, 250*frameRadio, 30*frameRadio)];
            titleLabel1.text=@"trending";
            
        
            titleLabel1.textColor=[UIColor whiteColor];
            titleLabel1.textAlignment=NSTextAlignmentCenter;
            
            UIFont *font1 = [UIFont fontWithName:@"BentonSans-Bold" size:14];
            NSString *string1= @"trending";
            NSMutableAttributedString *attributedString1= [[NSMutableAttributedString alloc] initWithString:string1.uppercaseString attributes:@{NSFontAttributeName: font1}  ];

            [attributedString1 addAttribute:NSKernAttributeName value:@(spacing) range:NSMakeRange(0, [titleLabel1.text length])];
            [titleLabel1 setAttributedText:attributedString1];
            
            [_scrollView addSubview:titleLabel1];

            
            
            if ([_selectedKeywordId isEqualToString:keyword.created_by_community_id]) {
                scrollToX=x;
            }
            x= x+ _scrollView.frame.size.width;

        }
    }else
    {
   
    for (int i=0; i<[_searchArrayKeyword count]; i++) {
        CreatedByCommunity *keyword= [_searchArrayKeyword objectAtIndex:i];
        
        AsyncImageView *scrollImage = [[AsyncImageView alloc] initWithFrame:CGRectMake(x, 0, _scrollView.frame.size.width, _scrollView.frame.size.height)];
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:scrollImage];
        scrollImage.imageURL =[NSURL URLWithString:keyword.cover_photo_url];
    
        scrollImage.contentMode = UIViewContentModeScaleToFill;
        [_scrollView addSubview:scrollImage];
        
      
        UILabel *titleLabel= [[UILabel alloc] initWithFrame:CGRectMake(x+(85*frameRadio), 25*frameRadio, 150*frameRadio, 90*frameRadio)];
        titleLabel.text=keyword.name;
        titleLabel.textColor=[UIColor whiteColor];
        titleLabel.numberOfLines=3;
        titleLabel.textAlignment=NSTextAlignmentCenter;
        
        UIFont *font = [UIFont fontWithName:@"BentonSans-Bold" size:18];
        NSString *string= titleLabel.text;
        NSMutableAttributedString *attributedString= [[NSMutableAttributedString alloc] initWithString:string.uppercaseString attributes:@{NSFontAttributeName: font}  ];
        float spacing = 1.5f;
        [attributedString addAttribute:NSKernAttributeName value:@(spacing) range:NSMakeRange(0, [titleLabel.text length])];
        [titleLabel setAttributedText:attributedString];

        [_scrollView addSubview:titleLabel];
        
        if ([_selectedKeywordId isEqualToString:keyword.created_by_community_id]) {
            scrollToX=x;
        }
        x= x+ _scrollView.frame.size.width;
    }
      
        
    }

    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * [_searchArrayKeyword count], self.scrollView.frame.size.height);
    [self.scrollView setContentOffset:CGPointMake(scrollToX, 0) animated:NO];
    [self.contentView addSubview:_scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat width = scrollView.frame.size.width;
    NSInteger page = (scrollView.contentOffset.x + (0.5f * width)) / width;
    
    CreatedByCommunity *temCom=[_searchArrayKeyword objectAtIndex:page];
    _selectedKeywordId=temCom.created_by_community_id;
    
  [[NSNotificationCenter defaultCenter] postNotificationName:@"cellAction" object:_selectedKeywordId];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

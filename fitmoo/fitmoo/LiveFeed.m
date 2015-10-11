//
//  LiveFeed.m
//  fitmoo
//
//  Created by hongjian lin on 10/11/15.
//  Copyright © 2015 com.fitmoo. All rights reserved.
//

#import "LiveFeed.h"

@implementation LiveFeed
-(id)init
{
  
    _comments=[[Comments alloc] init];
    _commentsArray= [[NSMutableArray alloc] init];

    return self;
}

-(void) resetComments
{
    _comments= [[Comments alloc] init];
}
@end

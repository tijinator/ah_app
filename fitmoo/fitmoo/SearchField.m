//
//  SearchField.m
//  fitmoo
//
//  Created by hongjian lin on 6/17/17.
//  Copyright © 2017 com.fitmoo. All rights reserved.
//

#import "SearchField.h"

@implementation SearchField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void) awakeFromNib{
    [super awakeFromNib];
    self.callQueueArray = [[NSMutableArray alloc] init];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{

    self.spellCheckingType = UITextSpellCheckingTypeNo;
    self.autocorrectionType = UITextAutocorrectionTypeNo;
    self.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

- (void) invalidateTimers{
    [self.timer invalidate];
    [self.queueTimer invalidate];
}

- (void)callQueue
{
    if (self.callQueueArray.count> 0 && _refresh) {
        NSString *searchTerm = [self.callQueueArray objectAtIndex:0];
        [self.callQueueArray removeObjectAtIndex:0];
        _refresh = false;
        [self.searchDelegate requestSearchObject:searchTerm];
        if (_callQueueArray.count == 0) {
            [self invalidateTimers];
        }
        
    }
}

- (void)timerTick:(NSTimer *)timer
{
    
    self.ticks += 0.1;
    double seconds = fmod(self.ticks, 60.0);
    
    if (seconds>=0.5 && seconds<0.6) {
        if(![self.text isEqualToString:@""]){
            [self addSearchTermIntoQueue:self.text];
        }
       
    }
}


- (void) addSearchTermIntoQueue:(NSString *) searchTerm{
    if (self.callQueueArray.count == 0) {
        [self.callQueueArray addObject:searchTerm];
        _refresh=true;
        [self callQueue];
    }else{
        if (self.queueTimer == nil) {
            self.queueTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(callQueue) userInfo:nil repeats:YES];
        }
    }

}


- (void)textFieldDidChange:(UITextField *)textField
{
    [_timer invalidate];
    self.ticks=0;
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerTick:) userInfo:nil repeats:YES];
 
}





@end

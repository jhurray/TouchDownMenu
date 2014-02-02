//
//  TouchDownGestureRecognizer.m
//  TouchDownMenuNavigationExampleProject
//
//  Created by Gregoire on 1/14/14.
//  Copyright (c) 2014 jhurrayApps. All rights reserved.
//
#import "TouchDownMenu.h"
#import "TouchDownGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

#define NUM_STEPS 50.0

@implementation TouchDownGestureRecognizer
int counter = 0;
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{

    self.state = UIGestureRecognizerStateBegan;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:PRESSDURATION target:self selector:@selector(setToEnded) userInfo:nil repeats:NO];
    self.incrementalTimer = [NSTimer scheduledTimerWithTimeInterval:MAX_ALPHA*PRESSDURATION/NUM_STEPS target:self selector:@selector(delegatePerformIncrementalAction) userInfo:nil repeats:YES];
    NSLog(@"\n\nTOUCHES BEGAN ");
    counter = 0;

}

-(void)delegatePerformIncrementalAction{
    
    [self.touchDownDelegate performIncrementalActionWithNumSteps:NUM_STEPS];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    //anything????
}

-(void)setToEnded{
    self.state = UIGestureRecognizerStateEnded;
    [self.touchDownDelegate touchTimerFinished];
    [self.incrementalTimer invalidate];
    [self.timer invalidate];
    NSLog(@"\n\nTIMER FINISHED");
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"\n\nCANCELLED");
    [self setCancelsTouchesInView:NO];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    self.state = UIGestureRecognizerStateEnded;
    if([self.timer isValid]){
        [self.touchDownDelegate touchReleaseTooEarly];   
    }
    [self.incrementalTimer invalidate];
    [self.timer invalidate];
    NSLog(@"\n\nTOUCH ENDED");
}


@end

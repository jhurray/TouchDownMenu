//
//  TouchDownGestureRecognizer.h
//  TouchDownMenuNavigationExampleProject
//
//  Created by Gregoire on 1/14/14.
//  Copyright (c) 2014 jhurrayApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TouchDownGestureRecognizerDelegate <NSObject>

-(void)touchTimerFinished;

@optional
-(void)performIncrementalActionWithNumSteps:(int)numSteps;
-(void)touchReleaseTooEarly;

@end

@interface TouchDownGestureRecognizer : UIGestureRecognizer

@property (nonatomic, strong) id<TouchDownGestureRecognizerDelegate> touchDownDelegate;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSTimer *incrementalTimer;

@end

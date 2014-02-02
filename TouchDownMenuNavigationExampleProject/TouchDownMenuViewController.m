//
//  MainViewController.m
//  TouchDownMenuNavigationExampleProject
//
//  Created by Gregoire on 1/14/14.
//  Copyright (c) 2014 jhurrayApps. All rights reserved.
//

#import "TouchDownMenuViewController.h"

#define OFFSET 100
#define NUM_BTNS 7
#define RADIUS 70

@interface TouchDownMenuViewController ()

@end

@implementation TouchDownMenuViewController

@synthesize touchDownMenu, presentControl, resignControl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    
    //segment controls
    presentControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Push", @"Spin", @"Swirl", @"Pinscer", nil]];
    presentControl.tag = 0;
    [presentControl setFrame:CGRectMake(30, 30, 260, 30)];
    [presentControl.layer setCornerRadius:10];
    [presentControl setBackgroundColor:[UIColor clearColor]];
    [presentControl setTintColor:[UIColor blackColor]];
    [presentControl setSelectedSegmentIndex:0];
    [presentControl addTarget:self action:@selector(handleSegmentedControl:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:presentControl];
    resignControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Push", @"Chaos", nil]];
    resignControl.tag = 1;
    [resignControl setFrame:CGRectMake(60, 70, 200, 30)];
    [resignControl.layer setCornerRadius:10];
    [resignControl setBackgroundColor:[UIColor clearColor]];
    [resignControl setTintColor:[UIColor blackColor]];
    [resignControl setSelectedSegmentIndex:0];
    [resignControl addTarget:self action:@selector(handleSegmentedControl:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:resignControl];
    
    
    
    // Do any additional setup after loading the view from its nib.
    touchDownMenu = [[TouchDownMenu alloc] initWithOrigin:self.view.center andRadius:RADIUS andNumButtons:NUM_BTNS];
    touchDownMenu.delegate = self;
    
    //adding gesture recognizers
    TouchDownGestureRecognizer *touchDown = [[TouchDownGestureRecognizer alloc] initWithTarget:self action:@selector(handleTouchDown:)];
    touchDown.touchDownDelegate = self;
    touchDown.delegate = self;
    [self.view addGestureRecognizer:touchDown];
    
    NSLog(@"VIEW IS LOADING");
}

-(void)handleSegmentedControl:(UISegmentedControl *)control{
    
    if(control.tag == 0){
        touchDownMenu.presentState = presentControl.selectedSegmentIndex;
    }
    else if(control.tag == 1){
        touchDownMenu.resignState = resignControl.selectedSegmentIndex;
        if (touchDownMenu.resignState == 1) {
            touchDownMenu.resignState = 4;
        }
    }
}

-(void)handleTouchDown:(TouchDownGestureRecognizer *)touchDown{
    CGPoint location = [touchDown locationInView:touchDown.view];
    
    switch (touchDown.state) {
            
        case UIGestureRecognizerStateBegan:
            if(location.y < 100) return;
            [touchDownMenu.backgroundSheet removeFromSuperview];
            [touchDownMenu setFrame:CGRectMake(location.x-RADIUS/2, location.y-RADIUS/2, RADIUS, RADIUS)];
            [touchDownMenu setAlpha:0.0];
            [self.view addSubview:touchDownMenu];
            
            NSLog(@"\n\n State Began");
            break;
        case UIGestureRecognizerStateEnded:
            NSLog(@"\n\nState Ended");
            break;
        case UIGestureRecognizerStateChanged:
            //NSLog(@"\n\nState Changed");
            [touchDownMenu setFrame:CGRectMake(location.x-RADIUS/2, location.y-RADIUS/2, RADIUS, RADIUS)];
            break;
        default:
            break;
    }
}


// TOUCH MENU DELEGATE

-(void)resignMenu{
    TouchDownGestureRecognizer *touchDown = [[TouchDownGestureRecognizer alloc] initWithTarget:self action:@selector(handleTouchDown:)];
    touchDown.touchDownDelegate = self;
    touchDown.delegate = self;
    [self.view addGestureRecognizer:touchDown];
}

//  UIGESTURE RECOGNIZER DELEGATE
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
       shouldReceiveTouch:(UITouch *)touch {
    
    if (touch.view == presentControl || touch.view == resignControl) {
        return NO;
    }
    return YES;
}

// TOUCH GESTURE RECOGNIZER DELEGATE

-(void)touchReleaseTooEarly{
    [touchDownMenu removeFromSuperview];
}

-(void)touchTimerFinished{
    
    CGPoint center = self.view.center;
    for (TouchDownGestureRecognizer *touch in self.view.gestureRecognizers) {
        [self.view removeGestureRecognizer:touch];
    }
    //do menu animations
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         [touchDownMenu setFrame:CGRectMake(center.x-RADIUS/2, center.y-RADIUS/2, RADIUS, RADIUS)];
                     }
                     completion:^(BOOL finished) {
                         [touchDownMenu animatePresentWithTouchDownAnimationType:touchDownMenu.presentState];
                     }];
    
    NSLog(@"\n\n FINISHED!!!\n\n");
    
}

-(void) performIncrementalActionWithNumSteps:(int)numSteps{
    
    touchDownMenu.alpha += MIN(1.0/numSteps, MAX_ALPHA-touchDownMenu.alpha);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

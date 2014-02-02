//
//  CircleView.m
//  TouchDownMenuNavigationExampleProject
//
//  Created by Gregoire on 1/14/14.
//  Copyright (c) 2014 jhurrayApps. All rights reserved.
//

#import "TouchDownMenu.h"

#define BORDERWIDTH 3
#define BORDERCOLOR [UIColor darkGrayColor]
#define BACKGROUNDCOLOR [UIColor blackColor]
#define BUTTONDIST 130
#define BACKGROUNDALPHA 0.4
#define PRESENTDURATION 0.8
#define RESIGNDURATION 0.3

@implementation TouchDownMenu

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithOrigin:(CGPoint) origin andRadius:(CGFloat)radius andNumButtons:(int)numButtons{
    
    if (self = [super initWithFrame:CGRectMake(origin.x, origin.y, radius, radius)]) {
        
        self.presentState = 0;
        self.resignState = 0;
        self.radius = radius;
        [self.layer setCornerRadius:radius/2];
        [self.layer setBorderWidth:BORDERWIDTH];
        [self.layer setBorderColor:BORDERCOLOR.CGColor];
        [self setBackgroundColor:CIRCLERCOLOR];
        [self setAlpha:0.0];
        
        //background sheet
        self.backgroundSheet = [[UIView alloc] initWithFrame:CGRectMake(-DEVICEWIDTH/2+radius/2, -DEVICEHEIGHT/2+radius/2, DEVICEWIDTH, DEVICEHEIGHT)];
        [self.backgroundSheet setBackgroundColor:BACKGROUNDCOLOR];
        [self.backgroundSheet setAlpha:0];
        
        //init buttons
        self.numButtons = numButtons;
        NSMutableArray *tmpBtns = [NSMutableArray array];
        CGFloat radians = PI/2;
        CGFloat x, y;
        for (int i = 0; i < numButtons; ++i) {
            CircleButton *btn = [[CircleButton alloc] initWithCircleView:(TouchDownMenu *)self];
            x = DEVICEWIDTH/2 + BUTTONDIST*cosf(radians);
            y = DEVICEHEIGHT/2 - BUTTONDIST*sinf(radians);
            btn.endCoord = CGPointMake(x, y);
            //NSLog(@"\n\nButton number %i x: %f, y: %f \n\n", i, x, y);
            [tmpBtns addObject:btn];
            radians+=2*PI/self.numButtons;
            btn.tag = i;
        }
        self.buttons = [NSArray arrayWithArray:tmpBtns];
    }
    return self;
}

// ---------------------------------  TAP GESTURE HANDLER  ---------------------------------------\\

-(void)tapGestureHandler:(UITapGestureRecognizer *)tap{
    
    switch (tap.state) {
        case UIGestureRecognizerStateEnded:
            NSLog(@"\n\n TAP UP\n\n");
            [self animateResignWithTouchDownAnimationType:self.resignState];
            [self.delegate resignMenu];
            break;
            
        default:
            break;
    }
    [self removeGestureRecognizer:tap];
    
}

// ---------------------------------  PRESENT ANIMATIONS  ---------------------------------------\\

BOOL presenting;

-(void)pushAnimationPresent{
    [UIView animateWithDuration:PRESENTDURATION
                          delay:0.0
                        options: UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         for (CircleButton *b in self.buttons) {
                             //NSLog(@"\ncenter is: (%f, %f)\n", b.center.x, b.center.y);
                             [b setCenter:b.endCoord];
                             //NSLog(@"\ncenter is NOW: (%f, %f)\n", b.center.x, b.center.y);
                             [b setAlpha:MAX_ALPHA];
                         }
                         [self.backgroundSheet setAlpha:BACKGROUNDALPHA];
                     }
                     completion:^(BOOL finished) {
                         NSLog(@"\n\nFinished push animation present.\n\n");
                     }];
}

/*
 
 Manipulate start value of radians and start value of rotaion animation to change the start point, speed, and direction of the animation
 
 */
-(void)spinAnimationPresentAsPinscer:(BOOL)pinscer andNumSpins:(NSInteger)numSpins{
    //pinscer = false;
    CGFloat radians = -PI/2;
    if(pinscer){
        radians = PI;
    }
    radians+=((numSpins-1)*2*PI);
    
    for (CircleButton *b in self.buttons) {
        
        [b.layer removeAllAnimations];
        //set anchor
        b.alpha = 1;
        CGFloat xAnchor = -((BUTTONDIST- self.radius*BTN_SCALE)/(self.radius*BTN_SCALE) + 0.5);
        CGFloat yAnchor = 0.5;
        if(pinscer){
            yAnchor = xAnchor;
            xAnchor = 0.5;
        }
        NSLog(@"\nAnchor is %f, %f\n\n", xAnchor, yAnchor);
        [b.layer setAnchorPoint:CGPointMake(xAnchor, yAnchor)];
        
        //rotation animation
        CABasicAnimation *rotate = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotate.fromValue = [NSNumber numberWithFloat:-PI];
        if(pinscer){
            rotate.fromValue = [NSNumber numberWithFloat:PI];
        }
        rotate.toValue = [NSNumber numberWithFloat: radians];
        rotate.duration = PRESENTDURATION; // seconds
        
        // opacity animation
        CABasicAnimation *opacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
        opacity.fromValue = [NSNumber numberWithFloat:0.0];
        opacity.toValue = [NSNumber numberWithFloat:MAX_ALPHA];
        opacity.duration = PRESENTDURATION;
        
        CAAnimationGroup *group = [CAAnimationGroup animation];
        [group setAnimations:[NSArray arrayWithObjects:opacity, rotate, nil]];
        [group setDuration:PRESENTDURATION];
        [group setRemovedOnCompletion:NO];
        [group setFillMode:kCAFillModeForwards];
        
        [b.layer addAnimation:group forKey:@"groupAnimation"];
        
        if(pinscer){
            if(self.numButtons/2 > b.tag){
                radians-=2*PI/self.numButtons;
            }
            else{//second half
                if(radians < PI){ radians = PI;}
                radians+=2*PI/self.numButtons;
            }
            
        }
        else{
            radians+=2*PI/self.numButtons;
        }
        
    }
    [self performSelector:@selector(setButtonAnchorPoints) withObject:self afterDelay:PRESENTDURATION];
}

-(void)swirlAnimationPresent{
    

    
}

-(void)chaosAnimationPresent{
    
    
}

// ---------------------------------  RESIGN ANIMATIONS  ---------------------------------------\\

-(void)pushAnimationResign{
    [UIView animateWithDuration:RESIGNDURATION
                          delay:0.0
                        options: UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         for (CircleButton *b in self.buttons) {
                             [b.layer setAnchorPoint:CGPointMake(0.5, 0.5)];
                             //NSLog(@"\ncenter is: (%f, %f)\n", b.center.x, b.center.y);
                             [b setCenter:CGPointMake(self.center.x, self.center.y)];
                             //NSLog(@"\ncenter is NOW: (%f, %f)\n\n", b.center.x, b.center.y);
                             [b setAlpha:0];
                         }
                         [self.backgroundSheet setAlpha:0];
                     }
                     completion:^(BOOL finished) {
                         NSLog(@"\n\nFinished push animation resign.\n\n");
                         [self removeViews];
                     }];
}

-(void)spinAnimationResign{

}

-(void)swirlAnimationResign{
    
}

-(void)chaosAnimationResign{
    CGFloat radians = 3*PI/2;
    for (CircleButton *b in self.buttons) {
        [b.layer removeAllAnimations];
        //set anchor
        b.alpha = 1;
        CGFloat xAnchor = (BUTTONDIST- self.radius*BTN_SCALE)/(self.radius*BTN_SCALE) + 0.5;
        //NSLog(@"\nXAnchor is %f\n\n", xAnchor);
        [b.layer setAnchorPoint:CGPointMake(-xAnchor, 0.5)];
        
        
        //rotation animation
        CABasicAnimation *rotate = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotate.fromValue = [NSNumber numberWithFloat:PI/2];
        rotate.toValue = [NSNumber numberWithFloat:radians];
        rotate.duration = RESIGNDURATION; // seconds
        
        // opacity animation
        CABasicAnimation *opacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
        opacity.fromValue = [NSNumber numberWithFloat:MAX_ALPHA];
        opacity.toValue = [NSNumber numberWithFloat:0.0];
        opacity.duration = RESIGNDURATION;
        
        CAAnimationGroup *group = [CAAnimationGroup animation];
        [group setAnimations:[NSArray arrayWithObjects:opacity, rotate, nil]];
        [group setDuration:RESIGNDURATION];
        [group setRemovedOnCompletion:NO];
        [group setFillMode:kCAFillModeForwards];
        
        [b.layer addAnimation:group forKey:@"groupAnimation"];
        
        radians+=2*PI/self.numButtons;
        
    }
    [self performSelector:@selector(setButtonAnchorPoints) withObject:self afterDelay:RESIGNDURATION];
    
}


// ---------------------------------  SWITCH STATEMENTS  ---------------------------------------\\

-(void)animateResignWithTouchDownAnimationType:(TouchDownAnimationType)type{
    
     presenting = FALSE;
    // remove label for 'X'
    
    //choose animation type
    switch (type) {
        case TouchDownAnimationTypePush:
            [self pushAnimationResign];
            break;
        case TouchDownAnimationTypeSpin:
            [self spinAnimationResign];
            break;
        case TouchDownAnimationTypeSwirl:
            [self swirlAnimationResign];
            break;
        case TouchDownAnimationTypeChaos:
            [self chaosAnimationResign];
            break;
        default:
            NSLog(@"\nHIT DEFAULT IN ANIMATION SWITCH\n");
            break;
    }
    [UIView animateWithDuration:RESIGNDURATION
                          delay:0.0
                        options: UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         [self.backgroundSheet setAlpha:0];
                     }
                     completion:nil];
}

-(void)animatePresentWithTouchDownAnimationType:(TouchDownAnimationType)type{
    presenting = TRUE;
    [self addSubview:self.backgroundSheet];
    [self sendSubviewToBack:self.backgroundSheet];
    
    //add to subview
    for (CircleButton *b in self.buttons) {
        [b setCenter:CGPointMake(self.superview.center.x, self.superview.center.y)];
        [self.superview addSubview:b];
    }
    //choose animation type
    switch (type) {
        case TouchDownAnimationTypePush:
            [self pushAnimationPresent];
            break;
        case TouchDownAnimationTypeSpin:
            [self spinAnimationPresentAsPinscer:NO andNumSpins:1];
            break;
        case TouchDownAnimationTypePinscer:
            [self spinAnimationPresentAsPinscer:YES andNumSpins:1];
            break;
        case TouchDownAnimationTypeSwirl:
            [self spinAnimationPresentAsPinscer:NO andNumSpins:3];
            break;
        case TouchDownAnimationTypeChaos:
            [self chaosAnimationPresent];
            break;
        default:
            NSLog(@"\nHIT DEFAULT IN ANIMATION SWITCH\n");
            break;
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureHandler:)];
    [self addGestureRecognizer:tap];
    // add label for 'X'
    [UIView animateWithDuration:PRESENTDURATION
                          delay:0.0
                        options: UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         [self.backgroundSheet setAlpha:BACKGROUNDALPHA];
                     }
                     completion:nil];
}

// ---------------------------------  HELPERS  ---------------------------------------\\

-(void)removeViews{
    for (CircleButton *b in self.buttons) {
        [b removeFromSuperview];
    }
    [self.backgroundSheet removeFromSuperview];
    [self removeFromSuperview];
}

-(void)setButtonAnchorPoints{
    for (CircleButton *b in self.buttons) {
        //NSLog(@"\nAnchor Point is %f, %f\n", b.layer.anchorPoint.x, b.layer.anchorPoint.y);
        [b.layer setAnchorPoint:CGPointMake(0.5, 0.5)];
        //NSLog(@"\nAnchor Point is NOW %f, %f\n\n", b.layer.anchorPoint.x, b.layer.anchorPoint.y);
        if(presenting){
            [b setCenter:b.endCoord];
        }
        else{
            [b setCenter:CGPointMake(b.superview.center.x, b.superview.center.y)];
            [self removeViews];
        }
        
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

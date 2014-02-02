//
//  CircleView.h
//  TouchDownMenuNavigationExampleProject
//
//  Created by Gregoire on 1/14/14.
//  Copyright (c) 2014 jhurrayApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CircleButton.h"
#define MAX_ALPHA 0.8
#define CIRCLERCOLOR [UIColor lightGrayColor]

@protocol TouchDownMenuDelegate <NSObject>

@optional
-(void)resignMenu;

@end

typedef NS_ENUM(NSInteger, TouchDownAnimationType) {
    TouchDownAnimationTypePush,
    TouchDownAnimationTypeSpin,
    TouchDownAnimationTypeSwirl,
    TouchDownAnimationTypePinscer,
    TouchDownAnimationTypeChaos
};

@interface TouchDownMenu : UIView

@property CGFloat radius;
@property int numButtons;
@property (nonatomic, strong) id <TouchDownMenuDelegate> delegate;
@property (nonatomic, strong) NSArray *buttons;
@property (nonatomic, strong) UIView *backgroundSheet;

@property int presentState;
@property int resignState;

-(id) initWithOrigin:(CGPoint) origin andRadius:(CGFloat)radius andNumButtons:(int)numButtons;
-(void)animatePresentWithTouchDownAnimationType:(TouchDownAnimationType)type;
-(void)animateResignWithTouchDownAnimationType:(TouchDownAnimationType)type;

@end

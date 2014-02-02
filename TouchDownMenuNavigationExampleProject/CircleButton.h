//
//  CircleButton.h
//  TouchDownMenuNavigationExampleProject
//
//  Created by Gregoire on 1/14/14.
//  Copyright (c) 2014 jhurrayApps. All rights reserved.
//
#import "TouchDownMenu.h"
#import <UIKit/UIKit.h>

#define BTN_SCALE 0.8

@class TouchDownMenu;

@interface CircleButton : UIButton

@property (nonatomic, readwrite) CGPoint endCoord;

-(id) initWithCircleView:(TouchDownMenu *)touchDownMenu;

@end

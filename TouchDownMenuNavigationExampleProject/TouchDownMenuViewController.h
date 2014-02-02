//
//  MainViewController.h
//  TouchDownMenuNavigationExampleProject
//
//  Created by Gregoire on 1/14/14.
//  Copyright (c) 2014 jhurrayApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TouchDownMenu.h"
#import "TouchDownGestureRecognizer.h"


@interface TouchDownMenuViewController : UIViewController<TouchDownGestureRecognizerDelegate, TouchDownMenuDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) TouchDownMenu *touchDownMenu;
@property (nonatomic, strong) UISegmentedControl *presentControl;
@property (nonatomic, strong) UISegmentedControl *resignControl;


@end

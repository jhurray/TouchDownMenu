//
//  CircleButton.m
//  TouchDownMenuNavigationExampleProject
//
//  Created by Gregoire on 1/14/14.
//  Copyright (c) 2014 jhurrayApps. All rights reserved.
//

#import "CircleButton.h"

@implementation CircleButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id) initWithCircleView:(TouchDownMenu *)touchDownMenu{
    
    CGRect frame = CGRectMake(0, 0, touchDownMenu.radius*BTN_SCALE, touchDownMenu.radius*BTN_SCALE);
    if(self = [super initWithFrame:frame]){
        [self setCenter:CGPointMake(touchDownMenu.radius/2 , touchDownMenu.radius/2)];
        [self setBackgroundColor:touchDownMenu.backgroundColor];
        [self.layer setCornerRadius:touchDownMenu.layer.cornerRadius*BTN_SCALE];
        [self.layer setBorderWidth:touchDownMenu.layer.borderWidth*BTN_SCALE];
        [self.layer setBorderColor:touchDownMenu.layer.borderColor];
        [self addTarget:self action:@selector(highlight:) forControlEvents:UIControlEventTouchDown];
        [self addTarget:self action:@selector(unhighlight:) forControlEvents:UIControlEventTouchUpInside];
        [self addTarget:self action:@selector(unhighlight:) forControlEvents:UIControlEventTouchUpOutside];
        
        [self setAlpha:0.0];
    }
    return self;
}

-(void)highlight:(UIButton *)btn{
    NSLog(@"\n\nButton %li Touched!!\n\n", btn.tag);
    [btn setBackgroundColor:[UIColor whiteColor]];
}

-(void)unhighlight:(UIButton *)btn{
    [btn setBackgroundColor:CIRCLERCOLOR];
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

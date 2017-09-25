//
//  StatsScrollView.m
//  JellyRole
//
//  Created by Kapil Kumar on 9/21/17.
//  Copyright © 2017 Kapil Kumar. All rights reserved.
//

#import "StatsScrollView.h"

@implementation StatsScrollView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)updateView {

    CGFloat xCord = 20;
    for (int i=0; i<1; i++) {
        
        if (i == 0) {

            UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setFrame:CGRectMake(xCord, 5, 30, 30)];
            [btn setTag:i+1];
            [btn setImage:[UIImage imageNamed:@"user"] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            
            
            UILabel* label = [[UILabel alloc] initWithFrame:btn.frame];
            [label setFont:[UIFont systemFontOfSize:8.0]];
            [label setTextColor:[UIColor blackColor]];
            [label setTextAlignment:NSTextAlignmentCenter];
            [label setText:[NSString stringWithFormat:@"%d", i+1]];
            
            [self addSubview:btn];
            [self addSubview:label];
            
            xCord += btn.frame.size.width + 10;
        } else {
           
            UIImage *newImage = [[UIImage imageNamed:@"user"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            
            UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.layer.cornerRadius = 15;
            btn.layer.masksToBounds = true;
            [btn setFrame:CGRectMake(xCord, 5, 30, 30)];
            [btn setTag:i+1];
            [btn addTarget:self action:@selector(buttonAction2:) forControlEvents:UIControlEventTouchUpInside];
            [btn setImage:newImage forState:UIControlStateNormal];
            [btn setTintColor:[UIColor greenColor]];
            [btn setAlpha:0.3];
            [self addSubview:btn];
            
            
            UIButton* btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn2 setFrame:CGRectMake(xCord, 5, 30, 30)];
            [btn2 setTag:i+1];
            [btn2 setImage:[UIImage imageNamed:@"lock"] forState:UIControlStateNormal];
            [btn2 addTarget:self action:@selector(buttonAction2:) forControlEvents:UIControlEventTouchUpInside];
            [btn2 setBackgroundColor:[UIColor clearColor]];
            [self addSubview:btn];
            [self addSubview:btn2];
            
            xCord += btn.frame.size.width + 10;
        }
    }
    
    [self setContentSize:CGSizeMake(xCord, 0)];
}

- (void)buttonAction:(UIButton *)sender {
    
}

- (void)buttonAction2:(UIButton *)sender {
    
}

@end

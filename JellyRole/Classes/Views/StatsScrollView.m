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

    UIColor* color1 = [UIColor colorWithRed:55.0/255.0 green:37.0/255.0 blue:35.0/255.0 alpha:1.0];
    UIColor* color2 = [UIColor colorWithRed:25.0/255.0 green:29.0/255.0 blue:52.0/255.0 alpha:1.0];
    UIColor* color3 = [UIColor colorWithRed:53.0/255.0 green:26.0/255.0 blue:39.0/255.0 alpha:1.0];
    UIColor* color4 = [UIColor colorWithRed:32.0/255.0 green:22.0/255.0 blue:47.0/255.0 alpha:1.0];
    UIColor* color5 = [UIColor colorWithRed:41.0/255.0 green:23.0/255.0 blue:34.0/255.0 alpha:1.0];
    UIColor* color6 = [UIColor colorWithRed:28.0/255.0 green:37.0/255.0 blue:41.0/255.0 alpha:1.0];
    UIColor* color7 = [UIColor colorWithRed:26.0/255.0 green:23.0/255.0 blue:34.0/255.0 alpha:1.0];
    CGFloat xCord = 20;
    for (int i=0; i<8; i++) {
        
        if (i == 0) {

            UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setFrame:CGRectMake(xCord, 5, 30, 30)];
            [btn setTag:i+1];
            [btn setImage:[UIImage imageNamed:@"user"] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            
            
            /*UILabel* label = [[UILabel alloc] initWithFrame:btn.frame];
            [label setFont:[UIFont systemFontOfSize:8.0]];
            [label setTextColor:[UIColor blackColor]];
            [label setTextAlignment:NSTextAlignmentCenter];
            [label setText:[NSString stringWithFormat:@"%d", i+1]];*/
            
            [self addSubview:btn];
            //[self addSubview:label];
            
            xCord += btn.frame.size.width + 10;
        } else {
           
            UIImage *newImage = [[UIImage imageNamed:@"user_2"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            
            UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.layer.cornerRadius = 15;
            btn.layer.masksToBounds = true;
            [btn setFrame:CGRectMake(xCord, 5, 30, 30)];
            [btn setTag:i+1];
            [btn addTarget:self action:@selector(buttonAction2:) forControlEvents:UIControlEventTouchUpInside];
            [btn setImage:newImage forState:UIControlStateNormal];
            
            if (i == 1) {
                [btn setTintColor:color1];
            } else if (i == 2) {
                [btn setTintColor:color2];
            } else if (i == 3) {
                [btn setTintColor:color3];
            } else if (i == 4) {
                [btn setTintColor:color4];
            } else if (i == 5) {
                [btn setTintColor:color5];
            } else if (i == 6) {
                [btn setTintColor:color6];
            } else if (i == 7) {
                [btn setTintColor:color7];
            }
            [btn setAlpha:1];
            [self addSubview:btn];
            
            
            UIButton* btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn2 setFrame:CGRectMake(xCord+7, 5+7, 16, 16)];
            btn2.layer.cornerRadius = 8;
            btn2.layer.masksToBounds = true;
            [btn2 setTag:i+1];
            [btn2 setImage:[UIImage imageNamed:@"lock"] forState:UIControlStateNormal];
            [btn2 addTarget:self action:@selector(buttonAction2:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            [self addSubview:btn2];
            
            xCord += btn.frame.size.width + 10;
        }
    }
    
    [self setContentSize:CGSizeMake(xCord+2000, 0)];
}

- (void)buttonAction:(UIButton *)sender {
    
}

- (void)buttonAction2:(UIButton *)sender {
    
}

@end

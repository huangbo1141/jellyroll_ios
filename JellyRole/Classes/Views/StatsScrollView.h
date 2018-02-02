//
//  StatsScrollView.h
//  JellyRole
//
//  Created by Kapil Kumar on 9/21/17.
//  Copyright © 2017 Kapil Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol StatsScrollViewDelegate <NSObject>

@optional

- (void)selectedBall;

@end

@interface StatsScrollView : UIScrollView

@property (assign, nonatomic) id delegates;

-(void)updateView;

@end

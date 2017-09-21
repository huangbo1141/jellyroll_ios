//
//  ViewMessage.m
//  JellyRole
//
//  Created by BoHuang on 3/22/17.
//  Copyright © 2017 mac. All rights reserved.
//

#import "ViewMessage.h"
#import <UIKit/UIKit.h>
@implementation ViewMessage

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)setData:(int)mode{
    switch (mode) {
        case 1:
        {
            UIImage *img = [UIImage imageNamed:@"msg_login_succ.png"];
            _imgContent.image = img;
            break;
        }
        case 2:
        {
            UIImage *img = [UIImage imageNamed:@"msg_login_fail.png"];
            _imgContent.image = img;
            break;
        }
        default:
            break;
    }
}
@end

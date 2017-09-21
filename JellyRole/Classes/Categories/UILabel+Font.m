//
//  UILabel(Font).m
//  JellyRole
//
//  Created by Kapil Kumar on 9/8/17.
//  Copyright © 2017 Kapil Kumar. All rights reserved.
//

#import "UILabel+Font.h"
#import "Utils.h"

@implementation UILabel (Font)

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)adjustsFontSizeToFitDevice {
 

    if ([Utils isIphone]) {
        
        if ([Utils isIphone5]) {
            
            self.font = [self.font fontWithSize:self.font.pointSize-1];
        } else if ([Utils isIphone6]) {
            
        }  else if ([Utils isIphone6Plus]) {
            
        }
        
    }
}



@end

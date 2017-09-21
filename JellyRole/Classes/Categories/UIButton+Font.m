//
//  UIButton+Font.m
//  JellyRole
//
//  Created by Kapil Kumar on 9/8/17.
//  Copyright © 2017 Kapil Kumar. All rights reserved.
//

#import "UIButton+Font.h"
#import "Utils.h"

@implementation UIButton(Font)

- (void)adjustsFontSizeToFitDevice {
    
    
    if ([Utils isIphone]) {
        
        if ([Utils isIphone5]) {
            
            
            self.titleLabel.font = [self.titleLabel.font fontWithSize:self.titleLabel.font.pointSize-2];
        } else if ([Utils isIphone6]) {
            
        }  else if ([Utils isIphone6Plus]) {
            
        }
        
    }
}

@end

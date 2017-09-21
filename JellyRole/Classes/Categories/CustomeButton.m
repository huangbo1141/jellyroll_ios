//
//  CustomeButton.m
//  JellyRole
//
//  Created by Kapil Kumar on 9/8/17.
//  Copyright © 2017 Kapil Kumar. All rights reserved.
//

#import "CustomeButton.h"
#import "UIButton+Font.h"

@implementation CustomeButton

- (void)awakeFromNib {
    
    [super awakeFromNib];
    [self adjustsFontSizeToFitDevice];
}

@end

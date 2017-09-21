//
//  CustomLable.m
//  JellyRole
//
//  Created by Kapil Kumar on 9/8/17.
//  Copyright © 2017 Kapil Kumar. All rights reserved.
//

#import "CustomLable.h"
#import "UILabel+Font.h"

@implementation CustomLable

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    
    [super awakeFromNib];
    [self adjustsFontSizeToFitDevice];
}

//override func awakeFromNib() {
//    super.awakeFromNib()
//    
//    adjustsFontSizeToFitDevice()
//}

@end

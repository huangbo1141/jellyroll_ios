//
//  UIImage+fixOrientation.h
//  JellyRole
//
//  Created by Kapil Kumar on 12/15/17.
//  Copyright © 2017 Kapil Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (fixOrientation)

- (UIImage *)fixOrientation;
- (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size;

@end

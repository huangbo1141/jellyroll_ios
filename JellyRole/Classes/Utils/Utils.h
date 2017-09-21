//  Created by Kapil on 01/08/17.
//  Copyright (c) 2017 Kapil. All rights reserved.



#import <UIKit/UIKit.h>

@interface Utils : NSObject

+ (NSString *)applicationDocumentsDirectory;
+ (NSString*) applicationLibraryDirectory;

+ (NSDate *)dateWithString:(NSString *)date dateFormat:(NSString *)dateFormat timeZone:(NSTimeZone *)timeZone;

+ (BOOL)isConnectedToNetwork;
+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL;
+ (BOOL)isIphone;
+ (BOOL)isIphone5;
+ (BOOL)isIphone6;
+ (BOOL)isIphone6Plus;
+ (NSString *)getLocalResourceWithName:(NSString *)name;
+ (NSString *)getIpadResourceName:(NSString*)name;
+ (UIImage *)getImageWithName:(NSString *)imgName;
+ (NSString *)versionString;
+ (void)rotateLayerInfinite:(CALayer *)layer;

+ (BOOL)isFileExist:(NSString *)filePath;
+ (BOOL)saveContents:(NSData*)contentData toFile:(NSString*)file;
+ (CGSize)stringSize:(NSString *)text size:(CGSize)size font:(UIFont *)font;
+ (UIImage *)changeIMageColor:(UIImage *)image color:(UIColor *)color;
+ (BOOL)isValidEmail:(NSString *)email;
+ (void)resignFromResponder:(UIView *)view;
+ (NSString *)getCurrentDate;
+ (NSString *)uniqueFileName;

@end

//  Created by Kapil on 01/08/17.
//  Copyright (c) 2017 Kapil. All rights reserved.


#import "Utils.h"
#import <netinet/in.h>
#import <SystemConfiguration/SCNetworkReachability.h>
#include <sys/xattr.h>
#import <QuartzCore/QuartzCore.h>

@implementation Utils


+ (NSString *)applicationDocumentsDirectory
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString* basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

+ (NSString*) applicationLibraryDirectory
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString* basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

+ (NSDate *)dateWithString:(NSString *)date dateFormat:(NSString *)dateFormat timeZone:(NSTimeZone *)timeZone
{
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init] ;
 //   dateFormatter.dateStyle = kCFDateFormatterFullStyle;
    NSTimeZone* sourceTimeZone = timeZone;
    [dateFormatter setTimeZone:sourceTimeZone];
    
    [dateFormatter setDateFormat:dateFormat];
	
	return [dateFormatter dateFromString:date];
}


#pragma mark
#pragma mark Check network
+ (BOOL)isConnectedToNetwork
{
	// Create zero addy
	struct sockaddr_in zeroAddress;
	bzero(&zeroAddress, sizeof(zeroAddress));
	zeroAddress.sin_len = sizeof(zeroAddress);
	zeroAddress.sin_family = AF_INET;
	
	// Recover reachability flags
	SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
	SCNetworkReachabilityFlags flags;
	
	// synchronous model
	BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
	CFRelease(defaultRouteReachability);
	
	if (!didRetrieveFlags)
	{
		return 0;
	}
	
	BOOL isReachable = flags & kSCNetworkFlagsReachable;
	BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
	
	return (isReachable && !needsConnection);
}

+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    const char* filePath = [[URL path] fileSystemRepresentation];
    
    const char* attrName = "com.apple.MobileBackup";
    u_int8_t attrValue = 1;
    
    int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
    return result == 0;
}

+ (BOOL)isIphone
{
	NSString* source = [[UIDevice currentDevice] model];
	return !([source rangeOfString:@"iPad" options:NSCaseInsensitiveSearch].length > 0);
    
}

+ (BOOL)isIphone5
{
    return ([UIScreen mainScreen].bounds.size.height == 568);
}

+ (BOOL)isIphone6
{
    return ([UIScreen mainScreen].bounds.size.height == 667);
}

+ (BOOL)isIphone6Plus
{
    return ([UIScreen mainScreen].bounds.size.height == 736);
}

+ (NSString *)getLocalResourceWithName:(NSString *)name
{
	return [[NSBundle mainBundle] pathForResource:name ofType:nil];
}

+ (NSString *)getIpadResourceName:(NSString*)name
{
    return name;
	//return [Utils isIphone] ? [NSString stringWithFormat:@"%@_iPhone",name] : [NSString stringWithFormat:@"%@_iPad",name];
}

+ (UIImage *)getImageWithName:(NSString *)imgName
{
	NSString* appDocDirPath = [Utils applicationDocumentsDirectory];
	NSString* path = [NSString stringWithFormat:@"%@/%@",appDocDirPath,imgName];
	UIImage*  image = [UIImage imageWithContentsOfFile:path];
	return image;
}

+ (NSString *)versionString
{
    NSString* sVersionNumber = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString* sBuildNumber = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    NSString* sBuildInfo = [NSString stringWithFormat:@"Ver %@ Build %@", sVersionNumber, sBuildNumber];
    return sBuildInfo;
}

+ (void)rotateLayerInfinite:(CALayer *)layer
{
    CABasicAnimation *rotation;
    rotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotation.fromValue = [NSNumber numberWithFloat:0];
    rotation.toValue = [NSNumber numberWithFloat:(2 * M_PI)];
    rotation.duration = 1.0f; // Speed
    rotation.repeatCount = HUGE_VALF; // Repeat forever. Can be a finite number.
    [layer removeAllAnimations];
    [layer addAnimation:rotation forKey:@"Spin"];
}


+ (BOOL)isFileExist:(NSString *)filePath
{
	NSFileManager* fileMgr = [NSFileManager defaultManager];
	return [fileMgr fileExistsAtPath:filePath];
}

+ (BOOL)saveContents:(NSData*)contentData toFile:(NSString*)file
{
    NSString* documentsDirectory = [Utils applicationDocumentsDirectory];
    NSString* myDocumentPath = [documentsDirectory stringByAppendingPathComponent:file];
    NSFileManager* fileMgr = [NSFileManager defaultManager];
	
    if (![fileMgr fileExistsAtPath:myDocumentPath])
    {
        BOOL fileCreated = [fileMgr createDirectoryAtPath:[myDocumentPath stringByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:nil];
        if (fileCreated != YES)
        {
            return NO;
        }
    }
	
    BOOL status = [contentData writeToFile:myDocumentPath atomically:YES];
	if (status)
	{
		NSURL* srcURL = [NSURL fileURLWithPath:myDocumentPath];
		[Utils addSkipBackupAttributeToItemAtURL:srcURL];
	}
    return status;
}

+ (CGSize)stringSize:(NSString *)text size:(CGSize)size font:(UIFont *)font
{
    //UIFont* theFont = [UIFont systemFontOfSize:16.0];
    CGRect stringSize = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font} context:nil];
    stringSize.size.width = ceil(stringSize.size.width);
    stringSize.size.height = ceil(stringSize.size.height);
    
	if (stringSize.size.height <= 0)
		stringSize.size.height = 14.0;
    return stringSize.size;
}

+ (UIImage *)changeIMageColor:(UIImage *)image color:(UIColor *)color
{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [color setFill];
    CGContextTranslateCTM(context, 0, image.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextClipToMask(context, CGRectMake(0, 0, image.size.width, image.size.height), [image CGImage]);
    CGContextFillRect(context, CGRectMake(0, 0, image.size.width, image.size.height));
    
    UIImage* coloredImg = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return coloredImg;
}

+ (BOOL)isValidEmail:(NSString *)email
{
    NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    return [emailTest evaluateWithObject:email];
}

+ (void)resignFromResponder:(UIView *)view
{
    for (UIView* subview in view.subviews) {
        [subview resignFirstResponder];
    }
}

+ (NSString *)getCurrentDate
{
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"yyyy-MM-dd H:m:s"];
    NSTimeZone* sourceTimeZone = [NSTimeZone defaultTimeZone];
    [f setTimeZone:sourceTimeZone];
    return [f stringFromDate:[NSDate date]];
}

+ (NSString *)uniqueFileName
{
    long long milliseconds = (long long)([[NSDate date] timeIntervalSince1970] * 1000.0);
    NSString *strTimeStamp = [NSString stringWithFormat:@"%lld",milliseconds];
    
    return strTimeStamp;//[NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
}

+(NSString *)stringToDate:(NSString *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    
    
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat : @"yyyy-MM-dd HH:mm:ss"];
    NSDate *dateTime = [formatter dateFromString:date];
    if (dateTime == nil) {
        
        dateTime = [NSDate date];
    }
    
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    [formatter setDateFormat : @"MMM dd yyyy"];
    
    return [formatter stringFromDate:dateTime];;
}


+(NSString *)stringToTime:(NSString *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat : @"yyyy-MM-dd HH:mm:ss"];
    NSDate *dateTime = [formatter dateFromString:date];
    if (dateTime == nil) {
        
        dateTime = [NSDate date];
    }
    
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    
    [formatter setDateFormat : @"hh:mm a"];
    
    return [formatter stringFromDate:dateTime];;
}


+(NSString*)selectRandomBallImageName:(NSString*)barid {
    int r = arc4random_uniform(16);
    if (barid!=nil) {
        r = [barid intValue];
    }
    
    r = r%16;
    if (r == 0) {
        r = 1;
    }
    NSString* name = [NSString stringWithFormat:@"%dball",r];
    return name;
    
    //    UIImage* image = [UIImage imageNamed:name];
    //    return image;
    
}

+(void)dropShadow:(UIView *)view {
    
 
    view.layer.shadowOpacity = 0.6;
    view.layer.shadowColor = [UIColor blackColor].CGColor;
    view.layer.shadowRadius = 5.0;
    //        topImageView.layer.masksToBounds = true;
    
    view.layer.shadowOffset = CGSizeMake(5, 5);
}

@end

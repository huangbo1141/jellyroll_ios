//
//  NotificationVC.h
//  JellyRole
//
//  Created by Kapil Kumar on 9/25/17.
//  Copyright © 2017 Kapil Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NotificationVCDelegates <NSObject>

- (void)updateTitleNotification:(NSString *)title;


@end

@interface NotificationVC : UIViewController
{
@public
    UIImage* _mapView;
}

@property(nonatomic, weak) id <NotificationVCDelegates> delegate;

@end

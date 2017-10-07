//
//  MainVCViewController.h
//  JellyRole
//
//  Created by Kapil Kumar on 9/23/17.
//  Copyright © 2017 Kapil Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MapVCDelegates <NSObject>

- (void)loadLocationStateVC:(UIImage *)image data:(NSDictionary *)data;

@end

@interface MapVC : UIViewController
{

    @public
    float _mylatitude, _myLongitude;
}

@property(nonatomic, weak) id <MapVCDelegates> delegate;

- (void)hideDialogPublic;
- (UIImage*)captureViewS;

@end

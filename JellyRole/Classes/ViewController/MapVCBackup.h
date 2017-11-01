//
//  MainVCViewController.h
//  JellyRole
//
//  Created by Kapil Kumar on 9/23/17.
//  Copyright © 2017 Kapil Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MapVCBackupDelegates <NSObject>

- (void)loadLocationStateVC:(UIImage *)image data:(NSDictionary *)data;
- (void)updateTitle:(NSString *)title;

@end

@interface MapVCBackup : UIViewController
{

    @public
    float _mylatitude, _myLongitude;
}

@property(nonatomic, weak) id <MapVCBackupDelegates> delegate;

- (void)hideDialogPublic;
- (UIImage*)captureViewS;

@end

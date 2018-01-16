//
//  QuickPlayVC.h
//  JellyRole
//
//  Created by Kapil Kumar on 10/2/17.
//  Copyright © 2017 Kapil Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QuickPlayVCDelegates <NSObject>

- (void)updateTitleQuickPlay:(NSString *)title;


@end

@interface QuickPlayVC : UIViewController
{
@public
    UIImage* _mapView;
    BOOL _isLocation;
    BOOL _isFromMap;
    BOOL _isQuickPlay;
    
    NSMutableDictionary* _selectedBar;
    
    float _mylatitude, _myLongitude;
}

@property(nonatomic, weak) id <QuickPlayVCDelegates> delegate;

- (BOOL)removeOpponetFromView;
- (IBAction)backAction:(id)sender;
@end

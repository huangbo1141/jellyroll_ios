//
//  QuickPlayVC.h
//  JellyRole
//
//  Created by Kapil Kumar on 10/2/17.
//  Copyright © 2017 Kapil Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuickPlayVC : UIViewController
{
@public
    UIImage* _mapView;
    BOOL _isLocation;
    
    NSMutableDictionary* _selectedBar;
    
}

@end
//
//  ArtPiece.h
//  JellyRole
//
//  Created by BoHuang on 3/23/17.
//  Copyright © 2017 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface ArtPiece : MKShape

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *imgname;
@property (nonatomic, strong) NSDictionary *data;
@property (nonatomic, strong) NSNumber* distance;

@end

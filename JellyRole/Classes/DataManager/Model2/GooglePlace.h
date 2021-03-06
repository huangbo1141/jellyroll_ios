//
//  GooglePlace.h
//  ResignDate
//
//  Created by BoHuang on 5/10/16.
//  Copyright © 2016 Twinklestar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GooglePlace : NSObject
@property (nonatomic,copy) NSString*reference;
@property (nonatomic,copy) NSString*place_id;
@property (nonatomic,copy) NSString*formatted_address;
@property (nonatomic,copy) NSString*formatted_phone_number;
@property (nonatomic,copy) NSString*lat;
@property (nonatomic,copy) NSString*lon;
@property (nonatomic,copy) NSString*icon;
@property (nonatomic,copy) NSString*name;
@property (nonatomic,strong) NSMutableArray* types;
@property (nonatomic,copy) NSString*xid;
@property (nonatomic,strong) NSMutableArray*address_components;

@property (nonatomic,copy) NSString* googlePicture;
@property (nonatomic,strong) NSMutableArray*weekday_text;

@property (nonatomic,assign) double distance;
@property (nonatomic,assign) BOOL isOpen;

-(instancetype)initWithDictionary:(NSDictionary*) dict;

-(NSString*)getAddressForTextQuery;



@end

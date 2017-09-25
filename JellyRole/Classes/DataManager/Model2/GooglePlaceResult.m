//
//  GooglePlaceResult.m
//  travpholer
//
//  Created by Twinklestar on 9/1/16.
//  Copyright © 2016 BoHuang. All rights reserved.
//

#import "GooglePlaceResult.h"
#import "BaseModel.h"

@implementation GooglePlaceResult

-(instancetype)initWithDictionary:(NSDictionary*) dict{
    self = [super init];
    if(self){
        
        [BaseModel parseResponse:self Dict:dict];
        
        id obj = [dict objectForKey:@"result"];
        if (obj!=nil && obj!= [NSNull null]) {
            
            GooglePlace* place = [[GooglePlace alloc] initWithDictionary:obj];
            _result = place;
        }
    }
    return self;
}
@end

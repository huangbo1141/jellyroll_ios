//
//  ViewMessage.h
//  JellyRole
//
//  Created by BoHuang on 3/22/17.
//  Copyright © 2017 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewMessage : UIView
@property (weak, nonatomic) IBOutlet UIImageView *imgContent;

-(void)setData:(int)mode;
@end

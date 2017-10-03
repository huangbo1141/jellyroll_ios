//
//  NotificationRequetVC.h
//  JellyRole
//
//  Created by Kapil Kumar on 9/25/17.
//  Copyright © 2017 Kapil Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NotificationRequetVCDelegate <NSObject>

@optional

- (void)selectedDeleteDict:(NSDictionary *)dict;

@end



@interface NotificationRequetVC : UITableView

@property (assign, nonatomic) id delegates;

- (void)setView:(BOOL)isPending ;
- (void)updateData:(NSArray *)array;


@end

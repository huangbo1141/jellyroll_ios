//
//  LeaderboardView.h
//  JellyRole
//
//  Created by Kapil Kumar on 9/8/17.
//  Copyright © 2017 Kapil Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LeaderboardViewDelegate <NSObject>

@optional

- (void)selectedUserDict:(NSDictionary *)dict;

@end

@interface LeaderboardView : UITableView

@property (assign, nonatomic) id delegates;

- (void)setView;
- (void)updateData:(NSArray *)array;

@end

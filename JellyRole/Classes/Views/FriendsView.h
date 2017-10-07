//
//  FriendsView.h
//  JellyRole
//
//  Created by Kapil Kumar on 10/5/17.
//  Copyright © 2017 Kapil Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FriendsViewDelegates <NSObject>

- (void)selectedUser:(NSDictionary *)selctedUser;

@end


@interface FriendsView : UITableView

@property(nonatomic, weak) id <FriendsViewDelegates> delegates;

- (void)setView;
- (void)updateData:(NSArray *)array isSearch:(BOOL)search;

@end

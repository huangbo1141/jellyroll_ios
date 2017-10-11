//
//  GameView.h
//  JellyRole
//
//  Created by Kapil Kumar on 9/8/17.
//  Copyright © 2017 Kapil Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameView : UITableView

- (void)setView;
- (void)updateData:(NSArray *)array isRecent:(BOOL)isRecent;

@end

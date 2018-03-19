//
//  GameView.m
//  JellyRole
//
//  Created by Kapil Kumar on 9/8/17.
//  Copyright © 2017 Kapil Kumar. All rights reserved.
//

#import "GameView.h"
#import "GameCell.h"

@interface GameView ()<UITableViewDelegate, UITableViewDataSource>
{
    NSArray* _list;
    BOOL _isRecent;
    BOOL _isState;
    BOOL _isSession;
}


@end

@implementation GameView

#pragma mark -
#pragma mark - Public Methods
- (void)setView {
    
    [self setDataSource:self];
    [self setDelegate:self];
    
    _list = [[NSArray alloc] init];

    //[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateIndicator) userInfo:nil repeats:true];
}

- (void)updateIndicator {
    
    [self flashScrollIndicators];
}

- (void)updateData:(NSArray *)array isRecent:(BOOL)isRecent isState:(BOOL)isState isSession:(BOOL)isSession {

    _list = array;
    _isRecent = isRecent;
    _isState = isState;
    _isSession = isSession;
    [self reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GameCell *cell = [tableView dequeueReusableCellWithIdentifier:_isSession ? @"cell2" : @"cell" forIndexPath:indexPath];
    
    NSDictionary* dict = [_list objectAtIndex:indexPath.row];
    
    UIImageView* imageView = [cell viewWithTag:101];
    
    UILabel* label1 = [cell viewWithTag:102];
    
    UILabel* label2 = [cell viewWithTag:103];
    
    UILabel* label3 = [cell viewWithTag:104];
    
    UILabel* label4 = [cell viewWithTag:105];
    
    if (_isRecent) {
    
        for (NSLayoutConstraint* cos in imageView.constraints) {
            cos.constant = 0;
        }
        
        for (NSLayoutConstraint* cos in label1.constraints) {
            cos.constant = 51;
        }
        
        cell.lConstraint.constant = 0;
        
        

    } else {
        
        for (NSLayoutConstraint* cos in imageView.constraints) {
            cos.constant = 18;
        }
        
        for (NSLayoutConstraint* cos in label1.constraints) {
            cos.constant = 27;
        }
        cell.lConstraint.constant = 6;
    }
    
    if (_isRecent) {
        
        [label1 setTextColor:[UIColor colorWithRed:15.0/255.0 green:248.0/255.0 blue:15.0/255.0 alpha:1.0]];
        if ([[dict[@"by_win_or_lost"] lowercaseString] isEqualToString:@"win"]) {
            
            [label1 setText:dict[@"player1"]];
            [label2 setText:dict[@"player2"]];
            
        } else {
            
            [label1 setText:dict[@"player2"]];
            [label2 setText:dict[@"player1"]];
        }
    } else {

        [label1 setTextColor:[UIColor whiteColor]];
        if ([[[_gAppPrefData userName] lowercaseString] isEqualToString:[dict[@"player1"] lowercaseString]]) {
            
            [label2 setText:dict[@"player2"]];
            
            if ([[dict[@"by_win_or_lost"] lowercaseString] isEqualToString:@"win"]) {
                
                [imageView setImage:[UIImage imageNamed:@"thumb1"]];
                [label1 setText:@"Win"];
            } else {
                
                [imageView setImage:[UIImage imageNamed:@"thumb2"]];
                [label1 setText:@"Loss"];
            }
            
        } else {
            [label2 setText:dict[@"player1"]];
            
            if ([[dict[@"other_win_or_lost"] lowercaseString] isEqualToString:@"win"]) {
                
                [imageView setImage:[UIImage imageNamed:@"thumb1"]];
                [label1 setText:@"Win"];
            } else {
                
                [imageView setImage:[UIImage imageNamed:@"thumb2"]];
                [label1 setText:@"Loss"];
            }
        }
    }
    
    
    if (_isState) {
        [label3 setText:[dict[@"location_name"] capitalizedString]];
    } else {
        
        if (dict[@"location_name"] != nil) {
            
            [label3 setText:[dict[@"location_name"] capitalizedString]];
        } else {
            [label3 setText:[Utils stringToTime:dict[@"insertime"]]];
        }
        
    }
    [label4 setText:[Utils stringToDate:dict[@"insertime"]]];
 
    if (_isSession) {
        
        int totalGames = [dict[@"totalGame"] intValue];
        int winGames = [dict[@"status"] intValue];
        int winPercentage = (winGames * 100) / totalGames;
        
        
        UIColor *normalColor = [UIColor whiteColor];
        UIColor *highlightColor = (winPercentage >= 50 ) ? kGreenColor : kRedColor;
        UIFont *font = [UIFont fontWithName:@"Open Sans" size:8];
        NSDictionary *normalAttributes = @{NSFontAttributeName:font, NSForegroundColorAttributeName:normalColor};
        NSDictionary *highlightAttributes = @{NSFontAttributeName:font, NSForegroundColorAttributeName:highlightColor};
        
        NSAttributedString *normalText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"/%d", totalGames] attributes:normalAttributes];
        NSAttributedString *highlightedText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d", winGames] attributes:highlightAttributes];
        
        NSMutableAttributedString *finalAttributedString = [[NSMutableAttributedString alloc] initWithAttributedString:highlightedText];
        [finalAttributedString appendAttributedString:normalText];
        [label3 setAttributedText:finalAttributedString];
        
        [imageView setImage:(winPercentage >= 50 ) ? [UIImage imageNamed:@"thumb1"] : [UIImage imageNamed:@"thumb2"]];
        [label1 setText:(winPercentage >= 50 ) ? @"Win" : @"Loss"];
        
    }
    return cell;
}


#pragma mark - Table view Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
}

@end

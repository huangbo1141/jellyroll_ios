//
//  UserComparisionView.m
//  JellyRole
//
//  Created by Kapil Kumar on 10/3/17.
//  Copyright © 2017 Kapil Kumar. All rights reserved.
//

#import "UserComparisionView.h"

@interface UserComparisionView()<UITableViewDelegate, UITableViewDataSource>
{
    NSArray* _list;
}
@end

@implementation UserComparisionView

- (void)setView {
    
    [self setDataSource:self];
    [self setDelegate:self];
    
    _list = [[NSArray alloc] init];
}

- (void)updateData:(NSArray *)array {
    
    _list = array;
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
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    NSDictionary* dict = [_list objectAtIndex:indexPath.row];
    
    UILabel* label1 = [cell viewWithTag:101];
    UILabel* label2 = [cell viewWithTag:102];
    UILabel* label3 = [cell viewWithTag:103];
    UILabel* label4 = [cell viewWithTag:104];
    UILabel* label5 = [cell viewWithTag:105];
    UILabel* label6 = [cell viewWithTag:106];
    UILabel* label7 = [cell viewWithTag:107];
    
    
    NSString* myString = [NSString stringWithFormat:@"%@/%@", dict[@"win"], dict[@"loss"]];
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:myString];
    NSRange range1 = [myString rangeOfString:dict[@"win"]];
    NSRange range2 = [myString rangeOfString:[NSString stringWithFormat:@"/%@", dict[@"loss"]]];
    [attString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:(15/255.0) green:(248/255.0) blue:(15/255.0) alpha:1.0] range:range1];
    [attString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:range2];

    label4.attributedText = attString;
    
    
    myString = [NSString stringWithFormat:@"%@/%@", dict[@"win_o"], dict[@"loss_o"]];
    NSMutableAttributedString *attString2 = [[NSMutableAttributedString alloc] initWithString:myString];
    range1 = [myString rangeOfString:dict[@"win_o"]];
    range2 = [myString rangeOfString:[NSString stringWithFormat:@"/%@", dict[@"loss_o"]]];
    [attString2 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:(15/255.0) green:(248/255.0) blue:(15/255.0) alpha:1.0] range:range1];
    [attString2 addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:range2];
    
    label5.attributedText = attString2;
    
    [label1 setText:[NSString stringWithFormat:@"%@",[dict[@"location"] capitalizedString]]];
    
    if ([dict[@"my_rank"] intValue] == 0) {
        [label2 setText:@"n/a"];
    } else {
    
        [label2 setText:[NSString stringWithFormat:@"#%@", dict[@"my_rank"]]];
    }
    
    if ([dict[@"other_rank"] intValue] == 0) {
        [label3 setText:@"n/a"];
    } else {
        
        [label3 setText:[NSString stringWithFormat:@"#%@", dict[@"other_rank"]]];
    }
    
    if ([dict[@"percent"] intValue] == 0) {
        [label6 setText:@"n/a"];
    } else {
        
        [label6 setText:[NSString stringWithFormat:@"#%@", dict[@"percent"]]];
    }
    
    if ([dict[@"percent_o"] intValue] == 0) {
        [label7 setText:@"n/a"];
    } else {
        
        [label7 setText:[NSString stringWithFormat:@"#%@", dict[@"percent_o"]]];
    }
    
    return cell;
}


#pragma mark - Table view Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
}

@end


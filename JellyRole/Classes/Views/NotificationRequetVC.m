
//
//  NotificationRequetVC.m
//  JellyRole
//
//  Created by Kapil Kumar on 9/25/17.
//  Copyright © 2017 Kapil Kumar. All rights reserved.
//

#import "NotificationRequetVC.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface NotificationRequetVC ()<UITableViewDelegate, UITableViewDataSource>
{
    NSArray* _list;
    BOOL _isPending;
}

@end


@implementation NotificationRequetVC

#pragma mark -
#pragma mark - Public Methods
- (void)setView:(BOOL)isPending {
    
    [self setDataSource:self];
    [self setDelegate:self];
    
    _list = [[NSArray alloc] init];
    _isPending = isPending;
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
    
    UIImageView* winImage = [cell viewWithTag:101];
    UILabel* winLabel = [cell viewWithTag:102];
    UIImageView* userImage = [cell viewWithTag:103];
    UILabel* userLabel = [cell viewWithTag:104];
    
    
    UILabel* barLabel = [cell viewWithTag:105];
    UILabel* dateLabel = [cell viewWithTag:106];
    UILabel* timeLabel = [cell viewWithTag:107];
    UIActivityIndicatorView* indicatorView = [cell viewWithTag:108];
    
    userImage.layer.cornerRadius = 15;
    userImage.layer.masksToBounds = true;
    
    __weak typeof(UIImageView) *weakSelf = userImage;
    [userImage setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:dict[@"user_image"]]] placeholderImage:[UIImage imageNamed:@"placeholdernew"] success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
        
        [weakSelf setImage:image];
        [indicatorView stopAnimating];
        
        [Utils saveContents:UIImageJPEGRepresentation(image, 1.0) toFile:[NSString stringWithFormat:@"Upload/%@.jpg", dict[@"by_user_id"]]];
    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        
        [indicatorView stopAnimating];
        
    }];
    
    
    if ([[dict[@"other_win_or_lost"] lowercaseString] isEqualToString:@"win"]) {
        
        [winImage setImage:[UIImage imageNamed:@"thumb2"]];
        [winLabel setText:@"Loss"];
    } else {
        
        [winImage setImage:[UIImage imageNamed:@"thumb1"]];
        [winLabel setText:@"Win"];
    }
    
    [userLabel setText:dict[@"username"]];
    [barLabel setText:dict[@"location_name"]];
    [dateLabel setText:[Utils stringToDate:dict[@"insertime"]]];
    [timeLabel setText:[Utils stringToTime:dict[@"insertime"]]];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_delegates != nil) {
        
        NSDictionary* dict = [_list objectAtIndex:indexPath.row];
        [_delegates selectedDeleteDict:dict];
    }
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return _isPending;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewCellEditingStyleDelete;
}



#pragma mark - Table view Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
}

@end

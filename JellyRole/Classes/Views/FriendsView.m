//
//  FriendsView.m
//  JellyRole
//
//  Created by Kapil Kumar on 10/5/17.
//  Copyright © 2017 Kapil Kumar. All rights reserved.
//

#import "FriendsView.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface FriendsView()<UITableViewDelegate, UITableViewDataSource>
{
    NSArray* _list;
    NSString* _myRank;
    BOOL _isSearch;
}


@end

@implementation FriendsView

- (void)setView {
    
    [self setDataSource:self];
    [self setDelegate:self];
    
    _list = [[NSArray alloc] init];
}

- (void)updateData:(NSArray *)array isSearch:(BOOL)search myRank:(NSString *)myrank{
    
    _list = array;
    _isSearch = search;
    _myRank = myrank;
    [self reloadData];
}




#pragma mark
#pragma mark UITableView DataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_isSearch) {
        
        return 44;
    } else {
        
        return 60;
    }
     
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [_list count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary* dict = _list[indexPath.row];
    if (_isSearch) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellSearch" forIndexPath:indexPath];
        
        UILabel* userName = [cell viewWithTag:101];
        userName.text = dict[@"username"];
        return cell;
    } else {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        
        UIActivityIndicatorView* indicator = [cell viewWithTag:105];
        [indicator startAnimating];
        [indicator hidesWhenStopped];
        
        UIImageView* imageView = [cell viewWithTag:101];
        imageView.layer.cornerRadius = 20;
        imageView.layer.masksToBounds = true;
        imageView.layer.borderWidth = 1.0;
        imageView.layer.borderColor = [UIColor whiteColor].CGColor;
        
        __weak typeof(UIImageView) *weakSelf = imageView;
        [imageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:dict[@"image"]]] placeholderImage:[UIImage imageNamed:@"placeholdernew"] success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
            
            [weakSelf setImage:image];
            [indicator stopAnimating];
            
            [Utils saveContents:UIImageJPEGRepresentation(image, 1.0) toFile:[NSString stringWithFormat:@"Upload/%@.jpg", dict[@"username"]]];
        } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
            
            [indicator stopAnimating];
            
        }];
        
        UILabel* userName = [cell viewWithTag:102];
        userName.text = [dict[@"username"] capitalizedString];
        
        UILabel* name = [cell viewWithTag:103];
        name.text = [dict[@"name"] capitalizedString];
        
        UILabel* address = [cell viewWithTag:104];
        address.text = dict[@"address"];
    
        UILabel* barRank = [cell viewWithTag:106];
        
        if ([dict[@"bar_rank"] intValue] == 0) {
            
            barRank.text = @"0";
        } else {
            barRank.text = [NSString stringWithFormat:@"#%d", [dict[@"bar_rank"] intValue]];
        }
        
        //barRank.text = [_myRank stringByReplacingOccurrencesOfString:@"My Ranking " withString:@""];
        return cell;
    }
}

#pragma mark
#pragma mark UITableView Delegates
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    NSDictionary* dict = _list[indexPath.row];
    
    if (_delegates != nil) {
        
        [_delegates selectedUser:dict];
    }
   /* if (_searchBar.text.length > 0 && dict[@"address"] == nil) {
        
        [_searchBar resignFirstResponder];
        NSString* str = [NSString stringWithFormat:@"Do you want to add \"%@\" into your friend list?", dict[@"username"]];
        
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:str preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"Yes, Add" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self addFriendsData:dict[@"email"]];
            
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        
        if (![Utils isIphone]) {
            alert.popoverPresentationController.sourceView = self.view;
        }
        
        [self presentViewController:alert animated:true completion:nil];
    }
    */
}

@end


//
//  ViewController.h
//  JellyRole
//
//  Created by Kapil Kumar on 9/8/17.
//  Copyright © 2017 Kapil Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeVC : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *notifyImage;
@property (weak, nonatomic) IBOutlet UIButton *notifyButton;

- (void)performIndexAction:(int)row;

@end


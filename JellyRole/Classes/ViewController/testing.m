//
//  testing.m
//  JellyRole
//
//  Created by Kapil Kumar on 9/22/17.
//  Copyright © 2017 Kapil Kumar. All rights reserved.
//

#define ANIMATION_DURATION 0.4
#define ANIMATION_DELAY 0


#import "testing.h"


@interface testing ()
{
    UIView* _mainView;
    UIView* _previousView;
}

@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;


@end

@implementation testing

- (void)viewDidLoad {
    [super viewDidLoad];
    _mainView = _view1;
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)pushViewController:(UIView *)viewController {
    // Place the new view to the right next to the current view
    
    viewController.hidden = false;
    viewController.frame = CGRectOffset(_mainView.frame, _mainView.bounds.size.width, 0);
    CGRect old = _mainView.frame;
    
    _previousView = _mainView;
    
    [UIView animateWithDuration:ANIMATION_DURATION delay:ANIMATION_DELAY options:UIViewAnimationOptionCurveEaseOut animations:^{
        _mainView.frame = CGRectOffset(_mainView.bounds, -self.view.bounds.size.width, _mainView.frame.origin.y);
        viewController.frame = old;
    }   completion:^(BOOL finished) {
        if (finished) {

            _previousView.hidden = true;
            _mainView = viewController;
        }
    }];
}

- (void)popViewController {
    // Sanity check - We only pop when there are at least two viewControllers in the stack,
    // otherwise there is nothing to pop
    
    _previousView.hidden = false;
    CGRect old = _mainView.frame;
    
    
    NSLog(@"...%f...%f...%f..%f", old.origin.x, old.origin.y, old.size.width, old.size.height);
    
    // Start animation
    [UIView animateWithDuration:ANIMATION_DURATION delay:ANIMATION_DELAY options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _mainView.frame = CGRectOffset(_mainView.bounds, self.view.bounds.size.width, _mainView.frame.origin.y);
        _previousView.frame = old;
    } completion:^(BOOL finished) {
        if (finished) {
            
            _mainView.hidden = true;
            _mainView = _previousView;
            NSLog(@"...%f...%f...%f..%f", old.origin.x, old.origin.y, old.size.width, old.size.height);

        }
    }];
}


- (IBAction)backAction:(id)sender {
    
    [self pushViewController:_view2];
}

- (IBAction)backAction2:(id)sender {
    
    [self popViewController];
}


@end

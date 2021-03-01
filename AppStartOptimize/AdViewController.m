//
//  AdViewController.m
//  AppStartOptimize
//
//  Created by sunner on 2021/3/1.
//  Copyright © 2021 sunner. All rights reserved.
//

#import "AdViewController.h"
#import "FirstViewController.h"
#import "StartStage.h"

@interface AdViewController ()

@end

@implementation AdViewController
{
    __weak UILabel *_label;
    NSTimer *_timer;
    NSUInteger _count;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor orangeColor];
    _count = 10;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
    label.center = self.view.center;
    label.text = [NSString stringWithFormat:@"广告页倒计时:%lu", (unsigned long)_count];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    _label = label;
    
    __weak typeof(self) ws = self;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
        __strong typeof(self) ss = ws;
        ss->_count--;
        label.text = [NSString stringWithFormat:@"广告页倒计时:%lu", (unsigned long)ss->_count];
        if (ss->_count >= 60) {
            [ss->_timer invalidate];
            ss->_timer = nil;
            // 
            [UIApplication sharedApplication].keyWindow.rootViewController = [[FirstViewController alloc] init];
        }
    }];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [_timer invalidate];
    _timer = nil;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [StartStage adStage];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

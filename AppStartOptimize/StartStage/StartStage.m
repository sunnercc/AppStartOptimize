//
//  StartStage.m
//  AppStartOptimize
//
//  Created by sunner on 2021/3/1.
//  Copyright © 2021 sunner. All rights reserved.
//

#import "StartStage.h"
#import "ThreadMonitor.h"
@implementation StartStage

+ (void)finishLaunchingStage {
    NSLog(@"finishLaunchingStage");
    // 应用的设置/配置，比如 NSUserDefault
    ThreadMonitor *monitor = [ThreadMonitor shareInstance];
    [monitor start];
}

+ (void)adStage {
    NSLog(@"AdStage");
    // 比较靠前的 SDK 的配置
}

+ (void)firstViewStage {
   NSLog(@"mainViewStage");
    // 比较靠后的 SDK 的配置
}

@end

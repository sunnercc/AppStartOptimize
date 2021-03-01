//
//  ThreadMonitor.h
//  AppStartOptimize
//
//  Created by sunner on 2021/3/1.
//  Copyright © 2021 sunner. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ThreadMonitor : NSObject
+ (instancetype)shareInstance;
- (void)start;
- (void)stop;
@end

NS_ASSUME_NONNULL_END

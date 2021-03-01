//
//  ThreadMonitor.m
//  AppStartOptimize
//
//  Created by sunner on 2021/3/1.
//  Copyright © 2021 sunner. All rights reserved.
//

#import "ThreadMonitor.h"

#define STUCKTIME 0.01f

@interface ThreadMonitor ()
@property (atomic, assign) NSTimeInterval beforeWaiting;
@property (atomic, assign) NSTimeInterval afterWaiting;
@property (atomic, assign) NSTimeInterval runloopDis;
@property (atomic, assign) BOOL free;
@property (nonatomic, assign) BOOL end;
@property (nonatomic, strong) NSThread *thread;
@end

@implementation ThreadMonitor

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    static id instance;
    dispatch_once(&onceToken, ^{
        if (!instance) {
            instance = [[self alloc] init];
        }
    });
    return instance;;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.end = NO;
        self.free = YES;
        __weak typeof(self) ws = self;
        self.thread = [[NSThread alloc] initWithBlock:^{
            __strong typeof(ws) ss = ws;
            NSTimer *timer = [NSTimer timerWithTimeInterval:1.0 target:ws selector:@selector(listen) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
            while (!ss.end) {
                 [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:NSDate.distantFuture];
             }
        }];
        [self.thread start];
    }
    return self;
}

- (void)start {
    typeof(self) ws = self;
        CFRunLoopObserverRef observerRef = CFRunLoopObserverCreateWithHandler(CFAllocatorGetDefault(), kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
            [ws performSelector:@selector(listenMainRunloopActivity:) onThread:ws->_thread withObject:@(activity) waitUntilDone:NO];
        });
        CFRunLoopAddObserver(CFRunLoopGetMain(), observerRef, kCFRunLoopCommonModes);
}

- (void)stop {
    self.end = YES;
}

- (void)listenMainRunloopActivity:(id)activity {
    typeof(self) ws = self;
    switch ([activity intValue]) {
            case kCFRunLoopBeforeWaiting:
            ws.free = NO;
            ws.beforeWaiting = [NSDate date].timeIntervalSince1970;
            ws.runloopDis = ws.beforeWaiting - ws.afterWaiting;
            break;
            case kCFRunLoopAfterWaiting:
            ws.free = NO;
            ws.afterWaiting = [NSDate date].timeIntervalSince1970;
            break;
    }
}

- (void)listen {
    if (_free == YES) {
        NSLog(@"主线程空闲了");
    }
    if (_runloopDis > STUCKTIME) {
        NSLog(@"主线程卡顿了");
    }
    _free = YES;
}

@end

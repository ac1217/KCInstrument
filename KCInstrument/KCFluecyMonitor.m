//
//  KCFluecyMonitor.m
//  KCInstrument
//
//  Created by Erica on 2019/2/15.
//  Copyright © 2019 Erica. All rights reserved.
//

#import "KCFluecyMonitor.h"
#import <CrashReporter/CrashReporter.h>

@interface KCFluecyMonitor()
{
    
    BOOL _isMoniting;
    
    int _timeoutCount;   // 耗时次数
    CFRunLoopObserverRef _observer;  // 观察者
@public
    dispatch_semaphore_t _semaphore; // 信号
    CFRunLoopActivity _activity; // 状态
    
}

@property (nonatomic, assign) CFRunLoopObserverRef observer;


@property (nonatomic, assign) dispatch_queue_t moniQueue;

@property (nonatomic,assign) int totalTimeoutCount;

@end

@implementation KCFluecyMonitor

+ (instancetype)sharedInstance
{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self new];
    });
    return instance;
    
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.timeThreshold = 0.5;
        self.totalTimeoutCount  = 5;
    }
    return self;
}

static void runLoopObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
    
    KCFluecyMonitor *monitor = (__bridge KCFluecyMonitor*)info;
    
    // 记录状态值
    monitor->_activity = activity;
    
    // 发送信号
    dispatch_semaphore_t semaphore = monitor->_semaphore;
    dispatch_semaphore_signal(semaphore);
//    NSLog(@"dispatch_semaphore_signal:st=%ld,time:%@",st,[BGPerformanceMonitor getCurTime]);
    
    //    kCFRunLoopEntry = (1UL << 0),
    //    kCFRunLoopBeforeTimers = (1UL << 1),
    //    kCFRunLoopBeforeSources = (1UL << 2),
    //    kCFRunLoopBeforeWaiting = (1UL << 5),
    //    kCFRunLoopAfterWaiting = (1UL << 6),
    //    kCFRunLoopExit = (1UL << 7),
    //    kCFRunLoopAllActivities = 0x0FFFFFFFU
    
    //    if (activity == kCFRunLoopEntry) {  // 即将进入RunLoop
    //        NSLog(@"runLoopObserverCallBack - %@",@"kCFRunLoopEntry");
    //    } else if (activity == kCFRunLoopBeforeTimers) {    // 即将处理Timer
    //        NSLog(@"runLoopObserverCallBack - %@",@"kCFRunLoopBeforeTimers");
    //    } else if (activity == kCFRunLoopBeforeSources) {   // 即将处理Source
    //        NSLog(@"runLoopObserverCallBack - %@",@"kCFRunLoopBeforeSources");
    //    } else if (activity == kCFRunLoopBeforeWaiting) {   //即将进入休眠
    //        NSLog(@"runLoopObserverCallBack - %@",@"kCFRunLoopBeforeWaiting");
    //    } else if (activity == kCFRunLoopAfterWaiting) {    // 刚从休眠中唤醒
    //        NSLog(@"runLoopObserverCallBack - %@",@"kCFRunLoopAfterWaiting");
    //    } else if (activity == kCFRunLoopExit) {    // 即将退出RunLoop
    //        NSLog(@"runLoopObserverCallBack - %@",@"kCFRunLoopExit");
    //    } else if (activity == kCFRunLoopAllActivities) {
    //        NSLog(@"runLoopObserverCallBack - %@",@"kCFRunLoopAllActivities");
    //    }
}
- (void)startMoniting
{
    
    if (_isMoniting) {
        return;
    }
    
    // 创建信号
    _semaphore = dispatch_semaphore_create(0);
//    NSLog(@"dispatch_semaphore_create:%@",[BGPerformanceMonitor getCurTime]);
    
    // 注册RunLoop状态观察
    CFRunLoopObserverContext context = {0,(__bridge void*)self,NULL,NULL};
    //创建Run loop observer对象
    //第一个参数用于分配observer对象的内存
    //第二个参数用以设置observer所要关注的事件，详见回调函数myRunLoopObserver中注释
    //第三个参数用于标识该observer是在第一次进入run loop时执行还是每次进入run loop处理时均执行
    //第四个参数用于设置该observer的优先级
    //第五个参数用于设置该observer的回调函数
    //第六个参数用于设置该observer的运行环境
    _observer = CFRunLoopObserverCreate(kCFAllocatorDefault,
                                       kCFRunLoopAllActivities,
                                       YES,
                                       0,
                                       &runLoopObserverCallBack,
                                       &context);
    CFRunLoopAddObserver(CFRunLoopGetMain(), _observer, kCFRunLoopCommonModes);
    
    _isMoniting = YES;
    // 在子线程监控时长
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        while (_isMoniting) {
            // 有信号的话 就查询当前runloop的状态
            // 假定连续5次超时50ms认为卡顿(当然也包含了单次超时250ms)
            
            int ms = self.timeThreshold * 1000 / self.totalTimeoutCount;
            
            long st = dispatch_semaphore_wait(_semaphore, dispatch_time(DISPATCH_TIME_NOW, ms*NSEC_PER_MSEC));
//            NSLog(@"dispatch_semaphore_wait:st=%ld,time:%@",st,[self getCurTime]);
            if (st != 0) {  // 有新的信号进来，表示runloop状态改变了。
                if (!_observer) {
                    _timeoutCount = 0;
                    _semaphore = 0;
                    _activity = 0;
                    return;
                }
//                NSLog(@"st = %ld,activity = %lu,time:%@",st,activity,[self getCurTime]);
                // kCFRunLoopBeforeSources - 即将处理source kCFRunLoopAfterWaiting - 刚从休眠中唤醒
                if (_activity == kCFRunLoopBeforeSources || _activity == kCFRunLoopAfterWaiting) {
                    if (++_timeoutCount < self.totalTimeoutCount) {
                        continue;
                    }
                    
                    // 收集Crash信息也可用于实时获取各线程的调用堆栈
                    PLCrashReporterConfig *config = [[PLCrashReporterConfig alloc] initWithSignalHandlerType:PLCrashReporterSignalHandlerTypeBSD symbolicationStrategy:PLCrashReporterSymbolicationStrategyAll];

                    PLCrashReporter *crashReporter = [[PLCrashReporter alloc] initWithConfiguration:config];

                    NSData *data = [crashReporter generateLiveReport];
                    PLCrashReport *reporter = [[PLCrashReport alloc] initWithData:data error:NULL];
                    NSString *report = [PLCrashReportTextFormatter stringValueForCrashReport:reporter withTextFormat:PLCrashReportTextFormatiOS];
                    
                    NSLog(@"---------卡顿信息\n%@\n--------------",report);
                    
                }
            }
//            NSLog(@"dispatch_semaphore_wait timeoutCount = 0，time:%@",[self getCurTime]);
            _timeoutCount = 0;
        }
    });
    
}

- (void)stopMoniting
{
    
    if (!_isMoniting) {
        return;
    }
    
    // 移除观察并释放资源
    CFRunLoopRemoveObserver(CFRunLoopGetMain(), _observer, kCFRunLoopCommonModes);
    CFRelease(_observer);
    _observer = NULL;
    
    _isMoniting = NO;
}


@end

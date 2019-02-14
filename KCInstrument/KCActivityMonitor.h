//
//  KCActivityMonitor.h
//  KCInstrument
//
//  Created by Erica on 2019/2/14.
//  Copyright © 2019 Erica. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KCActivityMonitor : NSObject

+ (instancetype)sharedInstance;

- (void)startMonitor;
- (void)stopMonitor;

- (long long)deviceMemoryAvailable;
- (long long)deviceMemoryUsage;
- (long long)memoryUsage;
//- (float)cpuUsage;
- (int)fps;

@end

NS_ASSUME_NONNULL_END

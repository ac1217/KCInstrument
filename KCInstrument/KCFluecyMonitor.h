//
//  KCFluecyMonitor.h
//  KCInstrument
//
//  Created by Erica on 2019/2/15.
//  Copyright © 2019 Erica. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KCFluecyMonitor : NSObject

@property (nonatomic,assign) NSTimeInterval timeThreshold;

+ (instancetype)sharedInstance;

- (void)startMoniting;
- (void)stopMoniting;

@end

NS_ASSUME_NONNULL_END

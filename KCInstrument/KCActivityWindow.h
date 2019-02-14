//
//  KCActivityWindow.h
//  KCInstrument
//
//  Created by Erica on 2019/2/14.
//  Copyright © 2019 Erica. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KCActivityWindow : UIWindow

@property (nonatomic,assign) float cpuUsage;
@property (nonatomic,assign) long long memoryUsage;
//@property (nonatomic,assign) float deviceMemoryAvailable;
//@property (nonatomic,assign) float deviceMemoryUsage;

@property (nonatomic,assign) int fps;
@end

NS_ASSUME_NONNULL_END

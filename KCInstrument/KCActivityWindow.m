//
//  KCActivityWindow.m
//  KCInstrument
//
//  Created by Erica on 2019/2/14.
//  Copyright © 2019 Erica. All rights reserved.
//

#import "KCActivityWindow.h"


@interface KCActivityWindow()

@property (nonatomic,strong) UILabel *cpuUsageLabel;
@property (nonatomic,strong) UILabel *memoryUsageLabel;
//@property (nonatomic,strong) UILabel *deviceMemoryAvailableLabel;
//@property (nonatomic,strong) UILabel *deviceMemoryUsageLabel;
@property (nonatomic,strong) UILabel *fpsLabel;

@end

@implementation KCActivityWindow

- (UILabel *)cpuUsageLabel
{
    if (!_cpuUsageLabel) {
        _cpuUsageLabel = [[UILabel alloc] init];
        _cpuUsageLabel.font = [UIFont systemFontOfSize:12];
        _cpuUsageLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _cpuUsageLabel;
}

- (UILabel *)fpsLabel
{
    if (!_fpsLabel) {
        _fpsLabel = [[UILabel alloc] init];
        _fpsLabel.font = [UIFont systemFontOfSize:12];
        _fpsLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _fpsLabel;
}

- (UILabel *)memoryUsageLabel
{
    if (!_memoryUsageLabel) {
        _memoryUsageLabel = [[UILabel alloc] init];
        _memoryUsageLabel.font = [UIFont systemFontOfSize:12];
        _memoryUsageLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _memoryUsageLabel;
}

//- (UILabel *)deviceMemoryAvailableLabel
//{
//    if (!_deviceMemoryAvailableLabel) {
//        _deviceMemoryAvailableLabel = [[UILabel alloc] init];
//        _deviceMemoryAvailableLabel.font = [UIFont systemFontOfSize:14];
//        _deviceMemoryAvailableLabel.translatesAutoresizingMaskIntoConstraints = NO;
//    }
//    return _deviceMemoryAvailableLabel;
//}
//
//- (UILabel *)deviceMemoryUsageLabel
//{
//    if (!_deviceMemoryUsageLabel) {
//        _deviceMemoryUsageLabel = [[UILabel alloc] init];
//        _deviceMemoryUsageLabel.font = [UIFont systemFontOfSize:14];
//        _deviceMemoryUsageLabel.textColor = [UIColor whiteColor]; _deviceMemoryUsageLabel.translatesAutoresizingMaskIntoConstraints = NO;
//    }
//    return _deviceMemoryUsageLabel;
//}

- (void)panGesture:(UIPanGestureRecognizer *)pan
{
    
    CGPoint t = [pan translationInView:pan.view];
    
    CGRect frame = self.frame;
    
    frame.origin.x += t.x;
    frame.origin.y += t.y;
    
    if (frame.origin.x <= 0) {
        frame.origin.x = 0;
    }else if (frame.origin.x >= [UIScreen mainScreen].bounds.size.width - self.frame.size.width) {
        
        frame.origin.x = [UIScreen mainScreen].bounds.size.width - self.frame.size.width;
    }
    
    if (frame.origin.y <= 0) {
        frame.origin.y = 0;
    }else if (frame.origin.y >= [UIScreen mainScreen].bounds.size.height - self.frame.size.height) {
        
        frame.origin.y = [UIScreen mainScreen].bounds.size.height - self.frame.size.height;
    }
    
    
    self.frame = frame;
    
    [pan setTranslation:CGPointZero inView:pan.view];
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.windowLevel = UIWindowLevelAlert;
        self.rootViewController = [UIViewController new];
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [self addSubview:self.cpuUsageLabel];
        [self addSubview:self.memoryUsageLabel];
//        [self addSubview:self.deviceMemoryAvailableLabel];
//        [self addSubview:self.deviceMemoryUsageLabel];
        [self addSubview:self.fpsLabel];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
        [self addGestureRecognizer:pan];
        
        // cpuUsageLabel
        [NSLayoutConstraint constraintWithItem:self.cpuUsageLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:10].active = YES;
        [NSLayoutConstraint constraintWithItem:self.cpuUsageLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:-10].active = YES;
        
        [NSLayoutConstraint constraintWithItem:self.cpuUsageLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:5].active = YES;
        
        // memoryUsageLabel
        [NSLayoutConstraint constraintWithItem:self.memoryUsageLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.cpuUsageLabel attribute:NSLayoutAttributeLeft multiplier:1 constant:0].active = YES;
        [NSLayoutConstraint constraintWithItem:self.memoryUsageLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.cpuUsageLabel attribute:NSLayoutAttributeRight multiplier:1 constant:0].active = YES;
        
        [NSLayoutConstraint constraintWithItem:self.memoryUsageLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.cpuUsageLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:5].active = YES;
        
        
//        // deviceMemoryUsageLabel
//        [NSLayoutConstraint constraintWithItem:self.deviceMemoryUsageLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.memoryUsageLabel attribute:NSLayoutAttributeLeft multiplier:1 constant:0].active = YES;
//        [NSLayoutConstraint constraintWithItem:self.deviceMemoryUsageLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.memoryUsageLabel attribute:NSLayoutAttributeRight multiplier:1 constant:0].active = YES;
//
//        [NSLayoutConstraint constraintWithItem:self.deviceMemoryUsageLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.memoryUsageLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:10].active = YES;
//
//        // deviceMemoryAvailableLabel
//        [NSLayoutConstraint constraintWithItem:self.deviceMemoryAvailableLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.deviceMemoryUsageLabel attribute:NSLayoutAttributeLeft multiplier:1 constant:0].active = YES;
//        [NSLayoutConstraint constraintWithItem:self.deviceMemoryAvailableLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.deviceMemoryUsageLabel attribute:NSLayoutAttributeRight multiplier:1 constant:0].active = YES;
//
//        [NSLayoutConstraint constraintWithItem:self.deviceMemoryAvailableLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.deviceMemoryUsageLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:10].active = YES;
        
        
        // fpsLabel
        [NSLayoutConstraint constraintWithItem:self.fpsLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.memoryUsageLabel attribute:NSLayoutAttributeLeft multiplier:1 constant:0].active = YES;
        [NSLayoutConstraint constraintWithItem:self.fpsLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.memoryUsageLabel attribute:NSLayoutAttributeRight multiplier:1 constant:0].active = YES;
        
        [NSLayoutConstraint constraintWithItem:self.fpsLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.memoryUsageLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:5].active = YES;
        
        
//        [NSLayoutConstraint constraintWithItem:self.fpsLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:-10].active = YES;
        
    }
    return self;
}

- (void)setCpuUsage:(float)cpuUsage
{
    _cpuUsage = cpuUsage;
    
    if (cpuUsage < 0.5) {
    
        self.cpuUsageLabel.textColor = [UIColor whiteColor];
        
    }else if (cpuUsage < 0.9) {
        
        self.cpuUsageLabel.textColor = [UIColor yellowColor];
    }else {
        
        self.cpuUsageLabel.textColor = [UIColor redColor];
    }
    
    self.cpuUsageLabel.text = [NSString stringWithFormat:@"CPU:%.f%%", cpuUsage * 100];
    
}

- (void)setMemoryUsage:(long long)memoryUsage
{
    _memoryUsage = memoryUsage;
    
    float mu = memoryUsage / 1024.0 / 1024.0;
    
    if (mu < 200) {
        self.memoryUsageLabel.textColor = [UIColor whiteColor];
        
        self.memoryUsageLabel.text = [NSString stringWithFormat:@"Memory:%.fM", mu];
        
    }else if (mu < 1024) {
        
        self.memoryUsageLabel.textColor = [UIColor yellowColor];
        self.memoryUsageLabel.text = [NSString stringWithFormat:@"Memory:%.fM", mu];
        
    }else {
        
        self.memoryUsageLabel.textColor = [UIColor redColor];
        
        self.memoryUsageLabel.text = [NSString stringWithFormat:@"Memory:%.2fG", mu / 1024];
        
    }
    
    
}

//- (void)setDeviceMemoryAvailable:(float)deviceMemoryAvailable
//{
//    
//    _deviceMemoryAvailable = deviceMemoryAvailable;
//    
//    float mu = deviceMemoryAvailable / 1024.0 / 1024.0;
//    
//    if (mu < 200) {
//        
//        self.deviceMemoryAvailableLabel.textColor = [UIColor redColor];
//        self.deviceMemoryAvailableLabel.text = [NSString stringWithFormat:@"设备可用内存:%.fM", mu];
//        
//    }else if (mu < 1024) {
//        
//        self.deviceMemoryAvailableLabel.textColor = [UIColor yellowColor];
//        self.deviceMemoryAvailableLabel.text = [NSString stringWithFormat:@"设备可用内存:%.fM", mu];
//        
//    }else {
//        
//        self.deviceMemoryAvailableLabel.textColor = [UIColor whiteColor];
//        
//        self.deviceMemoryAvailableLabel.text = [NSString stringWithFormat:@"设备可用内存:%.2fG", mu / 1024];
//        
//    }
//}
//
//- (void)setDeviceMemoryUsage:(float)deviceMemoryUsage
//{
//    
//    _deviceMemoryUsage = deviceMemoryUsage;
//    
//    float mu = deviceMemoryUsage / 1024.0 / 1024.0;
//    
//    if (mu < 1024) {
//        
//        self.deviceMemoryUsageLabel.text = [NSString stringWithFormat:@"设备使用内存:%.fM", mu];
//        
//    }else {
//        
//        self.deviceMemoryUsageLabel.text = [NSString stringWithFormat:@"设备使用内存:%.2fG", mu / 1024];
//        
//    }
//}

- (void)setFps:(int)fps
{
    _fps = fps;
    
    if (fps < 30) {
        
        self.fpsLabel.textColor = [UIColor redColor];
        
    }else if (fps < 50) {
        
        self.fpsLabel.textColor = [UIColor yellowColor];
    }else {
        
        self.fpsLabel.textColor = [UIColor whiteColor];
    }
    self.fpsLabel.text = [NSString stringWithFormat:@"FPS:%d", fps];
    
}

@end

//
//  BulletScreenView.h
//  BulletScreen
//
//  Created by horry on 15/8/15.
//  Copyright (c) 2015年 ___horryBear___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BulletScreenView : UIView

@property (nonatomic) NSInteger topLimit;
@property (nonatomic) NSInteger bottomLimit;
@property (nonatomic) CGFloat minSpeed;
@property (nonatomic) CGFloat maxSpeed;
@property (nonatomic) BOOL hidden;
@property (strong, nonatomic) NSArray *textArray;

- (void)addBullet:(NSString *)content;
- (void)addBullet:(NSString *)content color:(UIColor *)color;
//开始播放
- (void)play;
//暂停播放
- (void)pause;
//停止播放
- (void)stop;

@end

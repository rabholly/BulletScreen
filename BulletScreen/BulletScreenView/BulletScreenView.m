//
//  BulletScreenView.m
//  BulletScreen
//
//  Created by horry on 15/8/15.
//  Copyright (c) 2015年 ___horryBear___. All rights reserved.
//

#import "BulletScreenView.h"

#import "BulletLabel.h"
#import "BulletString.h"

@interface BulletScreenView() {
	NSTimer *bulletTimer;
	NSTimer *trackTimer;
	NSMutableArray *busyLabelArray;		//储存屏幕上显示的弹幕
	NSMutableArray *idleLabelArray;		//储存屏幕外的弹幕
	long long secondCount;
}

@end

@implementation BulletScreenView

//默认设置
CGFloat const BulletScreenDefaultMinSpeed = 1;
CGFloat const BulletScreenDefaultMaxSpeed = 2;
CGFloat const BulletScreenDefaultTopLimit = 20;
long long const BulletScreenClearTime = 300;


- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		self.backgroundColor = [UIColor blackColor];
		bulletTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(bulletTimerTimeout:) userInfo:nil repeats:YES];
		trackTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(trackTimerTimeout:) userInfo:nil repeats:YES];
		[self pauseTimer:trackTimer];
		busyLabelArray = [NSMutableArray new];
		idleLabelArray = [NSMutableArray new];
		_textArray = [NSArray new];
		_topLimit = BulletScreenDefaultTopLimit;
		_bottomLimit = self.frame.size.height / 2;
		_minSpeed = BulletScreenDefaultMinSpeed;
		_maxSpeed = BulletScreenDefaultMaxSpeed;
		secondCount = 0;
	}
	return self;
}

- (void)dealloc {
	[bulletTimer invalidate];
}

- (void)clearArray {
	for (NSUInteger i = 0; i < idleLabelArray.count; i++) {
		BulletLabel *label = [idleLabelArray objectAtIndex:i];
		[label removeFromSuperview];
		label = nil;
	}
	[idleLabelArray removeAllObjects];
	
	for (NSUInteger i = 0; i < busyLabelArray.count; i++) {
		BulletLabel *label = [busyLabelArray objectAtIndex:i];
		[label removeFromSuperview];
		label = nil;
	}
	[busyLabelArray removeAllObjects];
}

#pragma mark - 属性

- (void)setHidden:(BOOL)hidden {
	_hidden = hidden;
	if (hidden) {
		[self pauseTimer:bulletTimer];
		[self clearArray];
		
	} else {
		[self resumeTimer:bulletTimer];
	}
}

//生成弹幕初始垂直方向位置
- (CGFloat)getRandomNumber {
	return _topLimit + arc4random() % (_bottomLimit - _topLimit + 1);
}

//生成弹幕速度
- (CGFloat)getRandomSpeed {
	CGFloat speed = _minSpeed + arc4random() % 100 / 100.0 * (_maxSpeed - _minSpeed);
	NSLog(@"speed is %f", speed);
	return speed;
}

#pragma mark - 定时器

//添加轨迹中的弹幕
- (void)trackTimerTimeout:(NSTimer *)timer {
	secondCount++;
	if (secondCount % BulletScreenClearTime == 0) {		//每隔5分钟清除空闲label
		for (NSUInteger i = 0; i < idleLabelArray.count; i++) {
			BulletLabel *label = [idleLabelArray objectAtIndex:i];
			[label removeFromSuperview];
			label = nil;
		}
		[idleLabelArray removeAllObjects];
	}
	
	if (_hidden) {
		return ;
	}
	
	for (NSUInteger i = 0; i < _textArray.count; i++) {
		BulletString *bulletString = [_textArray objectAtIndex:i];
		if (bulletString.timeOffset == secondCount) {
			[self addBullet:bulletString.string];
		}
	}
}

//滚动弹幕
- (void)bulletTimerTimeout:(NSTimer *)timer {
	for (NSUInteger i = busyLabelArray.count ; i > 0; i--) {
		BulletLabel *label = [busyLabelArray objectAtIndex:i - 1];
		CGRect frame = label.frame;
		frame.origin.x -= label.speed;
		label.frame = frame;
		
		//滚动到屏幕外面的弹幕放入空闲队列
		if (frame.origin.x + frame.size.width < 0) {
			[busyLabelArray removeObject:label];
			[idleLabelArray addObject:label];
		}
	}
}

- (void)pauseTimer:(NSTimer *)timer {
	if (![timer isValid]) {
		return ;
	}
	[timer setFireDate:[NSDate distantFuture]];
}


- (void)resumeTimer:(NSTimer *)timer {
	if (![timer isValid]) {
		return ;
	}
	[timer setFireDate:[NSDate date]];
}

#pragma mark - 对外接口

- (void)play {
	[self resumeTimer:bulletTimer];
	[self resumeTimer:trackTimer];
}

- (void)pause {
	[self pauseTimer:bulletTimer];
	[self pauseTimer:trackTimer];
}

- (void)stop {
	secondCount = 0;
	[self pauseTimer:trackTimer];
	[self pauseTimer:bulletTimer];
	[self clearArray];
}

- (void)addBullet:(NSString *)content {
	[self addBullet:content color:[UIColor whiteColor]];
}

- (void)addBullet:(NSString *)content color:(UIColor *)color {
	NSLog(@"bullet count is %lu", idleLabelArray.count + busyLabelArray.count);
	BulletLabel *label;
	if (idleLabelArray.count == 0) {
		label = [[BulletLabel alloc] init];
		[self addSubview:label];
	} else {
		label = [idleLabelArray objectAtIndex:0];
		[idleLabelArray removeObject:label];
	}
	
	NSDictionary *tdic = [NSDictionary dictionaryWithObjectsAndKeys:label.font,NSFontAttributeName,nil];
	CGSize size = [content boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 20.0f) options:NSStringDrawingUsesLineFragmentOrigin attributes:tdic context:nil].size;
	label.frame = CGRectMake(self.frame.size.width, [self getRandomNumber], size.width, 20);
	label.textColor = color;
	label.text = content;
	label.speed = [self getRandomSpeed];
	[busyLabelArray addObject:label];
}
@end
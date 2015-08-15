//
//  BulletString.h
//  BulletScreen
//
//  Created by horry on 15/8/7.
//  Copyright (c) 2015年 ___horryBear___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BulletString : NSObject

@property (strong, nonatomic) NSString* string;
@property (nonatomic) NSInteger timeOffset;
@property (strong, nonatomic) UIColor* color;

@end

//
//  UIBezierPath+Smoothing.h
//  Mylines
//
//  Created by zpc on 2017/10/24.
//  Copyright © 2017年 赵鹏程的macpro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBezierPath (Smoothing)

/*
 pointsArray 点集合 nsvalue
 granularity 平滑程度 越大表示插入点越多
 indexs  忽略某几个点不插入中间点
 zeroY   y坐标的起始点，x坐标轴上的点中间不插入，避免数据突然变的很大造成曲线异常
 */
+ (UIBezierPath*)smoothedPathWithPoints:(NSArray *) pointsArray andGranularity:(NSInteger)granularity ignoreIndex:(NSArray*)indexs zeroY:(CGFloat)zeroY;
+ (UIBezierPath*)smoothedPathWithPoints:(NSArray *) pointsArray andGranularity:(NSInteger)granularity zeroY:(CGFloat)zeroY close:(BOOL)close;
@end

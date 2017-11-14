//
//  UIBezierPath+Smoothing.m
//  Mylines
//
//  Created by zpc on 2017/10/24.
//  Copyright © 2017年 赵鹏程的macpro. All rights reserved.
//

#import "UIBezierPath+Smoothing.h"
#define POINT(_INDEX_) [(NSValue *)[points objectAtIndex:_INDEX_] CGPointValue]
@implementation UIBezierPath (Smoothing)
+ (UIBezierPath*)smoothedPathWithPoints:(NSArray *) pointsArray andGranularity:(NSInteger)granularity ignoreIndex:(NSArray*)indexs zeroY:(CGFloat)zeroY{
    
    NSMutableArray *points = [pointsArray mutableCopy];
    
    UIBezierPath *smoothedPath = [UIBezierPath bezierPath];
    
    // Add control points to make the math make sense
    [points insertObject:[points objectAtIndex:0] atIndex:0];
    [points addObject:[points lastObject]];
    [smoothedPath moveToPoint:POINT(0)];
    
    for (NSUInteger index = 1; index < points.count - 2; index++) {
        CGPoint p0 = POINT(index - 1);
        CGPoint p1 = POINT(index);
        CGPoint p2 = POINT(index + 1);
        CGPoint p3 = POINT(index + 2);
        
        
        if ([indexs containsObject:@(index-1)]) {
            [smoothedPath addLineToPoint:p2];
            NSLog(@"%lu****",(unsigned long)index);

            continue;
        }
        //跳过点
        if (p1.x==p2.x||p1.y==p2.y||p1.y==zeroY) {
            [smoothedPath addLineToPoint:p2];
            continue;
        }
        
        // now add n points starting at p1 + dx/dy up until p2 using Catmull-Rom splines
        for (int i = 1; i < granularity; i++) {
            
            float t = (float) i * (1.0f / (float) granularity);
            float tt = t * t;
            float ttt = tt * t;
            
            CGPoint pi; // intermediate point
            pi.x = 0.5 * (2*p1.x+(p2.x-p0.x)*t + (2*p0.x-5*p1.x+4*p2.x-p3.x)*tt + (3*p1.x-p0.x-3*p2.x+p3.x)*ttt);
            pi.y = 0.5 * (2*p1.y+(p2.y-p0.y)*t + (2*p0.y-5*p1.y+4*p2.y-p3.y)*tt + (3*p1.y-p0.y-3*p2.y+p3.y)*ttt);
            
            if (pi.y>zeroY) {
                pi.y=zeroY;
            }
            [smoothedPath addLineToPoint:pi];
        }
        
        // Now add p2
        [smoothedPath addLineToPoint:p2];
    }
    
    // finish by adding the last point
    [smoothedPath addLineToPoint:POINT(points.count - 1)];
//    [smoothedPath addLineToPoint:POINT(0)];
    return smoothedPath;
    
//    CGContextAddPath(context, smoothedPath.CGPath);
//    CGContextDrawPath(context, kCGPathStroke);
    
}
+ (UIBezierPath*)smoothedPathWithPoints:(NSArray *) pointsArray andGranularity:(NSInteger)granularity zeroY:(CGFloat)zeroY close:(BOOL)close{
    
    NSMutableArray *points = [pointsArray mutableCopy];
    
    UIBezierPath *smoothedPath = [UIBezierPath bezierPath];
    
    // Add control points to make the math make sense
    [points insertObject:[points objectAtIndex:0] atIndex:0];
    [points addObject:[points lastObject]];
    [smoothedPath moveToPoint:POINT(0)];
    
    for (NSUInteger index = 1; index < points.count - 2; index++) {
        CGPoint p0 = POINT(index - 1);
        CGPoint p1 = POINT(index);
        CGPoint p2 = POINT(index + 1);
        CGPoint p3 = POINT(index + 2);
        
        //跳过点
        if (p1.x==p2.x||p1.y==p2.y||p1.y==zeroY) {
            [smoothedPath addLineToPoint:p2];
            continue;
        }
        
        // now add n points starting at p1 + dx/dy up until p2 using Catmull-Rom splines
        for (int i = 1; i < granularity; i++) {
            
            float t = (float) i * (1.0f / (float) granularity);
            float tt = t * t;
            float ttt = tt * t;
            
            CGPoint pi; // intermediate point
            pi.x = 0.5 * (2*p1.x+(p2.x-p0.x)*t + (2*p0.x-5*p1.x+4*p2.x-p3.x)*tt + (3*p1.x-p0.x-3*p2.x+p3.x)*ttt);
            pi.y = 0.5 * (2*p1.y+(p2.y-p0.y)*t + (2*p0.y-5*p1.y+4*p2.y-p3.y)*tt + (3*p1.y-p0.y-3*p2.y+p3.y)*ttt);
            
            if (pi.y>zeroY) {
                pi.y=zeroY;
            }
            [smoothedPath addLineToPoint:pi];
        }
        
        // Now add p2
        [smoothedPath addLineToPoint:p2];
    }
    
    // finish by adding the last point
    [smoothedPath addLineToPoint:POINT(points.count - 1)];
    if (close) {
        [smoothedPath addLineToPoint:POINT(0)];
    }
    
    return smoothedPath;
    
    
}

@end

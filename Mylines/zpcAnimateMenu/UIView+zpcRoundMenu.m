//
//  UIView+zpcRoundMenu.m
//  Mylines
//
//  Created by zpc on 2017/11/8.
//  Copyright © 2017年 赵鹏程的macpro. All rights reserved.
//

#import "UIView+zpcRoundMenu.h"
#import <objc/runtime.h>
static char * currentAngleKey ="currentAngleKey";
static char * currentOrderKey ="currentOrderKey";
@implementation UIView (zpcRoundMenu)

- (void)setCurrentAngle:(float)currentAngle{
    objc_setAssociatedObject(self, currentAngleKey, @(currentAngle), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (float)currentAngle{
    return [objc_getAssociatedObject(self, currentAngleKey) floatValue];
}


- (void)setCurrentOrder:(NSInteger)currentOrder{
    objc_setAssociatedObject(self, currentOrderKey, @(currentOrder), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSInteger)currentOrder{
    return [objc_getAssociatedObject(self,currentOrderKey) integerValue];
    
}
@end

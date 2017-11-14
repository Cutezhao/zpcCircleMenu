//
//  UIView+ZpcCircleMenu.m
//  Mylines
//
//  Created by zpc on 2017/11/7.
//  Copyright © 2017年 赵鹏程的macpro. All rights reserved.
//

#import "UIView+ZpcCircleMenu.h"
#import <objc/runtime.h>
static char *itemIndexPathKey = "itemIndexPathKey";

static char *dataIndexPathKey ="dataIndexPathKey";

@implementation UIView (ZpcCircleMenu)
- (void)setItemIndexPath:(NSIndexPath *)itemIndexPath{
    objc_setAssociatedObject(self, itemIndexPathKey, itemIndexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSIndexPath*)itemIndexPath{
    return objc_getAssociatedObject(self, itemIndexPathKey);
    
}

- (void)setDataIndexPath:(NSIndexPath *)dataIndexPath{
    objc_setAssociatedObject(self, dataIndexPathKey, dataIndexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSIndexPath*)dataIndexPath{
    return objc_getAssociatedObject(self, dataIndexPathKey);
}
@end

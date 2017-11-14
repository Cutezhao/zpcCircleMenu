//
//  ZpcPie.m
//  Mylines
//
//  Created by zpc on 2017/11/3.
//  Copyright © 2017年 赵鹏程的macpro. All rights reserved.
//

#import "ZpcPie.h"

@interface ZpcPieLayer : CAShapeLayer
@property (nonatomic,assign)CGFloat startAngle; //开始角度
@property (nonatomic,assign)CGFloat endAngle;   //结束角度
@property (nonatomic,assign)BOOL    isSelected; //是否已经选中
@end
@implementation ZpcPieLayer

@end

@interface ZpcPie(){
    CGPoint center;
    float radius;
    NSInteger selectIndex;
    NSArray *newDatas;//处理之后的数据
}


@property (nonatomic,strong)NSMutableArray*pieLayersArray;

@end
@implementation ZpcPie
- (instancetype)initWithFrame:(CGRect)frame{
    self =[super initWithFrame:frame];
    if (self) {
        center=CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        radius= MIN(frame.size.height, frame.size.width)/2;
        self.startAngle=-M_PI*(1/3.0);
    }
    return self;
}
#pragma mark 设置原始数据
- (void)setValues:(NSArray<NSNumber *> *)values{
    _values=values;
    [self reloadData];
}
#pragma mark 将原始数据变成比例值
- (NSArray*)dealDatas{
    NSMutableArray*array=[NSMutableArray arrayWithCapacity:0];
    NSNumber *sum = [self.values valueForKeyPath:@"@sum.floatValue"];
    
    for (NSNumber*value in self.values) {
        [array addObject:@(value.floatValue/sum.floatValue)];
    }
   return  array;
}
#pragma mark 更新数据
- (void)reloadData{
    newDatas = [self dealDatas];
    CGFloat start = self.startAngle;
    CGFloat end = start;
    //之所以加上这个循环，也是考虑到如果多次调用，也不会重复创建layer
    while (newDatas.count > self.pieLayersArray.count) {
        ZpcPieLayer *pieLayer = [ZpcPieLayer layer];
        pieLayer.strokeColor = NULL;
        [self.layer addSublayer:pieLayer];
        [self.pieLayersArray addObject:pieLayer];
        
    }
    for (int i = 0; i < self.pieLayersArray.count; i ++) {
        
        ZpcPieLayer *pieLayer = (ZpcPieLayer *)self.pieLayersArray[i];
        if (i < newDatas.count) {
            pieLayer.hidden = NO;
            end =  start + M_PI*2*[newDatas[i] floatValue];
            
            UIBezierPath *piePath = [UIBezierPath bezierPath];
            [piePath moveToPoint:center];
            [piePath addArcWithCenter:center radius:radius startAngle:start endAngle:end clockwise:YES];
            pieLayer.lineWidth=0.5;
            
            pieLayer.strokeColor=self.separatorColor.CGColor;
            pieLayer.fillColor = [UIColor clearColor].CGColor;
//            pieLayer.fillColor =[self randomColor].CGColor;
            pieLayer.startAngle = start;
            pieLayer.endAngle = end;
            pieLayer.path = piePath.CGPath;
            
            start = end;
        }else{
            pieLayer.hidden = YES;
        }
    }
}
- (UIColor*)separatorColor{
    if (!_separatorColor) {
        _separatorColor=[UIColor redColor];
    }
    return _separatorColor;
}
#pragma mark 点击
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    CGPoint point = [touches.anyObject locationInView:self];
   NSInteger index= [self getSelectIndexWithPoint:point];
//    NSLog(@"点击了%ld",(long)index);
    
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(ZpcPie:didSelectItem:point:)]&&index>=0) {
        [self.delegate ZpcPie:self didSelectItem:index point:point];
    }
    
}

- (NSInteger)getSelectIndexWithPoint:(CGPoint)point{
    //遍历查找点击的是哪一个layer
    for (int i=0; i<self.pieLayersArray.count; i++) {
        ZpcPieLayer*layer=(ZpcPieLayer*)self.pieLayersArray[i];
        if (CGPathContainsPoint(layer.path, &CGAffineTransformIdentity, point, 0)) {
            return i;
        }
    }
    return -1;
    
}


#pragma mark pieLayersArray 储存 pielayer
- (NSMutableArray*)pieLayersArray{
    if (!_pieLayersArray) {
        _pieLayersArray=[NSMutableArray arrayWithCapacity:0];
    }
    return _pieLayersArray;
}
#pragma mark 随机颜色
- (UIColor*)randomColor{
    int R = (arc4random() % 256) ;
    int G = (arc4random() % 256) ;
    int B = (arc4random() % 256) ;
   return  [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1];
}

@end

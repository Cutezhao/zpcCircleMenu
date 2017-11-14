//
//  ZpcRoundMenu.m
//  Mylines
//
//  Created by zpc on 2017/11/8.
//  Copyright © 2017年 赵鹏程的macpro. All rights reserved.
//

#import "ZpcRoundMenu.h"
#import "UIView+zpcRoundMenu.h"
@interface ZpcRoundMenu (){
    
    CGPoint center;
    float radius;
    float height;
    float width;
    NSMutableArray*viewsArray;
    NSInteger itemNum;
    NSMutableArray*centerPointArray;
    float itemNumFloat;
    
}
@end
@implementation ZpcRoundMenu

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame{
    self =[super initWithFrame:frame];
    if (self) {
        self.orginalStartAngle=M_PI*0.5;
        viewsArray=[NSMutableArray arrayWithCapacity:0];
        centerPointArray=[NSMutableArray arrayWithCapacity:0];
       
        [self reloadValue];
        
        [self addObserver:self forKeyPath:@"center" options:NSKeyValueObservingOptionNew context:nil];
        [self addObserver:self forKeyPath:@"bounds" options:NSKeyValueObservingOptionNew context:nil];
        
    }
    return self;
}
- (void)reloadValue{
    center=CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    height=self.frame.size.height;
    width=self.frame.size.width;
    radius=MIN(width, height)/2.0;
}

#pragma mark 更新视图
- (void)reload{
    
    [viewsArray removeAllObjects];
    [centerPointArray removeAllObjects];
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [self reloadViews];
    [self setViewsFrame];
}
- (void)reloadViews{
    
   
    
    itemNum = 0;
    if ([self.dataSource respondsToSelector:@selector(numberOfItemsInMenu:)]&&self.dataSource) {
        itemNum = [self.dataSource numberOfItemsInMenu:self];
        
    }
    if (itemNum==0) {
        return;
    }
    for (int i=0; i<itemNum; i++) {
        UIView*itemView;
        CGSize itemSize;
        if ([self.dataSource respondsToSelector:@selector(roundMenu:viewForItemAtIndex:)]&&self.dataSource) {
          itemView=  [self.dataSource roundMenu:self viewForItemAtIndex:i];
            
        }
        if (!itemView) {
            itemView=[[UIView alloc]init];
            
        }
        if ([self.dataSource respondsToSelector:@selector(roundMenu:sizeForItemViewAtIndexPath:)]&&self.dataSource) {
            itemSize=  [self.dataSource roundMenu:self sizeForItemViewAtIndexPath:i];
            
        }
        if (itemSize.width<=0&&itemSize.height<=0) {
            itemSize=CGSizeMake(44, 44);
        }
        itemView.bounds=CGRectMake(0, 0, itemSize.width, itemSize.height);
        [self addSubview:itemView];
        [viewsArray addObject:itemView];
        
        itemView.userInteractionEnabled=YES;
        UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(itemTap:)];
        [itemView addGestureRecognizer:tap];
        
        itemView.currentOrder=i;
        
        
    }
    
}
- (void)setViewsFrame{
    //画圆环
    CAShapeLayer*layer=[[CAShapeLayer alloc]init];
    layer.fillColor=[UIColor clearColor].CGColor;
    layer.strokeColor=[UIColor redColor].CGColor;
    layer.lineWidth=0.5;
    UIBezierPath*path=[UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:0 endAngle:2*M_PI clockwise:YES];
    layer.path=path.CGPath;
//    [self.layer addSublayer:layer];
    //初始角度
    float startAngle=self.orginalStartAngle;
    
   itemNumFloat= [[NSNumber numberWithInteger:itemNum] floatValue];
    float averageAngle=M_PI*2/itemNumFloat;
    for (int i=0; i<viewsArray.count; i++) {
        UIView*view=viewsArray[i];
        
        float y=sinf(averageAngle*i+startAngle)*radius;
        float x=cosf(averageAngle*i+startAngle)*radius;
        CGPoint point=CGPointMake(center.x+x, center.y+y);
        view.center=point;
        
        [centerPointArray addObject:[NSValue valueWithCGPoint:point]];
        
        float endAngle=startAngle+i*averageAngle;
        view.currentAngle=endAngle;
    }
    
}
#pragma mark tap事件
- (void)itemTap:(UITapGestureRecognizer*)tap{
    UIView*view=tap.view;
    [self menuRotate:view];
    
    
}
#pragma mark 旋转
- (void)menuRotate:(UIView*)selectView{
    if (selectView.currentOrder==0) {
        return;
    }
    NSInteger moveStep = itemNum - selectView.currentOrder;//需要移动几个位置
    float moveAngle =M_PI*2/itemNumFloat*moveStep;//需要增加的角度
    
    for (int i=0; i<itemNum; i++) {
        UIView*view=viewsArray[i];
        float endAngel=view.currentAngle+moveAngle;
        CGMutablePathRef arcPath = CGPathCreateMutable();
        CGPathAddArc(arcPath, nil, center.x, center.y, radius, view.currentAngle, endAngel, NO);
        CAKeyframeAnimation* animation;
        animation = [CAKeyframeAnimation animation];
        animation.path = arcPath;
        CGPathRelease(arcPath);
        animation.duration = 1;
        animation.repeatCount = 1;
        animation.calculationMode = @"paced";
        animation.removedOnCompletion=NO;
        animation.autoreverses=NO;
        [view.layer addAnimation:animation forKey:@"position"];
        
        //旋转之后所在的位置
        NSInteger nextOrder=(view.currentOrder+moveStep)%itemNum;
        view.center=[centerPointArray[nextOrder] CGPointValue];
        view.currentOrder=nextOrder;
        view.currentAngle=endAngel;
        
        
    }
    
    
}

- (void)setSelectItem:(NSInteger)index{
    if (index>viewsArray.count-1) {
        return;
    }
    
    UIView*view=viewsArray[index];
    [self menuRotate:view];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"center"]||[keyPath isEqualToString:@"bounds"]) {
        [self reloadValue];
    }
    
}

- (void)dealloc{
    [self removeObserver:self forKeyPath:@"center"];
    [self removeObserver:self forKeyPath:@"bounds"];
}
@end

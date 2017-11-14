//
//  ZpcLineChart.m
//  Mylines
//
//  Created by zpc on 2017/10/24.
//  Copyright © 2017年 赵鹏程的macpro. All rights reserved.
//

#import "ZpcLineChart.h"
#import "ZpcLinePoint.h"
#import "ZpcLine.h"
#import "UIBezierPath+Smoothing.h"
#import "ZpcLinePointView.h"
@interface ZpcLineChart()
{
    float left;
    float right;
    float top;
    float bottom;
    ZpcLine*line;
    
}
@property (nonatomic,assign)NSInteger horRows;//行数
@property (nonatomic,assign)NSInteger verRows;//列数
@property (nonatomic,assign)NSInteger maxInteger;//纵坐标最大值
@property (nonatomic,assign)NSInteger minInteger;//纵坐标最小值
@property (nonatomic,assign)float maxvalueScale;//最大值与纵坐标最大值得比例
@property (nonatomic,assign)CAGradientLayer*gradientLayer;
@property (nonatomic,strong)NSMutableArray*layerArray;
@property (nonatomic,strong)NSMutableArray*valueLabes;
@property (nonatomic,strong)NSMutableArray*xLabels;


@end
@implementation ZpcLineChart

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
        self.backgroundColor=[UIColor whiteColor];
        self.horRows=5;
        self.verRows=7;
        self.minInteger=0;
        self.maxvalueScale=0.8;
    
    }
    return self;
}
#pragma mark 数据相关的设置
- (void)reloadDataAninate:(BOOL)animate{
    [self.valueLabes makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.xLabels makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.layerArray makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    [self.layerArray removeAllObjects];
    
    
    NSInteger maxValueInteger = [[self.valueArray valueForKeyPath:@"@max.self"] integerValue];
    self.maxInteger=maxValueInteger/self.maxvalueScale;
    line=[[ZpcLine alloc]init];
    line.pointArray=[self dealValues:self.valueArray];
    [self.layer addSublayer:self.gradientLayer];
    //画横线
    for (int i=0; i<self.horRows-1; i++) {
        
      float y=(i+1)*((self.height-(top+bottom))/self.horRows)+top;
        
       CAShapeLayer*lineLayer=[self drawSeperationLineFrom:CGPointMake(left, y) end:CGPointMake(self.width-right, y) lindWidth:0.5 lincolor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.15]];
        [self.layerArray addObject:lineLayer];
    }
    //画竖线
    for (int i=0; i<self.verRows+1; i++) {
        
        float x=(i+1)*((self.width-(left+right))/(self.verRows+2))+left;
        
        CAShapeLayer*lineLayer= [self drawSeperationLineFrom:CGPointMake(x, top) end:CGPointMake(x, self.height-bottom) lindWidth:0.5 lincolor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.15]];
        [self.layerArray addObject:lineLayer];
    }
    if (line.pointArray.count>0) {
        //背景的shape
        CAShapeLayer*lineShap=[self getDataLinegradientLayer:line];
        
        self.gradientLayer.mask=lineShap;
        //画数据线
        CAShapeLayer*lineLayer= [self drawDataLine:line];
        [self.layerArray addObject:lineLayer];
        
        if (animate) {
            [self lineAnimateLayer:lineLayer];
        }
        [self addPointViewWithline:line];
        NSArray*valueLabes= [self addPointValueText:line];
        [self.valueLabes addObjectsFromArray:valueLabes];
        NSArray*xLabes=[self setXAxisLavels:self.horizontalS];
        [self.xLabels addObjectsFromArray:xLabes];
    }
}
//设置数据集合
- (void)setValueArray:(NSArray *)valueArray{
    _valueArray=valueArray;
    _verRows=valueArray.count;
}

//设置边界
- (void)setContentEdgeInsets:(UIEdgeInsets)contentEdgeInsets{
    _contentEdgeInsets=contentEdgeInsets;
    left=contentEdgeInsets.left;
    right=contentEdgeInsets.right;
    top=contentEdgeInsets.top;
    bottom=contentEdgeInsets.bottom;
}

//计算点的坐标
- (NSArray*)dealValues:(NSArray*)array{
    NSMutableArray*returnArr=[NSMutableArray arrayWithCapacity:0];
    for (int i=0; i<array.count; i++) {
        float value=[array[i] floatValue];
        float x=(i+1)*((self.width-(left+right))/(self.verRows+2))+left;
        float y=(self.height-bottom)-(value/self.maxInteger)*(self.height-top-bottom);
        ZpcLinePoint*point=[[ZpcLinePoint alloc]init];
        point.value=value;
        point.x=x;
        point.y=y;
        point.pointValue=[NSValue valueWithCGPoint:CGPointMake(x, y)];
        [returnArr addObject:point];
    }
    return returnArr;
}
#pragma mark 渐变色背景
- (CAGradientLayer*)gradientLayer{
    if (!_gradientLayer) {
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.frame = CGRectMake(0, 0, self.width, self.height);
        //  创建渐变色数组，需要转换为CGColor颜色
        _gradientLayer.colors = @[(__bridge id)[UIColor orangeColor].CGColor,(__bridge id)[UIColor yellowColor].CGColor];
        //  设置渐变颜色方向，左上点为(0,0), 右下点为(1,1)
        _gradientLayer.startPoint = CGPointMake(0, 0);
        _gradientLayer.endPoint = CGPointMake(0, 1);
        //  设置颜色变化点，取值范围 0.0~1.0
        _gradientLayer.locations = @[@0,@1];
    }
    return _gradientLayer;
}
- (NSMutableArray*)layerArray{
    if (!_layerArray) {
        _layerArray=[NSMutableArray arrayWithCapacity:0];
    }
    return _layerArray;
}
- (NSMutableArray*)valueLabes{
    if (!_valueLabes) {
        _valueLabes=[NSMutableArray arrayWithCapacity:0];
    }
    return _valueLabes;
}
- (NSMutableArray*)xLabels{
    if (!_xLabels) {
        _xLabels=[NSMutableArray arrayWithCapacity:0];
    }
    return _xLabels;
}
#pragma mark 显示x轴点
- (NSArray*)setXAxisLavels:(NSArray*)xStrings{
    if (!xStrings) {
        xStrings=[NSArray array];
    }
    NSMutableArray*array=[NSMutableArray arrayWithCapacity:0];
    if (xStrings.count<self.verRows) {
        NSMutableArray*strings=[xStrings mutableCopy];
        for (int i=0; i<self.verRows-xStrings.count; i++) {
           [strings addObject:@"未添加"];
        }
        xStrings=strings;
        
    }
    for (int i=0; i<self.verRows; i++) {
        NSString*string=xStrings[i];
    
        UILabel*label=[[UILabel alloc]init];
        label.textColor=[UIColor blueColor];
        label.textAlignment=NSTextAlignmentCenter;
        label.text=string;
        UIFont *font = [UIFont fontWithName:@"Mishafi" size:12];
        float x=(i+1)*((self.width-(left+right))/(self.verRows+2))+left;
        
        CGSize size=[string sizeWithAttributes:@{NSFontAttributeName:font}];
        size.width=size.width+5;
        if (size.width>(self.width-(left+right))/(self.verRows+2)) {
            size.width=(self.width-(left+right))/(self.verRows+2);
        }
        label.frame=CGRectMake(x-size.width/2, self.height-bottom, size.width, bottom);
        [self addSubview:label];
        [array addObject:label];
        
    }
    return array;
    
}
#pragma mark 为线添加点
- (void)addPointViewWithline:(ZpcLine*)line{
    for (ZpcLinePoint*point in line.pointArray) {
       
        ZpcLinePointView*view=[[ZpcLinePointView alloc]init];
        view.center=point.pointValue.CGPointValue;
        view.bounds=CGRectMake(0, 0, 10, 10);
        
        
        [self addSubview:view];
        
    }

}
//添加数值
- (NSArray*)addPointValueText:(ZpcLine*)line{
    NSMutableArray*array=[NSMutableArray arrayWithCapacity:0];
    for (ZpcLinePoint*point in line.pointArray) {
        NSString *string = [NSString stringWithFormat:@"%0.2f",point.value];
        
        UIFont *font = [UIFont fontWithName:@"Mishafi" size:12];
        CGPoint newPoint=CGPointMake(point.x, point.y-20);
        UILabel*label=[[UILabel alloc]init];
        label.text=string;
        label.font=font;
        label.textColor=[UIColor blackColor];
        [self addSubview:label];
        label.center=newPoint;
        CGSize size=[string sizeWithAttributes:@{NSFontAttributeName:font}];
        label.bounds=CGRectMake(0, 0, size.width, size.height);
        [array addObject:label];
    }
    
    return array;
}
#pragma mark 一条线
- (CAShapeLayer*)drawDataLine:(ZpcLine*)line{
    NSArray*pointArray=[self getDrawLinePoints:line];
   UIBezierPath*path=[UIBezierPath smoothedPathWithPoints:pointArray andGranularity:10 zeroY:self.height-bottom close:NO];
    path.lineWidth=1;
    
    CAShapeLayer*lineChartLayer = [CAShapeLayer layer];
    lineChartLayer.path = path.CGPath;
    lineChartLayer.strokeColor = [UIColor redColor].CGColor;
    lineChartLayer.fillColor = [[UIColor clearColor] CGColor];
    // 默认设置路径宽度为0，使其在起始状态下不显示
    lineChartLayer.lineWidth = 2;
    lineChartLayer.lineCap = kCALineCapRound;
    lineChartLayer.lineJoin = kCALineJoinRound;
    
    [self.layer addSublayer:lineChartLayer];//直接添加导视图上
    return lineChartLayer;
}
#pragma mark 线对应的shapelayer
- (CAShapeLayer*)getDataLinegradientLayer:(ZpcLine*)line{
    
    NSArray*pointArray=[self getDrawLinePoints:line];
    UIBezierPath*path=[UIBezierPath smoothedPathWithPoints:pointArray andGranularity:10 zeroY:self.height-bottom close:YES];
    path.lineWidth=0;
    CAShapeLayer*lineChartLayer = [CAShapeLayer layer];
    lineChartLayer.path = path.CGPath;
    
    // 默认设置路径宽度为0，使其在起始状态下不显示
    lineChartLayer.lineWidth = 1;
    lineChartLayer.lineCap = kCALineCapRound;
    lineChartLayer.lineJoin = kCALineJoinRound;
    return lineChartLayer;
}
#pragma mark 每条线需要的cgpoint集合
- (NSArray*)getDrawLinePoints:(ZpcLine*)line{
    NSMutableArray*pointArray=[NSMutableArray arrayWithCapacity:0];
    [pointArray addObject:[NSValue valueWithCGPoint:CGPointMake(left, self.height-bottom)]];
    //创建折现点标记
    for (NSInteger i = 0; i< line.pointArray.count; i++) {
        
        ZpcLinePoint*point=line.pointArray[i];
        [pointArray addObject:[NSValue valueWithCGPoint:CGPointMake(point.x, point.y)]];
    }
    [pointArray addObject:[NSValue valueWithCGPoint:CGPointMake(self.width-right, self.height-bottom)]];
    return pointArray;
    
}
- (void)drawRect:(CGRect)rect{
    //x轴
    
    [self drawSeperationLineFrom:CGPointMake(left, self.height-bottom) end:CGPointMake(self.width-right, self.height-bottom) lindWidth:0.5 lincolor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.15]];
    //y轴
//    [self drawSeperationLineFrom:CGPointMake(left, top) end:CGPointMake(left, self.height-bottom) lindWidth:2 lincolor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.15]];
    
}

#pragma mark  分割线
- (CAShapeLayer*)drawSeperationLineFrom:(CGPoint)startPoint end:(CGPoint)endPoint lindWidth:(CGFloat)lineWidth lincolor:(UIColor*)lineColor{
    CAShapeLayer * dashLayer = [CAShapeLayer layer];
    dashLayer.strokeColor = lineColor.CGColor;
    dashLayer.fillColor = [[UIColor clearColor] CGColor];
    
    dashLayer.lineWidth = lineWidth;
    UIBezierPath * path = [[UIBezierPath alloc]init];
    path.lineWidth = lineWidth;
    
    [path moveToPoint:startPoint];
    [path addLineToPoint:endPoint];
//    CGFloat dash[] = {10,10};
//    [path setLineDash:dash count:2 phase:10];
    [path stroke];
    dashLayer.path = path.CGPath;
    [self.layer addSublayer:dashLayer];
    return dashLayer;
    
}
#pragma mark  横纵坐标 画坐标轴x,y
- (void)drawaxisLineFrom:(CGPoint)startPoint end:(CGPoint)endPoint lindWidth:(CGFloat)lineWidth lincolor:(UIColor*)lineColor{
    //提示 使用ref的对象不用使用*
    //1.获取上下文.-UIView对应的上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //2.创建可变路径并设置路径
    //当我们开发动画的时候，通常制定对象运动的路线，然后由动画负责动画效果
    CGMutablePathRef path = CGPathCreateMutable();
    //2-1.设置起始点
    CGPathMoveToPoint(path, NULL, startPoint.x, startPoint.y);
    //2-2.设置目标点
    CGPathAddLineToPoint(path, NULL, endPoint.x, endPoint.y);
    //封闭路径
    //第一种方法
//    CGPathAddLineToPoint(path, NULL, 50, 50);
    //第二张方法
    CGPathCloseSubpath(path);
    //3.将路径添加到上下文
    CGContextAddPath(context, path);
    //4.设置上下文属性
    //4.1.设置线条颜色
    /*
     red 0～1.0  red / 255
     green 0～1.0  green / 255
     blue 0～1.0  blue / 255
     plpha   透明度  0 ～ 1.0
     0 完全透明
     1.0 完全不透明
     提示：在使用rgb设置颜色时。最好不要同时指定rgb和alpha,否则会对性能造成影响。
     
     线条和填充默认都是黑色
     */
    NSDictionary*rgbDic=[self getRGBDictionaryByColor:lineColor];
    float a= [rgbDic[@"A"] floatValue];
    float r= [rgbDic[@"R"] floatValue];
    float g= [rgbDic[@"G"] floatValue];
    float b= [rgbDic[@"B"] floatValue];
    
    
    CGContextSetRGBStrokeColor(context, r, g, b, a);
    //设置填充颜色
//    CGContextSetRGBFillColor(context, 0, 1.0, 0, 1.0);
    //4.2 设置线条宽度
    CGContextSetLineWidth(context,lineWidth);
    //设置线条顶点样式
    CGContextSetLineCap(context, kCGLineCapRound);
    //设置连接点的样式
    CGContextSetLineJoin(context, kCGLineJoinRound);
    //设置线条的虚线样式
    /*
     虚线的参数：
     phase：相位，虚线的起始位置＝通常使用 0 即可，从头开始画虚线
     lengths:长度的数组
     count ： lengths 数组的个数
     */
//    CGFloat lengths[2] = {20.0,10.0};
//    CGContextSetLineDash(context, 0, lengths, 3);
    //5.绘制路径
    /*
     kCGPathStroke:划线（空心）
     kCGPathFill: 填充（实心）
     kCGPathFillStroke：即划线又填充
     */
    CGContextDrawPath(context, kCGPathFillStroke);
    //6.释放路径
    CGPathRelease(path);
    
}
#pragma mark  动画
- (void)lineAnimateLayer:(CAShapeLayer*)lineChartLayer{
   
        lineChartLayer.lineWidth = 2;
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        pathAnimation.duration = 2;
        pathAnimation.repeatCount = 1;
        pathAnimation.removedOnCompletion = YES;
        pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
        pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
        // 设置动画代理，动画结束时添加一个标签，显示折线终点的信息
//        pathAnimation.delegate = self;
        [lineChartLayer addAnimation:pathAnimation forKey:@"strokeEnd"];
        //[self setNeedsDisplay];
    
}

#pragma mark 工具方法
- (NSDictionary *)getRGBDictionaryByColor:(UIColor *)originColor
{
    CGFloat r=0,g=0,b=0,a=0;
    if ([self respondsToSelector:@selector(getRed:green:blue:alpha:)]) {
        [originColor getRed:&r green:&g blue:&b alpha:&a];
    }
    else {
        const CGFloat *components = CGColorGetComponents(originColor.CGColor);
        r = components[0];
        g = components[1];
        b = components[2];
        a = components[3];
    }
    
    return @{@"R":@(r),
             @"G":@(g),
             @"B":@(b),
             @"A":@(a)};
}
- (void)strokeChart{
    [self reloadDataAninate:YES];
    
}
@end

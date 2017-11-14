//
//  ZpcCircleProgressView.m
//  Mylines
//
//  Created by zpc on 2017/10/25.
//  Copyright © 2017年 赵鹏程的macpro. All rights reserved.
//

#import "ZpcCircleProgressView.h"
@interface ZpcCircleProgressView()
{
    CGPoint center;
//    CAShapeLayer*progressLayer;
}

@property (nonatomic,strong)CAGradientLayer*gradientLayer;
@property (nonatomic,strong)CAShapeLayer*backLayer;
@property (nonatomic,strong)CAShapeLayer*progressLayer;


@end
@implementation ZpcCircleProgressView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        self.circlewidth=5;
        self.circleRadius= MIN(frame.size.height, frame.size.width)/2;
        center=CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        [self.layer addSublayer:self.backLayer];
        [self.layer addSublayer:self.gradientLayer];
        [self.layer addSublayer:self.progressLayer];
    }
    return self;
}
- (void)reloadProgress{
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    [CATransaction setAnimationDuration:1];

    _progressLayer.strokeEnd=self.progress;
    
    [CATransaction commit];
    
    
}
- (CAShapeLayer*)backLayer{
    if (!_backLayer) {
        _backLayer=[[CAShapeLayer alloc]init];
        _backLayer.fillColor=[UIColor clearColor].CGColor;
        _backLayer.strokeColor=[UIColor greenColor].CGColor;
        _backLayer.lineWidth=self.circlewidth;
    }
    return _backLayer;
}
- (CAShapeLayer*)progressLayer{
    if (!_progressLayer) {
        _progressLayer=[[CAShapeLayer alloc]init];
        _progressLayer.fillColor=[UIColor clearColor].CGColor;
        _progressLayer.strokeColor=[UIColor greenColor].CGColor;
        _progressLayer.lineWidth=self.circlewidth;
        _progressLayer.lineCap = kCALineCapRound;
        _progressLayer.lineJoin = kCALineJoinRound;
    }
    return _progressLayer;
}
- (void)setProgress:(float)progress{
    if (progress>1) {
        progress=1;
    }
    if (progress<0) {
        progress=0;
    }
    _progress=progress;
    [self reloadProgress];
}

- (UIBezierPath*)getCirclePathWithCenter:(CGPoint)center radius:(float)radius lineWidth:(float)lineWidth  scale:(float)scale{
    UIBezierPath*path=[UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:-0.5*M_PI endAngle:M_PI*2*scale-0.5*M_PI clockwise:YES];
    path.lineWidth=lineWidth;
    
    return path;
    
}

- (CAGradientLayer*)gradientLayer{
    if (!_gradientLayer) {
        _gradientLayer=[[CAGradientLayer alloc]init];
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
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
- (void)stroke{
    self.backLayer.strokeColor=[UIColor colorWithRed:0.89 green:0.89 blue:0.89 alpha:1].CGColor;
    
    self.backLayer.lineWidth=self.circlewidth;
    self.progressLayer.lineWidth=self.circlewidth;
    UIBezierPath*path1=[self getCirclePathWithCenter:center radius:self.circleRadius-self.circlewidth lineWidth:self.circlewidth scale:1];
    self.backLayer.path=path1.CGPath;
    UIBezierPath*path2=[self getCirclePathWithCenter:center radius:self.circleRadius-self.circlewidth lineWidth:self.circlewidth scale:1];
    self.progressLayer.path=path2.CGPath;
    self.gradientLayer.mask=self.progressLayer;
    if (self.color) {
       [self.gradientLayer setColors:@[(__bridge id)self.color.CGColor,(__bridge id)[UIColor whiteColor].CGColor]];
    }
    self.gradientLayer.locations=@[@1,@1];
    [self reloadProgress];

}
@end

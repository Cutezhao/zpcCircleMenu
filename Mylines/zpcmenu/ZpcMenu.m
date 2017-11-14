//
//  ZpcMenu.m
//  Mylines
//
//  Created by zpc on 2017/11/3.
//  Copyright © 2017年 赵鹏程的macpro. All rights reserved.
//

#import "ZpcMenu.h"
#import "ZpcPie.h"
@interface ZpcMenu ()<ZpcPieDelegate>{
    ZpcPie*pieView;
    CGPoint center;
    float startAngle;
    float radius;
    
    float currentAngle;
    NSArray*areaLayers;
    
    NSInteger currentArea;
    NSInteger currentSelectIndex;
    
    
}

@property (nonatomic,strong)CAGradientLayer*gradientLayer;
@property (nonatomic,strong)CAShapeLayer*circleLayer;
@end

@implementation ZpcMenu

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
        
        startAngle= -M_PI*(1/3.0);
        center=CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0);
        radius= MIN(self.frame.size.height, self.frame.size.width)/2-5;
        
        [self.layer addSublayer:self.circleLayer];
        self.gradientLayer.frame=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        [self.layer addSublayer:self.gradientLayer];
        self.gradientLayer.mask=self.circleLayer;
        
        areaLayers=[self setAreaLayers:startAngle num:3];
        
        pieView=[[ZpcPie alloc]initWithFrame:CGRectMake(5, 5, self.frame.size.width-10, self.frame.size.height-10)];
        pieView.separatorColor=self.separatorColor;
        pieView.startAngle=startAngle;
        pieView.delegate=self;
        [self addSubview:pieView];
        pieView.values=@[@(10),@(10),@(10),];
        [self addObserver:self forKeyPath:@"center" options:NSKeyValueObservingOptionNew context:nil];
        [self addObserver:self forKeyPath:@"bounds" options:NSKeyValueObservingOptionNew context:nil];
        
    }
    return self;
}

- (void)ZpcPie:(ZpcPie *)pie didSelectItem:(NSInteger)index point:(CGPoint)point{
    currentSelectIndex=index;
    if (self.delegate&&[self.delegate respondsToSelector:@selector(zpcMenu:didSelectItemAtIndex:)]) {
        [self.delegate zpcMenu:self didSelectItemAtIndex:index];
    }
    [self rotateAction:index point:point];
    
//    NSLog(@"%f+++%f",point.x,point.y);
    
    
}

#pragma mark 点击的时候旋转
- (void)rotateAction:(NSInteger)index point:(CGPoint)point{

    
    CGPoint newPoint= [pieView convertPoint:point toView:self];//坐标转换
    
    NSInteger selectArea=[self getSelectArea:newPoint];
    
    currentArea=selectArea;
    
    [self rotateWithArea:selectArea];
}
- (void)rotateWithArea:(NSInteger)selectArea{
    
    //旋转动画************************************************************************************************
    
    float rotateAngle=M_PI*2/3.0;
    if (selectArea==0) {
        return;
    }else if (selectArea==1){
        rotateAngle=2*rotateAngle;
    }else if(selectArea==2){
        rotateAngle=rotateAngle;
    }else{
        return;
    }
    
    
    //旋转要放在左后 不然会导致转换的坐标是旋转之后的位置
    pieView.transform = CGAffineTransformRotate (pieView.transform, rotateAngle);
    
    CABasicAnimation* rotationAnimation;
    //绕哪个轴，那么就改成什么：这里是绕z轴 ---> transform.rotation.z
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.fromValue=[NSNumber numberWithFloat: currentAngle];
    //旋转角度
    rotationAnimation.toValue = [NSNumber numberWithFloat: currentAngle+rotateAngle];
    //每次旋转的时间（单位秒）
    rotationAnimation.duration = 1;
    rotationAnimation.cumulative = YES;
    //重复旋转的次数，如果你想要无数次，那么设置成MAXFLOAT
    rotationAnimation.repeatCount = 0;
    [pieView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
    currentAngle=rotateAngle+currentAngle;
    //************************************************************************************************
}
- (void)setSelectIndex:(NSInteger)index{
    if (index==currentSelectIndex) {
        return;
    }
    if (index>2||index<0) {
        return;
    }
   
    NSArray*array=@[@[@0,@1,@2],
                    @[@2,@0,@1],
                    @[@1,@2,@0],];
    NSInteger area=[array[currentSelectIndex][index] integerValue];
    
    [self rotateWithArea:area];
    currentArea=area;
    currentSelectIndex=index;
    
}
#pragma mark 识别点击区域的layers
- (NSArray*)setAreaLayers:(float)startAngle num:(NSInteger)num{
    NSMutableArray*array=[NSMutableArray arrayWithCapacity:0];
    CGFloat start=startAngle;
    CGFloat end = start;
    for (int i = 0; i < num; i ++) {
        end =  start + M_PI*2/num;
        CAShapeLayer*layer=[[CAShapeLayer alloc]init];
        
        UIBezierPath *piePath = [UIBezierPath bezierPath];
        [piePath moveToPoint:center];
        [piePath addArcWithCenter:center radius:radius startAngle:start endAngle:end clockwise:YES];
        layer.lineWidth=5;
        layer.strokeColor=[UIColor redColor].CGColor;
        layer.fillColor = [UIColor redColor].CGColor;
        layer.path = piePath.CGPath;
        
        start = end;
        [array addObject:layer];
    }
    return array;
    
}
#pragma mark 点击是是那个区域
- (NSInteger)getSelectArea:(CGPoint)point{
    NSInteger index=0;
    for (int i=0; i<areaLayers.count; i++) {
        CAShapeLayer*layer=areaLayers[i];
        if (CGPathContainsPoint(layer.path, NULL, point, NO)) {
            
            index=i;
            break;
            
        }
    }
//   return  index-1<0?2:index-1;
    return index;
}

#pragma mark 渐变色背景
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
#pragma mark 一个圆形的layer 用于裁剪渐变色图层
- (CAShapeLayer*)circleLayer{
    if (!_circleLayer) {
        _circleLayer=[[CAShapeLayer alloc]init];
        
        UIBezierPath *circlePath = [UIBezierPath bezierPath];
        [circlePath moveToPoint:center];
        [circlePath addArcWithCenter:center radius:radius startAngle:0 endAngle:M_PI*2 clockwise:YES];
        _circleLayer.lineWidth=1;
        _circleLayer.path=circlePath.CGPath;
        
        
    }
    return _circleLayer;
}
- (void)setSeparatorColor:(UIColor *)separatorColor{
    _separatorColor=separatorColor;
    pieView.separatorColor=separatorColor;
    [pieView reloadData];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"center"]||[keyPath isEqualToString:@"bounds"]) {
        
    }
    
}

- (void)dealloc{
    [self removeObserver:self forKeyPath:@"center"];
    [self removeObserver:self forKeyPath:@"bounds"];
}
@end

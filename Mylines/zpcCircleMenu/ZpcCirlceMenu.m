//
//  ZpcScirlceMenu.m
//  Mylines
//
//  Created by zpc on 2017/11/7.
//  Copyright © 2017年 赵鹏程的macpro. All rights reserved.
//

#import "ZpcCirlceMenu.h"
#import "UIView+ZpcCircleMenu.h"
@interface ZpcCirlceMenu ()<UIScrollViewDelegate>{
    NSMutableArray*array;
    CGPoint centerPoint;
    float height;
    float width;
    NSInteger sectionNumber;//数据源有几组
    NSInteger viewNumber;//大的视图有几个
}
@property (nonatomic,strong)UIScrollView*scrollView;
@end
@implementation ZpcCirlceMenu

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
        self.backgroundColor=[UIColor clearColor];
        self.endLess=YES;
        array=[NSMutableArray arrayWithCapacity:0];
        centerPoint=CGPointMake(0, frame.size.height/2);
        height=frame.size.height;
        width=frame.size.width;
        self.radius=MIN(width, height/2);
        
        self.scrollView.frame=CGRectMake(0, 0, frame.size.width, frame.size.height);
        [self addSubview:self.scrollView];
        
       
    }
    return self;
}
- (UIScrollView*)scrollView{
    if (!_scrollView) {
        _scrollView=[[UIScrollView alloc]init];
        _scrollView.delegate=self;
        _scrollView.pagingEnabled=YES;
        _scrollView.backgroundColor=[UIColor clearColor];
        _scrollView.showsVerticalScrollIndicator=NO;
        _scrollView.showsHorizontalScrollIndicator=NO;
    }
    return  _scrollView;
}
- (void)setRadius:(float)radius{
    
    radius=fabsf(radius);
    if (radius==0) {
        radius=MIN(width, height/2);
    }
    _radius=radius;
    [self reloadData];
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    float currentPageIndex=scrollView.contentOffset.y/height;
    for (UIView*view in array) {
        
        if (view.itemIndexPath.section<=currentPageIndex+1&&
            view.itemIndexPath.section>=currentPageIndex-1) {
            view.hidden=NO;
        }else{
            view.hidden=YES;
        }
        view.center=[self getItemViewCenterPointAtIndex:view.itemIndexPath];
    }
    
    
    if (self.endLess) {
        
        if (currentPageIndex<=0) {
            
            
            [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, height*sectionNumber)];
        }
        if (currentPageIndex>=viewNumber-1) {
            
            
            [_scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, height)];
            
        }
        
    }
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    float currentPageIndex=scrollView.contentOffset.y/height;
    float currentSection;
    NSInteger n=[NSNumber numberWithFloat:currentPageIndex].integerValue;
    
    if (self.endLess) {
        
        if (currentPageIndex<=0) {
            currentSection=sectionNumber-1;
            
            
        }else if (currentPageIndex>=viewNumber-1) {
            currentSection=0;
            
            
            
        }else{
            currentSection=n-1;
        }
    }else{
        currentSection=n;
    }
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(menuView:didScrollowToSection:)]) {
        [self.delegate menuView:self didScrollowToSection:currentSection];
    }
    
}

#pragma mark 刷新数据
- (void)reloadData{
    
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [array removeAllObjects];
    
    
    
    if (self.dataSource&&[self.dataSource respondsToSelector:@selector(numberOfSectionsInMenuView:)]) {
        sectionNumber=[self.dataSource numberOfSectionsInMenuView:self];
    }
    if (sectionNumber<=0) {
        return;
    }
    if (self.endLess) {
        //无限滚动
        viewNumber=sectionNumber+2;
    }else{
        viewNumber=sectionNumber;
    }
    
    
    for (int i=0; i<viewNumber; i++) {
        NSInteger sectionIndex;//区号
        
        if (self.endLess) {
            sectionIndex=i-1;
            
        }else{
            sectionIndex=i;
        }
        
        if (sectionIndex<0) {
            sectionIndex=viewNumber-3;
        }
        if (sectionIndex==sectionNumber) {
            sectionIndex=0;
        }
        
        
        
        //items的承载视图
        UIView*view=[[UIView alloc]initWithFrame:CGRectMake(0, height*i, width, height)];
//        view.clipsToBounds=YES;
        [self.scrollView addSubview:view];
//        view.backgroundColor=[self randomColor];
        view.backgroundColor=[UIColor clearColor];
        
        NSInteger rowNum = 0;
        
        if (self.dataSource&&[self.dataSource respondsToSelector:@selector(menuView:numberOfItemInSection:)]) {
            rowNum=[self.dataSource menuView:self numberOfItemInSection:sectionIndex];
        }
        if (rowNum==0) {
            continue;
        }
        UIView*itemView;//item视图
        CGSize itemSize;//item尺寸
        NSIndexPath *indexPath;
        for (int j=0; j<rowNum; j++) {
            
            
            indexPath=[NSIndexPath indexPathForRow:j inSection:sectionIndex];
            
            if (self.dataSource&&[self.dataSource respondsToSelector:@selector(menuView:sizeForItemViewAtIndexPath:)]) {
                
                if (self.endLess&&(i==0||i==viewNumber-1)) {
                    //复制一份view
                    UIView*view=[self.dataSource menuView:self viewForItemAtIndexPath:indexPath];
                    NSData * tempArchive = [NSKeyedArchiver archivedDataWithRootObject:view];
                    itemView= [NSKeyedUnarchiver unarchiveObjectWithData:tempArchive];
                    
                }else{
                    itemView=[self.dataSource menuView:self viewForItemAtIndexPath:indexPath];
                }
                
                
                
            }
            if (!itemView) {
                continue;
            }
            //在视图中的位置
            itemView.itemIndexPath=[NSIndexPath indexPathForRow:j inSection:i];
            //对应数据源所在的位置
            itemView.dataIndexPath=[NSIndexPath indexPathForRow:j inSection:sectionIndex];
            
            
            if (self.dataSource&&[self.dataSource respondsToSelector:@selector(menuView:sizeForItemViewAtIndexPath:)]) {
                itemSize=[self.dataSource menuView:self sizeForItemViewAtIndexPath:indexPath];
            }
            if (itemSize.width<=0&&itemSize.height<=0) {
                itemSize=CGSizeMake(44, 44);
                
            }
            itemView.bounds=CGRectMake(0, 0, itemSize.width, itemSize.height);
            itemView.center=[self getItemViewCenterPointAtIndex:indexPath];
            [view addSubview:itemView];
            
            //item 会超出视图，cliptobounce 会导致有些时候某些按钮显示不全，根据滑动区域来选择隐藏和显示
            if (i==0) {
                itemView.hidden=NO;
            }else{
                itemView.hidden=YES;
            }
            
            
            [array addObject:itemView];
            //添加手势
            UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
            itemView.userInteractionEnabled=YES;
            [itemView addGestureRecognizer:tap];
            
            
        }
    }
    self.scrollView.contentSize=CGSizeMake(width, height*viewNumber);
    
    if (self.endLess) {
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x,height)];
    }
    
    
}
#pragma mark 计算坐标
- (CGPoint)getItemViewCenterPointAtIndex:(NSIndexPath*)indexPath{
    
    NSInteger sectionIndex=indexPath.section;
    
    NSInteger viewIndex=indexPath.section;
    
    if (self.endLess) {
        sectionIndex=sectionIndex-1;
        
    }else{
        sectionIndex=sectionIndex;
    }
    
    if (sectionIndex<0) {
        sectionIndex=viewNumber-3;
    }
    if (sectionIndex==sectionNumber) {
        sectionIndex=0;
    }
    
    NSInteger index=indexPath.row;
    
    NSInteger itemNum=[self.dataSource menuView:self numberOfItemInSection:sectionIndex];
   //两边留白的夹角
    float offsetAngle=0;
    if (self.dataSource&&[self.dataSource respondsToSelector:@selector(menuView:offsetAngleForSection:)]) {
        offsetAngle=[self.dataSource menuView:self offsetAngleForSection:sectionIndex];
        
    }
    offsetAngle=fabsf(offsetAngle);
    if (offsetAngle>M_PI*0.25) {
        offsetAngle=M_PI*0.25;
    }
    
    float angle=0;
    if (offsetAngle==0) {
        float num=[[NSNumber numberWithInteger:itemNum] floatValue]+1;
        float averageAngle=M_PI/num;//每个item之间的夹角
        
        angle= averageAngle*(index+1)+offsetAngle;//每个item对应的角度
    }else{
        float num=[[NSNumber numberWithInteger:itemNum] floatValue]-1;
        float averageAngle=(M_PI-2*offsetAngle)/num;//每个item之间的夹角
        
        angle= averageAngle*index+offsetAngle;//每个item对应的角度
    }
    
    int operator;
    float scale=(self.scrollView.contentOffset.y-height*viewIndex)/height;//滑动距离与高度的比例
    float plusAngle=-M_PI*scale;
    
    angle=angle+plusAngle;
    
    if (M_PI-angle>M_PI/2.0) {
        angle=M_PI/2.0-angle;
        operator=-1;
    }else if(M_PI-angle<M_PI/2.0){
        angle=angle-M_PI/2.0;
        operator=1;
    }else{
        angle=M_PI/2.0;
        operator=1;
    }
    
    float x =self.radius*cosf(angle);
    float y =centerPoint.y+ self.radius*sinf(angle)*operator+self.scrollView.contentOffset.y-height*viewIndex;
    
//    NSLog(@"%f***%f",x,y);
    return CGPointMake(x, y);
}
#pragma mark 点击手势
- (void)tapClick:(UITapGestureRecognizer*)gesture{
    UIView*view=gesture.view;
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(menuView:didSelectRowView:atIndexPath:)]) {
        [self.delegate menuView:self didSelectRowView:view atIndexPath:view.dataIndexPath];
        
    }
}
#pragma mark 切换
- (void)scrollToSection:(NSInteger)section animate:(BOOL)animate{
    
    NSInteger num=[self.dataSource numberOfSectionsInMenuView:self];
    if (section+1>num) {
        return;
    }
    
    if (self.endLess) {
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, height*(section+1)) animated:animate];
    }else{
       [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, height*section) animated:animate];
    }
    
    
}

- (UIColor*)randomColor{
    
    int R = (arc4random() % 256) ;
    int G = (arc4random() % 256) ;
    int B = (arc4random() % 256) ;
    return  [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1];
}
@end

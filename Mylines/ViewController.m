//
//  ViewController.m
//  Mylines
//
//  Created by zpc on 2017/10/24.
//  Copyright © 2017年 赵鹏程的macpro. All rights reserved.
//

#import "ViewController.h"
#import "ZpcLineChart.h"
#import "ZpcCircleProgressView.h"
#import "ZpcPie.h"
#import "ZpcMenu.h"
#import "ZpcCirlceMenu.h"
#import "ZpcRoundMenu.h"
#import "YKPAdministrationCircleItemView.h"

#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height
#define UIColorFromRGBA(rgbValue, alphaValue)[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 blue:((float)(rgbValue & 0x0000FF))/255.0 alpha:alphaValue]

@interface ViewController ()<UIScrollViewDelegate,ZpcCirlceMenuDelegate,ZpcCirlceMenuDatasource,ZpcRoundMenuDelegate,ZpcRoundMenuDatasource,ZpcMenuDelegate>
{
    

    CGPoint centerP;
    float radius;
     ZpcCirlceMenu*view;
     ZpcRoundMenu*roundMenu;
     ZpcMenu*menu;
    NSArray*allArray;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    NSArray*array=@[@"成员列表",@"成员添加",@"成员分析",@"权限管理",];
    NSArray*array1=@[@"活动列表",@"活动发布",@"活动类别",];
    NSArray*array2=@[@"赛事列表",@"赛事发布",@"赛事检录",@"赛事计时",@"成绩查询",@"颁奖管理",@"物资发放",];
    allArray=@[array,array1,array2];
    
    view=[[ZpcCirlceMenu alloc]initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64-50)];
    [self.view addSubview:view];
    [self.view bringSubviewToFront:view];
    view.delegate=self;
    view.dataSource=self;
    view.endLess=YES;
    [view reloadData];
//    [view scrollToSection:1 animate:NO];

    menu=[[ZpcMenu alloc]initWithFrame:CGRectMake(-WIDTH*0.1, HEIGHT/2-WIDTH*0.25, WIDTH*0.5, WIDTH*0.5)];
    menu.delegate=self;
    menu.separatorColor=UIColorFromRGBA(0x6E3EBF, 1);
    [self.view addSubview:menu];
    menu.gradientLayer.colors=@[(__bridge id)UIColorFromRGBA(0x5030D3, 1).CGColor,
                                (__bridge id)UIColorFromRGBA(0x8F5CD8, 0.9).CGColor,
                                (__bridge id)UIColorFromRGBA(0xB16CD4, 0.8).CGColor,];
    menu.gradientLayer.startPoint = CGPointMake(0, 0);
    menu.gradientLayer.endPoint = CGPointMake(1, 1);
    //  设置颜色变化点，取值范围 0.0~1.0
    menu.gradientLayer.locations = @[@0,@0.5,@1];
    
    menu.circleLayer.strokeColor=UIColorFromRGBA(0xDCB5FE, 0.5).CGColor;
    menu.circleLayer.lineWidth=10;
    
    
    
    roundMenu=[[ZpcRoundMenu alloc]initWithFrame:CGRectZero];
    roundMenu.orginalStartAngle=0;
    roundMenu.center=menu.center;
    roundMenu.bounds=CGRectMake(0, 0, WIDTH*0.2, WIDTH*0.2);
    [self.view addSubview:roundMenu];
    roundMenu.delegate=self;
    roundMenu.dataSource=self;
    [roundMenu reload];
    
    float radius=view.radius;
    CGPoint centerPoint=CGPointMake(0, HEIGHT*0.5+7);
    CAShapeLayer*line1=[self drawLineCenter:centerPoint radius:radius color:UIColorFromRGBA(0xBF75FF, 1)];
    CAShapeLayer*line2=[self drawLineCenter:CGPointMake(centerPoint.x+20,centerPoint.y-50)  radius:radius-20 color:UIColorFromRGBA(0xDCB5FE, 1)];
    CAShapeLayer*line3=[self drawLineCenter:CGPointMake(centerPoint.x-10,centerPoint.y+10) radius:radius+20 color:UIColorFromRGBA(0xDCB5FE, 1)];
//    [self.view.layer addSublayer:line1];
//    [self.view.layer addSublayer:line2];
//    [self.view.layer addSublayer:line3];
    [self.view.layer insertSublayer:line1 below:view.layer];
    [self.view.layer insertSublayer:line2 below:view.layer];
    [self.view.layer insertSublayer:line3 below:view.layer];
    
    

}
#pragma mark 画装饰线
- (CAShapeLayer*)drawLineCenter:(CGPoint)center radius:(float)radius color:(UIColor*)lineColor{
    CAShapeLayer*layer=[[CAShapeLayer alloc]init];
    layer.strokeColor=lineColor.CGColor;
    layer.fillColor=[UIColor clearColor].CGColor;
    layer.lineWidth=1;
    UIBezierPath*path=[UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:0 endAngle:M_PI*2 clockwise:YES];
    layer.path=path.CGPath;
    
    return layer;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [view reloadData];
}

- (NSInteger)numberOfSectionsInMenuView:(ZpcCirlceMenu *)MenuView{
    return allArray.count;
}
- (NSInteger)menuView:(ZpcCirlceMenu *)menuView numberOfItemInSection:(NSInteger)section{
   return [[allArray objectAtIndex:section] count];
}
- (UIView*)menuView:(ZpcCirlceMenu *)menuView viewForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    YKPAdministrationCircleItemView*view=[[YKPAdministrationCircleItemView alloc]initWithFrame:CGRectZero];

    NSString*str=[[allArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    view.imageName=str;
    view.title=str;
    return view;
    
}
- (CGSize)menuView:(ZpcCirlceMenu *)menuView sizeForItemViewAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(200, 44);
}
- (void)menuView:(ZpcCirlceMenu *)menuView didSelectRowView:(UIView *)view atIndexPath:(NSIndexPath *)indexPath{
    
    
//    [menuView scrollToSection:1 animate:YES];
    
    NSLog(@"%ld***%ld",(long)indexPath.section,(long)indexPath.row);
}

#pragma mark roundMenu
- (NSInteger)numberOfItemsInMenu:(ZpcRoundMenu*)menu;{
    return 3;
}
- (UIView*)roundMenu:(ZpcRoundMenu *)menu viewForItemAtIndex:(NSInteger)index{
    UILabel*lab=[[UILabel alloc]init];
    lab.text=@[@"人员",@"活动",@"赛事"][index];
    lab.textAlignment=NSTextAlignmentRight;
    lab.font=[UIFont systemFontOfSize:14];
    lab.textColor=[UIColor whiteColor];
    
//    lab.backgroundColor=[UIColor grayColor];
    return lab;
}
- (CGSize)roundMenu:(ZpcRoundMenu *)menu sizeForItemViewAtIndexPath:(NSInteger)index{
    return CGSizeMake(40, 30);
}

- (void)zpcMenu:(ZpcMenu *)menu didSelectItemAtIndex:(NSInteger)index{
    
    [view scrollToSection:index animate:YES];
    [roundMenu setSelectItem:index];
    
}
- (void)menuView:(ZpcCirlceMenu *)menuView didScrollowToSection:(NSInteger)section{
    [roundMenu setSelectItem:section];
    
    [menu setSelectIndex:section];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end

//
//  ZpcCircleProgressView.h
//  Mylines
//
//  Created by zpc on 2017/10/25.
//  Copyright © 2017年 赵鹏程的macpro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZpcCircleProgressView : UIView
@property (nonatomic,assign)float progress;
@property (nonatomic,strong)UIColor*color;
@property(nonatomic,assign) float circleRadius;//圆的半径
@property(nonatomic,assign) float circlewidth;//圆环的宽度
- (void)stroke;
@end

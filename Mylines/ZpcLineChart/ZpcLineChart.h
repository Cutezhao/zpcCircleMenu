//
//  ZpcLineChart.h
//  Mylines
//
//  Created by zpc on 2017/10/24.
//  Copyright © 2017年 赵鹏程的macpro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Layout.h"
@interface ZpcLineChart : UIView
@property (nonatomic,strong)NSArray*valueArray;
@property (nonatomic,strong)NSArray*horizontalS;
@property (nonatomic,assign)UIEdgeInsets contentEdgeInsets;//图标与视图的间距
@property (nonatomic,assign,readonly)CAGradientLayer*gradientLayer;
- (void)strokeChart;
@end

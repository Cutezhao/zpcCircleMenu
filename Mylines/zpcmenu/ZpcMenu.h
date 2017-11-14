//
//  ZpcMenu.h
//  Mylines
//
//  Created by zpc on 2017/11/3.
//  Copyright © 2017年 赵鹏程的macpro. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZpcMenu;
@protocol ZpcMenuDelegate <NSObject>

- (void)zpcMenu:(ZpcMenu*)menu didSelectItemAtIndex:(NSInteger)index;

@end
@interface ZpcMenu : UIView
@property (nonatomic,weak)id<ZpcMenuDelegate>delegate;
@property (nonatomic,strong,readonly)CAGradientLayer*gradientLayer;
@property (nonatomic,strong,readonly)CAShapeLayer*circleLayer;
@property (nonatomic,strong)UIColor*separatorColor;//分割线颜色
- (void)setSelectIndex:(NSInteger)index;
@end

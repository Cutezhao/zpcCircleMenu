//
//  ZpcPie.h
//  Mylines
//
//  Created by zpc on 2017/11/3.
//  Copyright © 2017年 赵鹏程的macpro. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZpcPie;
@protocol ZpcPieDelegate <NSObject>
- (void)ZpcPie:(ZpcPie*)pie didSelectItem:(NSInteger)index point:(CGPoint)point;
@end
@interface ZpcPie : UIView
@property (nonatomic,strong)NSArray<NSNumber*>*values;
@property (nonatomic,assign)float startAngle;//起始角度
@property (nonatomic,weak)id <ZpcPieDelegate> delegate;
@property (nonatomic,strong)UIColor*separatorColor;//分割线颜色
- (void)reloadData;
@end

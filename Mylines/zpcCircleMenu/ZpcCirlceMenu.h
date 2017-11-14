//
//  ZpcScirlceMenu.h
//  Mylines
//
//  Created by zpc on 2017/11/7.
//  Copyright © 2017年 赵鹏程的macpro. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZpcCirlceMenu;
@protocol ZpcCirlceMenuDatasource <NSObject>
@required

- (NSInteger)menuView:(ZpcCirlceMenu *)menuView numberOfItemInSection:(NSInteger)section;


- (UIView *)menuView:(ZpcCirlceMenu *)menuView viewForItemAtIndexPath:(NSIndexPath *)indexPath;

- (NSInteger)numberOfSectionsInMenuView:(ZpcCirlceMenu *)MenuView;
@optional;
- (CGSize)menuView:(ZpcCirlceMenu *)menuView sizeForItemViewAtIndexPath:(NSIndexPath *)indexPath;
//夹角
- (CGFloat)menuView:(ZpcCirlceMenu *)menuView offsetAngleForSection:(NSInteger)section;

@end
@protocol ZpcCirlceMenuDelegate <NSObject>

- (void)menuView:(ZpcCirlceMenu *)menuView didSelectRowView:(UIView*)view atIndexPath:(NSIndexPath *)indexPath;
- (void)menuView:(ZpcCirlceMenu *)menuView didScrollowToSection:(NSInteger)section;

@end
@interface ZpcCirlceMenu : UIView
@property (nonatomic,weak)id<ZpcCirlceMenuDatasource>dataSource;
@property (nonatomic,weak)id<ZpcCirlceMenuDelegate>delegate;
@property (nonatomic,assign)BOOL endLess;

@property (nonatomic,assign)float radius;

- (void)reloadData;
- (void)scrollToSection:(NSInteger)section animate:(BOOL)animate;
@end

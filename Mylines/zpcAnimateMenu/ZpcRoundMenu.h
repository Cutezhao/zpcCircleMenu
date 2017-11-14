//
//  ZpcRoundMenu.h
//  Mylines
//
//  Created by zpc on 2017/11/8.
//  Copyright © 2017年 赵鹏程的macpro. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZpcRoundMenu;
@protocol ZpcRoundMenuDatasource <NSObject>
@required;
- (NSInteger)numberOfItemsInMenu:(ZpcRoundMenu*)menu;
- (UIView*)roundMenu:(ZpcRoundMenu*)menu viewForItemAtIndex:(NSInteger)index;
- (CGSize)roundMenu:(ZpcRoundMenu *)menu sizeForItemViewAtIndexPath:(NSInteger )index;
@end
@protocol ZpcRoundMenuDelegate <NSObject>



@end
@interface ZpcRoundMenu : UIView
@property (nonatomic,weak)id<ZpcRoundMenuDatasource>dataSource;
@property (nonatomic,weak)id<ZpcRoundMenuDelegate>delegate;
@property (nonatomic,assign)float orginalStartAngle;
- (void)reload;
- (void)setSelectItem:(NSInteger)index;
@end

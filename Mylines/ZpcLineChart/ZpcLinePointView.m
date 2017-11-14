//
//  ZpcLinePointView.m
//  Mylines
//
//  Created by zpc on 2017/10/25.
//  Copyright © 2017年 赵鹏程的macpro. All rights reserved.
//

#import "ZpcLinePointView.h"
#import "UIView+Layout.h"
@interface ZpcLinePointView()
@property(nonatomic,strong)UIImageView*imageview;
//@property (nonatomic,strong)UILabel*label;

@end

@implementation ZpcLinePointView

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
        [self addSubview:self.imageview];
        self.imageview.center=self.center;
        self.bounds=CGRectMake(0, 0, self.width*0.8, self.height*0.8);
        self.backgroundColor=[UIColor redColor];
    }
    return self;
}
- (UIImageView*)imageview{
    if (!_imageview) {
        
    }
    return _imageview;
}
//- (UILabel*)label{
//    if (!_label) {
//        _label=[[UILabel alloc]init];
//        _label.font=[UIFont systemFontOfSize:10];
//    }
//    return _label;
//}
@end

//
//  YKPAdministrationCircleItemView.m
//  RunningManage
//
//  Created by zpc on 2017/11/9.
//  Copyright © 2017年 zpc. All rights reserved.
//

#import "YKPAdministrationCircleItemView.h"

@interface YKPAdministrationCircleItemView (){
    UIImageView*header;
    UILabel*titleLab;
}
@end
@implementation YKPAdministrationCircleItemView

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
        header=({
            UIImageView*imageView=[[UIImageView alloc]init];
//            imageView.image=[UIImage imageNamed:@""];
            [self addSubview:imageView];
            imageView;
        });
        titleLab=({
            UILabel*label=[[UILabel alloc]init];
//            label.text=@"";
//            label.textColor=<#UIColor#>;
            label.textAlignment=NSTextAlignmentCenter;
            label.font=[UIFont systemFontOfSize:15];
            [self addSubview:label];
            label;
        });
//        [header mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.center.equalTo(self);
//            make.height.width.equalTo(self.mas_height).multipliedBy(0.8);
//        }];
//        [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(header.mas_right).offset(5);
//            make.right.equalTo(self);
//            make.centerY.equalTo(self);
//        }];
        
        header.frame=CGRectMake(80, 2, 40, 40);
        titleLab.frame=CGRectMake(125, 0, 75, 44);
//        header.backgroundColor=[UIColor redColor];
        


        
       

    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
//    header .frame=CGRectMake(0, 0, self.frame.size.height*0.8, self.frame.size.height*0.8);
//    header.center=CGPointMake(self.frame.size.width*0.5, self.frame.size.height*0.5);
//    header.bounds=CGRectMake(0, 0, self.frame.size.height*0.8, self.frame.size.height*0.8);
//    titleLab.frame=CGRectMake(header.frame.origin.x+header.frame.size.width+5, 0, self.frame.size.width-(header.frame.origin.x+header.frame.size.width)-5, self.frame.size.height);
    
    
}
- (void)setImageName:(NSString *)imageName{
    _imageName=imageName;
    header.image=[UIImage imageNamed:imageName];
}
- (void)setTitle:(NSString *)title{
    _title=title;
    titleLab.text=title;
}
@end

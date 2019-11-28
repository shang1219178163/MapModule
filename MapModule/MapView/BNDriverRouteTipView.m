//
//  BNDriverRouteTipView.m
//  VehicleBonus
//
//  Created by Bin Shang on 2019/4/4.
//  Copyright © 2019 Xi'an iRain IOT Technology Service CO., Ltd. . All rights reserved.
//

#import "BNDriverRouteTipView.h"
#import <Masonry/Masonry.h>

@implementation BNDriverRouteTipView


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.label];
        [self addSubview:self.labelSub];
        [self addSubview:self.btn];
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.label.superview).offset(kX_GAP);
        make.right.equalTo(self.label.superview).offset(-kX_GAP);
        make.height.equalTo(@(35));
    }];
    
    [self.labelSub mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.label.mas_bottom).offset(kX_GAP);
        make.left.right.height.equalTo(self.label);

    }];
    
    [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labelSub.mas_bottom).offset(kX_GAP);
        make.left.right.equalTo(self.label);
        make.bottom.equalTo(self.btn.superview).offset(-kX_GAP);
    }];
    
}

-(UILabel *)label{
    if (!_label) {
        _label = ({
            UILabel * view = [[UILabel alloc] initWithFrame:CGRectZero];
            view.font = [UIFont systemFontOfSize:16];
            //            view.textColor = UIColor.grayColor;
            view.textAlignment = NSTextAlignmentCenter;
            
            view.numberOfLines = 1;
            view.adjustsFontSizeToFitWidth = true;//高德地图bug
            view.userInteractionEnabled = false;
            //        view.backgroundColor = UIColor.greenColor;
            view;
        });
    }
    return _label;
}


-(UILabel *)labelSub{
    if (!_labelSub) {
        _labelSub = ({
            UILabel * view = [[UILabel alloc] initWithFrame:CGRectZero];
            view.font = [UIFont systemFontOfSize:16];
            //            view.textColor = UIColor.grayColor;
            view.textAlignment = NSTextAlignmentCenter;
            
            view.numberOfLines = 1;
            view.adjustsFontSizeToFitWidth = true;//高德地图bug
            view.userInteractionEnabled = false;
            //        view.backgroundColor = UIColor.greenColor;
            view;
        });
    }
    return _labelSub;
}

-(UIButton *)btn{
    if (!_btn) {
        _btn = ({
            UIButton * view = [UIButton buttonWithType:UIButtonTypeCustom];
            view.backgroundColor = UIColor.themeColor;
            [view setTitle:@"开始导航" forState:UIControlStateNormal];
            
            view;
        });
    }
    return _btn;
}


@end

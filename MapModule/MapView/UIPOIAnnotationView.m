//
//  UIPOIAnnotationView.m
//  VehicleBonus
//
//  Created by Bin Shang on 2019/3/20.
//  Copyright © 2019 Xi'an iRain IOT Technology Service CO., Ltd. . All rights reserved.
//

#import "UIPOIAnnotationView.h"

#import <Masonry/Masonry.h>

@implementation UIPOIAnnotationView

- (void)dealloc{
//    [self removeObserver:self forKeyPath:@"isSelected"];
    
}

-(id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        self.bounds = CGRectMake(0, 0, 37, 50);

        CGFloat padding = 3.0;
        [self addSubview:self.label];
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self.label.superview).offset(padding);
            make.right.equalTo(self.label.superview).offset(-padding);
            make.height.equalTo(@(CGRectGetWidth(self.label.superview.bounds) - padding*2));

        }];
        
        [self addObserver:self forKeyPath:@"selected" options:NSKeyValueObservingOptionNew context:nil];
        
        [self getViewLayer];
    }
    return self;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    id newValue = change[NSKeyValueChangeNewKey];
    if ([keyPath isEqualToString:@"selected"]) {
        BOOL isSelected = ((NSNumber *)newValue).boolValue;
        self.transform = isSelected ? CGAffineTransformScale(self.transform, 3.0, 3.0) : CGAffineTransformIdentity;
        [self changeShowType:self.type];
    }
    
}

- (void)setType:(NSNumber *)type{
    _type = type;
    
    NSParameterAssert(type.integerValue >= 0 && type.integerValue <= 3);
    [self changeShowType:type];
}

#pragma make - - funtions

/**
 改变针视图选中selected值
 */
+ (void)selectAnnotationView:(MAAnnotationView *)view{
    if (![view isKindOfClass:UIPOIAnnotationView.class]) {
        return ;
    }
//    UIPOIAnnotationView * annoView = (UIPOIAnnotationView *)view;
//    annoView.selected = !annoView.selected;
    view.selected = view.selected;
    DDLog(@"selected_%@_%@_", @(view.selected), @(view.selected));
}

- (void)changeShowType:(NSNumber *)type{
    NSString * imgName = @"";
    NSString * imgNameSelected = @"";
    
    UIColor * textColor = UIColor.blackColor;
    UIColor * textColorSelected = UIColor.blackColor;
    switch (type.integerValue) {
        case 1:
        {
            imgName = @"map_annotation_orange_normal";
            imgNameSelected = @"map_annotation_orange_selected";
            textColor = UIColorHexValue(0xFC9628);
            textColorSelected = UIColor.whiteColor;
        }
            break;
        case 2:
        {
            imgName = @"map_annotation_gray_normal";
            imgNameSelected = @"map_annotation_gray_selected";
            textColor = UIColorHexValue(0xAAAAAA);
            textColorSelected = UIColor.whiteColor;
        }
            break;
        case 3:
        {
            imgName = @"map_annotation_red_normal";
            imgNameSelected = @"map_annotation_red_selected";
            textColor = UIColorHexValue(0xF94E41);
            textColorSelected = UIColor.clearColor;
        }
            break;
        default:
        {
            imgName = @"map_annotation_blue_normal";
            imgNameSelected = @"map_annotation_blue_selected";
            textColor = UIColorHexValue(0x418AF9);
            textColorSelected = UIColor.whiteColor;
        }
            break;
    }
    
    NSString * showImageName = self.isSelected ? imgNameSelected : imgName;
    self.image = [UIImage imageNamed:showImageName];
    self.label.textColor = self.isSelected ? textColorSelected : textColor;
    self.label.font = self.isSelected ? [UIFont systemFontOfSize:18] : [UIFont systemFontOfSize:16];
}

#pragma mark - -layz

//-(UIImageView *)imgView{
//    if (!_imgView) {
//        _imgView = ({
//            UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectZero];
//            view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
//            view.contentMode = UIViewContentModeScaleAspectFit;
//            view.userInteractionEnabled = YES;
//            view.tag = kTAG_IMGVIEW;
//            view;
//        });
//    }
//    return _imgView;
//}

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



@end

//
//  NNPOIAnnotationView.m
//  VehicleBonus
//
//  Created by Bin Shang on 2019/3/20.
//  Copyright © 2019 Xi'an iRain IOT Technology Service CO., Ltd. . All rights reserved.
//

#import "NNPOIAnnotationView.h"

#import <Masonry/Masonry.h>

@implementation NNPOIAnnotationView

- (void)dealloc{
    [self removeObserver:self forKeyPath:@"selected"];
    
}

-(id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        self.bounds = CGRectMake(0, 0, 35, 43);

        CGFloat padding = 3.0;
        [self addSubview:self.label];
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self).offset(padding);
            make.right.equalTo(self).offset(-padding);
            make.height.equalTo(@(CGRectGetWidth(self.bounds) - padding*2));
        }];
        
        [self addObserver:self forKeyPath:@"selected" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
//    id newValue = change[NSKeyValueChangeNewKey];
    if ([keyPath isEqualToString:@"selected"]) {
//        BOOL isSelected = ((NSNumber *)newValue).boolValue;
//        self.transform = isSelected ? CGAffineTransformScale(self.transform, 1.2, 1.2) : CGAffineTransformIdentity;
        [self changeShowType:self.type];
    }
    
}

- (void)setType:(NNPOIAnnotationStyle)type{
    _type = type;
    
    [self changeShowType:type];
}

- (void)setTapSelected:(BOOL)tapSelected{
    _tapSelected = tapSelected;
    self.selected = tapSelected;
}

#pragma make -funtions

/**
 改变针视图选中selected值
 */
//+ (void)selectAnnotationView:(MAAnnotationView *)view{
//    if (![view isKindOfClass:NNPOIAnnotationView.class]) {
//        return ;
//    }
////    NNPOIAnnotationView * annoView = (NNPOIAnnotationView *)view;
////    annoView.selected = !annoView.selected;
//    view.selected = view.selected;
//    DDLog(@"selected_%@_%@_", @(view.selected), @(view.selected));
//}

- (void)changeShowType:(NNPOIAnnotationStyle)type{    
    NSString * imgName = @"";
    NSString * imgNameSelected = @"";
    
    UIColor * textColor = UIColor.blackColor;
    UIColor * textColorSelected = UIColor.blackColor;
    switch (type) {
        case NNPOIAnnotationStyleOrange:
        {
            imgName = @"map_annotation_orange_normal";
            imgNameSelected = @"map_annotation_orange_selected";
            textColor = UIColorHexValue(0xFC9628);
            textColorSelected = UIColor.whiteColor;
        }
            break;
        case NNPOIAnnotationStyleGray:
        {
            imgName = @"map_annotation_gray_normal";
            imgNameSelected = @"map_annotation_gray_selected";
            textColor = UIColorHexValue(0xAAAAAA);
            textColorSelected = UIColor.whiteColor;
        }
            break;
        case NNPOIAnnotationStyleRed:
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
    
    if (self.imageNormal && self.imageSelected) {
        self.image = self.isSelected ? self.imageSelected : self.imageNormal;

    } else {
        NSString * showImageName = self.isSelected ? imgNameSelected : imgName;
        self.image = [UIImage imageNamed:showImageName];
    }

    self.label.textColor = self.isSelected ? textColorSelected : textColor;
//    self.label.font = self.isSelected ? [UIFont systemFontOfSize:18] : [UIFont systemFontOfSize:16];
    self.label.font = self.isSelected ? [UIFont systemFontOfSize:15 weight:UIFontWeightMedium] : [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];

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

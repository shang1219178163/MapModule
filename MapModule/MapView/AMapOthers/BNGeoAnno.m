//
//  BNGeoAnno.m
//  HuiZhuBang
//
//  Created by BIN on 2017/9/9.
//  Copyright © 2017年 Shang. All rights reserved.
//

#import "BNGeoAnno.h"

@interface BNGeoAnno ()

@property (nonatomic, readwrite, strong) AMapGeocode *geocode;

@end


@implementation BNGeoAnno

- (NSString *)title{
    return self.geocode.formattedAddress;
}

- (NSString *)subtitle{
    return [self.geocode.location description];
}

- (CLLocationCoordinate2D)coordinate{
    return CLLocationCoordinate2DMake(self.geocode.location.latitude, self.geocode.location.longitude);
}

#pragma mark - Life Cycle

- (id)initWithGeocode:(AMapGeocode *)geocode{
    if (self = [super init]){
        self.geocode = geocode;
        
    }
    return self;
}


@end

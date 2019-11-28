//
//  LocationShareModel.m
//  Location
//
//  Created by Rick
//  Copyright (c) 2014 Location. All rights reserved.
//

#import "LocationShareModel.h"

@implementation LocationShareModel

//Class method to make sure the share model is synch across the app
+ (id)shared{
    static id _instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
        
    });
    return _instance;
}

@end

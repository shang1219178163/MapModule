//
//  ViewController.h
//  test
//
//  Created by yi chen on 14-8-20.
//  Copyright (c) 2014年 yi chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>

@interface TrackViewController : UIViewController

- (void)initRoute:(CLLocationCoordinate2D *)coords count:(NSUInteger)count;

@end

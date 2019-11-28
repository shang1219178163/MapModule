//
//  LocationTracker.h
//  Location
//
//  Created by Rick
//  Copyright (c) 2014 Location. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "LocationShareModel.h"

#define kTimerInterval  60*20
#define kTimerInterval_Foreground  60*5

#define kLocationDuration  5
#define kLocationAccuracy  2000

#define keyLocationLatitude   @"keyLocationLatitude"
#define keyLocationLongitude  @"keyLocationLongitude"
#define keyLocationAccuracy   @"keyLocationAccuracy"
#define keyLocationTimeStamp  @"keyLocationTimeStamp"

#define kNotiPostNameLocationOld @"kNotiPostNameLocationOld"
#define kNotiPostNameLocationNew @"kNotiPostNameLocationNew"

@interface LocationTracker : NSObject <CLLocationManagerDelegate>

@property (nonatomic) CLLocationCoordinate2D myLastLocation;
@property (nonatomic) CLLocationAccuracy myLastLocationAccuracy;

@property (strong,nonatomic) LocationShareModel * shareModel;

@property (nonatomic) CLLocationCoordinate2D myLocation;
@property (nonatomic) CLLocationAccuracy myLocationAccuracy;

+ (CLLocationManager *)shared;

- (void)startLocationTracking;
- (void)stopLocationTracking;
- (void)updateLocationToServer;

+(instancetype)shareInstance;

@end

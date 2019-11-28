//
//  LocationTracker.m
//  Location

//  Created by Rick
//  Copyright (c) 2014 Location All rights reserved.
//

#import "LocationTracker.h"

#import "NNGloble.h"
#import "BNNoti.h"

#import "UIApplication+Helper.h"
#import "NSTimer+Helper.h"

@interface LocationTracker ()

@property (nonatomic, strong) NSDate *lastSendDate;
@property (nonatomic, assign) BOOL isEnterBackgroud;

@end

@implementation LocationTracker

+ (CLLocationManager *)shared {
	static CLLocationManager *_locationManager;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        _locationManager.allowsBackgroundLocationUpdates = YES;
        _locationManager.pausesLocationUpdatesAutomatically = NO;
        
    });
	return _locationManager;
}

- (id)init {
	if (self == [super init]) {
        //Get the share model and also initialize myLocationArray
        self.shareModel = [LocationShareModel shared];
        self.shareModel.myLocationArray = [[NSMutableArray alloc]init];
        
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(applicationEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(applicationEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];

	}
	return self;
}

+(instancetype)shareInstance{
    static id obj;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [[LocationTracker alloc]init];
        
    });
    return obj;
}

-(void)applicationEnterBackground{
    [self locationMangerBegin];

    self.shareModel.bgTask = [BackgroundTaskManager sharedBackgroundTaskManager];
    [self.shareModel.bgTask beginNewBackgroundTask];
        
    self.isEnterBackgroud = YES;

    //Use the BackgroundTaskManager to manage all the background Task
}

-(void)applicationEnterForeground{
    [self locationMangerBegin];

    self.isEnterBackgroud = NO;
}


- (void)restartLocationUpdates{
    [NSTimer stopTimer:self.shareModel.timer];
    
    [self locationMangerBegin];
}

- (void)locationMangerBegin{
    CLLocationManager *locationManager = [LocationTracker shared];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    
    [locationManager requestAlwaysAuthorization];
    [locationManager startUpdatingLocation];

}

- (void)startLocationTracking {
    CLAuthorizationStatus authorizationStatus = [CLLocationManager authorizationStatus];
    if (authorizationStatus == kCLAuthorizationStatusAuthorizedAlways) {
        [self locationMangerBegin];
        
    }
    else{
        NSString *msg = [NSString stringWithFormat:@"请开启始终定位(设置->隐私->定位服务->选择%@->始终)",UIApplication.appName];
        [UIApplication.rootController showAlertTitle:@"定位服务" msg:msg actionTitles:@[kTitleSure] handler:nil];
        
    }
}

- (void)stopLocationTracking {
    [NSTimer stopTimer:self.shareModel.timerDelay];

	CLLocationManager *locationManager = [LocationTracker shared];
	[locationManager stopUpdatingLocation];
    
}


#pragma mark - CLLocationManagerDelegate Methods

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    if (locations.count != 0) {
        CLLocation *userLocation = [locations lastObject];
//        DDLog(@"userLocation__%@",userLocation);
        CLLocationCoordinate2D coordinate = userLocation.coordinate;
        CLLocationAccuracy accuracy = userLocation.horizontalAccuracy;
        
        NSTimeInterval locationAge = -[userLocation.timestamp timeIntervalSinceNow];
        if (locationAge > 20) return;
        
        if(userLocation != nil && accuracy > 0 && accuracy < kLocationAccuracy &&(!(coordinate.latitude == 0.0 && coordinate.longitude == 0.0))){
            self.myLastLocation = coordinate;
            self.myLastLocationAccuracy = accuracy;
            
            NSDictionary * dict = @{
                                    keyLocationLatitude : @(coordinate.latitude),
                                    keyLocationLongitude : @(coordinate.longitude),
                                    keyLocationAccuracy : @(accuracy),
                                    
                                    };
            
            //Add the vallid location with good accuracy into an array
            //Every 1 minute, I will select the best location based on accuracy and send to server
            [self.shareModel.myLocationArray addObject:dict];
            
//            if (!self.lastSendDate || [[self.lastSendDate dateByAddingInterval:kTimerInterval] compare:[NSDate date]] <= 0) {
//                self.lastSendDate = [NSDate date];
//                NSLog(@"send________%f->%f->%@",coordinate.latitude,coordinate.longitude,@(accuracy));
//
//            }
        }
    }

    //If the timer still valid, return it (Will not run the code below)
    if (self.shareModel.timer) {
        return;
    }
    
//    if (self.isEnterBackgroud) {
        self.shareModel.bgTask = [BackgroundTaskManager sharedBackgroundTaskManager];
        [self.shareModel.bgTask beginNewBackgroundTask];
        
//    }
    
    
    NSTimeInterval timeInterval = kTimerInterval_Foreground - kLocationDuration;
    if (self.isEnterBackgroud) {
        timeInterval = kTimerInterval - kLocationDuration;
        
    }
    
     //Restart the locationMaanger after 1 minute
    self.shareModel.timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self
                                                           selector:@selector(restartLocationUpdates)
                                                           userInfo:nil
                                                            repeats:NO];
    
    //Will only stop the locationManager after 10 seconds, so that we can get some accurate locations
    //The location manager will only operate for 10 seconds to save battery
    self.shareModel.timerDelay = [NSTimer scheduledTimerWithTimeInterval:kLocationDuration target:self
                                                    selector:@selector(stopLocationTracking)
                                                    userInfo:nil
                                                     repeats:NO];

}

- (void)locationManager: (CLLocationManager *)manager didFailWithError: (NSError *)error{
   // NSLog(@"locationManager error:%@",error);
    
    switch([error code])
    {
        case kCLErrorNetwork: // general, network-related error
        {
            [UIApplication.rootController showAlertTitle:@"网络错误" msg:@"网络链接失败,请检查网络" actionTitles:@[kTitleSure] handler:nil];
        }
            break;
        case kCLErrorDenied:
        {
            NSString *msg = [NSString stringWithFormat:@"请开启始终定位(设置->隐私->定位服务->选择%@->始终)",UIApplication.appName];
            [UIApplication.rootController showAlertTitle:@"定位失败" msg:msg actionTitles:@[kTitleSure] handler:nil];
            
        }
            break;
        default:
            break;
    }
}


//Send the location to Server
- (void)updateLocationToServer {
    
//    NSLog(@"%@",NSStringFromSelector(_cmd));
    NSArray * array = [NSArray arrayWithArray:self.shareModel.myLocationArray];
//    DDLog(@"locationArrayCount__%@__array__%@",@(self.shareModel.myLocationArray.count),array);
    
    // Find the best location from the array based on accuracy
    NSDictionary * myBestLocation = [NSDictionary dictionary];
    
    for(int i = 0; i < self.shareModel.myLocationArray.count; i++){
        NSDictionary * currentLocation = self.shareModel.myLocationArray[i];
        if(i == 0){
            myBestLocation = currentLocation;
        }
        else{
            if([currentLocation[keyLocationAccuracy] floatValue] <= [myBestLocation[keyLocationAccuracy] floatValue]){
                myBestLocation = currentLocation;
            }
        }
    }
    
//    NSLog(@"My Best location:%@",myBestLocation);
    
    //If the array is 0, get the last location
    //Sometimes due to network issue or unknown reason, you could not get the location during that  period, the best you can do is sending the last known location to the server
    if(self.shareModel.myLocationArray.count == 0){
        DDLog(@"Unable to get location, use the last known location");
        self.myLocation = self.myLastLocation;
        self.myLocationAccuracy = self.myLastLocationAccuracy;
        
    }
    else{
        CLLocationCoordinate2D bestLocation = CLLocationCoordinate2DMake(0.0, 0.0);
        bestLocation.latitude = [myBestLocation[keyLocationLatitude] floatValue];
        bestLocation.longitude = [myBestLocation[keyLocationLongitude] floatValue];
        self.myLocation = bestLocation;
        self.myLocationAccuracy = [myBestLocation[keyLocationAccuracy] floatValue];
    }
    
//    DDLog(@"Send to Server: Latitude(%f) Longitude(%f) Accuracy(%f)   %@",self.myLocation.latitude, self.myLocation.longitude,self.myLocationAccuracy,self.isEnterBackgroud ? @"后台定位":@"前台定位");
    NSDictionary * dict = @{
                            keyLocationLatitude : @(self.myLocation.latitude),
                            keyLocationLongitude : @(self.myLocation.longitude),
                            keyLocationAccuracy : @(self.myLocationAccuracy),
                            keyLocationTimeStamp : [self currentTimeStamp]
                            };
    
    [NSNotificationCenter.defaultCenter postNotificationName:kNotiPostNameLocation_UploadCoordinate object:nil userInfo:dict];

    //TODO: Your code to send the self.myLocation and self.myLocationAccuracy to your server
    
    //After sending the location to the server successful, remember to clear the current array with the following code. It is to make sure that you clear up old location in the array and add the new locations from locationManager
    [self.shareModel.myLocationArray removeAllObjects];
    self.shareModel.myLocationArray = nil;
    self.shareModel.myLocationArray = [[NSMutableArray alloc]init];
}


//获取当前时间戳
- (NSString *)currentTimeStamp{
    NSString *timeStr = [NSString stringWithFormat:@"%.0f", NSDate.date.timeIntervalSince1970];
    return timeStr;
}

@end

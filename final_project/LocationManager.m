//
//  LocationManager.m
//  final_project
//
//  Created by Varun Mehta on 5/4/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import "LocationManager.h"
#import <UIKit/UIKit.h>

@interface LocationManager ()

@property (nonatomic) CLLocationManager *manager;
@property (nonatomic) CLLocation *currentLocation;

//Private methods
+ (CLLocationManager *)sharedManager; //Method to access CLLocationManager.
- (NSString *)locationInHumanReadableFormat: (CLLocation *)location;
@end

@implementation LocationManager

+ (instancetype)sharedLocationManager {
    static LocationManager *sharedInstance;
    if (!sharedInstance) {
        static dispatch_once_t token;
        dispatch_once(&token, ^{
            sharedInstance = [[super allocWithZone:nil] init];
            
            //Custom initialization
            sharedInstance.manager = [[CLLocationManager alloc] init];
            sharedInstance.manager.desiredAccuracy = kCLLocationAccuracyKilometer;
            sharedInstance.manager.delegate = sharedInstance;
        });
    }
    return sharedInstance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [LocationManager sharedLocationManager];
}

- (id)copy {
    return self;
}

//Use this method to access CLLocationManager instance.
+ (CLLocationManager *)sharedManager {
    //returns sharedInstance.manager
    return [[LocationManager sharedLocationManager] manager];
}

//Method initiating location analysis
- (void)initiateLocationServices {
    //Check if location services enabled
    if ([CLLocationManager locationServicesEnabled]) {
        //Check for app authorization status
        CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
        
        //User has never asked for authorization, request authorization
        if (status == kCLAuthorizationStatusNotDetermined) {
            //Following is required in iOS 8+. This check prevents app crash for lower version.
            if ([[LocationManager sharedManager] respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
                [[LocationManager sharedManager] requestWhenInUseAuthorization];
            }
        }
        
        //If user has given authorization, use it to access location
        //kCLAuthorizationStatusAuthorized in iOS 7.0- translates to kCLAuthorizationStatusAuthorizedWhenInUse || kCLAuthorizationStatusAuthorizedAlways
        if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
//            [[LocationManager sharedManager] startMonitoringSignificantLocationChanges];
            [[LocationManager sharedManager] startUpdatingLocation];
        }
    }
}

//CLLocationManagerDelegate method returning latest information
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *currentLocation = [locations lastObject];
    NSDate *eventDate = currentLocation.timestamp;
    
    NSTimeInterval informationTimeDelta = [eventDate timeIntervalSinceNow];
    if (fabs(informationTimeDelta) < 10.0) {
        //save location information
        self.currentLocation = currentLocation;
        
        //Stop location monitoring to optimize battery performance
        [[LocationManager sharedManager] stopUpdatingLocation];
        
        //Convert Lat Long to human readable format
        [self locationInHumanReadableFormat:currentLocation];
        
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    //Location fetch failed.
    NSLog(@"%@\n%@", [error localizedDescription], [error localizedFailureReason]);
    //Stop monitoring
    [[LocationManager sharedManager] stopUpdatingLocation];
}

//Convert lat long to human readable format using Geocode;
- (NSString *)locationInHumanReadableFormat:(CLLocation *)location {
    __block NSString *locationString;
    
    //if location is not empty
    if (location) {
        //CLGeocoder is used for reverse encoding of lat/long to location
        CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
        
        __weak LocationManager *weakSelf = self;
        [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error){
            //map weakself to strong reference to ensure accessibility through out block
            __strong LocationManager *strongSelf = weakSelf;

            //If no error and placemarks is not empty
            if (!error && ([placemarks count] > 0)) {
                CLPlacemark *placemark = [placemarks lastObject];
                locationString = [NSString stringWithFormat:@"%@, %@, %@",placemark.subAdministrativeArea, placemark.administrativeArea, placemark.country];

                //send location information to delegate
                if (strongSelf)
                    [strongSelf.delegate userCurrentLocation:self.currentLocation inString:locationString];
            }
        }];
    }
    return locationString;
}
@end

//
//  LocationManager.h
//  final_project
//
//  Created by Varun Mehta on 5/4/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol LocationManagerDelegate <NSObject>

- (void)userCurrentLocation: (CLLocation *)currentLocation inString:(NSString *)location;

@end

@interface LocationManager : NSObject <CLLocationManagerDelegate>

+ (instancetype)sharedLocationManager; //Method to access shared location manager
- (void)initiateLocationServices;

@property (nonatomic, weak) id <LocationManagerDelegate> delegate;
@end

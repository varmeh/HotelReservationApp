//
//  EANWebFramework.h
//  final_project
//
//  Created by iOS on 2/25/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EANWebFramework : NSObject

- (NSArray *)getHotelsList:(NSString *)city stateProvinceCode:(NSString *)stateCode countryCode: (NSString *)countryCode forArrivalDateInUSFormat:(NSString *)arrivalDate withDepartureDate:(NSString *)departureDate forNumberOfRooms:(NSString *)roomCount roomOccupantsDetails:(NSArray *)roomOccupantsDetails;



@end

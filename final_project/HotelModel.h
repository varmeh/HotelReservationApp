//
//  HotelModel.h
//  final_project
//
//  Created by Varun Mehta on 5/7/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RoomDetailsModel.h"

@interface HotelModel : NSObject

@property (assign, nonatomic) NSInteger hotelId; //ID for the property. This same ID will be used in any subsequent room or reservation requests.
@property (nonatomic) NSString *name; //
@property (nonatomic) NSString *address1; //Hotel street address
@property (nonatomic) NSString *city;
@property (nonatomic) NSString *stateProvinceCode;
@property (nonatomic) NSString *postalCode;
@property (assign, nonatomic) CGFloat hotelRating; //Star rating (0-5) of the hotel. A value of 0.0 or a blank value indicate none is available.
@property (assign, nonatomic) NSInteger amenistyMask; //The amenityMask is a bitmask of 28 amenities - http://developer.ean.com/general-info/amenity-mask
@property (assign) NSInteger tripadvisorRating;
@property (nonatomic) NSString *tripAdvisorRatingURL;
@property (nonatomic) NSString *shortDescription; //Short description text entered by the property.
@property (nonatomic) NSString *locationDescription; //General location as entered by the property, e.g. "Near Pike Place Market"
@property (nonatomic) NSString *lowRate; //Lowest rate returned by the hotel in recent queries. This is a statistical figure and not necessarily a rate for current availability.
@property (nonatomic) NSString *highRate; //Highest rate returned by the hotel in recent queries.
@property (assign, nonatomic) CGFloat latitude;
@property (assign, nonatomic) CGFloat longitude;
@property (assign, nonatomic) CGFloat proximityDistance; //The distance of the hotel from the originally specified origin coordinates, if that search method was used.
@property (nonatomic) NSString *proximityUnit;
@property (assign) bool hotelInDestination; //Indicates whether the property is within the originally specified city or in an expanded area, i.e. a major suburb or other nearby city.
@property (nonatomic) NSString *thumbNailUrl; //it's a relative path and should be appended with http://images.travelnow.com
@property (nonatomic) RoomDetailsModel *roomDetails;

@end

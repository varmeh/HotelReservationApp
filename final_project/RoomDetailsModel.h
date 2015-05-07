//
//  RoomDetailsModel.h
//  final_project
//
//  Created by Varun Mehta on 5/7/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RateInfoModel.h"

@interface RoomDetailsModel : NSObject

@property (nonatomic) NSString *roomTypeCode;
@property (nonatomic) NSString *roomRateCode;
@property (assign) NSInteger maxRoomOccupancy; //Maximum number of guests allowed in the room returned.
@property (assign) NSInteger quotedRoomOccupancy; //Confirms the actual occupancy used to calculate the rate.
@property (assign) NSInteger minGuestAge;
@property (nonatomic) NSString *roomDescription;
@property (nonatomic) NSString *promoId; //ID for the promo offer returned, if any.
@property (nonatomic) NSString *promoDescription;
@property (nonatomic) NSString *promoDetailText;
@property (assign) NSInteger currentAllotment; //no of bookable rooms
@property (assign) bool propertyAvailable;
@property (assign) bool propertyRestricted;
@property (nonatomic) NSString *expediaPropertyId; //Expedia's ID for the hotel. Use this value to map to a hotelId when cross-referencing to Expedia.
@property (nonatomic) NSString *smokingPreferences;
@property (nonatomic) NSString *valueAdds; //Contains a description element for a free service offered with the provided room and rate, such as free breakfast or wireless internet.
@property (nonatomic) RateInfoModel *rateDetails;

@end

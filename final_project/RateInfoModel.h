//
//  RateInfoModel.h
//  final_project
//
//  Created by Varun Mehta on 5/7/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CharageableRateInfoModel.h"

@interface RateInfoModel : NSObject

@property (assign, nonatomic) bool priceBreakdown; //Indicates if a full price breakdown including taxes and total price to be charged is included.
@property (assign, nonatomic) bool promo; //Indicates if the rate returned is a promotional rate.
@property (assign, nonatomic) bool rateChange; //Indicates if the rate is different for at least one of the nights during the stay.
@property (assign, nonatomic) NSInteger numberOfAdults;
@property (assign, nonatomic) NSInteger numberOfChildren;
@property (nonatomic) NSString *promoId;
@property (nonatomic) NSString *promoDescription;
@property (assign, nonatomic) NSInteger currentAllotment; //The number of bookable rooms remaining at the property. Use this value to create rules for urgency messaging to alert users to low availability on busy travel dates or at popular properties.
@property (nonatomic) NSString *cancellationPolicy;
@property (nonatomic)  NSString *rateType; //Indicates if the rate returned is prepaid via EAN or post-paid at the hotel.
@property (assign, nonatomic) bool nonRefundable;

@property (nonatomic) CharageableRateInfoModel *charageableRates;

@end

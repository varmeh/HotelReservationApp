//
//  CharageableRateInfoModel.h
//  final_project
//
//  Created by Varun Mehta on 5/7/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CharageableRateInfoModel : NSObject

//Following represents total amount payable for reservation
@property (assign) CGFloat total; //The total of all nightly rates, taxes, and surcharges to be charged for the reservation. This is the total value that must be displayed to the customer and included in the booking request.
@property (assign) CGFloat averageRate; //Average of all nightly rates with any promo values applied, without surcharges.
@property (assign) CGFloat commissionableUsdTotal; //Amount used to calculate partner commissions, in USD. Total of nightly rates less surchages.
@property (assign) CGFloat surchargeTotal; //Total of TaxAndServiceFee and ExtraPersonFee from the Surcharges array.
@property (nonatomic) NSString *surchargeType;

//Following represents charge for a night
@property (assign) bool promoRateApplicable; //Indicates if a promo rate is applied for this night's rate.
@property (assign) CGFloat nightlyRate; //The nightly rate after the promo, if any, is applied.
@property (assign) CGFloat baseRate; //The nightly rate before the promo, if any, is applied.

@end

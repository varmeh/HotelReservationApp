//
//  EANFilter.h
//  popover_iphone
//
//  Created by iOS on 2/28/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import "EANPopOver.h"

@protocol EANFilterDelegate <EANPopoverDelegate>

- (void)filtersSelected;
- (NSArray *)getCurrentFilterValues;

@end

@interface EANFilter : EANPopOver

@property (nonatomic, weak) id <EANFilterDelegate> delegate;

- (NSString *)hotelNameFilterValue;
- (NSNumber *)starRatingFilterValue;
- (NSNumber *)distanceFromSelectedLocationFilterValue;
- (NSNumber *)priceFilterValue;
@end

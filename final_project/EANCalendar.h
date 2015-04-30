//
//  EANCalendar.h
//  popover_iphone
//
//  Created by iOS on 3/2/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import "EANPopOver.h"
#import "CKCalendarView.h"

@protocol EANCalendatDelegate <EANPopoverDelegate>

- (void)datesSelected:(NSDate *)checkIn withCheckOutDate:(NSDate *)checkOut;

@end

@interface EANCalendar : EANPopOver <CKCalendarDelegate>

@property (nonatomic, weak) id <EANCalendatDelegate> delegate;
@end

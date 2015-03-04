//
//  EANCalendar.h
//  popover_iphone
//
//  Created by iOS on 3/2/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import "EANPopOver.h"
#import "CKCalendarView.h"

@protocol EANCalendatDelegate <NSObject>

- (void)datesSelected;

@end

@interface EANCalendar : EANPopOver <CKCalendarDelegate>

@property (nonatomic, weak) id <EANCalendatDelegate> delegate;
@end

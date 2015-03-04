//
//  EANCalendar.m
//  popover_iphone
//
//  Created by iOS on 3/2/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import "EANCalendar.h"

@interface EANCalendar ()

@property (nonatomic) CKCalendarView *calendar;
@property CGFloat calendarPreviousHeight;
@end


@implementation EANCalendar

- (instancetype)initWithFrame:(CGRect)frame forTarget:(UIView *)parentView withReferenceFrameToolBarHeight:(CGFloat)toolbarHeight {
    self = [super initWithFrame:frame forTarget:parentView withReferenceFrameToolBarHeight:toolbarHeight];
    return self;
}

- (void)showAnimated {
    //Could not be called from init as delegate is required for this function & delegation connection is done afterwards.
    [self addCalendar];
    [super showAnimated];
}

- (void) addCalendar {
    self.calendar = [[CKCalendarView alloc] initWithFrame:CGRectMake(0, 30, self.frame.size.width, self.frame.size.height-30)];
    self.calendar.delegate = self;
    self.calendarPreviousHeight = self.calendar.frame.size.height;
    [self addSubview:self.calendar];
}

//This function called when selection completed.
- (void)selectionDidComplete:(id)sender {
    [self.delegate datesSelected];
    [super selectionDidComplete:sender];
}

- (BOOL)calendar:(CKCalendarView *)calendar willSelectDate:(NSDate *)date {
    return YES;
}

- (void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date {
    
}

- (BOOL)calendar:(CKCalendarView *)calendar willChangeToMonth:(NSDate *)date {
    return YES;
}

- (void)calendar:(CKCalendarView *)calendar configureDateItem:(CKDateItem *)dateItem forDate:(NSDate *)date {

}

- (void)calendar:(CKCalendarView *)calendar didLayoutInRect:(CGRect)frame {
    if (frame.size.height != self.calendarPreviousHeight) {
        CGFloat increaseInHeight = frame.size.height - self.calendarPreviousHeight;
        [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y - increaseInHeight, self.frame.size.width, self.frame.size.height + increaseInHeight)];
        self.calendarPreviousHeight = frame.size.height;
    }
}

@end

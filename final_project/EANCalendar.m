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
@property NSDate *checkInDate;
@property NSDate *checkOutDate;
@property (nonatomic) NSCalendar *referencCalendar;
@property NSMutableArray *dateRange;
// Range Method
- (void) setDateRange;

@end


@implementation EANCalendar

@dynamic delegate;

- (instancetype)initWithFrame:(CGRect)frame forTarget:(UIView *)parentView withReferenceFrameToolBarHeight:(CGFloat)toolbarHeight {
    self = [super initWithFrame:frame forTarget:parentView withReferenceFrameToolBarHeight:toolbarHeight];
    self.dateRange = [NSMutableArray new];
    self.referencCalendar = [NSCalendar currentCalendar];
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
    [self.delegate datesSelected:self.checkInDate withCheckOutDate:self.checkOutDate];
    [super selectionDidComplete:sender];
}

- (BOOL)calendar:(CKCalendarView *)calendar willSelectDate:(NSDate *)date {
    //00:00 hrs has 0 seconds  and 24:00 hrs is 86400. All calculation made against 00:00 hrs.
    if ([date timeIntervalSinceNow] > -86400)
        return YES;
    else
        return NO;
}

- (void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date {
    if (self.checkInDate == nil) {
        self.checkInDate = date;
    } else if (self.checkOutDate == nil) {
        self.checkOutDate = date;
        
        //If checkout date is earlier than checkIn date, swap dates
        if ([[self.checkOutDate earlierDate:self.checkInDate] isEqualToDate:self.checkOutDate]) {
            NSDate *temp = self.checkInDate;
            self.checkInDate = self.checkOutDate;
            self.checkOutDate = temp;
        }
        [self setDateRange];
        
    } else {
        self.checkOutDate = nil;
        self.checkInDate = date;
        [self.dateRange removeAllObjects]; //Date Range no longer valid
    }
}

- (BOOL)calendar:(CKCalendarView *)calendar willChangeToMonth:(NSDate *)date {
    return YES;
}

- (void)calendar:(CKCalendarView *)calendar configureDateItem:(CKDateItem *)dateItem forDate:(NSDate *)date {
    NSDateComponents *day = [self.referencCalendar components:NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear fromDate:date];
    if ([self.dateRange containsObject:day]) {
        dateItem.backgroundColor = UIColorFromRGB(0x007AFF);
        dateItem.textColor = UIColorFromRGB(0xFFFFFF);
    }
}

- (void)calendar:(CKCalendarView *)calendar didLayoutInRect:(CGRect)frame {
    if (frame.size.height != self.calendarPreviousHeight) {
        CGFloat increaseInHeight = frame.size.height - self.calendarPreviousHeight;
        [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y - increaseInHeight, self.frame.size.width, self.frame.size.height + increaseInHeight)];
        self.calendarPreviousHeight = frame.size.height;
    }
}

- (void) setDateRange {
    [self.dateRange removeAllObjects];
    
    NSDate *nextDay = self.checkInDate;
    
    while ([nextDay timeIntervalSinceDate:self.checkOutDate] < 1) {
        NSDateComponents *date = [self.referencCalendar components:NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear fromDate:nextDay];
        [self.dateRange addObject:date];
        nextDay = [NSDate dateWithTimeInterval:(24*60*60) sinceDate:nextDay];
    }
}

@end

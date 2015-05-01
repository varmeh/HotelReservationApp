//
//  EANFilter.m
//  popover_iphone
//
//  Created by iOS on 2/28/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import "EANFilter.h"

@interface EANFilter ()

@property (nonatomic, strong) UITextField *filterHotelName;
@property (nonatomic, strong) UISegmentedControl *filterDistance;
@property (nonatomic, strong) UISegmentedControl *filterStar;
@property (nonatomic, strong) UISegmentedControl *filterPrice;

@end

@implementation EANFilter

//Delaying property synthesis to runtime. Required for delegate property overloading of super class.
@dynamic delegate;

//Custom initialization method.
- (instancetype)initWithFrame:(CGRect)frame forTarget:(UIView *)parentView withReferenceFrameToolBarHeight:(CGFloat)toolbarHeight {
    self = [super initWithFrame:frame forTarget:parentView withReferenceFrameToolBarHeight:toolbarHeight];
    return self;
}

//Add filter components to view and shows the pop up afterwards
- (void)showAnimated {
    //Could not be called from init as delegate is required for this function & delegation connection is done afterwards.
    [self addFilters];
    [super showAnimated];
}

//Add filters to pop up.
//All filters values except hotel name are hardcoded. Bad practice.
- (void) addFilters {
    UIEdgeInsets insets = UIEdgeInsetsMake(7, 7, 7, 7);
    CGFloat marginBetweenFilters = 7;
    CGRect parentFrame = self.frame;
    CGFloat heightOfComponent = (parentFrame.size.height - (insets.top + insets.bottom))/4.0 - 2*marginBetweenFilters;
    
    CGRect frame = CGRectMake(insets.left, self.tabBarHeight + insets.top, parentFrame.size.width - (insets.left+insets.right), heightOfComponent);

    //Get currently selected Values using delegate method.
    NSArray *selectedValues = [self.delegate getCurrentFilterValues];
    
    //Adding elements in sequential order
    //Component 1 - Hotel Name Filter. It's a text field
    self.filterHotelName = [[UITextField alloc] initWithFrame:frame];
    [self.filterHotelName setPlaceholder:@"Filter By Hotel Name"];
    [self.filterHotelName setBorderStyle:UITextBorderStyleRoundedRect];
    frame.origin.y += heightOfComponent + marginBetweenFilters;
    
    NSDictionary *textAttributes = @{NSFontAttributeName:[UIFont fontWithName:@"Arial" size:20.0]};
    
    //Component 2 - Distance. A segmented control.
    self.filterDistance = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"2.5", @"7.5", @"All", nil]];
    [self.filterDistance setFrame:frame];
    [self.filterDistance setSelectedSegmentIndex:[[selectedValues objectAtIndex:0] integerValue]];
    [self.filterDistance setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
    [self.filterDistance setTitleTextAttributes:textAttributes forState:UIControlStateSelected];

    frame.origin.y += heightOfComponent + marginBetweenFilters;

    //Component 3 - Star. A segmented control.
    self.filterStar = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"4", @"5", @"All", nil]];
    [self.filterStar setFrame:frame];
    [self.filterStar setSelectedSegmentIndex:[[selectedValues objectAtIndex:1] integerValue]];
    [self.filterStar setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
    [self.filterStar setTitleTextAttributes:textAttributes forState:UIControlStateSelected];

    frame.origin.y += heightOfComponent + marginBetweenFilters;
    
    //Component 4 - Price. A segmented control.
    self.filterPrice = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"$$", @"$$$", @"All", nil]];
    [self.filterPrice setFrame:frame];
    [self.filterPrice setSelectedSegmentIndex:[[selectedValues objectAtIndex:2] integerValue]];
    [self.filterPrice setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
    [self.filterPrice setTitleTextAttributes:textAttributes forState:UIControlStateSelected];

    
    //Add all components to pop over view
    [self addSubview:self.filterHotelName];
    [self addSubview:self.filterDistance];
    [self addSubview:self.filterStar];
    [self addSubview:self.filterPrice];
}

//This method called when selection completed, which in turns calls delegate function to pass on selection to parent.
- (void)selectionDidComplete:(id)sender {
    [self.delegate filtersSelected];
    [super selectionDidComplete:sender];
}

//Returns string entered in text field.
- (NSString *)hotelNameFilterValue {
    return self.filterHotelName.text;
}

//Returns distance filter value
- (NSNumber *)distanceFromSelectedLocationFilterValue {
    return [NSNumber numberWithInteger:[self.filterDistance selectedSegmentIndex]];
}

//Returns set rating value
- (NSNumber *)starRatingFilterValue {
    return [NSNumber numberWithInteger:[self.filterStar selectedSegmentIndex]];
}

//Returns price value.
- (NSNumber *)priceFilterValue {
    return [NSNumber numberWithInteger: [self.filterPrice selectedSegmentIndex]];
}

@end

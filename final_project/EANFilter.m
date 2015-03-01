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

- (instancetype)initWithFrame:(CGRect)frame forTarget:(UIView *)parentView withReferenceFrameToolBarHeight:(CGFloat)toolbarHeight {
    self = [super initWithFrame:frame forTarget:parentView withReferenceFrameToolBarHeight:toolbarHeight];
    return self;
}

- (void)showAnimated {
    //Could not be called from init as delegate is required for this function & delegation connection is done afterwards.
    [self addFilters];
    [super showAnimated];
}

- (void) addFilters {
    UIEdgeInsets insets = UIEdgeInsetsMake(7, 7, 7, 7);
    CGFloat marginBetweenFilters = 7;
    CGRect parentFrame = self.frame;
    CGFloat heightOfComponent = (parentFrame.size.height - (insets.top + insets.bottom))/4.0 - 2*marginBetweenFilters;
    
    CGRect frame = CGRectMake(insets.left, self.tabBarHeight + insets.top, parentFrame.size.width - (insets.left+insets.right), heightOfComponent);
    
    //Adding elements in sequential order
    //Component 1 - Hotel Name Filter
    self.filterHotelName = [[UITextField alloc] initWithFrame:frame];
    [self.filterHotelName setPlaceholder:@"Filter By Hotel Name"];
    [self.filterHotelName setBorderStyle:UITextBorderStyleRoundedRect];
    frame.origin.y += heightOfComponent + marginBetweenFilters;
    
    NSDictionary *normalStateTextAttributes = @{NSFontAttributeName:[UIFont fontWithName:@"Arial" size:20.0]};
    NSDictionary *highlightedStateTextAttributes = @{NSFontAttributeName:[UIFont fontWithName:@"Arial" size:20.0], NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    //Component 2 - Distance
    self.filterDistance = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"2.5", @"7.5", @"All", nil]];
    [self.filterDistance setFrame:frame];
    [self.filterDistance setSelectedSegmentIndex:UISegmentedControlSegmentRight];
    [self.filterDistance setTitleTextAttributes:normalStateTextAttributes forState:UIControlStateNormal];
    [self.filterDistance setTitleTextAttributes:highlightedStateTextAttributes forState:UIControlStateSelected];

    frame.origin.y += heightOfComponent + marginBetweenFilters;

    //Component 3 - Star
    self.filterStar = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"4", @"5", @"All", nil]];
    [self.filterStar setFrame:frame];
//    [self.filterStar setSelectedSegmentIndex:2];
    [self.filterStar setTitleTextAttributes:normalStateTextAttributes forState:UIControlStateNormal];
    [self.filterStar setTitleTextAttributes:highlightedStateTextAttributes forState:UIControlStateSelected];

    frame.origin.y += heightOfComponent + marginBetweenFilters;
    
    //Component 4 - Price
    self.filterPrice = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"$$", @"$$$", @"All", nil]];
    [self.filterPrice setFrame:frame];
//    [self.filterPrice setSelectedSegmentIndex:2];
    [self.filterPrice setTitleTextAttributes:normalStateTextAttributes forState:UIControlStateNormal];
    [self.filterPrice setTitleTextAttributes:highlightedStateTextAttributes forState:UIControlStateSelected];

    
    //Add all components to pop over view
    [self addSubview:self.filterHotelName];
    [self addSubview:self.filterDistance];
    [self addSubview:self.filterStar];
    [self addSubview:self.filterPrice];
}

//This function called when selection completed.
- (void)selectionDidComplete:(id)sender {
    [self.delegate filtersSelected];
    [super selectionDidComplete:sender];
}

- (NSString *)hotelNameFilterValue {
    return self.filterHotelName.text;
}

- (NSInteger)distanceFromSelectedLocationFilterValue {
    return [self.filterDistance selectedSegmentIndex];
}

- (NSInteger)starRatingFilterValue {
    return [self.filterStar selectedSegmentIndex];
}

- (NSInteger)priceFilterValue {
    return [self.filterPrice selectedSegmentIndex];
}

@end

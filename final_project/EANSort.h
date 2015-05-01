//
//  EANSort.h
//  popover_iphone
//
//  Created by iOS on 2/28/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

/*
 This method provides users with output sorting options.
 Currently, supported sorting options are:
 a. Popularity
 b. Price
 c. Distance
*/
#import "EANPopOver.h"

@protocol EANSortDelegate <EANPopoverDelegate>

- (void)sortCriteriaSelected;
- (NSString *)getCurrentSortCriteria;

@end

//This class requires two icons radio button behavior
@interface EANSort : EANPopOver <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) id <EANSortDelegate> delegate;

- (NSString *)sortCriteria;
@end

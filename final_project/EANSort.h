//
//  EANSort.h
//  popover_iphone
//
//  Created by iOS on 2/28/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import "EANPopOver.h"

@protocol EANSortDelegate <NSObject>

- (void)sortCriteriaSelected;
- (NSString *)getCurrentSortCriteria;

@end

//This class requires two icons radio button behavior
@interface EANSort : EANPopOver <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) id <EANSortDelegate> delegate;

- (NSString *)sortCriteria;
@end

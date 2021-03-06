//
//  EANPicker.h
//  popover_iphone
//
//  Created by iOS on 2/28/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import "EANPopOver.h"

@protocol EANPickerDelegate <EANPopoverDelegate>
//required functions - app crashes, if any of those left out.
- (void)selectionCompleteForPicker;
- (NSInteger) getSelectedNumberOfAdults;
- (NSInteger) getSelectedNumberOfChildren;
@end

@interface EANPicker : EANPopOver

@property (nonatomic, weak) id<EANPickerDelegate, UIPickerViewDelegate, UIPickerViewDataSource> delegate;
- (NSInteger)rowSelectedForComponent: (NSInteger)component;
@end

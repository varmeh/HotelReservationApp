//
//  EANPicker.m
//  popover_iphone
//
//  Created by iOS on 2/28/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import "EANPicker.h"

@interface EANPicker ()

@property (nonatomic, strong) UIPickerView *picker;

@end

@implementation EANPicker

@dynamic delegate;

- (instancetype)initWithFrame:(CGRect)frame forTarget:(UIView *)parentView withReferenceFrameToolBarHeight:(CGFloat)toolbarHeight {
    self = [super initWithFrame:frame forTarget:parentView withReferenceFrameToolBarHeight:toolbarHeight];
    return self;
}

- (void)showAnimated {
    //Could not be called from init as delegate is required for this function & delegation connection is done afterwards.
    [self addPickers];
    [super showAnimated];
}

- (void) addPickers {
    UIEdgeInsets insets = UIEdgeInsetsMake(10, 10, 10, 10);
    self.picker = [[UIPickerView alloc] initWithFrame:CGRectMake(insets.left, self.tabBarHeight + insets.top, self.frame.size.width - (insets.left+insets.right), self.frame.size.height - self.tabBarHeight - (insets.top + insets.bottom))];
    
    self.picker.delegate = self.delegate;
    self.picker.dataSource = self.delegate;
    
    [self.picker selectRow:[self.delegate getSelectedNumberOfAdults] inComponent:0 animated:NO];
    [self.picker selectRow:[self.delegate getSelectedNumberOfChildren] inComponent:1 animated:NO];
    
    [self addSubview:self.picker];
}

//This function called when selection completed.
- (void)selectionDidComplete:(id)sender {
    [self.delegate selectionCompleteForPicker];
    [super selectionDidComplete:sender];
}

- (NSInteger)rowSelectedForComponent: (NSInteger)component {
    return [self.picker selectedRowInComponent:component];
}

@end

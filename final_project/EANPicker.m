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

//@dynamic compiler ensures definition synthesis at runtime and is required for delegate overriding.
@dynamic delegate;

//Custom initialization method with similarity to parent.
- (instancetype)initWithFrame:(CGRect)frame forTarget:(UIView *)parentView withReferenceFrameToolBarHeight:(CGFloat)toolbarHeight {
    self = [super initWithFrame:frame forTarget:parentView withReferenceFrameToolBarHeight:toolbarHeight];
    return self;
}

//Add picker views to pop up and displays the animated view.
- (void)showAnimated {
    //Could not be called from init as delegate is required for this function & delegation connection is done afterwards.
    [self addPickers];
    [super showAnimated];
}

//Add picker subviews to pop up.
- (void) addPickers {
    UIEdgeInsets insets = UIEdgeInsetsMake(10, 10, 10, 10);
    
    //Create an instance of UIPicker Class.
    self.picker = [[UIPickerView alloc] initWithFrame:CGRectMake(insets.left, self.tabBarHeight + insets.top, self.frame.size.width - (insets.left+insets.right), self.frame.size.height - self.tabBarHeight - (insets.top + insets.bottom))];
    
    //Set data source & delegate for Picker instance.
    self.picker.delegate = self.delegate;
    self.picker.dataSource = self.delegate;
    
    //Set components of picker
    [self.picker selectRow:[self.delegate getSelectedNumberOfAdults] inComponent:0 animated:NO];
    [self.picker selectRow:[self.delegate getSelectedNumberOfChildren] inComponent:1 animated:NO];
    
    //Adding to subview.
    [self addSubview:self.picker];
}

//This function called when selection completed. It passes on the user selection to it's delegate.
- (void)selectionDidComplete:(id)sender {
    [self.delegate selectionCompleteForPicker];
    [super selectionDidComplete:sender];
}

//Returns user selection for input component number.
- (NSInteger)rowSelectedForComponent: (NSInteger)component {
    return [self.picker selectedRowInComponent:component];
}

@end

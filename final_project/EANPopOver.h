//
//  EANPopOver.h
//  popover_iphone
//
//  Created by iOS on 2/28/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

/*
 This is the base class for filter, sort, guest selection and calender pop up.
 All pop up and selection functionality is common to all above child classes and thus, implemented in this base class.
*/
#import <UIKit/UIKit.h>

@protocol EANPopoverDelegate <NSObject>

- (void)setPopoverToNil;

@end

@interface EANPopOver : UIView <UIToolbarDelegate>

@property NSInteger tabBarHeight;
- (instancetype)initWithFrame:(CGRect)frame forTarget:(UIView *)parentView withReferenceFrameToolBarHeight:(CGFloat)toolbarHeight;
- (void)setTitle: (NSString *)title;
- (void)dismissPopOver;
- (void)showAnimated;

@property(nonatomic, weak) id <EANPopoverDelegate>delegate;

//Override this function in all child classes for delegate implementation.
//Call this super function once delegation completed.
- (IBAction)selectionDidComplete:(id)sender;

@end

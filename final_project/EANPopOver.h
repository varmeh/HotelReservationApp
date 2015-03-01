//
//  EANPopOver.h
//  popover_iphone
//
//  Created by iOS on 2/28/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EANPopOver : UIView <UIToolbarDelegate>

@property NSInteger tabBarHeight;
- (instancetype)initWithFrame:(CGRect)frame forTarget:(UIView *)parentView withReferenceFrameToolBarHeight:(CGFloat)toolbarHeight;
- (void)setTitle: (NSString *)title;
- (void)dismissPopOver;
- (void)showAnimated;

//Override this function in all child classes for delegate implementation.
//Call this super function once delegation completed.
- (IBAction)selectionDidComplete:(id)sender;

@end

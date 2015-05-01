//
//  EANPopOver.m
//  popover_iphone
//
//  Created by iOS on 2/28/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import "EANPopOver.h"

#define HEIGHT_OF_POPOVER_TABBAR        30 //used to determine the height of subview Tabbar.

@interface EANPopOver ()
{
    //Private variables.
    UIBarButtonItem *barTitle;
    UIView *popOverMainScreenView;
    EANPopOver *popoverView;
}
//Private methods
- (void)addSelectionBarAtTop;
@end

@implementation EANPopOver

//Custom initialization method for all it's subclasses.
//Pending - Blur effect. Add to popOverMainScreenView.
- (instancetype)initWithFrame:(CGRect)frame forTarget:(UIView *)parentView withReferenceFrameToolBarHeight:(CGFloat)toolbarHeight{
    //All pop up would be from bottom of screen. So, Y of pop up should be height of pop up + toolbarHeihght subtracted from parent view frame.
    CGRect popoverFrame = CGRectMake(frame.origin.x, parentView.frame.size.height - (frame.size.height + toolbarHeight + 2), frame.size.width, frame.size.height);
    
    //Initializing pop over view.
    popoverView = [self initWithFrame:popoverFrame];

    //Adding a empty view layer between main view & subview.
    //This ensures that all events are captured and managed by child and not passed on directly to view at the back.
    popOverMainScreenView = [[UIView alloc] initWithFrame:CGRectMake(parentView.frame.origin.x, parentView.frame.origin.y, parentView.frame.size.width, parentView.frame.size.height - toolbarHeight)];
    [popOverMainScreenView addSubview:popoverView];
    
    [parentView addSubview:popOverMainScreenView];
    
    //Adding Tap Gesture to layer view. It provides functionality for removal pop up on screen touch.
    UITapGestureRecognizer *dismissPopover = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissPopOver)];
    dismissPopover.numberOfTapsRequired = 1;
    dismissPopover.numberOfTouchesRequired = 1;
    [popOverMainScreenView addGestureRecognizer:dismissPopover];
    
    return popoverView;
}

//Standard initialization method with custom initialization.
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSelectionBarAtTop];
        [self setOpaque:YES];
        [self setAlpha:0.0];
        [self.layer setBorderColor:[UIColor blueColor].CGColor];
        [self.layer setBorderWidth:0.5];
    }
    return self;
}

- (void)addSelectionBarAtTop {
    
    //Adding toolbar to top of popover window
    [self setTabBarHeight:HEIGHT_OF_POPOVER_TABBAR];
    UIToolbar *bar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.tabBarHeight)];
    bar.delegate = self;
    
    //add components to toolbar
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"checkmark"] style:UIBarButtonItemStylePlain target:self action:@selector(selectionDidComplete:)];
    
    barTitle = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    
    [bar setItems:[NSArray arrayWithObjects:barTitle, flexibleSpace, btnDone, nil]];
    
    [self addSubview:bar];
}

//UIToolbar delegate function
- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar {
    return UIBarPositionTop;
}

- (IBAction)selectionDidComplete:(id)sender {
    [self dismissPopOver];
}

//Set title of Popover View
- (void)setTitle: (NSString *)title {
    [barTitle setTitle: title];
}

- (void)dismissPopOver {
    //Block call with UIView animateWithDuration removed as it's async by design. So, thread will move to creation of new pop overs even before previous popover is removed leading to zombies
    //Fix - Used sync dispatch call or semaphore or remove it, if not necessary.
    [self setAlpha:0.0];
    [popoverView removeFromSuperview];
    [popOverMainScreenView removeFromSuperview];
    [self.delegate setPopoverToNil];
}

//displays pop up with animation.
- (void)showAnimated {
    [UIView animateWithDuration:0.2 animations:^{
        [self setAlpha:1.0];
    }];
}

@end

//
//  EANPopOver.m
//  popover_iphone
//
//  Created by iOS on 2/28/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import "EANPopOver.h"

#define HEIGHT_OF_POPOVER_TABBAR        30
@interface EANPopOver ()
{
    UIBarButtonItem *barTitle;
}

- (void)addSelectionBarAtTop;
@end


@implementation EANPopOver

- (instancetype)initWithFrame:(CGRect)frame forTarget:(UIView *)parentView withReferenceFrameToolBarHeight:(CGFloat)toolbarHeight{
    CGRect popoverFrame = CGRectMake(frame.origin.x, parentView.frame.size.height - (frame.size.height + toolbarHeight + 2), frame.size.width, frame.size.height);
    return [self initWithFrame:popoverFrame];
}

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

- (void)setTitle: (NSString *)title {
    [barTitle setTitle: title];
}

- (void)dismissPopOver {
    [UIView animateWithDuration:0.3 animations:^{
        [self setAlpha:0.0];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)showAnimated {
    [UIView animateWithDuration:0.3 animations:^{
        [self setAlpha:1.0];
    }];
}

@end

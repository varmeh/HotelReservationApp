//
//  EANAutoCompleteView.h
//  popover_iphone
//
//  Created by iOS on 3/1/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//
/*
 This class provides user autocomplete feature for location input using Google location services.
*/
#import <UIKit/UIKit.h>

@protocol EANAutoCompleteViewDelegate <NSObject>

- (NSArray *)autocompleteResults;
- (void)userSelectedAutoCompleteResult:(NSString *)string;

@end

@interface EANAutoCompleteView : UIView <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) id <EANAutoCompleteViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame forTarget:(UIView *)parentView;
- (void)reloadAutoCompleteData;

@end

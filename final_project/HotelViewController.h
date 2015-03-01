//
//  HotelViewController.h
//  final_project
//
//  Created by iOS on 2/25/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EANPicker.h"
#import "EANFilter.h"

@interface HotelViewController : UIViewController <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, EANPickerDelegate, EANFilterDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollBarOutlet;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBarHotelScreenOutlet;

@end

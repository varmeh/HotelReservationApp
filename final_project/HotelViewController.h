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
#import "EANSort.h"
#import "EANAutoCompleteView.h"
#import "EANCalendar.h"
#import "DecodingLocationAutoCompleteData.h"

@interface HotelViewController : UIViewController <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, EANPickerDelegate, EANFilterDelegate, EANSortDelegate, EANAutoCompleteViewDelegate, EANCalendatDelegate, DecodingLocationAutoCompleteDataDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollBarOutlet;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBarHotelScreenOutlet;

@end

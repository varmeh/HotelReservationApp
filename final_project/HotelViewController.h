//
//  HotelViewController.h
//  final_project
//
//  Created by iOS on 2/25/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HotelViewController : UIViewController <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollBarOutlet;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBarHotelScreenOutlet;

@end

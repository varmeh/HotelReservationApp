//
//  HotelViewController.m
//  final_project
//
//  Created by iOS on 2/25/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import "HotelViewController.h"
#import <MapKit/MapKit.h>

@interface HotelViewController ()
{
    BOOL isMapView;
}

@end

@implementation HotelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isMapView = NO;
    
    [self addChildToNavigationBar];
    [self addChildToToolBar];
    
    //Adding table & map view to scroll bar
    CGRect frame = self.view.frame;
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    
    MKMapView *mapView = [[MKMapView alloc] initWithFrame:CGRectMake(frame.size.width, 0, frame.size.width, frame.size.height)];
    
    //add table & map view to scroll bar.
    [self.scrollBarOutlet setContentSize:CGSizeMake(frame.size.width, frame.size.height)];
    [self.scrollBarOutlet addSubview:tableView];
    [self.scrollBarOutlet addSubview:mapView];
    
    //Customize scrollbar
    [self.scrollBarOutlet setShowsHorizontalScrollIndicator:NO];
    [self.scrollBarOutlet setAlwaysBounceVertical:YES];
    [self.scrollBarOutlet setKeyboardDismissMode:UIScrollViewKeyboardDismissModeOnDrag];
}

- (void) addChildToNavigationBar {
    //Adding search bar to navigation bar
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(-5.0, 0.0, 200, 44)];
    searchBar.delegate = self;
    //Customize search bar
    searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    searchBar.placeholder = @"Location";
    searchBar.searchBarStyle = UISearchBarStyleMinimal;
    searchBar.tintColor = [UIColor blueColor];
    
    //add button for date picker
    UIBarButtonItem *calender = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"calendar"] style:UIBarButtonItemStylePlain target:self action:@selector(displayCalendar)];
    
    UIBarButtonItem *people = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"user_male_filled"] style:UIBarButtonItemStylePlain target:self action:@selector(selectNoOfUsers)];
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:people, calender, nil];
    self.navigationItem.titleView = searchBar;
    
}

- (void) addChildToToolBar {
    //Adding items to toolbar
    UIBarButtonItem *sort = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"generic_sorting"] style:UIBarButtonItemStylePlain target:self action:@selector(showSortView)];
    
    UIBarButtonItem *filter = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"filter"] style:UIBarButtonItemStylePlain target:self action:@selector(showFilterView)];
    
    UIBarButtonItem *toggleDataView = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"geo_fence"] style:UIBarButtonItemStylePlain target:self action:@selector(toggleMainView)];
    
    //UIBarButtonSystemItemFlexibleSpace is used to evenly place items on a tool bar. Check their addition in toolBarHotelScreenOutlet.
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    [self.toolBarHotelScreenOutlet setItems:[NSArray arrayWithObjects: flexibleSpace, sort, flexibleSpace, filter, flexibleSpace, toggleDataView, flexibleSpace, nil]];

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"hotelCell" forIndexPath:indexPath];
    
    return cell;
}



- (void)displayCalendar {
    
}

- (void)selectNoOfUsers {
    
}

- (void)showSortView {
    
}

- (void) showFilterView {
    
}

- (void) toggleMainView {
    //The change in content size ensures no horizontal dragging from table view to map view.
    //draging in map view anyways result in moving to new areas.
    if (isMapView) {
        [self.scrollBarOutlet setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)];
        [self.scrollBarOutlet setContentOffset:CGPointMake(0, 0) animated:YES];
    } else {
        [self.scrollBarOutlet setContentSize:CGSizeMake(self.view.frame.size.width*2, self.view.frame.size.height)];
        [self.scrollBarOutlet setContentOffset:CGPointMake(self.view.frame.size.width, 0) animated:YES];
    }
    isMapView = !isMapView;
}
@end

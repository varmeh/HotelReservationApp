//
//  HotelViewController.m
//  final_project
//
//  Created by iOS on 2/25/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import "HotelViewController.h"

@implementation HotelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    return 10;
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
    
}
@end

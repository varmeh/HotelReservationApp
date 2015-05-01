//
//  HotelViewController.m
//  final_project
//
//  Created by iOS on 2/25/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import "HotelViewController.h"
#import <MapKit/MapKit.h>
#import "HotelTableViewCell.h"
#import <AFNetworking.h>

@interface HotelViewController ()
{
    BOOL isMapView;
    NSArray *guestList;
    UISearchBar *searchBar;
    NSString *autocompleteBaseURL;
    NSDictionary *jsonAutocompleteData;
    EANAutoCompleteView *searchTable;
}

//Storage for adult selection
@property NSInteger numberOfAdults;
@property NSInteger numberOfChildren;

//Storage for filter results
@property (nonatomic) NSString *filterHotelName;
@property NSNumber *filterDistance;
@property NSNumber *filterStar;
@property NSNumber *filterPrice;

//Storage for sort criteria
@property (nonatomic) NSString *sortCriteria;

//Base Popover class reference for accessing popover subclasses - EANSort, EANFilter, EANCalendar & EANPicker
@property (nonatomic, strong) EANPopOver *popover;

//Storage for all hotels returned by JSON for a place.
@property (nonatomic) NSMutableArray *placeList;

//Private Methods
- (void)displayPopOver;

@end

@implementation HotelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isMapView = NO; //Default view is list view. User could switch between list and map views of hotels.
    
    //Configure Navigation bar with Search Bar, Dates Selection and Guest Selection Button
    [self addChildToNavigationBar];
    
    //Add Sort, Filter and Map/List Toggle buttons to Tools bar
    [self addChildToToolBar];
    
    //Add Map and List view to scroll bar of main screen. User could see results either as a table or annotations in maps.
    [self addChildViewToScrollbar];
    
    //Data Source for Picker View. It provides input for guest selection.
    guestList = [NSArray arrayWithObjects:@[@"1 Adult", @"2 Adults", @"3 Adults", @"4 Adults"], @[@"NO Child", @"1 Child", @"2 Children", @"3 Children", @"4 Children"], nil];
    
    //EAN Base URL for accessing hotel informtaion
    autocompleteBaseURL = @"https://maps.googleapis.com/maps/api/place/autocomplete/json?key=AIzaSyDBH36zCQWUjSm6ZqlEwW7lPmaOeAgIfr8&input=";
    
    //Configuring base variables.
    jsonAutocompleteData = [NSDictionary new];
    self.placeList = [NSMutableArray new];
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat navigationBarHeight = self.navigationController.navigationBar.frame.size.height;
    
    //Configuring search table. It displays results for location auto complete, just below search view in navigation bar using Google Location Service.
    searchTable = [[EANAutoCompleteView alloc] initWithFrame:CGRectMake(10, statusBarHeight + navigationBarHeight, 200, 200) forTarget:self.view];
    searchTable.delegate = self;
    [self.view addSubview:searchTable];
    
    //Default value initialization for filters.
    self.filterDistance = @2;
    self.filterStar = @2;
    self.filterPrice = @2;
    
    //Default Value for guest value
    self.numberOfChildren = 0;
    self.numberOfAdults = 1;
    
    //Setting default criteria for sorting
    self.sortCriteria = @"Popularity";
}

/*  
 Main View Configuration for 1st Screen
 Main View has scroll view as a base with table and maps as components.
 Users would either see all options in table or map annotations.
 Table View is set as default view.

 V2 update - Planned & Pending - Defualt view could be added to configuration plist in next phase.
*/
- (void)addChildViewToScrollbar {
    //Configuring table view to scroll bar
    CGRect frame = self.view.frame;
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    
    //register table view cell
    [tableView registerNib:[UINib nibWithNibName:@"HotelTableViewCell" bundle:nil] forCellReuseIdentifier:@"hotelCell"];
    
    //Configure map view
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

/*
 Navigation Bar Configuration.
 Components:
 a. Search bar - User could search location on basis on name. Search facilitated by autocomplete feature which displays all results in a table.
                 Any time, at max, 5 results are displayed. Google Location service is used for this feature.
 b. Date Selector - Displays an instance of EANCalender on click.
 c. Guest Selector - Displays an instance of EANPicker on click. It allows user to select number of guest.
*/
- (void) addChildToNavigationBar {
    //Adding search bar to navigation bar
    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(-5.0, 0.0, 200, 44)];
    searchBar.delegate = self;
    
    //Customize search bar
    searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    searchBar.placeholder = @"Location";
    searchBar.searchBarStyle = UISearchBarStyleMinimal;
    searchBar.tintColor = [UIColor blueColor];
    
    //add button for date picker
    UIBarButtonItem *calender = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"calendar"] style:UIBarButtonItemStylePlain target:self action:@selector(displayCalendar:)];
    
    //add button for people selection
    UIBarButtonItem *people = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"user_male_filled"] style:UIBarButtonItemStylePlain target:self action:@selector(selectNoOfUsers:)];
    
    //add people and calender as navigation bar right buttons
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:people, calender, nil];
    self.navigationItem.titleView = searchBar;
    
}

/*
 Tool Bar Components:
 a. Sort button - Pop up an instance of EANSort. User could then sort results accordingly.
 b. Filter button - Pop up instance of EANFilter. User could use this to filter the results on basis of multiple inputs.
 c. Toggle button - Toggles results in main view between table and map view. Scroll bar acts as a base for toggling.
*/
- (void) addChildToToolBar {
    //Configure sort button
    UIBarButtonItem *sort = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"generic_sorting"] style:UIBarButtonItemStylePlain target:self action:@selector(showSortView:)];
    
    //Configure filter button
    UIBarButtonItem *filter = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"filter"] style:UIBarButtonItemStylePlain target:self action:@selector(showFilterView:)];
    
    //Configure toggle button
    UIBarButtonItem *toggleDataView = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"map_marker"] style:UIBarButtonItemStylePlain target:self action:@selector(toggleMainView:)];
    
    //UIBarButtonSystemItemFlexibleSpace is used to evenly place items on a tool bar. Check their addition in toolBarHotelScreenOutlet.
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    //Configuring Tool bar by adding components to childbar.
    [self.toolBarHotelScreenOutlet setItems:[NSArray arrayWithObjects: flexibleSpace, sort, flexibleSpace, filter, flexibleSpace, toggleDataView, flexibleSpace, nil]];
}

/* Methods specific to Hotel Table View - Main View. */

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HotelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"hotelCell" forIndexPath:indexPath];
    
    //Customizing Cell Color on selection
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor colorWithRed:0.0 green:122.0 blue:255.0 alpha:0.0];
    [cell setSelectedBackgroundView:bgColorView];
    return cell;
}

//This function ensures custom height for each row.
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 85.0;
}

//Performs segue to detail view
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"segueHotelDetail" sender:self];
}

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if ([[segue identifier] isEqualToString:@"segueHotelDetail"]) {
//        [segue.destinationViewController setTitle:@"Hotel"];
//    }
//}

/*
 This method toggles between Table View & map view on 1st screen.
 In table, all results are displayed in sorted, filtered fashion as rows.
 In map, all results are displayed as annotations.
*/
- (IBAction)toggleMainView:(UIBarButtonItem *)sender {
    //The change in content size ensures no horizontal dragging from table view to map view.
    //draging in map view anyways result in moving to new areas.
    if (isMapView) {
        //Current view is map view. Changing it to list view.
        [self.scrollBarOutlet setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)];
        [self.scrollBarOutlet setContentOffset:CGPointMake(0, 0) animated:YES];
        [sender setImage:[UIImage imageNamed:@"map_marker"]]; //changing button image in tool bar to Map
    } else {
        //Moving to map view.
        
        //Remove popover if any as sorting, filtering etc. do not work in map view.
        [self.popover dismissPopOver];
        
        [self.scrollBarOutlet setContentSize:CGSizeMake(self.view.frame.size.width*2, self.view.frame.size.height)];
        [self.scrollBarOutlet setContentOffset:CGPointMake(self.view.frame.size.width, 0) animated:YES];
        [sender setImage:[UIImage imageNamed:@"align_justify"]]; //changing button image in tool bar to List
    }
    //Toggling the flag. This flag acts as identifier for current view.
    isMapView = !isMapView;
}

/* Method related to Popovers */

/*
 This displays calender for date selection on clicking dates button in navigation bar.
 
 It checks if some popover already exist, removes that first.
 Then it creates an instance of EANCalender and displays it.
 
 Assumptions:
 a. No popover in map view. To ensure that it first checks for flag - isMapView and if it is true, it returns immediately.
*/
- (IBAction)displayCalendar:(id)sender {
    //In mapview, do not display any popovers
    if (isMapView)
        return;
    
    //If some other popover exist, remove that first.
    if (self.popover)
        [self.popover dismissPopOver];
    
    //Create an instance of EANCalender to an property of it's superclass.
    self.popover = [[EANCalendar alloc] initWithFrame:CGRectMake(40, 0, self.view.frame.size.width-80, 300) forTarget:self.view withReferenceFrameToolBarHeight:42.0];
    ((EANCalendar *)self.popover).delegate = self;
    [self.popover setTitle:@"Select Dates"];

    //Pop up calendar.
    [self displayPopOver];
}

- (void)datesSelected:(NSDate *)checkIn withCheckOutDate:(NSDate *)checkOut {
    //Set dates accordingly
}

//-------Method related to Picker View for Adult selection------//
- (IBAction)selectNoOfUsers:(id)sender {
    //In mapview, do not display any popovers
    if (isMapView)
        return;

    //If some other popover exist, remove that first.
    if (self.popover)
        [self.popover dismissPopOver];

    //Create an instance of EANPicker to an property of it's superclass.
    self.popover = [[EANPicker alloc] initWithFrame:CGRectMake(40, 0, self.view.frame.size.width-80, 300) forTarget:self.view withReferenceFrameToolBarHeight:42.0];
    ((EANPicker *)self.popover).delegate = self;
    [self.popover setTitle:@"Guest Selection"];

    //Pop up selection view.
    [self displayPopOver];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [[guestList objectAtIndex:component] count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [[guestList objectAtIndex:component] objectAtIndex:row];
}

//this is a delegate function and outputs the user selection to property values
- (void)selectionCompleteForPicker {
    self.numberOfAdults = [((EANPicker *)self.popover) rowSelectedForComponent:0] + 1;
    self.numberOfChildren = [((EANPicker *)self.popover) rowSelectedForComponent:1];
}

//Input delegate function - Used to show previous selection
- (NSInteger)getSelectedNumberOfAdults {
    return self.numberOfAdults-1;
}
//Input delegate function - used to show previous selection when it pop ups.
- (NSInteger)getSelectedNumberOfChildren {
    return self.numberOfChildren;
}

//-------Method related to Sorting of Hotel Information------//
/*
 This pop ups sort view to user.
 User could sort on basis of following choices:
 a. Price
 b. Popularity
 c. Distance
*/
- (IBAction)showSortView:(id)sender {
    //In mapview, do not display any popovers
    if (isMapView)
        return;
    
    //If some other popover exist, remove that first.
    if (self.popover)
        [self.popover dismissPopOver];
    
    //Create an instance of EANSort to an property of it's superclass.
    self.popover = [[EANSort alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 250)/2, 0, 150, 150) forTarget:self.view withReferenceFrameToolBarHeight:42.0];
    self.popover.delegate = self;
    [self.popover setTitle:@"Sort Hotels"];
    
    [self displayPopOver];
}

//Output delegate method for sort view. Returns the user selection.
- (void)sortCriteriaSelected {
    self.sortCriteria = [(EANSort *)self.popover sortCriteria];
}

//Input delegate methode for sort view. Provides input to display user the current sort criteria.
- (NSString *)getCurrentSortCriteria {
    return self.sortCriteria;
}

//-------Method related to Filtering of Hotel Information------//
/*
 Selector for filter button in tool bar. Pops up filter view.
 It creates a instance of filter view with following filter selection:
 a. Name
 b. Distance
 c. Ratings
 d. Price Range
 All the hotels which satisfy all filter values will be displayed.
 Filter combinations could led to no match.
*/
- (IBAction)showFilterView:(id)sender {
    //In mapview, do not display any popovers
    if (isMapView)
        return;
    
    //It some other pop up exist, remove that first.
    if (self.popover)
        [self.popover dismissPopOver];

    //Create an instance of EANFilter to an property of it's superclass.
    self.popover = [[EANFilter alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 250)/2, 0, 250, 250) forTarget:self.view withReferenceFrameToolBarHeight:42.0];
    ((EANFilter *)self.popover).delegate = self;
    [self.popover setTitle:@"Filter Hotels"];
    
    //Pop up filter view.
    [self displayPopOver];
}

//Output Delegate method for filters.
- (void)filtersSelected {
    self.filterHotelName = [((EANFilter *)self.popover) hotelNameFilterValue];
    self.filterStar = [((EANFilter *)self.popover) starRatingFilterValue];
    self.filterDistance = [((EANFilter *)self.popover) distanceFromSelectedLocationFilterValue];
    self.filterPrice = [((EANFilter *)self.popover) priceFilterValue];
}

//Input Delegate method to get current values.
- (NSArray *)getCurrentFilterValues{
    return [NSArray arrayWithObjects:self.filterDistance, self.filterStar, self.filterPrice, nil];
}

//----------- Method for managing display popovers -----------//
//This is common functionality to all pop ups and thus, refactored into a comman location.
- (void)displayPopOver {
    //Make pop up a sub view of current view.
    [self.view addSubview:self.popover];
    
    //Customizing background color of pop up to white.
    [self.popover setBackgroundColor:[UIColor whiteColor]];
    
    //Displaying pop up animated
    [self.popover showAnimated];
}

//This is done to resign the ownership of current pop up. That way, it's allocation counter would become 0 and thus, would be deallocated from object graph.
-(void)setPopoverToNil{
    self.popover = nil;
}

//-------Method related to Search & AutoComplete------//

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSString *searchURL = [autocompleteBaseURL stringByAppendingString:searchText];
    
    // this line of code avoids invalid parameter url string
    NSString *encoded = [searchURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:encoded parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        jsonAutocompleteData = (NSDictionary *)responseObject;
        [self parseAutoCompleteData];
    }failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",[error localizedDescription]);
    }];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
}

- (void) parseAutoCompleteData {
    [self.placeList removeAllObjects];
    for (NSDictionary *place in jsonAutocompleteData[@"predictions"]) {
        NSString *newPlace = place[@"description"];
        [self.placeList addObject:newPlace];
    }
    [searchTable reloadAutoCompleteData];
}

- (NSArray *)autocompleteResults {
    return [self.placeList copy];
}

- (void)userSelectedAutoCompleteResult:(NSString *)string {
    [searchBar setText:string];
    
    //Add search request here.
}
@end

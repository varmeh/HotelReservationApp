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

@property NSInteger numberOfAdults;
@property NSInteger numberOfChildren;

@property (nonatomic) NSString *filterHotelName;
@property NSNumber *filterDistance;
@property NSNumber *filterStar;
@property NSNumber *filterPrice;

@property (nonatomic) NSString *sortCriteria;

@property (nonatomic, strong) EANPopOver *popover;

@property (nonatomic) NSMutableArray *placeList;

//Private Methods
- (void)displayPopOver;

@end

@implementation HotelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isMapView = NO;
    
    [self addChildToNavigationBar];
    [self addChildToToolBar];
    [self addChildViewToScrollbar];
    
    guestList = [NSArray arrayWithObjects:@[@"1 Adult", @"2 Adults", @"3 Adults", @"4 Adults"], @[@"NO Child", @"1 Child", @"2 Children", @"3 Children", @"4 Children"], nil];
    
    autocompleteBaseURL = @"https://maps.googleapis.com/maps/api/place/autocomplete/json?key=AIzaSyDBH36zCQWUjSm6ZqlEwW7lPmaOeAgIfr8&input=";
    jsonAutocompleteData = [NSDictionary new];
    self.placeList = [NSMutableArray new];
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat navigationBarHeight = self.navigationController.navigationBar.frame.size.height;
    searchTable = [[EANAutoCompleteView alloc] initWithFrame:CGRectMake(10, statusBarHeight + navigationBarHeight, 200, 200) forTarget:self.view];
    searchTable.delegate = self;
    [self.view addSubview:searchTable];
    
    self.filterDistance = @2;
    self.filterStar = @2;
    self.filterPrice = @2;
    
    self.sortCriteria = @"Popularity";
}

- (void)addChildViewToScrollbar {
    //Adding table & map view to scroll bar
    CGRect frame = self.view.frame;
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    //register table view cell
    [tableView registerNib:[UINib nibWithNibName:@"HotelTableViewCell" bundle:nil] forCellReuseIdentifier:@"hotelCell"];
    
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
    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(-5.0, 0.0, 200, 44)];
    searchBar.delegate = self;
    
    //Customize search bar
    searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    searchBar.placeholder = @"Location";
    searchBar.searchBarStyle = UISearchBarStyleMinimal;
    searchBar.tintColor = [UIColor blueColor];
    
    //add button for date picker
    UIBarButtonItem *calender = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"calendar"] style:UIBarButtonItemStylePlain target:self action:@selector(displayCalendar:)];
    
    UIBarButtonItem *people = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"user_male_filled"] style:UIBarButtonItemStylePlain target:self action:@selector(selectNoOfUsers:)];
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:people, calender, nil];
    self.navigationItem.titleView = searchBar;
    
}

- (void) addChildToToolBar {
    //Adding items to toolbar
    UIBarButtonItem *sort = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"generic_sorting"] style:UIBarButtonItemStylePlain target:self action:@selector(showSortView:)];
    
    UIBarButtonItem *filter = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"filter"] style:UIBarButtonItemStylePlain target:self action:@selector(showFilterView:)];
    
    UIBarButtonItem *toggleDataView = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"map_marker"] style:UIBarButtonItemStylePlain target:self action:@selector(toggleMainView:)];
    
    //UIBarButtonSystemItemFlexibleSpace is used to evenly place items on a tool bar. Check their addition in toolBarHotelScreenOutlet.
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    [self.toolBarHotelScreenOutlet setItems:[NSArray arrayWithObjects: flexibleSpace, sort, flexibleSpace, filter, flexibleSpace, toggleDataView, flexibleSpace, nil]];
    
}

//Methods specific to Hotel Table View
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 85.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"segueHotelDetail" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"segueHotelDetail"]) {
        [segue.destinationViewController setTitle:@"Hotel"];
    }
}

//Method related to Popovers
- (IBAction)displayCalendar:(id)sender {
    
}

//-------Method related to Picker View for Adult selection------//
- (IBAction)selectNoOfUsers:(id)sender {
    if (self.popover)
        [self.popover dismissPopOver];
    
    self.popover = [[EANPicker alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width-20, 300) forTarget:self.view withReferenceFrameToolBarHeight:42.0];
    ((EANPicker *)self.popover).delegate = self;
    self.popover.popoverDelegate = self;
    [self.popover setTitle:@"Pick Guest Number"];
    
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

- (void)selectionCompleteForPicker {
    self.numberOfAdults = [((EANPicker *)self.popover) rowSelectedForComponent:0] + 1;
    self.numberOfChildren = [((EANPicker *)self.popover) rowSelectedForComponent:1];
}

//-------Method related to Sorting of Hotel Information------//
- (IBAction)showSortView:(id)sender {
    if (self.popover)
        [self.popover dismissPopOver];
        
    self.popover = [[EANSort alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 250)/2, 0, 150, 150) forTarget:self.view withReferenceFrameToolBarHeight:42.0];
    ((EANSort *)self.popover).delegate = self;
    self.popover.popoverDelegate = self;
    
    [self displayPopOver];
}

- (void)sortCriteriaSelected {
    self.sortCriteria = [(EANSort *)self.popover sortCriteria];
}

- (NSString *)getCurrentSortCriteria {
    return self.sortCriteria;
}
//-------Method related to Filtering of Hotel Information------//
- (IBAction)showFilterView:(id)sender {
    if (self.popover)
        [self.popover dismissPopOver];
    
    self.popover = [[EANFilter alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 250)/2, 0, 250, 250) forTarget:self.view withReferenceFrameToolBarHeight:42.0];
    ((EANFilter *)self.popover).delegate = self;
    self.popover.popoverDelegate = self;
    
    [self displayPopOver];
}

- (void)filtersSelected {
    self.filterHotelName = [((EANFilter *)self.popover) hotelNameFilterValue];
    self.filterStar = [((EANFilter *)self.popover) starRatingFilterValue];
    self.filterDistance = [((EANFilter *)self.popover) distanceFromSelectedLocationFilterValue];
    self.filterPrice = [((EANFilter *)self.popover) priceFilterValue];
}

- (NSArray *)getCurrentFilterValues{
    return [NSArray arrayWithObjects:self.filterDistance, self.filterStar, self.filterPrice, nil];
}

- (IBAction)toggleMainView:(UIBarButtonItem *)sender {
    //The change in content size ensures no horizontal dragging from table view to map view.
    //draging in map view anyways result in moving to new areas.
    if (isMapView) {
        [self.scrollBarOutlet setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)];
        [self.scrollBarOutlet setContentOffset:CGPointMake(0, 0) animated:YES];
        [sender setImage:[UIImage imageNamed:@"map_marker"]];
    } else {
        [self.scrollBarOutlet setContentSize:CGSizeMake(self.view.frame.size.width*2, self.view.frame.size.height)];
        [self.scrollBarOutlet setContentOffset:CGPointMake(self.view.frame.size.width, 0) animated:YES];
        [sender setImage:[UIImage imageNamed:@"align_justify"]];
    }
    isMapView = !isMapView;
}

//----------- Method for managing display popovers -----------//
- (void)displayPopOver {
    [self.view addSubview:self.popover];
    
    [self.popover setBackgroundColor:[UIColor whiteColor]];
    [self.popover showAnimated];
}

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

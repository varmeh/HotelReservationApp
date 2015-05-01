//
//  EANSort.m
//  popover_iphone
//
//  Created by iOS on 2/28/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import "EANSort.h"

@interface EANSort ()

@property (nonatomic, strong) NSArray *sortOptions;
@property CGFloat cellHeight;
@property (nonatomic, strong) UITableView *table;

@property NSInteger currentSelectedRow;
@end

@implementation EANSort

//Ensure runtime synthesis of subclass delegate to avoid collision with parent superclass.
@dynamic delegate;

//Custom initializer.
- (instancetype)initWithFrame:(CGRect)frame forTarget:(UIView *)parentView withReferenceFrameToolBarHeight:(CGFloat)toolbarHeight {
    self = [super initWithFrame:frame forTarget:parentView withReferenceFrameToolBarHeight:toolbarHeight];
    return self;
}

//Configures and displays pop up.
- (void)showAnimated {
    //Could not be called from init as delegate is required for this function & delegation connection is done afterwards.
    self.sortOptions = [NSArray arrayWithObjects:@"Popularity", @"Price", @"Distance", nil];
    self.currentSelectedRow = 0;
    [self addSortOptions];
    [super showAnimated];
}

//Configure pop up for sorting.
//As no radio button exists as UIKit components, Custom Radio Buttons created using UITableView.
- (void)addSortOptions {
    //Creating a table view.
    self.table = [[UITableView alloc] initWithFrame:CGRectMake(0, self.tabBarHeight, self.frame.size.width, self.frame.size.height-self.tabBarHeight) style:UITableViewStylePlain];
    self.table.delegate = self;
    self.table.dataSource = self;
    
    //Add it to pop up.
    [self addSubview:self.table];
    self.cellHeight = (self.frame.size.height-self.tabBarHeight)/[self.sortOptions count];

    //Customize table to ensure it's feel as radio button.
    [self.table setShowsVerticalScrollIndicator:NO];
    [self.table setScrollEnabled:NO];
    [self.table setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    //Current Selected Row
    self.currentSelectedRow = [self.sortOptions indexOfObject:[self.delegate getCurrentSortCriteria]];
}

//This function called when selection completed and passes on new sort criteria to user.
- (void)selectionDidComplete:(id)sender {
    [self.delegate sortCriteriaSelected];
    [super selectionDidComplete:sender];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.frame = CGRectMake(0, self.cellHeight*indexPath.row, self.frame.size.width, self.cellHeight);
    [cell.textLabel setText:[self.sortOptions objectAtIndex:indexPath.row]];

    //While filling cells, check if it's selected. In that case, a filled image would be added to highlight current selection.
    if (self.currentSelectedRow == indexPath.row){
        [cell.imageView setImage:[UIImage imageNamed:@"like_filled"]];
        [tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentSelectedRow inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
    }
    else
        [cell.imageView setImage:[UIImage imageNamed:@"like"]];
    
    
    //Customizing Cell Color
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor colorWithRed:0.0 green:122.0 blue:255.0 alpha:0.0];
    [cell setSelectedBackgroundView:bgColorView];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.sortOptions count];
}

//This table view method ensures custom cell height in all cases.
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.cellHeight;
}

//This table view method unhighlight last selected row.
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell.imageView setImage:[UIImage imageNamed:@"like"]];
}

//This table view method highlights newly selected row by changing image.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell.imageView setImage:[UIImage imageNamed:@"like_filled"]];
}

//Returns selected sort criteria
- (NSString *)sortCriteria {
    UITableViewCell *cell = [self.table cellForRowAtIndexPath:[self.table indexPathForSelectedRow]];
    return cell.textLabel.text;
}   
@end

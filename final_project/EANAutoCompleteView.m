//
//  EANAutoCompleteView.m
//  popover_iphone
//
//  Created by iOS on 3/1/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import "EANAutoCompleteView.h"

@interface EANAutoCompleteView ()

@property (nonatomic) UITableView *table;
@property (nonatomic) NSMutableArray *autocompleteData; //this property acts as data source for table view
@end

@implementation EANAutoCompleteView

//Initialize frame and it's size.
- (instancetype)initWithFrame:(CGRect)frame forTarget:(UIView *)parentView {
    CGRect popoverFrame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
    return [self initWithFrame:popoverFrame];
}

//Overriden base initialization method for custom initialization.
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    //Custom initization.
    if (self) {
        [self setAlpha:0.0];
        [self.layer setBorderColor:[UIColor blueColor].CGColor];
        [self.layer setBorderWidth:0.5];
        [self addAutoCompleteResultsDisplayTable];
    }
    return self;
}

//Results of search would be displayed using a table view
- (void) addAutoCompleteResultsDisplayTable {
    //Initialising table view
    self.table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) style:UITableViewStylePlain];
    self.table.delegate = self;
    self.table.dataSource = self;
    
    //Add table view to main view.
    [self addSubview:self.table];
    
    //Creating empty data source for this table
    self.autocompleteData = [NSMutableArray new];
    
    //Customize table
    [self.table setShowsVerticalScrollIndicator:NO];
    [self.table setScrollEnabled:NO];
    [self.table setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    [cell.textLabel setText:[self.autocompleteData objectAtIndex:indexPath.row]];
    return cell;
}

//this method manages number of visible rows.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    [self.autocompleteData removeAllObjects];
    [self.autocompleteData addObjectsFromArray:[self.delegate autocompleteResults]];
    NSInteger rowCount = [self.autocompleteData count];
    //If no result, hide table
    if (rowCount)
        [self setAlpha:1.0];
    else
        [self setAlpha:0.0];
    return (rowCount > 5 ? 5 : rowCount); //if results are more than 5, show 5 else actual value.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.frame.size.height/5;
}

- (void)reloadAutoCompleteData{
    [self.table reloadData];
}

//Pass on selection to parent using delegate.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.delegate userSelectedAutoCompleteResult:[self.autocompleteData objectAtIndex:[tableView indexPathForSelectedRow].row]];
    [self setAlpha:0.0];
}
@end

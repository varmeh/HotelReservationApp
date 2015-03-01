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

@end

@implementation EANSort

- (instancetype)initWithFrame:(CGRect)frame forTarget:(UIView *)parentView withReferenceFrameToolBarHeight:(CGFloat)toolbarHeight {
    self = [super initWithFrame:frame forTarget:parentView withReferenceFrameToolBarHeight:toolbarHeight];
    return self;
}

- (void)showAnimated {
    //Could not be called from init as delegate is required for this function & delegation connection is done afterwards.
    self.sortOptions = [NSArray arrayWithObjects:@"Popularity", @"Price", @"Distance", nil];
    [self addSortOptions];
    [super showAnimated];
}

- (void)addSortOptions {
    self.table = [[UITableView alloc] initWithFrame:CGRectMake(0, self.tabBarHeight, self.frame.size.width, self.frame.size.height-self.tabBarHeight) style:UITableViewStylePlain];
    self.table.delegate = self;
    self.table.dataSource = self;
    
    [self addSubview:self.table];
    self.cellHeight = (self.frame.size.height-self.tabBarHeight)/[self.sortOptions count];

    //Customize table
    [self.table setShowsVerticalScrollIndicator:NO];
    [self.table setScrollEnabled:NO];
    [self.table setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

//This function called when selection completed.
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
    [cell.imageView setImage:[UIImage imageNamed:@"like"]];
    
    //Customizing Cell Color on selection
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor cyanColor];
    [cell setSelectedBackgroundView:bgColorView];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.sortOptions count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.cellHeight;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell.imageView setImage:[UIImage imageNamed:@"like"]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell.imageView setImage:[UIImage imageNamed:@"like_filled"]];
}

- (NSString *)sortCriteria {
    UITableViewCell *cell = [self.table cellForRowAtIndexPath:[self.table indexPathForSelectedRow]];
    return cell.textLabel.text;
}   
@end

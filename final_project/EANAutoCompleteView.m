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
@property (nonatomic) NSMutableArray *autocompleteData;
@end

@implementation EANAutoCompleteView

- (instancetype)initWithFrame:(CGRect)frame forTarget:(UIView *)parentView {
    CGRect popoverFrame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
    return [self initWithFrame:popoverFrame];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setAlpha:0.0];
        [self.layer setBorderColor:[UIColor blueColor].CGColor];
        [self.layer setBorderWidth:0.5];
        [self addAutoCompleteResultsDisplayTable];
    }
    return self;
}

- (void) addAutoCompleteResultsDisplayTable {
    self.table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) style:UITableViewStylePlain];
    self.table.delegate = self;
    self.table.dataSource = self;
    
    [self addSubview:self.table];
    
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    [self.autocompleteData removeAllObjects];
    [self.autocompleteData addObjectsFromArray:[self.delegate autocompleteResults]];
    NSInteger rowCount = [self.autocompleteData count];
    if (rowCount)
        [self setAlpha:1.0];
    else
        [self setAlpha:0.0];
    return (rowCount > 5 ? 5 : rowCount);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.frame.size.height/5;
}

- (void)reloadAutoCompleteData{
    [self.table reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.delegate userSelectedAutoCompleteResult:[self.autocompleteData objectAtIndex:[tableView indexPathForSelectedRow].row]];
    [self setAlpha:0.0];
}
@end

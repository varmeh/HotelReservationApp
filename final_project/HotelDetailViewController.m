//
//  HotelDetailViewController.m
//  final_project
//
//  Created by iOS on 2/26/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import "HotelDetailViewController.h"

@interface HotelDetailViewController ()

@end

@implementation HotelDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    UILabel *selectionLabel = [[UILabel alloc] init];
//    selectionLabel.text = @"Book";
//    
//    UIButton *selectionButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [selectionButton setImage:[UIImage imageNamed:@"checkmark"] forState:UIControlStateNormal];
//
//    UIView *selectionView = [[UIView alloc] init];
//    [selectionView addSubview:selectionButton];
//    [selectionView addSubview:selectionLabel];
//    
//    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:selectionView];
//    self.navigationItem.rightBarButtonItem = barButton;
    
    UIBarButtonItem *selectedHotel = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"checkmark"] style:UIBarButtonItemStylePlain target:self action:@selector(bookHotel:)];
    self.navigationItem.rightBarButtonItem = selectedHotel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)bookHotel:(id)sender {
    [self performSegueWithIdentifier:@"segueBook" sender:sender];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"segueBook"]) {
        [segue.destinationViewController setTitle:@"Book"];
    }
}

@end

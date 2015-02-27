//
//  HotelDetailViewController.m
//  final_project
//
//  Created by iOS on 2/26/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import "HotelDetailViewController.h"

#define TOP_INSET_FOR_EXTENDED_IMAGES       50
#define NAVIGATION_BAR_DEDEUCTION           64
@interface HotelDetailViewController ()
{
    UIScrollView *imageScroll;
    UIView *imageContainer;
    CGSize imageScrollOriginalSize;
    CGSize imageScrollExtendedSize;
    BOOL isImageScrollBarInOriginalSize;
}
@end

@implementation HotelDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *selectedHotel = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"checkmark"] style:UIBarButtonItemStylePlain target:self action:@selector(bookHotel:)];
    self.navigationItem.rightBarButtonItem = selectedHotel;
    
    //Add image scroll bar
    [self addScrollBarForImageList];
    isImageScrollBarInOriginalSize = YES;
}


- (void)addScrollBarForImageList {
    imageScrollOriginalSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height * (1/3.0));
    imageScrollExtendedSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height-NAVIGATION_BAR_DEDEUCTION);
    
    imageScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_DEDEUCTION, imageScrollOriginalSize.width, imageScrollOriginalSize.height)];
    imageScroll.delegate = self;
    
    //Customize Scrollbar
    [imageScroll setBackgroundColor:[UIColor blueColor]];
    [imageScroll setShowsHorizontalScrollIndicator:NO];
    [imageScroll setShowsVerticalScrollIndicator:NO];
    [imageScroll setPagingEnabled:YES];
    [imageScroll setBounces:NO];
    [imageScroll setAutoresizesSubviews:YES];
    
    //Adding Gestures to ScrollBar
    UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleFingerTapOnImageScroll:)];
    singleFingerTap.numberOfTapsRequired = 1;
    singleFingerTap.numberOfTouchesRequired = 1;
    
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDownImageScroll:)];
    swipeDown.numberOfTouchesRequired = 1;
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;

    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeUpImageScroll:)];
    swipeDown.numberOfTouchesRequired = 1;
    swipeDown.direction = UISwipeGestureRecognizerDirectionUp;

    [imageScroll addGestureRecognizer:singleFingerTap];
    [imageScroll addGestureRecognizer:swipeDown];
    [imageScroll addGestureRecognizer:swipeUp];
    
    //All images will be added to container view. It helps to control image size when zooming images
    imageContainer = [[UIView alloc] initWithFrame:CGRectMake(0, -NAVIGATION_BAR_DEDEUCTION, imageScrollOriginalSize.width, imageScrollOriginalSize.height)];
    [imageContainer setBackgroundColor:[UIColor redColor]];
    //Add code for image array here
    CGRect imageFrame = CGRectMake(0, 0, imageScrollOriginalSize.width, imageScrollOriginalSize.height);
    for (NSInteger i=1 ; i < 2; i++) {
        //?? First line will be replaced by code for image loading
        UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"palace-100"]];
        image.frame = imageFrame;

        //Next Property ensures image resizing on resizing of container.
        [image setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
        
        //Adding image to container.
        [imageContainer addSubview:image];
        
        //Preparing frame for next value
        imageFrame.origin.x += self.view.frame.size.width;
    }
    //???? --- change 1 to number of images.set image scroll content size according to number of images
    [imageScroll setContentSize:CGSizeMake(imageScrollOriginalSize.width*1, imageScrollOriginalSize.height)];
    
    //Add container to scroll bar
    [imageScroll addSubview:imageContainer];
    
    //Adding scrollbar to view
    [self.view addSubview:imageScroll];
}

- (void)singleFingerTapOnImageScroll: (UITapGestureRecognizer *)recognizer {
    if (isImageScrollBarInOriginalSize) {
        [self transitionToFrame:CGRectMake(0, NAVIGATION_BAR_DEDEUCTION, imageScrollExtendedSize.width, imageScrollExtendedSize.height) containerFrame:CGRectMake(0, -NAVIGATION_BAR_DEDEUCTION + TOP_INSET_FOR_EXTENDED_IMAGES, imageScrollExtendedSize.width, imageScrollExtendedSize.height - TOP_INSET_FOR_EXTENDED_IMAGES*2)];
    } else {
        [self transitionToFrame:CGRectMake(0, NAVIGATION_BAR_DEDEUCTION, imageScrollOriginalSize.width, imageScrollOriginalSize.height) containerFrame:CGRectMake(0, 0, imageScrollOriginalSize.width, imageScrollOriginalSize.height)];
    }
    isImageScrollBarInOriginalSize = !isImageScrollBarInOriginalSize;
}

- (void)swipeDownImageScroll: (UISwipeGestureRecognizer *)recognizer {
    //Works only for original scroll. sets to extended size.
   if (isImageScrollBarInOriginalSize) {
        [self transitionToFrame:CGRectMake(0, NAVIGATION_BAR_DEDEUCTION, imageScrollExtendedSize.width, imageScrollExtendedSize.height) containerFrame:CGRectMake(0, -NAVIGATION_BAR_DEDEUCTION + TOP_INSET_FOR_EXTENDED_IMAGES, imageScrollExtendedSize.width, imageScrollExtendedSize.height - TOP_INSET_FOR_EXTENDED_IMAGES*2)];
        isImageScrollBarInOriginalSize = NO;
    }
    NSLog(@"Swipe Down");
}

- (void)swipeUpImageScroll: (UISwipeGestureRecognizer *)recognizer {
    //Works only for extended scroll. resets to original size
    if (!isImageScrollBarInOriginalSize) {
        [self transitionToFrame:CGRectMake(0, NAVIGATION_BAR_DEDEUCTION, imageScrollOriginalSize.width, imageScrollOriginalSize.height) containerFrame:CGRectMake(0, 0, imageScrollOriginalSize.width, imageScrollOriginalSize.height)];
        isImageScrollBarInOriginalSize = YES;
    }
    NSLog(@"Swipe Up");
}

- (void) transitionToFrame: (CGRect)imageScrollFrame containerFrame: (CGRect)containerFrame {
    [UIView animateWithDuration:0.5 animations:^{
        imageScroll.frame = imageScrollFrame;
        imageContainer.frame = containerFrame;
    }];
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

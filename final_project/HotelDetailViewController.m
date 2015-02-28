//
//  HotelDetailViewController.m
//  final_project
//
//  Created by iOS on 2/26/15.
//  Copyright (c) 2015 MAC. All rights reserved.
//

#import "HotelDetailViewController.h"

#define TOP_INSET_FOR_EXTENDED_IMAGES       75

@interface HotelDetailViewController ()
{
    UIScrollView *imageScroll;
    UIView *imageContainer;
    CGRect imageScrollOriginalFrame;
    CGRect imageScrollExtendedFrame;
    BOOL isImageScrollBarInOriginalSize;
}
@end

@implementation HotelDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *selectedHotel = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"checkmark"] style:UIBarButtonItemStylePlain target:self action:@selector(bookHotel:)];
    self.navigationItem.rightBarButtonItem = selectedHotel;
    
    //Following line ensures that Origin for content view is (0.0, 64.0) w.r.t to main view.
    self.edgesForExtendedLayout = UIRectEdgeNone;

    //Add image scroll bar
    [self addScrollBarForImageList];
    isImageScrollBarInOriginalSize = YES;
}

- (void)addScrollBarForImageList {
    imageScrollOriginalFrame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height * (1/3.0));
    
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat navigationBarHeight = self.navigationController.navigationBar.frame.size.height;
    imageScrollExtendedFrame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - (statusBarHeight + navigationBarHeight));
    
    imageScroll = [[UIScrollView alloc] initWithFrame:imageScrollOriginalFrame];
    imageScroll.delegate = self;
    
    //Customize Scrollbar
    [imageScroll setShowsHorizontalScrollIndicator:NO];
    [imageScroll setShowsVerticalScrollIndicator:NO];
    [imageScroll setPagingEnabled:YES];
    [imageScroll setBounces:NO];
    [imageScroll setAutoresizesSubviews:YES];
    [imageScroll setUserInteractionEnabled:YES];
    
    //Adding Gestures to ScrollBar
    UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleFingerTapOnImageScroll:)];
    singleFingerTap.numberOfTapsRequired = 1;
    singleFingerTap.numberOfTouchesRequired = 1;
    
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDownImageScroll:)];
    swipeDown.numberOfTouchesRequired = 1;
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeUpImageScroll:)];
    swipeUp.numberOfTouchesRequired = 1;
    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    
    [imageScroll addGestureRecognizer:singleFingerTap];
    [imageScroll addGestureRecognizer:swipeDown];
    [imageScroll addGestureRecognizer:swipeUp];
    
    //All images will be added to container view. It helps to control image size when zooming images
    imageContainer = [[UIView alloc] initWithFrame:imageScrollOriginalFrame];
    
    //Add code for image array here
    CGRect imageFrame = imageScrollOriginalFrame;
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
    [imageScroll setContentSize:CGSizeMake(imageScrollOriginalFrame.size.width*1, imageScrollOriginalFrame.size.height)];
    
    //Add container to scroll bar
    [imageScroll addSubview:imageContainer];
    
    //Adding scrollbar to view
    [self.view addSubview:imageScroll];
    
    //Adding color to scroll & container for insets impacts
    [imageScroll setBackgroundColor:[UIColor darkGrayColor]];
    [imageContainer setBackgroundColor:[UIColor lightGrayColor]];
}

- (void)singleFingerTapOnImageScroll: (UITapGestureRecognizer *)recognizer {
    if (isImageScrollBarInOriginalSize) {
        [self transitionToFrame:imageScrollExtendedFrame containerFrame:CGRectMake(0, TOP_INSET_FOR_EXTENDED_IMAGES, imageScrollExtendedFrame.size.width, imageScrollExtendedFrame.size.height-TOP_INSET_FOR_EXTENDED_IMAGES*2)];
    } else {
        [self transitionToFrame:imageScrollOriginalFrame containerFrame:imageScrollOriginalFrame];
    }
    isImageScrollBarInOriginalSize = !isImageScrollBarInOriginalSize;
}

- (void)swipeDownImageScroll: (UISwipeGestureRecognizer *)recognizer {
    //Works only for original scroll. sets to extended size.
    if (isImageScrollBarInOriginalSize) {
        [self transitionToFrame:imageScrollExtendedFrame containerFrame:CGRectMake(0, TOP_INSET_FOR_EXTENDED_IMAGES, imageScrollExtendedFrame.size.width, imageScrollExtendedFrame.size.height - TOP_INSET_FOR_EXTENDED_IMAGES*2)];
        isImageScrollBarInOriginalSize = NO;
    }
}

- (void)swipeUpImageScroll: (UISwipeGestureRecognizer *)recognizer {
    //Works only for extended scroll. resets to original size
    if (!isImageScrollBarInOriginalSize) {
        [self transitionToFrame:imageScrollOriginalFrame containerFrame:imageScrollOriginalFrame];
        isImageScrollBarInOriginalSize = YES;
    }
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

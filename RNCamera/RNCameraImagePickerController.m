//
// Created by Hank Brekke on 7/11/17.
// Copyright (c) 2017 Hank Brekke. All rights reserved.
//

#import "RNCameraImagePickerController.h"

@interface RNCameraImagePickerController ()

@property (nonatomic, assign) CGRect lastViewFrame;

#if TARGET_IPHONE_SIMULATOR

@property (nonatomic, retain) UIView *cameraViewfinder;

@property (nonatomic, retain) NSTimer *cameraTimer;
@property (nonatomic, assign) int cameraRed;
@property (nonatomic, assign) int cameraGreen;
@property (nonatomic, assign) int cameraBlue;

- (void)shiftColor;

#endif

@end

@implementation RNCameraImagePickerController

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    if (self.boundsDidChangeBlock && !CGRectEqualToRect(self.lastViewFrame, self.view.frame)) {
        self.boundsDidChangeBlock(self.view.bounds);
        self.lastViewFrame = self.view.frame;
    }
}

#if TARGET_IPHONE_SIMULATOR

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor blackColor];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.cameraViewfinder = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        self.cameraViewfinder.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    } else {
        // Mimic physical iPhone devices (esp. iPhone X) which set a viewfinder in the top-left corner at a 4/3 ratio.
        // See https://hnryjms.io/2019/01/ios-camera-overlay/
        self.cameraViewfinder = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width * 4/3)];
    }
    
    [self.view addSubview:self.cameraViewfinder];
    
    self.cameraTimer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(shiftColor) userInfo:nil repeats:YES];
}

- (void)setCameraOverlayView:(UIView *)cameraOverlayView {
    if (_cameraOverlayView) {
        [_cameraOverlayView removeFromSuperview];
    }

    if (cameraOverlayView) {
        cameraOverlayView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        cameraOverlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

        [self.view addSubview:cameraOverlayView];
    }
    _cameraOverlayView = cameraOverlayView;
}

- (void)shiftColor {
    self.cameraRed += 1;
    self.cameraGreen += 2;
    self.cameraBlue += 3;

    self.cameraViewfinder.backgroundColor = [UIColor colorWithRed:abs(self.cameraRed % 510 - 255) / 255.0f
                                                green:abs(self.cameraGreen % 510 - 255) / 255.0f
                                                 blue:abs(self.cameraBlue % 510 - 255) / 255.0f
                                                alpha:1];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:animated ? UIStatusBarAnimationFade : UIStatusBarAnimationNone];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:animated ? UIStatusBarAnimationFade : UIStatusBarAnimationNone];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? UIInterfaceOrientationMaskAll : UIInterfaceOrientationMaskPortrait;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)takePicture {
    // iPhone7/iPadPro 12MP camera (4000px x 3000px photos)
    CGRect imageFrame = CGRectMake(0, 0, 4000, 3000);
    UIGraphicsBeginImageContextWithOptions(imageFrame.size, false, 0.0);
    [self.view.backgroundColor setFill];
    UIRectFill(imageFrame);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    [self.delegate imagePickerController:nil didFinishPickingMediaWithInfo:@{
            UIImagePickerControllerOriginalImage: image
    }];
}

- (void)setCameraDevice:(UIImagePickerControllerCameraDevice)cameraDevice {
}

- (void)setCameraFlashMode:(UIImagePickerControllerCameraFlashMode)cameraFlashMode {
}
- (void)setCameraViewTransform:(CGAffineTransform)cameraViewTransform {
    self.cameraViewfinder.transform = cameraViewTransform;
}
- (CGAffineTransform)cameraViewTransform {
    return self.cameraViewfinder.transform;
}

#endif

@end

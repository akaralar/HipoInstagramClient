//
//  ImageViewController.m
//  HipoInstagramClient
//
//  Created by Ahmet Karalar on 09/09/15.
//  Copyright (c) 2015 akaralar. All rights reserved.
//

#import "ImageViewController.h"

static const CGFloat kZoomStep = 1.5;

@interface ImageViewController () <UIScrollViewDelegate>

@property (nonatomic) UIImage *image;

@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic) UIImageView *imageView;

- (CGRect)zoomRectForScale:(CGFloat)scale withCenter:(CGPoint)center;

- (void)handleDoubleTap:(UITapGestureRecognizer *)gr;
- (void)handleTwoFingerTap:(UITapGestureRecognizer *)gr;

@end

@implementation ImageViewController

- (instancetype)initWithImage:(UIImage *)image
{
    self = [self init];

    if (!self) {
        return nil;
    }

    _image = image;

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = NSLocalizedString(@"Browser", nil);
    
    self.scrollView = [UIScrollView new];
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.scrollView.delegate = self;
    self.scrollView.backgroundColor = [UIColor blackColor];
    self.scrollView.maximumZoomScale = 10;//
    [self.view addSubview:self.scrollView];
    self.scrollView.frame = self.view.bounds;
    
    self.imageView = [UIImageView new];
    self.imageView.image = self.image;
    self.imageView.userInteractionEnabled = YES;
    [self.imageView sizeToFit];
    [self.scrollView addSubview:self.imageView];

    UITapGestureRecognizer *doubleTap =
        [[UITapGestureRecognizer alloc] initWithTarget:self  //
                                                action:@selector(handleDoubleTap:)];
    UITapGestureRecognizer *twoFingerTap =
        [[UITapGestureRecognizer alloc] initWithTarget:self  //
                                                action:@selector(handleTwoFingerTap:)];

    [doubleTap setNumberOfTapsRequired:2];
    [twoFingerTap setNumberOfTouchesRequired:2];

    [self.imageView addGestureRecognizer:doubleTap];
    [self.imageView addGestureRecognizer:twoFingerTap];

    // calculate minimum scale to perfectly fit image width, and begin at that scale

    CGFloat minimumScale = [self.view bounds].size.width / [self.imageView frame].size.width;
    [self.scrollView setMinimumZoomScale:minimumScale];
    [self.scrollView setZoomScale:minimumScale];

    self.imageView.center = self.scrollView.center;
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)gr
{
    // double tap zooms in
    CGFloat newScale = [self.scrollView zoomScale] * kZoomStep;
    CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gr locationInView:gr.view]];
    [self.scrollView zoomToRect:zoomRect animated:YES];
}

- (void)handleTwoFingerTap:(UITapGestureRecognizer *)gr
{
    if (self.scrollView.zoomScale == self.scrollView.minimumZoomScale) {
        return;
    }
    // two-finger tap zooms out
    CGFloat newScale = [self.scrollView zoomScale] / kZoomStep;
    CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gr locationInView:gr.view]];
    [self.scrollView zoomToRect:zoomRect animated:YES];
}

- (CGRect)zoomRectForScale:(CGFloat)scale withCenter:(CGPoint)center {
    
    CGRect zoomRect;
    
    // the zoom rect is in the content view's coordinates.
    //    At a zoom scale of 1.0, it would be the size of the imageScrollView's bounds.
    //    As the zoom scale decreases, so more content is visible, the size of the rect grows.
    zoomRect.size.height = [self.scrollView frame].size.height / scale;
    zoomRect.size.width  = [self.scrollView frame].size.width  / scale;
    
    // choose an origin so as to get the right center.
    zoomRect.origin.x    = center.x - (zoomRect.size.width  / (CGFloat)2.0);
    zoomRect.origin.y    = center.y - (zoomRect.size.height / (CGFloat)2.0);
    
    return zoomRect;
}


#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

@end

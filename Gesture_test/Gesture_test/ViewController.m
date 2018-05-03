//
//  ViewController.m
//  Gesture_test
//
//  Created by Dmitriy Tarelkin on 3/5/18.
//  Copyright © 2018 Dmitriy Tarelkin. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIGestureRecognizerDelegate> // allow simultaneous recognition of ROTATION + ZOOM(Pinch)

@property (weak, nonatomic) UIView* testSubView;

@property (assign, nonatomic) CGFloat testSubViewScale;
@property (assign, nonatomic) CGFloat testSubViewRotation;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//create subView in center of main view
    UIView* subView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMidX(self.view.bounds) - 100,
                                                              CGRectGetMidY(self.view.bounds) - 100,
                                                              200, 200)];
    subView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    
    subView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:subView];
    self.testSubView = subView;
    
//tap
    UITapGestureRecognizer* tapGesture =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleTap:)];
    [self.view addGestureRecognizer:tapGesture];
    
//double tap
    UITapGestureRecognizer* doubleTapGesture =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleDoubleTap:)];
    doubleTapGesture.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:doubleTapGesture];
    
    //tapGesture не сработает раньше doubleTapGesture, если будет второе нажатие
    [tapGesture requireGestureRecognizerToFail:doubleTapGesture];
    
//double tap with 2 touches
    UITapGestureRecognizer* doubleTapDoubleTouchGesture =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleDoubleTapDoubleTouch:)];
    doubleTapDoubleTouchGesture.numberOfTapsRequired = 2;
    doubleTapDoubleTouchGesture.numberOfTouchesRequired = 2;
    
    [self.view addGestureRecognizer:doubleTapDoubleTouchGesture];
    
//pinch (zoom)
    UIPinchGestureRecognizer* pinchGesture =
    [[UIPinchGestureRecognizer alloc] initWithTarget:self
                                              action: @selector(handlePinch:)];
    
    //make it delegate to allow simultaneous recognition of ROTATION + ZOOM(Pinch)
    pinchGesture.delegate = self;
    [self.view addGestureRecognizer:pinchGesture];
    
//rotation
    UIRotationGestureRecognizer* rotateGesture =
    [[UIRotationGestureRecognizer alloc] initWithTarget:self
                                                 action:@selector(handleRotation:)];
    
    //make it delegate to allow simultaneous recognition of ROTATION + ZOOM(Pinch)
    rotateGesture.delegate = self;
    [self.view addGestureRecognizer:rotateGesture];
    
//pan
    UIPanGestureRecognizer* panGesture =
    [[UIPanGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handlePan:)];
    panGesture.delegate = self;                                 //make it delegate to allow swipe before pan
    [self.view addGestureRecognizer:panGesture];
    
    
//swipe
    //vertical
    UISwipeGestureRecognizer* verticalSwipeGesture =
    [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                              action:@selector(handleVerticalSwipe:)];
    verticalSwipeGesture.direction = UISwipeGestureRecognizerDirectionDown | UISwipeGestureRecognizerDirectionUp;
    verticalSwipeGesture.delegate = self;                       //make it delegate to allow swipe before pan
    [self.view addGestureRecognizer:verticalSwipeGesture];
    
    
    //horizontal
    UISwipeGestureRecognizer* horizontalSwipeGesture =
    [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                              action:@selector(handleHorizontalSwipe:)];
    horizontalSwipeGesture.direction = UISwipeGestureRecognizerDirectionLeft | UISwipeGestureRecognizerDirectionRight;
    horizontalSwipeGesture.delegate = self;                     //make it delegate to allow swipe before pan
    [self.view addGestureRecognizer:horizontalSwipeGesture];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Custom methods
-(UIColor*)randomColor {
    CGFloat r = (CGFloat)(arc4random() %256) /255.f;
    CGFloat g = (CGFloat)(arc4random() %256) /255.f;
    CGFloat b = (CGFloat)(arc4random() %256) /255.f;
    
    return [UIColor colorWithRed:r green:g blue:b alpha:1.f];
}

#pragma mark - Gestures

-(void)handleTap:(UIGestureRecognizer*)tapGesture{
    //show tap coordinats on view
    NSLog(@"\nTap on: %@", NSStringFromCGPoint([tapGesture locationInView:self.view]));
    
    self.testSubView.backgroundColor = [self randomColor];
}


-(void)handleDoubleTap:(UIGestureRecognizer*)tapGesture{
    //show tap coordinats on view
    NSLog(@"\nDouble tap on: %@", NSStringFromCGPoint([tapGesture locationInView:self.view]));
    
    CGAffineTransform currentTranform = self.testSubView.transform;
    //скейлит переданнаю матрицу
    CGAffineTransform newTransform = CGAffineTransformScale(currentTranform, 1.2f, 1.2f);
    
    //add some animation
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.testSubView.transform = newTransform;
                     } completion:^(BOOL finished) {
                         
                     }];
    
    self.testSubViewScale = 1.2f;
}


-(void)handleDoubleTapDoubleTouch:(UIGestureRecognizer*)doubleTapGesture{
    //show tap coordinats on view
    NSLog(@"\nDoubleTap DoubleTouch on: %@", NSStringFromCGPoint([doubleTapGesture locationInView:self.view]));
    
    CGAffineTransform currentTranform = self.testSubView.transform;
    CGAffineTransform newTransform = CGAffineTransformScale(currentTranform, 0.8f, 0.8f);
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.testSubView.transform = newTransform;
                     } completion:^(BOOL finished) {
                         
                     }];
    
    self.testSubViewScale = 0.8;
}


-(void)handlePinch:(UIPinchGestureRecognizer*)pinchGesture {
    NSLog(@"\nPinch(Zoom) %1.3f", pinchGesture.scale);
    
    //если тач начинается, то делаем скейл 100%, чтобы не было рывка
    if (pinchGesture.state == UIGestureRecognizerStateBegan) {
        self.testSubViewScale = 1.f;
    }
    
    CGFloat deltaScale = 1.f + pinchGesture.scale - self.testSubViewScale;
    
    CGAffineTransform currentTranform = self.testSubView.transform;
    CGAffineTransform newTransform = CGAffineTransformScale(currentTranform, deltaScale, deltaScale);
    
    self.testSubView.transform = newTransform;
    
    self.testSubViewScale = pinchGesture.scale;
}


-(void)handleRotation:(UIRotationGestureRecognizer*)rotationGesture {
    NSLog(@"\nRotation %f", rotationGesture.rotation);
    
    //если тач начинается, то обнуляем rotation, чтобы не было рывка
    if (rotationGesture.state == UIGestureRecognizerStateBegan) {
        self.testSubViewRotation = 0;
    }
    
    CGFloat deltaRotation = rotationGesture.rotation - self.testSubViewRotation;
    
    CGAffineTransform currentTranform = self.testSubView.transform;
    CGAffineTransform newTransform = CGAffineTransformRotate(currentTranform, deltaRotation);
    
    self.testSubView.transform = newTransform;
    
    self.testSubViewRotation = rotationGesture.rotation;
    
}


-(void)handlePan:(UIPanGestureRecognizer*)panGesture {
    NSLog(@"\nPan gesture");
    
    self.testSubView.center = [panGesture locationInView:self.view];
}

-(void)handleVerticalSwipe:(UISwipeGestureRecognizer*)verticalSwipeGesture {
    NSLog(@"Vertical swipe");
}

-(void)handleHorizontalSwipe:(UISwipeGestureRecognizer*)horizontalSwipeGesture {
    NSLog(@"Horizontal swipe");
}



#pragma mark - UIGestureRecognizerDelegate

//allow simultaneous recognition
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    //only for ROTATION + ZOOM(Pinch) gestures
    return YES;
}

//allow SWIPE to being first before PAN
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    //making SWIPE before PAN
    return [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] &&
    [otherGestureRecognizer isKindOfClass:[UISwipeGestureRecognizer class]];
}


@end

//
//  UISildeNavigationController.m
//  NavTest
//
//  Created by midoks on 14/12/12.
//  Copyright (c) 2014年 midoks. All rights reserved.
//

#import "SlideNavigationController.h"

@interface SlideNavigationController () <UIGestureRecognizerDelegate, UINavigationControllerDelegate>
@property (nonatomic, strong) UITapGestureRecognizer *tapRecognizer;
@property (nonatomic, strong) UIPanGestureRecognizer *panRecognizer;
@property (nonatomic, assign) CGPoint draggingPoint;
@property (nonatomic, assign) BOOL menuNeedsLayout;
@property (nonatomic, assign) CGFloat portraitSlideOffset;
@property (nonatomic, assign) CGFloat landscapeSlideOffset;

@property (nonatomic, strong) UIBarButtonItem *pLeftMenu;
@property (nonatomic, strong) UIBarButtonItem *pRightMenu;
@end

@implementation SlideNavigationController


NSString * const SlideNavigationControllerDidOpen = @"SlideNavigationControllerDidOpen";
NSString * const SlideNavigationControllerDidClose = @"SlideNavigationControllerDidClose";
NSString  *const SlideNavigationControllerDidReveal = @"SlideNavigationControllerDidReveal";

#pragma mark - Initialization -

- (id)init
{
    if (self = [super init])
    {
        self.delegate = self;
        singletonInstance = self;
        self.enableShadow = YES;
        self.enableSwipeGesture = NO;
        self.avoidSwitchingToSameClassViewController = YES;
        self.landscapeSlideOffset = MENU_DEFAULT_SLIDE_OFFSET;
        self.portraitSlideOffset = MENU_DEFAULT_SLIDE_OFFSET;
        
        
        //left right
        UIImage *image = [UIImage imageNamed:MENU_IMAGE];
        _pLeftMenu = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(leftMenuSelected)];
        //add color control
        _pLeftMenu.tintColor = [UIColor whiteColor];
        _pRightMenu = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(rightMenuSelected)];
        _pRightMenu.tintColor = [UIColor whiteColor];
        
    }
    return self;
}


- (id)initWithRootViewController:(UIViewController *)rootViewController
{
    if (self = [self init]) {
        self = [super initWithRootViewController:rootViewController];
    }
    return self;
}

static SlideNavigationController *singletonInstance;
+ (SlideNavigationController *)sharedInstance
{
    if (!singletonInstance)
    {
        return [[self alloc] init];
    }
    return singletonInstance;
}


- (CGFloat)horizontalLocation
{
    CGRect rect = self.view.frame;
    UIDevice *device = [UIDevice currentDevice];
    UIDeviceOrientation orientation = device.orientation;
    //UIDeviceOrientation
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
    {
        return rect.origin.x;
    }
    else
    {
        if (UIDeviceOrientationIsLandscape(orientation))
        {
            return (orientation == UIInterfaceOrientationLandscapeRight)
            ? rect.origin.y
            : rect.origin.y*-1;
        }
        else
        {
            return (orientation == UIInterfaceOrientationPortrait)
            ? rect.origin.x
            : rect.origin.x*-1;
        }
    }
}

- (CGFloat)horizontalSize
{
    CGRect rect = self.view.frame;
    UIDevice *device = [UIDevice currentDevice];
    UIDeviceOrientation orientation = device.orientation;
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
    {
        return rect.size.width;
    }
    else
    {
        if (UIDeviceOrientationIsLandscape(orientation))
        {
            return rect.size.height;
        }
        else
        {
            return rect.size.width;
        }
    }
}



- (void)viewWillLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    // Update shadow size of enabled
    if (self.enableShadow)
        self.view.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.view.bounds].CGPath;
    
    if (self.menuNeedsLayout)
    {
        [self updateMenuFrameAndTransformAccordingToOrientation];
        
        // Handle different horizontal/vertical slideOffset during rotation
        // On iOS below 8 we just close the menu, iOS8 handles rotation better so we support keepiong the menu open
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0") && [self isMenuOpen])
        {
            Menu menu = (self.horizontalLocation > 0) ? MenuLeft : MenuRight;
            [self openMenu:menu withDuration:0 andCompletion:nil];
        }
        
        self.menuNeedsLayout = NO;
    }
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    self.menuNeedsLayout = YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    self.menuNeedsLayout = YES;
}


-(CGRect)initialRectForMenu
{
    CGRect rect = self.view.frame;
    rect.origin.x = 0;
    rect.origin.y = 0;
    UIDevice *device = [UIDevice currentDevice];
    UIDeviceOrientation orientation = device.orientation;
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        return rect;
    }
    
    if (UIDeviceOrientationIsLandscape(orientation))
    {
        // For some reasons in landscape below the status bar is considered y=0, but in portrait it's considered y=20
        rect.origin.x = (orientation == UIInterfaceOrientationLandscapeRight) ? 0 : STATUS_BAR_HEIGHT;
        rect.size.width = self.view.frame.size.width-STATUS_BAR_HEIGHT;
    }
    else
    {
        // For some reasons in landscape below the status bar is considered y=0, but in portrait it's considered y=20
        rect.origin.y = (orientation == UIInterfaceOrientationPortrait) ? STATUS_BAR_HEIGHT : 0;
        rect.size.height = self.view.frame.size.height-STATUS_BAR_HEIGHT;
    }
    
    return rect;
}

#pragma mark - UINavigationControllerDelegate Methods -

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated
{
    
    if (_leftMenu) {
        viewController.navigationItem.leftBarButtonItem = _pLeftMenu;
    }
    
    if (_rightMenu) {
        viewController.navigationItem.rightBarButtonItem = _pRightMenu;
    }
}



#pragma mark - Public Methods -



- (void)switchToViewController:(UIViewController *)viewController
         withSlideOutAnimation:(BOOL)slideOutAnimation
                       popType:(PopType)poptype
                 andCompletion:(void (^)())completion
{
    if (self.avoidSwitchingToSameClassViewController && [self.topViewController isKindOfClass:viewController.class])
    {
        [self closeMenuWithCompletion:completion];
        return;
    }
    
    void (^switchAndCallCompletion)(BOOL) = ^(BOOL closeMenuBeforeCallingCompletion) {
        if (poptype == PopTypeAll) {
            [self setViewControllers:@[viewController]];
        }
        else {
            [super popToRootViewControllerAnimated:NO];
            [super pushViewController:viewController animated:NO];
        }
        
        if (closeMenuBeforeCallingCompletion)
        {
            [self closeMenuWithCompletion:^{
                if (completion){
                    completion();
                }
            }];
        }
        else
        {
            if (completion)
            {
                completion();
            }
        }
    };
    
    if ([self isMenuOpen])
    {
        if (slideOutAnimation)
        {
            [UIView animateWithDuration:(slideOutAnimation) ? MENU_SLIDE_ANIMATION_DURATION : 0
                                  delay:0
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 CGFloat width = self.horizontalSize;
                                 CGFloat moveLocation = (self.horizontalLocation> 0) ? width : -1*width;
                                 [self moveHorizontallyToLocation:moveLocation];
                             } completion:^(BOOL finished) {
                                 switchAndCallCompletion(YES);
                             }];
        }
        else
        {
            switchAndCallCompletion(YES);
        }
    }
    else
    {
        switchAndCallCompletion(NO);
    }
}

- (void)switchToViewController:(UIViewController *)viewController withCompletion:(void (^)())completion
{
    [self switchToViewController:viewController withSlideOutAnimation:NO popType:PopTypeRoot andCompletion:completion];
}

- (void)popToRootAndSwitchToViewController:(UIViewController *)viewController
                     withSlideOutAnimation:(BOOL)slideOutAnimation
                             andCompletion:(void (^)())completion
{
    [self switchToViewController:viewController withSlideOutAnimation:slideOutAnimation popType:PopTypeRoot andCompletion:completion];
}

- (void)popToRootAndSwitchToViewController:(UIViewController *)viewController
                            withCompletion:(void (^)())completion
{
    [self switchToViewController:viewController withSlideOutAnimation:YES popType:PopTypeRoot andCompletion:completion];
}

- (void)popAllAndSwitchToViewController:(UIViewController *)viewController
                  withSlideOutAnimation:(BOOL)slideOutAnimation
                          andCompletion:(void (^)())completion
{
    [self switchToViewController:viewController withSlideOutAnimation:slideOutAnimation popType:PopTypeAll andCompletion:completion];
}

- (void)popAllAndSwitchToViewController:(UIViewController *)viewController
                         withCompletion:(void (^)())completion
{
    [self switchToViewController:viewController withSlideOutAnimation:YES popType:PopTypeAll andCompletion:completion];
}

- (void)setEnableShadow:(BOOL)enable
{
    _enableShadow = enable;
    
    if (enable)
    {
        self.view.layer.shadowColor = [UIColor darkGrayColor].CGColor;
        self.view.layer.shadowRadius = MENU_SHADOW_RADIUS;
        self.view.layer.shadowOpacity = MENU_SHADOW_OPACITY;
        self.view.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.view.bounds].CGPath;
        self.view.layer.shouldRasterize = YES;
        self.view.layer.rasterizationScale = [UIScreen mainScreen].scale;
    }
    else
    {
        self.view.layer.shadowOpacity = 0;
        self.view.layer.shadowRadius = 0;
    }
}

-(void)leftMenuSelected
{
    if ([self isMenuOpen]) {
        [self closeMenuWithCompletion:nil];
    }else{
        [self openMenu:MenuLeft withCompletion:nil];
    }
}

-(void)rightMenuSelected
{
    if ([self isMenuOpen]) {
        [self closeMenuWithCompletion:nil];
    }else{
        [self openMenu:MenuRight withCompletion:nil];
    }
}

#pragma mark - Override Methods -

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated
{
    if ([self isMenuOpen])
    {
        [self closeMenuWithCompletion:^{
            [super popToRootViewControllerAnimated:animated];
        }];
    }
    else
    {
        return [super popToRootViewControllerAnimated:animated];
    }
    
    return nil;
}

- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([self isMenuOpen])
    {
        [self closeMenuWithCompletion:^{
            [super popToViewController:viewController animated:animated];
        }];
    }
    else
    {
        return [super popToViewController:viewController animated:animated];
    }
    
    return nil;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([self isMenuOpen])
    {
        [self  closeMenuWithCompletion:^{
            [super pushViewController:viewController animated:animated];
        }];
    }
    else
    {
        [super pushViewController:viewController animated:animated];
    }
}

#pragma mark - Private Methods -

//-(UIInterfaceOrientation) toUIInterfaceOrientationType:(UIDeviceOrientation) to
//{
//    switch (to) {
//        case UIDeviceOrientationUnknown:
//            return 
//            break;
//            
//        default:
//            break;
//    }
//    
//
//}

- (void)updateMenuAnimation:(Menu)menu
{
    //    CGFloat progress = (menu == MenuLeft)
    //    ? (self.horizontalLocation / (self.horizontalSize - self.slideOffset))
    //    : (self.horizontalLocation / ((self.horizontalSize - self.slideOffset) * -1));
    
    //[self.menuRevealAnimator animateMenu:menu withProgress:progress];
}

- (void)moveHorizontallyToLocation:(CGFloat)location
{
    CGRect rect = self.view.frame;
    UIDevice *device = [UIDevice currentDevice];
    UIDeviceOrientation orientation = device.orientation;
    Menu menu = (self.horizontalLocation >= 0 && location >= 0) ? MenuLeft : MenuRight;
    
    if ((location > 0 && self.horizontalLocation <= 0) || (location < 0 && self.horizontalLocation >= 0)) {
        [self postNotificationWithName:SlideNavigationControllerDidReveal forMenu:(location > 0) ? MenuLeft : MenuRight];
    }
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
    {
        rect.origin.x = location;
        rect.origin.y = 0;
    }
    else
    {
        if (UIDeviceOrientationIsLandscape(orientation))
        {
            rect.origin.x = 0;
            rect.origin.y = (orientation == UIInterfaceOrientationLandscapeRight) ? location : location*-1;
        }
        else
        {
            rect.origin.x = (orientation == UIInterfaceOrientationPortrait) ? location : location*-1;
            rect.origin.y = 0;
        }
    }
    
    self.view.frame = rect;
    [self updateMenuAnimation:menu];
}

- (void)enableTapGestureToCloseMenu:(BOOL)enable
{
    if (enable)
    {
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
            self.interactivePopGestureRecognizer.enabled = NO;
        
        self.topViewController.view.userInteractionEnabled = NO;
        [self.view addGestureRecognizer:self.tapRecognizer];
    }
    else
    {
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
            self.interactivePopGestureRecognizer.enabled = YES;
        
        self.topViewController.view.userInteractionEnabled = YES;
        [self.view removeGestureRecognizer:self.tapRecognizer];
    }
}

-(BOOL)isMenuOpen
{
    return ([self horizontalLocation] == 0) ? NO : YES;
}

- (void)closeMenuWithCompletion:(void (^)())completion
{
    [self closeMenuWithDuration:MENU_SLIDE_ANIMATION_DURATION andCompletion:completion];
}

- (void)openMenu:(Menu)menu withCompletion:(void (^)())completion
{
    [self openMenu:menu withDuration:MENU_SLIDE_ANIMATION_DURATION andCompletion:completion];
}

- (void)closeMenuWithDuration:(float)duration andCompletion:(void (^)())completion
{
    [self enableTapGestureToCloseMenu:NO];
    Menu menu = (self.horizontalLocation > 0) ? MenuLeft : MenuRight;
    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
                     }
                     completion:^(BOOL finished) {
                         if (completion)
                         {
                             completion();
                         }
                         if (menu == MenuLeft) {
                             [_leftMenu.view removeFromSuperview];
                         }else{
                             [_rightMenu.view removeFromSuperview];
                         }
                         [self postNotificationWithName:SlideNavigationControllerDidClose forMenu:menu];
                     }];
}

- (void)openMenu:(Menu)menu withDuration:(float)duration andCompletion:(void (^)())completion
{
    [self enableTapGestureToCloseMenu:YES];
    [self prepareMenuForReveal:menu];
    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         CGRect rect = self.view.frame;
                         CGFloat width = self.horizontalSize;
                         rect.origin.x = (menu == MenuLeft) ? (width - self.slideOffset) : ((width - self.slideOffset )* -1);
                         self.view.frame = CGRectMake(rect.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height);
                     }
                     completion:^(BOOL finished) {
                         if (completion)
                         {
                             completion();
                         }
                         [self postNotificationWithName:SlideNavigationControllerDidOpen forMenu:menu];
                     }];
}

- (void)prepareMenuForReveal:(Menu)menu
{
    UIViewController *menuViewController = (menu == MenuLeft) ? self.leftMenu : self.rightMenu;
    UIViewController *removingMenuViewController = (menu == MenuLeft) ? self.rightMenu : self.leftMenu;
    
    [removingMenuViewController.view removeFromSuperview];
    
    CGRect _rect =  menuViewController.view.frame;
    _rect.origin.y = 20;
    menuViewController.view.frame = _rect;
    
    [self.view.window insertSubview:menuViewController.view atIndex:0];
    
    [self updateMenuFrameAndTransformAccordingToOrientation];
    
}

- (void)updateMenuFrameAndTransformAccordingToOrientation
{
    // Animate rotatation when menu is open and device rotates
    CGAffineTransform transform = self.view.transform;
    self.leftMenu.view.transform = transform;
    self.rightMenu.view.transform = transform;
    
    self.leftMenu.view.frame = [self initialRectForMenu];
    self.rightMenu.view.frame = [self initialRectForMenu];
}

- (void)postNotificationWithName:(NSString *)name forMenu:(Menu)menu
{
    NSString *menuString = (menu == MenuLeft) ? NOTIFICATION_USER_INFO_MENU_LEFT : NOTIFICATION_USER_INFO_MENU_RIGHT;
    NSDictionary *userInfo = @{ NOTIFICATION_USER_INFO_MENU : menuString };
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:nil userInfo:userInfo];
}

#pragma mark - UISwipeGestureRecognizer register -

-(void)panDetected:(UIPanGestureRecognizer *)recognizer
{
    CGPoint translation = [recognizer translationInView:recognizer.view];
    CGPoint velocity = [recognizer velocityInView:recognizer.view];
    NSInteger movement = translation.x - self.draggingPoint.x;
    
    Menu currentMenu;
    if (self.horizontalLocation > 0)
    {
        currentMenu = MenuLeft;
    }
    else if (self.horizontalLocation < 0)
    {
        currentMenu = MenuRight;
    }
    else
    {
        currentMenu = (translation.x > 0) ? MenuLeft : MenuRight;
    }
    
    [self prepareMenuForReveal:currentMenu];
    
    if (recognizer.state == UIGestureRecognizerStateBegan)
    {
        self.draggingPoint = translation;
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged)
    {
        static CGFloat lastHorizontalLocation = 0;
        CGFloat newHorizontalLocation = [self horizontalLocation];
        lastHorizontalLocation = newHorizontalLocation;
        newHorizontalLocation += movement;
        
        CGFloat minDrag = (self.horizontalSize - self.slideOffset)  * -1;
        CGFloat maxDrag = (self.horizontalSize - self.slideOffset);
        
        if (newHorizontalLocation >= minDrag && newHorizontalLocation <= maxDrag) {
            
            //leftMenu exist, can drag
            if (_leftMenu && movement >= 0) {
                self.view.frame = CGRectMake(newHorizontalLocation, 0, self.view.frame.size.width, self.view.frame.size.height);
            }
            
            //rightMenu exist, can drag
            if (_rightMenu && movement <=0) {
                self.view.frame = CGRectMake(newHorizontalLocation, 0, self.view.frame.size.width, self.view.frame.size.height);
            }
            
            
        }
        self.draggingPoint = translation;
    }
    else if(recognizer.state == UIGestureRecognizerStateEnded)
    {
        NSInteger currentX = [self horizontalLocation];
        NSInteger currentXOffset = (currentX > 0) ? currentX : currentX * -1;
        NSInteger positiveVelocity = (velocity.x > 0) ? velocity.x : velocity.x * -1;
        
        if (positiveVelocity >= MENU_FAST_VELOCITY_FOR_SWIPE_FOLLOW_DIRECTION) {
            //move right
            if (velocity.x > 0 && _leftMenu) {
                if (currentX > 0)
                {
                    [self openMenu:MenuLeft withCompletion:nil];
                }
                else
                {
                    [self closeMenuWithCompletion:nil];
                }
            }
            else if (_rightMenu)
                //move left
            {
                if (currentX > 0 )
                {
                    [self closeMenuWithCompletion:nil];
                }
                else
                {
                    [self openMenu:MenuRight withCompletion:nil];
                }
            }
        }
        else
        {
            if (currentXOffset < (self.horizontalSize - self.slideOffset)/2)
            {
                [self closeMenuWithCompletion:nil];
            }
            else
            {
                if (currentX>0 && _leftMenu) {
                    [self openMenu:MenuLeft withCompletion:nil];
                }
                else if(_rightMenu)
                {
                    [self openMenu:MenuRight withCompletion:nil];
                }
            }
        }
        
    }
}

- (void)tapDetected:(UITapGestureRecognizer *)tapRecognizer
{
    [self closeMenuWithCompletion:nil];
}

- (CGFloat)slideOffset
{
    UIDevice *device = [UIDevice currentDevice];
    UIDeviceOrientation orientation = device.orientation;
    return (UIDeviceOrientationIsLandscape(orientation))
    ? self.landscapeSlideOffset
    : self.portraitSlideOffset;
}


#pragma mark - Setter & Getter -

- (UITapGestureRecognizer *)tapRecognizer
{
    if (!_tapRecognizer)
    {
        _tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
    }
    
    return _tapRecognizer;
}

- (UIPanGestureRecognizer *)panRecognizer
{
    if (!_panRecognizer)
    {
        _panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panDetected:)];
        _panRecognizer.delegate = self;
    }
    
    return _panRecognizer;
}

- (void)setEnableSwipeGesture:(BOOL)markEnableSwipeGesture
{
    _enableSwipeGesture = markEnableSwipeGesture;
    
    if (_enableSwipeGesture)
    {
        [self.view addGestureRecognizer:self.panRecognizer];
    }
    else
    {
        [self.view removeGestureRecognizer:self.panRecognizer];
    }
}

- (void)setLeftMenu:(UIViewController *)leftMenu
{
    [_leftMenu.view removeFromSuperview];
    _leftMenu = leftMenu;
}

- (void)setRightMenu:(UIViewController *)rightMenu
{
    [_rightMenu.view removeFromSuperview];
    _rightMenu = rightMenu;
}



@end

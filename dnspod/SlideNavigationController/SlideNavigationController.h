//
//  UISildeNavigationController.h
//  NavTest
//
//  Created by midoks on 14/12/12.
//  Copyright (c) 2014年 midoks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface SlideNavigationController : UINavigationController <UINavigationControllerDelegate>

extern NSString  *const SlideNavigationControllerDidOpen;
extern NSString  *const SlideNavigationControllerDidClose;
extern NSString  *const SlideNavigationControllerDidReveal;

@property (nonatomic, assign) BOOL avoidSwitchingToSameClassViewController;
@property (nonatomic, strong) UIViewController *leftMenu;
@property (nonatomic, strong) UIViewController *rightMenu;
@property (nonatomic, assign) BOOL enableSwipeGesture;
@property (nonatomic, assign) BOOL enableShadow;

typedef  enum{
    MenuLeft = 1,
    MenuRight = 2
}Menu;

typedef enum {
    PopTypeAll,
    PopTypeRoot
} PopType;

#define MENU_IMAGE @"menu-button"
#define MENU_DEFAULT_SLIDE_OFFSET 60
#define MENU_SLIDE_ANIMATION_DURATION .3
#define MENU_QUICK_SLIDE_ANIMATION_DURATION .18
#define MENU_FAST_VELOCITY_FOR_SWIPE_FOLLOW_DIRECTION 1200
#define MENU_SHADOW_RADIUS 10
#define MENU_SHADOW_OPACITY 1
#define STATUS_BAR_HEIGHT 20

#define NOTIFICATION_USER_INFO_MENU_LEFT @"left"
#define NOTIFICATION_USER_INFO_MENU_RIGHT @"right"
#define NOTIFICATION_USER_INFO_MENU @"menu"


- (void)switchToViewController:(UIViewController *)viewController withCompletion:(void (^)())completion __deprecated;
- (void)popToRootAndSwitchToViewController:(UIViewController *)viewController withSlideOutAnimation:(BOOL)slideOutAnimation andCompletion:(void (^)())completion;
- (void)popToRootAndSwitchToViewController:(UIViewController *)viewController withCompletion:(void (^)())completion;
- (void)popAllAndSwitchToViewController:(UIViewController *)viewController withSlideOutAnimation:(BOOL)slideOutAnimation andCompletion:(void (^)())completion;
- (void)popAllAndSwitchToViewController:(UIViewController *)viewController withCompletion:(void (^)())completion;
//- (void)bounceMenu:(Menu)menu withCompletion:(void (^)())completion;
- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated;
- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated;
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (id)initWithRootViewController:(UIViewController *)rootViewController;
-(BOOL)isMenuOpen;
-(void)closeMenuWithCompletion:(void (^)())completion;
-(void)leftMenuSelected;
-(void)rightMenuSelected;

#pragma mark - static methods -
+(SlideNavigationController *)sharedInstance;

@end

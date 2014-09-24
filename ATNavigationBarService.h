//
//  ATNavigationBarService.h
//
//  Created by Amos Todman on 9/24/14.
//  Copyright (c) 2014 Amos Todman. All rights reserved.
//
@import UIKit;
// Speed of nav bar height animation: less time = faster animation
#define NAVBAR_HEIGHT_DELAY_INCREMENT 0.001

/**
 *  Provides methods to resize a UIViewController's UINavigationBar with animation
 */
@interface ATNavigationBarService : NSObject
/**
 *  Singleton for convenience
 *
 *  @return Singleton instance of this class
 */
+ (instancetype)sharedInstance;
/**
 *  Adjust a view controller's navigation bar height
 *
 *  Note: If the height will get smaller the bar button items will dissapear and come back when maximized
 *
 *  @param height          height to minimize to
 *  @param viewController  view controller holding the navigation bar
 *  @param shouldHideItems if true, hide navBar items when minimizing
 */
- (void)changeNavigationBarHeight:(CGFloat)height
                 onViewController:(UIViewController *)viewController
                     hideBarItems:(BOOL)shouldHideItems;
/**
 *  Minimize a view controller's navigation bar
 *
 *  @param viewController view controller holding the navigation bar
 *  @param height         height to minimize to
 *  @param shouldHideItems if true, hide navBar items if minimizing
 */
- (void)minimizeNavOnViewController:(UIViewController *)viewController
                           toHeight:(CGFloat)height
                       hideBarItems:(BOOL)shouldHideItems;
/**
 *  Maximize a view controller's navigation bar
 *
 *  @param viewController view controller holding the navigation bar
 *  @param height         height to maximize to
 */
- (void)maximizeNavOnViewController:(UIViewController *)viewController
                           toHeight:(CGFloat)height;
/**
 *  Hides navigation bar button items
 *
 *  @param viewController View controller holding the navigation bar
 */
- (void)hideBarItemsOnViewController:(UIViewController *)viewController;
/**
 *  Shows navigation bar button items
 *
 *  @param viewController View controller holding the navigation bar
 */
- (void)showBarItemsOnViewController:(UIViewController *)viewController;

@end

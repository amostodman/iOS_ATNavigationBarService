//
//  ATNavigationBarHeightService.m
//
//  Created by Amos Todman on 9/24/14.
//  Copyright (c) 2014 Amos Todman. All rights reserved.
//

#import "ATNavigationBarService.h"

@interface ATNavigationBarService ()

@property (nonatomic,strong) NSMutableDictionary* storedNavTitleTextAttributes;
@property (nonatomic,strong) NSMutableArray* rightNavBarButtons;
@property (nonatomic,strong) NSMutableArray* leftNavBarButtons;
@property (nonatomic,assign) CGFloat navBarMinimizedHeight;
@property (nonatomic,assign) CGFloat navBarMaximizedHeight;
@property (nonatomic,assign) BOOL navBarIsDecreasingHeight;
@property (nonatomic,assign) BOOL navBarIsIncreasingHeight;
@property (nonatomic,assign) BOOL navBarItemsAreHidden;

@end

@implementation ATNavigationBarService


#pragma mark - Lifecycle

- (id)init
{
    self = [super init];
    
    if (self) {
        self.rightNavBarButtons = [[NSMutableArray alloc] init];
        self.leftNavBarButtons = [[NSMutableArray alloc] init];
        return self;
    }
    return nil;
}

+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static ATNavigationBarService *instance;
    
    dispatch_once(&once, ^{
        instance = [[ATNavigationBarService alloc] init];
    });
    
    return instance;
}

- (void)dealloc
{
    // implement -dealloc & remove abort() when refactoring for
    // non-singleton use.
    abort();
}

#pragma mark - public

- (void)changeNavigationBarHeight:(CGFloat)height
                 onViewController:(UIViewController*)viewController
                     hideBarItems:(BOOL)shouldHideItems
{
    
    // get current nav bar frame
    CGRect frame = viewController.navigationController.navigationBar.frame;
    
    //minimizing
    if (frame.size.height > height) {
        [self minimizeNavOnViewController:viewController toHeight:height hideBarItems:shouldHideItems];
    }
    //maximizing
    if (frame.size.height < height) {
        [self maximizeNavOnViewController:viewController toHeight:height];
    }
}

- (void)hideBarItemsOnViewController:(UIViewController*)viewController {
    
    // if nav bar buttons are already hidden don't do anything
    if (self.navBarItemsAreHidden) {
        return;
    }
    
    // empty the storage
    self.rightNavBarButtons = nil;
    self.leftNavBarButtons = nil;
    
    self.rightNavBarButtons = [[NSMutableArray alloc] initWithArray:[viewController.navigationItem rightBarButtonItems]];
    self.leftNavBarButtons = [[NSMutableArray alloc] initWithArray:[viewController.navigationItem leftBarButtonItems]];
    
    // remove nav bar buttons
    viewController.navigationItem.rightBarButtonItems = nil;
    viewController.navigationItem.leftBarButtonItems = nil;
    self.navBarItemsAreHidden = YES;
}
- (void)showBarItemsOnViewController:(UIViewController*)viewController {
    // add nav bar items
    viewController.navigationItem.rightBarButtonItems = self.rightNavBarButtons;
    viewController.navigationItem.leftBarButtonItems = self.leftNavBarButtons;
    self.navBarItemsAreHidden = NO;
}

#pragma mark - Private

- (void)minimizeNavOnViewController:(UIViewController*)viewController
                           toHeight:(CGFloat)height
                       hideBarItems:(BOOL)shouldHideItems {

    // store height
    self.navBarMinimizedHeight = height;
    
    // get current frame
    CGRect frame = viewController.navigationController.navigationBar.frame;
    
    // If already minimized do nothing
    if (frame.size.height == self.navBarMinimizedHeight) {
        self.navBarIsDecreasingHeight = NO;
        return;
    }
    
    // store the buttons if we're starting the animation
    if (!self.navBarIsDecreasingHeight && !self.navBarItemsAreHidden) {
        self.rightNavBarButtons = nil;
        self.leftNavBarButtons = nil;
        
        self.rightNavBarButtons = [[NSMutableArray alloc] initWithArray:[viewController.navigationItem rightBarButtonItems]];
        self.leftNavBarButtons = [[NSMutableArray alloc] initWithArray:[viewController.navigationItem leftBarButtonItems]];
    }
    
    // update status
    self.navBarIsDecreasingHeight = YES;

    //store text attributes
    self.storedNavTitleTextAttributes = viewController.navigationController.navigationBar.titleTextAttributes.mutableCopy;
    
    // create text attributes if there were none so we can change font etc
    if (!self.storedNavTitleTextAttributes) {
        self.storedNavTitleTextAttributes = [[NSMutableDictionary alloc] init];
        self.storedNavTitleTextAttributes[NSFontAttributeName] = [UIFont boldSystemFontOfSize:12];
    }
    
    // Make the font smaller
    self.storedNavTitleTextAttributes[NSFontAttributeName] = [UIFont boldSystemFontOfSize:12];
    [viewController.navigationController.navigationBar setTitleTextAttributes:self.storedNavTitleTextAttributes];
    
    // decrement the nav bar height;
    frame.size.height--;
    [viewController.navigationController.navigationBar setFrame:frame];
    
    if (shouldHideItems) {
        // remove the bar button items - don't worry we saved them above
        viewController.navigationItem.rightBarButtonItems = nil;
        viewController.navigationItem.leftBarButtonItems = nil;
        self.navBarItemsAreHidden = YES;
    }
    
    if (frame.size.height > self.navBarMinimizedHeight) {
        // small delay simulates an animation
        double delayInSeconds = NAVBAR_HEIGHT_DELAY_INCREMENT;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
            // run again if our height limit has not been hit
            
            [self minimizeNavOnViewController:viewController toHeight:height hideBarItems:shouldHideItems];
            
        });
    } else {
        self.navBarIsDecreasingHeight = NO;
    }
}
- (void)maximizeNavOnViewController:(UIViewController*)viewController toHeight:(CGFloat)height
{
    // update status
    self.navBarIsIncreasingHeight = YES;
    self.navBarMaximizedHeight = height;
    
    // get current nav bar frame
    CGRect frame = viewController.navigationController.navigationBar.frame;
    
    // If already maximized do nothing
    if (frame.size.height == self.navBarMaximizedHeight) {
        self.navBarIsIncreasingHeight = NO;
        return;
    }
    
    // title font
    self.storedNavTitleTextAttributes[NSFontAttributeName] = [UIFont boldSystemFontOfSize:17];
    [viewController.navigationController.navigationBar setTitleTextAttributes:self.storedNavTitleTextAttributes];
    
    // add nav bar items
    viewController.navigationItem.rightBarButtonItems = self.rightNavBarButtons;
    viewController.navigationItem.leftBarButtonItems = self.leftNavBarButtons;
    self.navBarItemsAreHidden = NO;
    
    // increment nav bar height
    frame.size.height++;
    [viewController.navigationController.navigationBar setFrame:frame];
    
    if (frame.size.height < self.navBarMaximizedHeight) {
        // small delay simulates an animation
        double delayInSeconds = NAVBAR_HEIGHT_DELAY_INCREMENT;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
            [self maximizeNavOnViewController:viewController toHeight:height];
        });
    } else {
        self.navBarIsIncreasingHeight = NO;
    }
}

@end

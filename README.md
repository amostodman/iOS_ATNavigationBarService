iOS_ATNavigationBarService
==========================

ATNavigationBarService is an iOS class which mainly provides methods for modifying the UINavigationBar height on the fly.

[Documentation is here](http://afewdevelopers.com/ATNavigationBarService/)

Quick Start

Import the ATNavigationBarService class files into your class file you wish to modify the UINavigationBar on.
Most likely a UIViewController which is inside a UINavigationController's array or viewControllers.

    import "ATNavigationBarService.h"

Now just use the methods when applicable:

    /* Hide the nav bar */
    [[ATNavigationBarService sharedInstance] changeNavigationBarHeight:20.0 onViewController:self hideBarItems:YES];

    /* Show the nav bar */
    [[ATNavigationBarService sharedInstance] changeNavigationBarHeight:44.0 onViewController:self hideBarItems:YES];

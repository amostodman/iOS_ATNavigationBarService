//
//  ViewController.m
//  ATNavigationBarService
//
//  Created by Amos Todman on 9/24/14.
//  Copyright (c) 2014 TeamAmos. All rights reserved.
//

#import "ViewController.h"
#import "ATNavigationBarService.h"

@interface ViewController ()

@property (nonatomic, strong) ATNavigationBarService *service;
@property (nonatomic, assign) BOOL wasLoadedBefore;

@end

@implementation ViewController

#pragma mark - UIViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appBecameActive:)
                                                 name:@"APP_BECAME_ACTIVE"
                                               object:nil];

    self.wasLoadedBefore = true;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions

- (IBAction)hideNav:(id)sender
{
    [[ATNavigationBarService sharedInstance] changeNavigationBarHeight:20.0 onViewController:self hideBarItems:YES];
    self.currentNavBarHeight = 20.0;
}
- (IBAction)showNav:(id)sender
{
    [[ATNavigationBarService sharedInstance] changeNavigationBarHeight:44.0 onViewController:self hideBarItems:YES];
    self.currentNavBarHeight = 44.0;
}
- (IBAction)hideNavBarButtons:(id)sender
{
    [[ATNavigationBarService sharedInstance] hideBarItemsOnViewController:self];
}
- (IBAction)showNavBarButtons:(id)sender
{
    [[ATNavigationBarService sharedInstance] showBarItemsOnViewController:self];
}

#pragma mark - private

- (void)appBecameActive:(NSNotification *)aNotification
{
    if (!self.currentNavBarHeight) {
        self.currentNavBarHeight = 44.0;
    }

    // maximize nav bar again and unhide buttons if necessary
    [self showNav:nil];
}
@end
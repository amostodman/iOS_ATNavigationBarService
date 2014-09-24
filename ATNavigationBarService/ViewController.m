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

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)hideNav:(id)sender
{
    [[ATNavigationBarService sharedInstance] changeNavigationBarHeight:20.0 onViewController:self hideBarItems:YES];
}
- (IBAction)showNav:(id)sender
{
    [[ATNavigationBarService sharedInstance] changeNavigationBarHeight:44.0 onViewController:self hideBarItems:YES];
}
- (IBAction)hideNavBarButtons:(id)sender
{
    [[ATNavigationBarService sharedInstance] hideBarItemsOnViewController:self];
}
- (IBAction)showNavBarButtons:(id)sender
{
    [[ATNavigationBarService sharedInstance] showBarItemsOnViewController:self];
}
@end
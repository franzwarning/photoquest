//
//  MainTabBarController.m
//  photoquest
//
//  Created by Raymond kennedy on 11/9/13.
//  Copyright (c) 2013 Randomay Designs. All rights reserved.
//

#import "MainTabBarController.h"

@interface MainTabBarController ()

@end

@implementation MainTabBarController

/*
 * Called right after the view loads
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    // Get whether or not this is the users first time launching the app
//    bool firstTime = true;
//    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"firstTime"]) firstTime = false;
//    
//    // Get the storyboard because we need it to instantiate view controllers
//    UIStoryboard *mainStoryboard =[UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
//    if (!firstTime) {
//        self.viewControllers = [NSArray arrayWithObject:[mainStoryboard instantiateViewControllerWithIdentifier:@"QuestsViewController"]];
//    } else {
//        self.viewControllers = [NSArray arrayWithObject:[mainStoryboard instantiateViewControllerWithIdentifier:@"GCLoginViewController"]];
//    }
}

@end

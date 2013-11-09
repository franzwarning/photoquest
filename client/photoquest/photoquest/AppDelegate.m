//
//  AppDelegate.m
//  photoquest
//
//  Created by Paul Julius Martinez on 6/30/13.
//  Copyright (c) 2013 Randomay Designs. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  // Override point for customization after application launch.
  [Parse setApplicationId:@"aGDSNbRnv8jv4Nz2iFyUInz0SrluXE333kIHq4Qm"
                clientKey:@"qjVw5kWxxzzdyCOy1YqpZnazNnPixCvhdAdGfTaI"];
  [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
  
  // Set the view controller structure
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  
  // Get the storyboard so we can do shit with it
  UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
  
  // Set the left and center panels
  self.viewController = [[JASidePanelController alloc] init];
  [self.viewController setAllowLeftOverpan:NO];
  self.viewController.leftPanel = [mainStoryboard instantiateViewControllerWithIdentifier:@"LeftPanelViewController"];
  
  UIViewController *centerViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"QuestsNavigationController"];
  self.viewController.centerPanel = centerViewController;
  
  self.window.rootViewController = self.viewController;
  [self.window makeKeyAndVisible];
  
  bool firstTime = true;
  if ([[NSUserDefaults standardUserDefaults] valueForKey:@"firstTime"]) firstTime = false;
  
  // On every app startup, authenticate the player
  if (!firstTime) [self authenticateLocalPlayer];
  
  //  // Register for push notifications
  //  [[UIApplication sharedApplication] registerForRemoteNotificationTypes: UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound];
  
  return YES;
}

- (JASidePanelController *)getSidePanelController
{
  return self.viewController;
}

/*
 * Called on every app launch, pretty much checks the current state of the Game Center user
 * and acts accordingly.
 */
- (void)authenticateLocalPlayer
{
  // If the player is already authenticated the block returns pretty much immediately so
  // no need to worry about network lag. If the user hasn't authenticated yet, show the controller
  GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
  [localPlayer setAuthenticateHandler:^(UIViewController *viewController, NSError *error) {
    
    if (viewController) {
      // Gamecenter wants us to display the controller
      [PFUser logOut];
      [self.window.rootViewController presentViewController:viewController animated:YES completion:^{}];
      
    } else if ([GKLocalPlayer localPlayer].isAuthenticated) {
      // Check which page we are on, and go to homeViewController if neccessary
      [[NSNotificationCenter defaultCenter] postNotificationName:@"GCLoginSuccess" object:nil];
      
      // login/create account for PFUser
      PFUser *currentUser = [PFUser currentUser];
      if (!currentUser) {
        // The user isn't logged in yet
        [self setupUser];
      } else {
        [[PFUser currentUser] refreshInBackgroundWithBlock:^(PFObject *object, NSError *error) {
          [User createOrUpdateUser:[PFUser currentUser]];
        }];
      }
      
    } else {
      // Display the login page, because the user denied the login
      [[NSNotificationCenter defaultCenter] postNotificationName:@"GCLoginFailed" object:nil];
      
      [PFUser logOut];
      
      // Present the GCLoginViewController
      UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
      UIViewController *GCLoginViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"GCLoginViewController"];
      [self.window.rootViewController presentViewController:GCLoginViewController animated:YES completion:^{}];

    }
  }];
}

/*
 * If the user isn't logged in, or doesn't have an account yet, this method is called.
 * I did a little hack and made everyone's password "photoquest", since we don't really care about
 * passwords -- that's Game Center's problem. By default on parse - "username":GameCenterID, "password":"photoquest",
 * "gameCenterAlias":GameCenterAlias.
 */
- (void)setupUser
{
  // First try to login the user
  NSString *username = [GKLocalPlayer localPlayer].playerID;
  [PFUser logInWithUsernameInBackground:username password:@"photoquest" block:^(PFUser *user, NSError *error) {
    if (user) {
      // Do stuff after successful login.
      NSLog(@"PFUser has logged in!");
      PFInstallation *currentInstallation = [PFInstallation currentInstallation];
      [currentInstallation setObject:[PFUser currentUser] forKey:@"owner"];
      [currentInstallation saveInBackground];
      
      // Update their alias if it has changed
      if ([[user valueForKey:@"alias"]  isEqualToString:[GKLocalPlayer localPlayer].alias]) {
        [[PFUser currentUser] setValue:[GKLocalPlayer localPlayer].alias forKey:@"gameCenterAlias"];
        [[PFUser currentUser] saveInBackground];
      }

      [User createOrUpdateUser:[PFUser currentUser]];
      
    } else {
      // The login failed. Check error to see why.
      NSLog(@"User probably doesn't have an account yet");
      PFUser *newUser = [PFUser user];
      newUser.username = [GKLocalPlayer localPlayer].playerID;
      newUser.password = @"photoquest";
      [newUser setValue:[NSNumber numberWithInt:0] forKey:@"xp"];
      [newUser setValue:[GKLocalPlayer localPlayer].alias forKey:@"gameCenterAlias"];
      [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
          // Hooray! Let them use the app now.
          NSLog(@"PFUser has logged in for the first time!");
          PFInstallation *currentInstallation = [PFInstallation currentInstallation];
          [currentInstallation setObject:[PFUser currentUser] forKey:@"owner"];
          [currentInstallation saveInBackground];
          
          [User createOrUpdateUser:[PFUser currentUser]];

        } else {
          NSString *errorString = [[error userInfo] objectForKey:@"error"];
          NSLog(@"Error creating Parse account: %@", errorString);
        }
      }];
    }
  }];
}

/*
 * User hit "Allow Push Notifications", so let's send the token to parse
 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)newDeviceToken {
  
  // Store the deviceToken in the current installation and save it to Parse.
  PFInstallation *currentInstallation = [PFInstallation currentInstallation];
  [currentInstallation setDeviceTokenFromData:newDeviceToken];
  [currentInstallation saveInBackground];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

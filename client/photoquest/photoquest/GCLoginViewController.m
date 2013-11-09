//
//  GCLoginViewController.m
//  PhotoQuest
//
//  Created by Matt Portner on 5/19/13.
//  Copyright (c) 2013 Raymond kennedy. All rights reserved.
//

#import "GCLoginViewController.h"

@interface GCLoginViewController ()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, weak) IBOutlet UIButton *gameCenterLoginButton;
@property (nonatomic, weak) IBOutlet UILabel *gameCenterMessage;
@property (nonatomic, weak) IBOutlet UILabel *loadingLabel;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation GCLoginViewController

@synthesize timer = _timer;
@synthesize gameCenterLoginButton = _gameCenterLoginButton;
@synthesize gameCenterMessage = _gameCenterMessage;
@synthesize loadingLabel = _loadingLabel;
@synthesize activityIndicator = _activityIndicator;

/*
 * The view loads, set the timer
 */
- (void)viewDidLoad
{
  [super viewDidLoad];
  
  // Set a timer that goes off every two seconds to see if the user has authenticated
  self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(checkForLogin) userInfo:nil repeats:YES];
  
  // Hide the loading stuff
  [self loadingUIHidden:true];
  
  // Make sure the sidepanel is hidden and center view is selected
  JASidePanelController *sidePanelController = (JASidePanelController *)((AppDelegate *)[[UIApplication sharedApplication] delegate]).viewController;
  [sidePanelController showCenterPanelAnimated:true];
  [sidePanelController setAllowLeftSwipe:false];
}

/*
 * Checks every time the timer calls this function (every 2 sec.) to see if the user is authenticated yet
 */
- (void)checkForLogin
{
  bool firstTime = true;
  if ([[NSUserDefaults standardUserDefaults] valueForKey:@"firstTime"]) firstTime = false;
  
  if ([GKLocalPlayer localPlayer].isAuthenticated && !firstTime) {
    [self.timer invalidate];
    
    // Make sure the user is already logged in via parse as well
    PFUser *currentUser = [PFUser currentUser];
    if (!currentUser) {
      // The user isn't logged in yet
      NSLog(@"This should probably be called because the PFUser was logged out when he/she failed authentication on GameCenter");
      [(AppDelegate *)[[UIApplication sharedApplication] delegate] setupUser];
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
      // Enable the side panel stuff
      JASidePanelController *sidePanelController = (JASidePanelController *)((AppDelegate *)[[UIApplication sharedApplication] delegate]).viewController;
      [sidePanelController showCenterPanelAnimated:true];
      [sidePanelController setAllowLeftSwipe:true];
    }];
  }
}

/*
 * Redirect to game center, or set the authentication handler
 * for gamecenter
 */
- (IBAction)gameCenterLoginButtonPressed:(UIButton *)sender
{
  // Check to see if this is the users very first time using the app
  bool firstTime = true;
  if ([[NSUserDefaults standardUserDefaults] valueForKey:@"firstTime"]) firstTime = false;
  
  if (firstTime) {
    // Update the UI
    [self loadingUIHidden:false];
    [[NSUserDefaults standardUserDefaults] setValue:@"temp" forKey:@"firstTime"];
    
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    [localPlayer setAuthenticateHandler:^(UIViewController *viewController, NSError *error) {
      [self loadingUIHidden:true];
      
      if (viewController) {
        [PFUser logOut];
        
        // Gamecenter wants us to display the controller
        [self presentViewController:viewController animated:YES completion:^{}];
        
      } else if ([GKLocalPlayer localPlayer].isAuthenticated) {
        [self.timer invalidate];
        
        // login/create account for PFUser
        PFUser *currentUser = [PFUser currentUser];
        if (!currentUser) {
          // The user isn't logged in yet
          [(AppDelegate *)[[UIApplication sharedApplication] delegate] setupUser];
          
        } else {
          NSLog(@"The current user is already logged in? Something must have gone wrong....");
        }
        
        // Enable the side panel stuff
        JASidePanelController *sidePanelController = (JASidePanelController *)((AppDelegate *)[[UIApplication sharedApplication] delegate]).viewController;
        [sidePanelController showCenterPanelAnimated:true];
        [sidePanelController setAllowLeftSwipe:true];
        
        // Go to main quest view
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        UIViewController *questsViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"QuestsViewController"];
        [self.navigationController setViewControllers:[NSArray arrayWithObject:questsViewController] animated:YES];
                
      } else {
        [PFUser logOut];

        // Display the login page, because the user denied the login
        NSLog(@"Login Failed");
      }
    }];
  } else {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"gamecenter:"]];
  }
}

/*
 * Make the loading UIHidden
 */
- (void)loadingUIHidden:(bool)hidden
{
    self.activityIndicator.hidden = hidden;
    self.loadingLabel.hidden = hidden;
    if (hidden) [self.activityIndicator stopAnimating];
    else [self.activityIndicator startAnimating];
}

@end
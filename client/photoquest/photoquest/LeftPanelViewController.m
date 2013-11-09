//
//  LeftPanelViewController.m
//  photoquest
//
//  Created by Raymond Kennedy on 7/13/13.
//  Copyright (c) 2013 Randomay Designs. All rights reserved.
//

#import "LeftPanelViewController.h"

@interface LeftPanelViewController ()

@property (nonatomic, strong) IBOutlet UIImageView *profPicImageView;
@property (nonatomic, strong) IBOutlet UILabel *usernameLabel;
@property (nonatomic, strong) IBOutlet UILabel *levelLabel;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) XPBarView *xpBar;

@end

@implementation LeftPanelViewController

@synthesize profPicImageView = _profPicImageView;
@synthesize usernameLabel = _usernameLabel;
@synthesize levelLabel = _levelLabel;
@synthesize scrollView = _scrollView;
@synthesize xpBar = _xpBar;

#define LEFT_PADDING 20
#define XP_BAR_WIDTH 200
#define XP_BAR_HEIGHT 30

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.levelLabel.textColor = [UIColor colorWithRed:0.61f green:0.35f blue:0.71f alpha:1.00f];
  self.profPicImageView.layer.borderColor = [UIColor colorWithRed:0.61f green:0.35f blue:0.71f alpha:1.00f].CGColor;
  self.profPicImageView.layer.borderWidth = 2.0f;
  self.profPicImageView.layer.cornerRadius = 6.0f;
  [self.profPicImageView.layer setMasksToBounds:YES];
  
  self.xpBar = [[XPBarView alloc] initWithFrame:CGRectMake(LEFT_PADDING, self.usernameLabel.frame.origin.y + 50, XP_BAR_WIDTH, XP_BAR_HEIGHT)];
  [self.scrollView addSubview:self.xpBar];
  
  self.levelLabel.text = @"...";
  self.usernameLabel.text = @"...";
}

- (void)setupXPBar
{
  if ([PFUser currentUser]) {
    float newRatio = [[XPManager sharedManager] getRatioForXp:[[[User getCurrentUser] xp] intValue]];

    [self.xpBar updateToRatio:newRatio];
  }
}

- (void)willBecomeActiveAsPanelAnimated:(BOOL)animated withBounce:(BOOL)withBounce
{
  // Load the profilePicture
  if ([GKLocalPlayer localPlayer].isAuthenticated) [self loadProfilePicture];
  [self setupUsername];
  [self setupLevel];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  // Load the profilePicture
  if ([GKLocalPlayer localPlayer].isAuthenticated) [self loadProfilePicture];
  [self setupUsername];
  [self setupLevel];
  [self setupXPBar];
}

- (void)setupLevel
{
  if ([PFUser currentUser]) {
    int currentLevel = [[User getCurrentUser] getLevel];
    self.levelLabel.text = [NSString stringWithFormat:@"%02d", currentLevel];
  } else {
    self.levelLabel.text = @"...";
  }
}

- (void)setupUsername
{
  if ([GKLocalPlayer localPlayer].isAuthenticated) self.usernameLabel.text = [GKLocalPlayer localPlayer].alias;
  else self.usernameLabel.text = @"LOADING...";
}



- (void)loadProfilePicture
{
//  GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
//  [localPlayer loadPhotoForSize:GKPhotoSizeSmall withCompletionHandler:^(UIImage *photo, NSError *error) {
//    CABasicAnimation *crossFade = [CABasicAnimation animationWithKeyPath:@"contents"];
//    crossFade.duration = 1.0f;
//    crossFade.fromValue = (id)[self.profPicImageView image].CGImage;
//    crossFade.toValue = (id)photo.CGImage;
//    [self.profPicImageView.layer addAnimation:crossFade forKey:@"animateContents"];
//    
//    self.profPicImageView.image = photo;
//  }];
}

@end

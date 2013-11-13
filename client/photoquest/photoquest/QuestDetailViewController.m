//
//  QuestDetailViewController.m
//  photoquest
//
//  Created by Matt Portner on 7/5/13.
//  Copyright (c) 2013 Randomay Designs. All rights reserved.
//

#import "QuestDetailViewController.h"

@interface QuestDetailViewController ()

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UILabel *questLabel;
@property (nonatomic, weak) IBOutlet UILabel *xpLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet UIView *timeView;
@property (nonatomic, weak) IBOutlet UIButton *beginQuestButton;

@end

@implementation QuestDetailViewController

@synthesize questLabel = _questLabel;
@synthesize timeLabel = _timeLabel;
@synthesize xpLabel = _xpLabel;
@synthesize currentQuest = _currentQuest;
@synthesize scrollView = _scrollView;
@synthesize isDaily = _isDaily;
@synthesize dailyQuest = _dailyQuest;
@synthesize timeView = _timeView;
@synthesize beginQuestButton = _beginQuestButton;

/*
 * Called when the view first loads
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.beginQuestButton.layer.cornerRadius = 6.0f;
    self.beginQuestButton.layer.borderColor = [UIColor colorWithRed:0.18f green:0.80f blue:0.44f alpha:1.00f].CGColor;
    self.beginQuestButton.layer.borderWidth = 3.0f;
    [self.beginQuestButton.layer setMasksToBounds:YES];
}

/*
 * Setup the DefaultQuestBoxView
 */
- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
    
}

@end

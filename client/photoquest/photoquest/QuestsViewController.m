//
//  QuestsViewController.m
//  photoquest
//
//  Created by Matt Portner on 7/5/13.
//  Copyright (c) 2013 Randomay Designs. All rights reserved.
//

#import "QuestsViewController.h"

@interface QuestsViewController () <QuestManagerDelegate>

@property (nonatomic, strong) Quest *dailyQuest;

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UILabel *questLabel;
@property (nonatomic, weak) IBOutlet UILabel *xpLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet UIButton *questButton;
@property (nonatomic, weak) IBOutlet UIView *statsView;

@end


@implementation QuestsViewController

#define QUEST_LABEL_Y_SPACING 75
#define QUEST_LABEL_X_SPACING 20
#define QUEST_LABEL_WIDTH 280
#define QUEST_LABEL_BOTTOM_PADDING 20

/*
 * The view has finished loading
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Set the daily quest to nil
    self.dailyQuest = nil;
    
    // Fire the seconds timer
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateDailyQuestTimer) userInfo:nil repeats:YES];
    [timer fire];
    
    // So the timer still fires while scrolling
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

/*
 * Setup the view right before it appears
 */
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.questButton.enabled = NO;
    
    // Get the current quests the user is working on
    [[QuestManager sharedManager] setDelegate:self];
    [[QuestManager sharedManager] getDailyQuest];
    
    if (!self.dailyQuest) {
        [self changeQuestText:@"Loading..."];
        [self.xpLabel setText:@"Loading..."];
    }
    
    // Unhide the tab bar
    [self.tabBarController.tabBar setHidden:NO];

}

/*
 * Adjusts the quest label height and animates the change (if any)
 */
- (void)changeQuestText:(NSString *)text;
{
    if ([text isEqualToString:self.questLabel.text]) return;
    
    // Adjust the size of the label accordingly
    CGSize maximumLabelSize = CGSizeMake(QUEST_LABEL_WIDTH, 9999);
    CGSize expectedLabelSize = [text sizeWithFont:[UIFont fontWithName:@"HelveticaNeue" size:19] constrainedToSize:maximumLabelSize lineBreakMode:NSLineBreakByTruncatingTail];
    
    CATransition *animation = [CATransition animation];
    animation.duration = 0.4f;
    animation.type = kCATransitionPush;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.questLabel.layer addAnimation:animation forKey:@"changeTextTransition"];
    self.questLabel.text = text;
    
    [self.questLabel setFrame:CGRectMake(QUEST_LABEL_X_SPACING, QUEST_LABEL_Y_SPACING, QUEST_LABEL_WIDTH, expectedLabelSize.height)];
    
    NSLog(@"Frame: %@", NSStringFromCGRect(self.questLabel.frame));
    
    // Make sure the stat height is the right place
    [self updateStatViewHeight];
}

/*
 * Update stats view height
 */
- (void)updateStatViewHeight
{
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.statsView setFrame:CGRectMake(QUEST_LABEL_X_SPACING, self.questLabel.frame.origin.y + self.questLabel.frame.size.height + QUEST_LABEL_BOTTOM_PADDING, self.statsView.frame.size.width, self.statsView.frame.size.height)];
    } completion:^(BOOL finished) {}];
}

/*
 * Called from QuestManager.h
 */
- (void)foundDailyQuest:(Quest *)dailyQuest
{
    self.dailyQuest = dailyQuest;
    [self changeQuestText:self.dailyQuest.text];
    
    [self checkForQuestButton];
    [self updateStats];
    
    NSLog(@"Daily Quest: %@", dailyQuest.text);
}

/*
 * Updates the quest button to the appropriate shit
 */
- (void)checkForQuestButton
{
    // Get the quest and see if it has a submission from user
    NSManagedObjectContext *moc = [[DataManager sharedInstance] managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"quest == %@ && owner == %@", self.dailyQuest, [User getCurrentUser]];
    [request setFetchLimit:1];
    [request setPredicate:predicate];
    [request setEntity:[NSEntityDescription entityForName:@"Submission" inManagedObjectContext:moc]];
    
    NSError *error = nil;
    NSArray *results = [moc executeFetchRequest:request error:&error];
    
    if (![results count] || !results) {
        
        // User hasn't submitted yet
        NSLog(@"User hasn't submitted for quest yet...");
        [self.questButton setEnabled:YES];
        [self.questButton setTitle:@"Begin Quest" forState:UIControlStateNormal];
        [self.questButton setTitleColor:[UIColor colorWithRed:0.18f green:0.80f blue:0.44f alpha:1.00f] forState:UIControlStateNormal];
        
    } else if ([results count] == 1) {
        
        // User has already submitted
        NSLog(@"User already submitted for quest...");
        [self.questButton setEnabled:NO];
        [self.questButton setTitle:@"In Progress..." forState:UIControlStateNormal];
        [self.questButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        
    } else {
        // We encountered a fatal error
        NSLog(@"[FATAL] -- found more than one daily quest for date: %@", [[NSDate date] strippedDate]);

    }
}

/*
 * Update all the stats elements
 */
- (void)updateStats
{
    // First set the xp to the appropriate amount...
    self.xpLabel.text = [NSString stringWithFormat:@"%d XP", [self.dailyQuest.xp intValue]];
}

/*
 * Update the timer in the daily quest box
 */
- (void)updateDailyQuestTimer
{
    NSDate *referenceDate = [NSDate date];
    int hours = 23 - [referenceDate hour];
    int mins = 59 - [referenceDate minute];
    int seconds = 59 - [referenceDate second];
    
    self.timeLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d", hours, mins, seconds];
}

/*
 * Failed to load teh daily quest
 */
- (void)failedToGetDailyQuest
{
    self.dailyQuest = nil;
    [self changeQuestText:@"We probably forgot to set the quest..."];
    
    NSLog(@"Failed to get the daily quest...");
}

/*
 * Quest button
 */
- (IBAction)questButtonHit:(id)sender
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    QuestDetailViewController *qdvc = [mainStoryboard instantiateViewControllerWithIdentifier:@"QuestDetailViewController"];
    qdvc.currentQuest = self.dailyQuest;
    
    [self.navigationController pushViewController:qdvc animated:YES];
}

@end

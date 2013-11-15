//
//  QuestsViewController.m
//  photoquest
//
//  Created by Matt Portner on 7/5/13.
//  Copyright (c) 2013 Randomay Designs. All rights reserved.
//

#import "QuestsViewController.h"

@interface QuestsViewController () <QuestManagerDelegate>

@property (nonatomic, strong) NSArray *currentQuests;
@property (nonatomic, strong) DailyQuest *dq;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end


@implementation QuestsViewController

#define QUEST_Y_SPACING 8.0f
#define QUEST_LABEL_WIDTH 206.0f
#define QUEST_X_SPACING 20.0f

/*
 * The view has finished loading
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.dq = nil;
}

/*
 * Setup the view right before it appears
 */
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Get the current quests the user is working on
    [[QuestManager sharedManager] setDelegate:self];
    self.currentQuests = [[QuestManager sharedManager] getCurrentQuests];
}

/*
 * Called from QuestManager.h
 */
- (void)foundDailyQuest:(DailyQuest *)dailyQuest
{
    if (!self.dq  || ![dailyQuest.text isEqualToString:self.dq.text]) {
        self.dq = dailyQuest;
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationMiddle];
        
        // Setup the timer
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateDailyQuestTimer) userInfo:nil repeats:YES];
        [timer fire];
        
        // So the timer still fires while scrolling
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    }
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
    
    DailyQuestCell *dqc = (DailyQuestCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    dqc.timeLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d", hours, mins, seconds];
}

/*
 * Failed to load teh daily quest
 */
- (void)failedToGetDailyQuest
{
    NSLog(@"Failed to get the daily quest...");
}


#pragma TableViewDataSource

/*
 * Called for every cell in the table view
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSString *cellIdentifier = @"";
    
    if (indexPath.row == 0) {
        // Release a daily quest cell
        cellIdentifier = @"DailyQuestCell";
        
        DailyQuestCell *dqc = (DailyQuestCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (self.dq) {
            dqc.questLabel.text = self.dq.text;
            dqc.xpView.hidden = NO;
            dqc.timeView.hidden = NO;
            dqc.xpLabel.text = [NSString stringWithFormat:@"%d XP", self.dq.xp];
            
        } else {
            dqc.questLabel.text = @"Loading...";
            dqc.xpView.hidden = YES;
            dqc.timeView.hidden = YES;
        }
        
        // Adjust the size of the label accordingly
        CGSize maximumLabelSize = CGSizeMake(QUEST_LABEL_WIDTH, 9999);
        CGSize expectedLabelSize = [dqc.questLabel.text sizeWithFont:[UIFont fontWithName:@"HelveticaNeue" size:17] constrainedToSize:maximumLabelSize lineBreakMode:NSLineBreakByTruncatingTail];
        [dqc.questLabel setFrame:CGRectMake(QUEST_X_SPACING, QUEST_Y_SPACING, QUEST_LABEL_WIDTH, expectedLabelSize.height + 1)];
        
        return dqc;
    } else {
        // Release a default quest cell
        cellIdentifier = @"DefaultQuestCell";
        
        DefaultQuestCell *dqc = (DefaultQuestCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        Quest *currentQuest = [self.currentQuests objectAtIndex:(indexPath.row - 1)];
        
        dqc.questLabel.text = currentQuest.text;
        dqc.xpLabel.text = [NSString stringWithFormat:@"%d XP", [currentQuest.xp intValue]];

        // Adjust the size of the label accordingly
        CGSize maximumLabelSize = CGSizeMake(QUEST_LABEL_WIDTH, 9999);
        CGSize expectedLabelSize = [dqc.questLabel.text sizeWithFont:[UIFont fontWithName:@"HelveticaNeue" size:17] constrainedToSize:maximumLabelSize lineBreakMode:NSLineBreakByTruncatingTail];
        [dqc.questLabel setFrame:CGRectMake(QUEST_X_SPACING, QUEST_Y_SPACING, QUEST_LABEL_WIDTH, expectedLabelSize.height + 1)];
        
        return dqc;
    }
    
    return nil;
}

/*
 * Get the number of rows in a given section in the table view
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ([self.currentQuests count] + 1);
}

/*
 * Get the height for each row @ index path
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *questText = @"";
    if (indexPath.row == 0) {
        if (self.dq) questText = self.dq.text;
        else questText = @"Loading...";
    } else {
        Quest *currentQuest = [self.currentQuests objectAtIndex:(indexPath.row - 1)];
        questText = currentQuest.text;
    }
    CGSize maximumLabelSize = CGSizeMake(QUEST_LABEL_WIDTH, 9999);
    CGSize expectedLabelSize = [questText sizeWithFont:[UIFont fontWithName:@"HelveticaNeue" size:17] constrainedToSize:maximumLabelSize lineBreakMode:NSLineBreakByTruncatingTail];
    return MAX(50, (2 * QUEST_Y_SPACING) + expectedLabelSize.height + 1);
}

/*
 * To hide the extra rows in the table view.
 */
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return 0.01f;
}

/*
 * After selecting a row
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    QuestDetailViewController *qdvc = [mainStoryboard instantiateViewControllerWithIdentifier:@"QuestDetailViewController"];
    
    if (indexPath.row == 0) {
        qdvc.isDaily = YES;
        qdvc.dailyQuest = self.dq;
    } else {
        qdvc.isDaily = NO;
        qdvc.currentQuest = [self.currentQuests objectAtIndex:(indexPath.row - 1)];
    }
    
    [self.navigationController pushViewController:qdvc animated:YES];
}


@end

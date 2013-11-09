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
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) DailyQuestBoxView *dqbv;
@property (nonatomic, strong) NSMutableArray *questBoxes;
@property (nonatomic, strong) DailyQuest *dq;
@property (nonatomic) BOOL introTweenHasFinished;
@property (nonatomic, strong) NSTimer *animTimer;

@end


@implementation QuestsViewController

@synthesize currentQuests = _currentQuests;
@synthesize scrollView = _scrollView;
@synthesize dqbv = _dqbv;
@synthesize questBoxes = _questBoxes;
@synthesize dq = _dq;
@synthesize introTweenHasFinished = _introTweenHasFinished;
@synthesize animTimer = _animTimer;

#define SPACE_BETWEEN_BOX 10
#define TIME_BETWEEN_QUEST_ANIMATION 0.2
#define QUEST_ANIMATION_TIME .3
#define QUEST_BOX_WIDTH 300
#define QUEST_BOX_HEIGHT 90
#define QUEST_ANIMATION_LEFT_START -310
#define QUEST_ANIMATION_RIGHT_START 320
/*
 * The view has finished loading
 */
- (void)viewDidLoad
{
  [super viewDidLoad];
	// Do any additional setup after loading the view.
  
  self.dqbv = [[DailyQuestBoxView alloc] initWithFrame:CGRectMake(SPACE_BETWEEN_BOX, SPACE_BETWEEN_BOX, QUEST_BOX_WIDTH, QUEST_BOX_HEIGHT)];
  [self.scrollView addSubview:self.dqbv];
  self.questBoxes = [[NSMutableArray alloc] init];
  
  self.animTimer = [NSTimer timerWithTimeInterval:0.5f target:self selector:@selector(checkAnimDone) userInfo:nil repeats:YES];
  [self.animTimer fire];
  
  [[NSRunLoop currentRunLoop] addTimer:self.animTimer forMode:NSRunLoopCommonModes];
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
  
  [self layoutQuests];
}

/*
 * Adds the quests to the view in an elegant way
 */
- (void)layoutQuests
{
  double currentY = SPACE_BETWEEN_BOX * 2 + self.dqbv.frame.size.height;
  
  if ([self.questBoxes count] == 0) {
    
    self.introTweenHasFinished = NO;
    for (int i = 0; i < [self.currentQuests count]; i++) {
      // Create a box for each quest
      Quest *currentQuest = [self.currentQuests objectAtIndex:i];
      
      // Animate the quests coming in
      DefaultQuestBoxView *box;
      if ((i%2) != 0) {
        box = [[DefaultQuestBoxView alloc] initWithFrame:CGRectMake(QUEST_ANIMATION_LEFT_START, currentY, QUEST_BOX_WIDTH, QUEST_BOX_HEIGHT) quest:currentQuest];
        [self.scrollView addSubview:box];
        [UIView animateWithDuration:QUEST_ANIMATION_TIME delay:i*TIME_BETWEEN_QUEST_ANIMATION options:UIViewAnimationOptionCurveEaseOut animations:^{
          [box setFrame:CGRectMake(SPACE_BETWEEN_BOX * 2, currentY, box.frame.size.width, box.frame.size.height)];
        } completion:^(BOOL finished) {
          [UIView animateWithDuration:.1f delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            [box setFrame:CGRectMake(SPACE_BETWEEN_BOX, currentY, box.frame.size.width, box.frame.size.height)];
          } completion:^(BOOL finished) {
            if (i == (self.currentQuests.count - 1)) {
              self.introTweenHasFinished = YES;
            }
          }];
        }];
        
      } else {
        box = [[DefaultQuestBoxView alloc] initWithFrame:CGRectMake(QUEST_ANIMATION_RIGHT_START, currentY, QUEST_BOX_WIDTH, QUEST_BOX_HEIGHT) quest:currentQuest];
        [self.scrollView addSubview:box];
        [UIView animateWithDuration:QUEST_ANIMATION_TIME delay:i*TIME_BETWEEN_QUEST_ANIMATION options:UIViewAnimationOptionCurveEaseOut animations:^{
          [box setFrame:CGRectMake(0, currentY, box.frame.size.width, box.frame.size.height)];
        } completion:^(BOOL finished) {
          [UIView animateWithDuration:.1f delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            [box setFrame:CGRectMake(SPACE_BETWEEN_BOX, currentY, box.frame.size.width, box.frame.size.height)];
          } completion:^(BOOL finished) {
            if (i == (self.currentQuests.count - 1)) {
              self.introTweenHasFinished = YES;
            }
          }];
        }];
      }
      UITapGestureRecognizer *singleTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(questClicked:)];
      if (![box singleTap]) {
        [box addGestureRecognizer:singleTap];
        [box setSingleTap:singleTap];
      }
      box.tag = i;
      [self.questBoxes addObject:box];
      
      currentY += box.frame.size.height + SPACE_BETWEEN_BOX;
    }
  }
}

- (void)updateScrollViewHeight
{
  DefaultQuestBoxView *lastBox= [self.questBoxes lastObject];
  float totalHeight = lastBox.frame.origin.y + lastBox.frame.size.height + SPACE_BETWEEN_BOX;
  [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, totalHeight)];
}

/*
 * One of the quests was clicked - go to the QuestDetailViewController
 */
- (void)questClicked:(UITapGestureRecognizer *)sender
{
  UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
  QuestDetailViewController *qdvc = [mainStoryboard instantiateViewControllerWithIdentifier:@"QuestDetailViewController"];
  [qdvc setCurrentQuest:[self.currentQuests objectAtIndex:sender.view.tag]];
  [qdvc setIsDaily:NO];
  [self.navigationController pushViewController:qdvc animated:YES];
}

/*
 * Daily Quest clicked
 */
- (void)dailyQuestClicked
{
  UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
  QuestDetailViewController *qdvc = [mainStoryboard instantiateViewControllerWithIdentifier:@"QuestDetailViewController"];
  [qdvc setDailyQuest:self.dq];
  [qdvc setIsDaily:YES];
  [self.navigationController pushViewController:qdvc animated:YES];
}

/*
 * Check if the intro tween has finished - then perform the next animation
 */
- (void)checkAnimDone
{
  if (self.introTweenHasFinished && self.dq) {
    [self.animTimer invalidate];

    float newDailyBoxHeight = [self.dqbv updateWithQuest:self.dq];
    
    for (int i = 0; i < self.questBoxes.count; i++) {
      DefaultQuestBoxView *box = [self.questBoxes objectAtIndex:i];
      [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        [box setFrame:CGRectMake(box.frame.origin.x, box.frame.origin.y + (newDailyBoxHeight - self.dqbv.frame.size.height), box.frame.size.width, box.frame.size.height)];
      } completion:^(BOOL complete) {}];
    }
    
    [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
      [self.dqbv setFrame:CGRectMake(self.dqbv.frame.origin.x, self.dqbv.frame.origin.y, self.dqbv.frame.size.width, newDailyBoxHeight)];
    } completion:^(BOOL finished) {
      [self.dqbv showQuest:self.dq withHeight:newDailyBoxHeight];
      [self updateScrollViewHeight];
      UITapGestureRecognizer *singleTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dailyQuestClicked)];
      if (![self.dqbv singleTap]) {
        [self.dqbv addGestureRecognizer:singleTap];
        [self.dqbv setSingleTap:singleTap];
      }
    }];
  }
}

/*
 * Called from QuestManager.h
 */
- (void)foundDailyQuest:(DailyQuest *)dailyQuest
{
  if (![self.animTimer isValid] && !self.dq) {
    self.animTimer = [NSTimer timerWithTimeInterval:0.5f target:self selector:@selector(checkAnimDone) userInfo:nil repeats:YES];
    [self.animTimer fire];
    [[NSRunLoop currentRunLoop] addTimer:self.animTimer forMode:NSRunLoopCommonModes];
  }
  self.dq = dailyQuest;

}

/*
 * Failed to load teh daily quest
 */
- (void)failedToGetDailyQuest
{
  self.dq = nil;
  float newDailyBoxHeight = [self.dqbv updateHeightForQuest:@"FAILED TO LOAD QUEST..."];
  
  for (int i = 0; i < self.questBoxes.count; i++) {
    DefaultQuestBoxView *box = [self.questBoxes objectAtIndex:i];
    [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
      [box setFrame:CGRectMake(box.frame.origin.x, box.frame.origin.y + (newDailyBoxHeight - self.dqbv.frame.size.height), box.frame.size.width, box.frame.size.height)];
    } completion:^(BOOL complete) {}];
  }
  
  [self.dqbv setFailed];
}

@end

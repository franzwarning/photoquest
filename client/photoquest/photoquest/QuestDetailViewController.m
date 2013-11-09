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
@property (nonatomic, strong) IBOutlet UILabel *questTextLabel;

@end

@implementation QuestDetailViewController

#define QUEST_ANIMATION_TIME .3
#define QUEST_BOX_WIDTH 300
#define QUEST_BOX_HEIGHT 90
#define QUEST_ANIMATION_LEFT_START -310
#define QUEST_ANIMATION_RIGHT_START 320
#define TOP_PADDING 10
#define LEFT_PADDING 10

@synthesize currentQuest = _currentQuest;
@synthesize scrollView = _scrollView;
@synthesize questTextLabel = _questTextLabel;
@synthesize isDaily = _isDaily;
@synthesize dailyQuest = _dailyQuest;

/*
 * Take you back to the previous page
 */
- (IBAction)goBack:(id)sender
{
  [self.navigationController popViewControllerAnimated:YES];
}

/*
 * Setup the DefaultQuestBoxView
 */
- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  if (!self.isDaily) {
    DefaultQuestBoxView *box = [[DefaultQuestBoxView alloc] initWithFrame:CGRectMake(QUEST_ANIMATION_LEFT_START, TOP_PADDING, QUEST_BOX_WIDTH, QUEST_BOX_HEIGHT) quest:self.currentQuest];
    [self.scrollView addSubview:box];
    [UIView animateWithDuration:QUEST_ANIMATION_TIME delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
      [box setFrame:CGRectMake(LEFT_PADDING * 2, TOP_PADDING, box.frame.size.width, box.frame.size.height)];
    } completion:^(BOOL finished) {
      [UIView animateWithDuration:.1f delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        [box setFrame:CGRectMake(LEFT_PADDING, TOP_PADDING, box.frame.size.width, box.frame.size.height)];
      } completion:^(BOOL finished) {}];
    }];
  } else {
    DailyQuestBoxView *box = [[DailyQuestBoxView alloc] initWithFrame:CGRectMake(QUEST_ANIMATION_LEFT_START, TOP_PADDING, QUEST_BOX_WIDTH, QUEST_BOX_HEIGHT)];
    float newHeight = [box updateWithQuest:self.dailyQuest];

    [box setFrame:CGRectMake(box.frame.origin.x, box.frame.origin.y, box.frame.size.width, newHeight)];
    [box showQuest:self.dailyQuest withHeight:newHeight];
    [self.scrollView addSubview:box];
    [UIView animateWithDuration:QUEST_ANIMATION_TIME delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
      [box setFrame:CGRectMake(LEFT_PADDING * 2, TOP_PADDING, box.frame.size.width, box.frame.size.height)];
    } completion:^(BOOL finished) {
      [UIView animateWithDuration:.1f delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        [box setFrame:CGRectMake(LEFT_PADDING, TOP_PADDING, box.frame.size.width, box.frame.size.height)];
      } completion:^(BOOL finished) {}];
    }];
  }
}

@end

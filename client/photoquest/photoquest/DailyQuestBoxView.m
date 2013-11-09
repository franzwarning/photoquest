//
//  DailyQuestBoxView.m
//  photoquest
//
//  Created by Raymond Kennedy on 7/14/13.
//  Copyright (c) 2013 Randomay Designs. All rights reserved.
//

#import "DailyQuestBoxView.h"

@interface DailyQuestBoxView()

@property (nonatomic, strong) BebasLabel *questTextLabel;
@property (nonatomic, strong) BebasLabel *questXpLabel;

@end

@implementation DailyQuestBoxView

@synthesize questXpLabel = _questXpLabel;
@synthesize questTextLabel = _questTextLabel;
@synthesize singleTap = _singleTap;

#define QUEST_TEXT_LEFT_PADDING 5
#define QUEST_TEXT_TOP_PADDING 0
#define QUEST_XP_RIGHT_PADDING 5
#define QUEST_XP_WIDTH 80
#define QUEST_XP_TOP_PADDING 2
#define MIN_BOX_HEIGHT 30
#define MAX_BOX_HEIGHT 900

/*
 * Initialize with frame -- sets up the bounds for the questtextlabel
 * and the questxplabel
 */
- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    // Set some of its own properties
    [self setBackgroundColor:[UIColor whiteColor]];
    self.layer.borderColor = [UIColor colorWithRed:0.61f green:0.35f blue:0.71f alpha:1.00f].CGColor;
    self.layer.borderWidth = 1.5f;
    self.layer.cornerRadius = 6.0f;
    self.layer.masksToBounds = YES;

    // Add the questTextLabel to the top left of the box
    self.questTextLabel = [[BebasLabel alloc] initWithFrame:CGRectMake(QUEST_TEXT_LEFT_PADDING, 0, frame.size.width - 80, 30)];
    self.questTextLabel.textColor = [UIColor colorWithRed:0.61f green:0.35f blue:0.71f alpha:1.00f];
    self.questTextLabel.backgroundColor = [UIColor clearColor];
    [self.questTextLabel setLineBreakMode:NSLineBreakByWordWrapping];
    self.questTextLabel.numberOfLines = 6;
    [self.questTextLabel setFont:[UIFont fontWithName:@"BebasNeue" size:25]];
    [self.questTextLabel setText:@"Loading..."];
    float newHeight = [self updateHeightForQuest:@"Loading..."];
    
    [self.questTextLabel setFrame:CGRectMake(self.questTextLabel.frame.origin.x, self.questTextLabel.frame.origin.y, self.questTextLabel.frame.size.width,newHeight)];
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, newHeight)];
    
    
    // Format the XP values
    self.questXpLabel = [[BebasLabel alloc] initWithFrame:CGRectMake(self.frame.size.width - (QUEST_XP_RIGHT_PADDING + QUEST_XP_WIDTH), QUEST_XP_TOP_PADDING, QUEST_XP_WIDTH, 25)];
    [self.questXpLabel setText:@""];
    [self.questXpLabel setFont:[UIFont fontWithName:@"BebasNeue" size:25]];
    self.questXpLabel.textColor = [UIColor colorWithRed:0.61f green:0.35f blue:0.71f alpha:1.00f];
    [self.questXpLabel setTextAlignment:NSTextAlignmentRight];
    [self.questXpLabel setBackgroundColor:[UIColor clearColor]];
    
    [self addSubview:self.questTextLabel];
    [self addSubview:self.questXpLabel];
  }
  return self;
}

/*
 * Update the height for the quest -- returns the new frame height
 */
- (float)updateHeightForQuest:(NSString *)currentQuest
{
  // The max size is the current size
  CGSize maximumLabelSize = CGSizeMake(self.questTextLabel.frame.size.width, MAX_BOX_HEIGHT);
  
  // Get how long the label is going to be
  // More specifically, how tlal the label is going to be
  CGSize expectedLabelSize = [currentQuest sizeWithFont:[UIFont fontWithName:@"BebasNeue" size:25] constrainedToSize:maximumLabelSize lineBreakMode:NSLineBreakByWordWrapping];
  
  if (expectedLabelSize.height < MIN_BOX_HEIGHT) expectedLabelSize.height = MIN_BOX_HEIGHT;
  
  CGRect newFrame = CGRectMake(self.questTextLabel.frame.origin.x, self.questTextLabel.frame.origin.y, self.questTextLabel.frame.size.width, expectedLabelSize.height);
  
  return newFrame.size.height;
}

/*
 * Update with quest to the new height
 */
- (float)updateWithQuest:(DailyQuest *)currentQuest
{
  float newHeight = [self updateHeightForQuest:currentQuest.text];
  return newHeight;
}

/*
 * Show the Current Quest in the dailyquestboxview
 */
- (void)showQuest:(DailyQuest *)currentQuest withHeight:(float)newHeight
{
  CATransition *animation = [CATransition animation];
  animation.duration = 0.2;
  animation.type = kCATransitionPush;
  animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
  [self.questTextLabel.layer addAnimation:animation forKey:@"changeTextTransition"];
  
  [self.questTextLabel setText:currentQuest.text];
  [self.questTextLabel setFrame:CGRectMake(self.questTextLabel.frame.origin.x, self.questTextLabel.frame.origin.y, self.questTextLabel.frame.size.width,newHeight)];
  [self.questTextLabel setTextColor:[UIColor colorWithRed:0.61f green:0.35f blue:0.71f alpha:1.00f]];
  self.layer.borderColor = [UIColor colorWithRed:0.61f green:0.35f blue:0.71f alpha:1.00f].CGColor;
  
  [self.questXpLabel setAlpha:0.0f];
  [self.questXpLabel setText:[NSString stringWithFormat:@"+%d XP", currentQuest.xp]];
  [UIView animateWithDuration:0.2f delay:0.5f options:UIViewAnimationOptionCurveEaseOut animations:^{
    [self.questXpLabel setAlpha:1.0f];
  } completion:^(BOOL finished){}];
}

/*
 * Upon failure to load quest...
 */
- (void)setFailed
{
  // Make it unclickable  
  [self removeGestureRecognizer:self.singleTap];
  
  CATransition *animation = [CATransition animation];
  animation.duration = 0.2;
  animation.type = kCATransitionPush;
  animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
  [self.questTextLabel.layer addAnimation:animation forKey:@"changeTextTransition"];
  
  [self.questTextLabel setText:@"FAILED TO LOAD QUEST..."];
  [self.questTextLabel setTextColor:[UIColor colorWithRed:0.91f green:0.30f blue:0.24f alpha:1.00f]];
  [self.questXpLabel setText:@""];
  self.layer.borderColor = [UIColor colorWithRed:0.91f green:0.30f blue:0.24f alpha:1.00f].CGColor;
  float newHeight = [self updateHeightForQuest:@"FAILED TO LOAD QUEST..."];
  [self.questTextLabel setFrame:CGRectMake(self.questTextLabel.frame.origin.x, self.questTextLabel.frame.origin.y, self.questTextLabel.frame.size.width,newHeight)];
  [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, newHeight)];
  } completion:^(BOOL finished) {}];
  
}

@end

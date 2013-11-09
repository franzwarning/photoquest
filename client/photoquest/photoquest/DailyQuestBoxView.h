//
//  DailyQuestBoxView.h
//  photoquest
//
//  Created by Raymond Kennedy on 7/14/13.
//  Copyright (c) 2013 Randomay Designs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "BebasLabel.h"
#import "Quest.h"
#import "DailyQuest.h"

@interface DailyQuestBoxView : UIView

@property (nonatomic, strong) UIGestureRecognizer *singleTap;

- (float)updateWithQuest:(DailyQuest *)currentQuest;
- (void)showQuest:(DailyQuest *)currentQuest withHeight:(float)newHeight;
- (void)setFailed;
- (float)updateHeightForQuest:(NSString *)currentQuest;

@end

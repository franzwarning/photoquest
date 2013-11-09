//
//  QuestDetailViewController.h
//  photoquest
//
//  Created by Matt Portner on 7/5/13.
//  Copyright (c) 2013 Randomay Designs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Quest.h"
#import "DailyQuestBoxView.h"
#import "DefaultQuestBoxView.h"

@interface QuestDetailViewController : UIViewController

@property (nonatomic, strong) Quest *currentQuest;
@property (nonatomic, strong) DailyQuest *dailyQuest;
@property (nonatomic) BOOL isDaily;

@end

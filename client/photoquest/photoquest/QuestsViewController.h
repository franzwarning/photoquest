//
//  QuestsViewController.h
//  photoquest
//
//  Created by Matt Portner on 7/5/13.
//  Copyright (c) 2013 Randomay Designs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sys/semaphore.h>
#import "QuestManager.h"
#import "Quest.h"
#import "DailyQuest.h"
#import "QuestDetailViewController.h"
#import "DailyQuestCell.h"
#import "DefaultQuestCell.h"

@interface QuestsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@end

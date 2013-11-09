//
//  QuestManager.h
//  photoquest
//
//  Created by Raymond Kennedy on 7/14/13.
//  Copyright (c) 2013 Randomay Designs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "Quest.h"
#import "JSONKit.h"
#import "DataManager.h"
#import "DailyQuest.h"
#import "NSDate+Utils.h"

@protocol QuestManagerDelegate <NSObject>

@required

- (void)foundDailyQuest:(DailyQuest *)dailyQuest;
- (void)failedToGetDailyQuest;

@end

@interface QuestManager : NSObject

@property (nonatomic, strong) id <QuestManagerDelegate> delegate;

- (NSArray *)getCurrentQuests;
+ (id)sharedManager;

@end

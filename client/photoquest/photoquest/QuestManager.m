//
//  QuestManager.m
//  photoquest
//
//  Created by Raymond Kennedy on 7/14/13.
//  Copyright (c) 2013 Randomay Designs. All rights reserved.
//

#import "QuestManager.h"

@implementation QuestManager

@synthesize delegate = _delegate;

static bool hasParsed = false;
static DailyQuest *dailyQuest;

// Get the shared instance and create it if necessary.
+ (QuestManager *)sharedManager {
    static QuestManager *sharedManager = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        sharedManager = [[QuestManager alloc] init];
    });
    return sharedManager;
}

// Get the current [4] quests to show the user (and fetch the daily quest)
- (NSArray *)getCurrentQuests
{
    [self getDailyQuest];
    
    // Get the Moc
    NSManagedObjectContext *moc = [[DataManager sharedInstance] managedObjectContext];
    
    // Parse the quests into coredata if we have yet to do so.
    if (!hasParsed) {
        
        // Parse the JSON and put it in core data
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"quests" ofType:@"json.txt"];
        NSString *jsonString = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error: NULL];
        
        // Get the data into an NSDictionary
        NSDictionary *deserializedData = [jsonString objectFromJSONString];
        NSArray *quests = [deserializedData objectForKey:@"quests"];
        for (int i = 0; i < [quests count]; i++) {
            NSDictionary *questDictionary = [quests objectAtIndex:i];
            int questId = [[questDictionary objectForKey:@"id"] intValue];
            NSString *questText = [questDictionary objectForKey:@"quest"];
            int questXp = [[questDictionary objectForKey:@"xp"] intValue];
            
            Quest *currentQuest = nil;
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"questId == %d", questId];
            NSFetchRequest *request = [[NSFetchRequest alloc] init];
            [request setEntity:[NSEntityDescription entityForName:@"Quest" inManagedObjectContext:moc]];
            [request setPredicate:predicate];
            NSError *error = nil;
            NSArray *results = [moc executeFetchRequest:request error:&error];
            if (![results count] || !results) {
                currentQuest = (Quest *)[NSEntityDescription insertNewObjectForEntityForName:@"Quest" inManagedObjectContext:moc];
                currentQuest.text = questText;
                currentQuest.xp = [NSNumber numberWithInt:questXp];
                currentQuest.questId = [NSNumber numberWithInt:questId];
                currentQuest.hasCompleted = [NSNumber numberWithBool:false];
            } else if ([results count] == 1){
                currentQuest = [results lastObject];
                currentQuest.text = questText;
                currentQuest.xp = [NSNumber numberWithInt:questXp];
            } else {
                NSLog(@"[FATAL] - More than one quest exists with id: %d", questId);
            }
        }
        NSError *saveError = nil;
        if (![moc save:&saveError]) NSLog(@"Error saving managedobjectcontext: %@", saveError.localizedDescription);
        
        hasParsed = true;
    }
    
    // Now fetch the quests from CoreData
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"hasCompleted == false"];
    NSSortDescriptor *sortById = [NSSortDescriptor sortDescriptorWithKey:@"questId" ascending:YES];
    [request setSortDescriptors:[NSArray arrayWithObject:sortById]];
    [request setFetchLimit:4];
    [request setPredicate:predicate];
    [request setEntity:[NSEntityDescription entityForName:@"Quest" inManagedObjectContext:moc]];
    NSError *error = nil;
    return [moc executeFetchRequest:request error:&error];
}

- (void)getDailyQuest
{
    bool hasQuest = false;
    if (dailyQuest) {
        if (!dailyQuest.forDate) NSLog(@"Dailyquest.text == %@", dailyQuest.text);
        if ([[NSDate date] isSameDay:dailyQuest.forDate])
        {
            NSLog(@"QUEST IS SAME DAY");
            hasQuest = true;
        }
    }
    
    if (hasQuest) {
        NSLog(@"ALREADY HAS THE QUEST");
        [self.delegate foundDailyQuest:dailyQuest];
    } else {
        [PFCloud callFunctionInBackground:@"getDailyQuest" withParameters:@{@"forDate":[[NSDate date] strippedDate]} block:^(id result, NSError *error) {
            if (!error) {
                if (result) {
                    if (!dailyQuest) dailyQuest = [[DailyQuest alloc] init];
                    dailyQuest.text = [(NSDictionary *)result objectForKey:@"text"];
                    dailyQuest.xp = [[(NSDictionary *)result objectForKey:@"xp"] intValue];
                    dailyQuest.forDate = [(NSDictionary *)result objectForKey:@"forDate"];
                    [self.delegate foundDailyQuest:dailyQuest];
                }
            } else {
                dailyQuest = nil;
                [self.delegate failedToGetDailyQuest];
            }
        }];
    }
}



@end

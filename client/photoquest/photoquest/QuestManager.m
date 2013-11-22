//
//  QuestManager.m
//  photoquest
//
//  Created by Raymond Kennedy on 7/14/13.
//  Copyright (c) 2013 Randomay Designs. All rights reserved.
//

#import "QuestManager.h"

@implementation QuestManager

// Get the shared instance and create it if necessary.
+ (QuestManager *)sharedManager {
    static QuestManager *sharedManager = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        sharedManager = [[QuestManager alloc] init];
    });
    return sharedManager;
}

/*
 * Get the daily quest either by querying parse.com or checking in core data...
 */
- (void)getDailyQuest
{
    Quest *dailyQuest = [self getDailyQuestFromCoreData];
    
    if (dailyQuest) {
        
        NSLog(@"Found the daily quest in core data...");
        // We already found the daily quest
        [self.delegate foundDailyQuest:dailyQuest];
        
    } else {
        
        NSLog(@"Searching for daily quest on parse...");
        [PFCloud callFunctionInBackground:@"getDailyQuest" withParameters:@{@"forDate":[[NSDate date] strippedDate]} block:^(id result, NSError *error) {
            if (!error) {
                if (result) {
                    
                    NSLog(@"Found daily quest on parse...");
                    // We found the quest -- add it to core data and return it to the delegate
                    [self.delegate foundDailyQuest:[self addQuestToCoreData:result]];
                }
            } else {
                [self.delegate failedToGetDailyQuest];
            }
        }];
    }
}

/*
 * A check to see if we already have the daily quest
 */
- (Quest *)getDailyQuestFromCoreData
{
    NSManagedObjectContext *moc = [[DataManager sharedInstance] managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"forDate == %@", [[NSDate date] strippedDate]];
    [request setFetchLimit:1];
    [request setPredicate:predicate];
    [request setEntity:[NSEntityDescription entityForName:@"Quest" inManagedObjectContext:moc]];
    
    NSError *error = nil;
    NSArray *results = [moc executeFetchRequest:request error:&error];
    
    if (![results count] || !results) {
        return nil;
    } else if ([results count] == 1) {
        return [results lastObject];
    } else {
        // We encountered a fatal error
        NSLog(@"[FATAL] -- found more than one daily quest for date: %@", [[NSDate date] strippedDate]);
        return nil;
    }
}

/*
 * Add the quest to core data if we don't already have it
 */
- (Quest *)addQuestToCoreData:(id)result
{
    NSLog(@"Adding the quest to core data....");
    NSManagedObjectContext *moc = [[DataManager sharedInstance] managedObjectContext];

    Quest *newQuest = (Quest *)[NSEntityDescription insertNewObjectForEntityForName:@"Quest" inManagedObjectContext:moc];
    newQuest.text = [(NSDictionary *)result objectForKey:@"text"];
    newQuest.xp = [NSNumber numberWithInt:[[(NSDictionary *)result objectForKey:@"xp"] intValue]];
    newQuest.forDate = [(NSDictionary *)result objectForKey:@"forDate"];
    newQuest.parseId = [(PFObject *)result objectId];
    
    NSLog(@"Result: %@", result);
    NSLog(@"Added quest with parse id: %@", newQuest.parseId);
    
    NSError *saveError = nil;
    if (![moc save:&saveError]) NSLog(@"Error saving managedobjectcontext: %@", saveError.localizedDescription);
    
    return newQuest;
}

@end

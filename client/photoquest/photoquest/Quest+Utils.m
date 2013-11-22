//
//  Quest+Utils.m
//  photoquest
//
//  Created by Raymond kennedy on 11/21/13.
//  Copyright (c) 2013 Randomay Designs. All rights reserved.
//

#import "Quest+Utils.h"

@implementation Quest (Utils)

/*
 * Returns the quest object for a parse id
 */
+ (Quest *)getQuestForParseId:(NSString *)parseId
{
    NSManagedObjectContext *moc = [[DataManager sharedInstance] managedObjectContext];
    
    Quest *coreDataQuest = nil;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"parseId == %@", parseId];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Quest" inManagedObjectContext:moc]];
    [request setPredicate:predicate];
    NSError *error = nil;
    NSArray *results = [moc executeFetchRequest:request error:&error];
    if (![results count] || !results) {
        NSLog(@"Couldn't find quest for parseId: %@", parseId);
        return nil;
    } else if ([results count] == 1){
        coreDataQuest = (Quest *)[results lastObject];
    } else {
        NSLog(@"[FATAL] - More than one quest exists with parseId: %@", parseId);
    }
    
    NSError *saveError = nil;
    if (![moc save:&saveError]) NSLog(@"Error saving managedobjectcontext: %@", saveError.localizedDescription);
    
    return coreDataQuest;
}

@end

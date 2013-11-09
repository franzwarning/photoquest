//
//  XPManager.m
//  photoquest
//
//  Created by Raymond Kennedy on 8/4/13.
//  Copyright (c) 2013 Randomay Designs. All rights reserved.
//

#import "XPManager.h"

@implementation XPManager

#define MIN_XP 0
#define MAX_XP 2363020
#define MIN_LEVEL 1
#define MAX_LEVEL 99
// Get the shared instance and create it if necessary.
+ (XPManager *)sharedManager {
  static XPManager *sharedManager = nil;
  static dispatch_once_t pred;
  dispatch_once(&pred, ^{
    sharedManager = [[XPManager alloc] init];
  });
  return sharedManager;
}

- (int)getLevelForXP:(int)xp
{
  if (xp <= MIN_XP) return MIN_LEVEL;
  if (xp >= MAX_XP) return MAX_LEVEL;
  
  NSString *filePath = [[NSBundle mainBundle] pathForResource:@"levels" ofType:@"json.txt"];
  NSString *jsonString = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error: NULL];
  NSDictionary *deserializedData = [jsonString objectFromJSONString];
  NSArray *levels = [deserializedData objectForKey:@"levels"];
  int currentLevel = 0;
  for (int i = 0; i < levels.count; i++) {
    NSDictionary *levelsObject = [levels objectAtIndex:i];
    int xpRequired = [[levelsObject valueForKey:@"xp_required"] intValue];
    if (xp < xpRequired) break;
    currentLevel = [[levelsObject valueForKey:@"level"] intValue];
  }
  
  return currentLevel;
}

- (float)getRatioForXp:(int)xp
{
  NSString *filePath = [[NSBundle mainBundle] pathForResource:@"levels" ofType:@"json.txt"];
  NSString *jsonString = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error: NULL];
  NSDictionary *deserializedData = [jsonString objectFromJSONString];
  NSArray *levels = [deserializedData objectForKey:@"levels"];
  int previousXPRequired = 0;
  int xpRequired = 0;
  for (int i = 0; i < levels.count; i++) {
    NSDictionary *levelsObject = [levels objectAtIndex:i];
    xpRequired = [[levelsObject valueForKey:@"xp_required"] intValue];
    if (xp < xpRequired) break;
    previousXPRequired = xpRequired;
  }
  return (float)(xp - previousXPRequired)/(xpRequired - previousXPRequired);
}

- (int)getXPRequiredForNextLevel:(int)xp
{
  NSString *filePath = [[NSBundle mainBundle] pathForResource:@"levels" ofType:@"json.txt"];
  NSString *jsonString = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error: NULL];
  NSDictionary *deserializedData = [jsonString objectFromJSONString];
  NSArray *levels = [deserializedData objectForKey:@"levels"];
  int xpRequired = 0;
  for (int i = 0; i < levels.count; i++) {
    NSDictionary *levelsObject = [levels objectAtIndex:i];
    xpRequired = [[levelsObject valueForKey:@"xp_required"] intValue];
    if (xp < xpRequired) break;
  }
  return xpRequired;
}


@end

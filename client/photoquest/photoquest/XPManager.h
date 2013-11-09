//
//  XPManager.h
//  photoquest
//
//  Created by Raymond Kennedy on 8/4/13.
//  Copyright (c) 2013 Randomay Designs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "User+Utils.h"
#import "JSONKit.h"

@interface XPManager : NSObject

+ (id)sharedManager;
- (int)getLevelForXP:(int)xp;
- (float)getRatioForXp:(int)xp;
- (int)getXPRequiredForNextLevel:(int)xp;

@end

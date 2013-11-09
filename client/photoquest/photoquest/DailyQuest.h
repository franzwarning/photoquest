//
//  DailyQuest.h
//  photoquest
//
//  Created by Raymond Kennedy on 8/3/13.
//  Copyright (c) 2013 Randomay Designs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DailyQuest : NSObject

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSDate *forDate;
@property (nonatomic) int xp;

@end

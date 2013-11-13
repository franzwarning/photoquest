//
//  NSDate+Utils.h
//  photoquest
//
//  Created by Raymond Kennedy on 8/3/13.
//  Copyright (c) 2013 Randomay Designs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Utils)

- (BOOL)isSameDay:(NSDate *)otherDate;
- (NSDate *)strippedDate;
- (int)hour;
- (int)minute;
- (int)second;

@end

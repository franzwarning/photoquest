//
//  NSDate+Utils.m
//  photoquest
//
//  Created by Raymond Kennedy on 8/3/13.
//  Copyright (c) 2013 Randomay Designs. All rights reserved.
//

#import "NSDate+Utils.h"

@implementation NSDate (Utils)

/*
 * Check if two dates are the same day
 */
- (BOOL)isSameDay:(NSDate*)otherDate {
  NSCalendar* calendar = [NSCalendar currentCalendar];
  
  unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
  NSDateComponents* comp1 = [calendar components:unitFlags fromDate:self];
  NSDateComponents* comp2 = [calendar components:unitFlags fromDate:otherDate];
  
  return [comp1 day]   == [comp2 day] &&
  [comp1 month] == [comp2 month] &&
  [comp1 year]  == [comp2 year];
}

/*
 * Strip the date of any time credentials
 */
- (NSDate *)strippedDate
{
  unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
  NSCalendar* calendar = [NSCalendar currentCalendar];
  NSDateComponents* components = [calendar components:flags fromDate:self];
  return [[calendar dateFromComponents:components] dateByAddingTimeInterval:[[NSTimeZone localTimeZone]secondsFromGMT]];
}

- (int)hour
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"HH"];
    NSString *dateString = [df stringFromDate:self];
    return [dateString integerValue];
}
- (int)minute
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"mm"];
    NSString *dateString = [df stringFromDate:self];
    return [dateString integerValue];
}
- (int)second
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"ss"];
    NSString *dateString = [df stringFromDate:self];
    return [dateString integerValue];
}

@end

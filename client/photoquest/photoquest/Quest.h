//
//  Quest.h
//  photoquest
//
//  Created by Raymond kennedy on 11/21/13.
//  Copyright (c) 2013 Randomay Designs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Submission;

@interface Quest : NSManagedObject

@property (nonatomic, retain) NSString * parseId;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSNumber * xp;
@property (nonatomic, retain) NSDate * forDate;
@property (nonatomic, retain) NSSet *submissions;
@end

@interface Quest (CoreDataGeneratedAccessors)

- (void)addSubmissionsObject:(Submission *)value;
- (void)removeSubmissionsObject:(Submission *)value;
- (void)addSubmissions:(NSSet *)values;
- (void)removeSubmissions:(NSSet *)values;

@end

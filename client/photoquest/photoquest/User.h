//
//  User.h
//  photoquest
//
//  Created by Raymond kennedy on 11/20/13.
//  Copyright (c) 2013 Randomay Designs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Submission;

@interface User : NSManagedObject

@property (nonatomic, retain) NSString * gameCenterAlias;
@property (nonatomic, retain) NSString * gameCenterId;
@property (nonatomic, retain) NSNumber * xp;
@property (nonatomic, retain) NSSet *submissions;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addSubmissionsObject:(Submission *)value;
- (void)removeSubmissionsObject:(Submission *)value;
- (void)addSubmissions:(NSSet *)values;
- (void)removeSubmissions:(NSSet *)values;

@end

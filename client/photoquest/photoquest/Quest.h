//
//  Quest.h
//  photoquest
//
//  Created by Raymond Kennedy on 8/4/13.
//  Copyright (c) 2013 Randomay Designs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Photo;

@interface Quest : NSManagedObject

@property (nonatomic, retain) NSNumber * hasCompleted;
@property (nonatomic, retain) NSNumber * inProgress;
@property (nonatomic, retain) NSNumber * isDaily;
@property (nonatomic, retain) NSNumber * questId;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSNumber * xp;
@property (nonatomic, retain) NSSet *photos;
@end

@interface Quest (CoreDataGeneratedAccessors)

- (void)addPhotosObject:(Photo *)value;
- (void)removePhotosObject:(Photo *)value;
- (void)addPhotos:(NSSet *)values;
- (void)removePhotos:(NSSet *)values;

@end

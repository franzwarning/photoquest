//
//  Photo.h
//  photoquest
//
//  Created by Raymond Kennedy on 8/4/13.
//  Copyright (c) 2013 Randomay Designs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Quest, User;

@interface Photo : NSManagedObject

@property (nonatomic, retain) NSDate * creationDate;
@property (nonatomic, retain) NSString * localURL;
@property (nonatomic, retain) NSString * webURL;
@property (nonatomic, retain) User *owner;
@property (nonatomic, retain) Quest *quest;

@end

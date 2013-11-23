//
//  Submission.h
//  photoquest
//
//  Created by Raymond kennedy on 11/21/13.
//  Copyright (c) 2013 Randomay Designs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Quest, User;

@interface Submission : NSManagedObject

@property (nonatomic, retain) NSDate * creationDate;
@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, retain) NSString * parseId;
@property (nonatomic, retain) NSNumber * upVotes;
@property (nonatomic, retain) NSNumber * downVotes;
@property (nonatomic, retain) NSNumber * votingClosed;
@property (nonatomic, retain) NSNumber * success;
@property (nonatomic, retain) User *owner;
@property (nonatomic, retain) Quest *quest;

@end

//
//  Quest+Utils.h
//  photoquest
//
//  Created by Raymond kennedy on 11/21/13.
//  Copyright (c) 2013 Randomay Designs. All rights reserved.
//

#import "Quest.h"
#import "DataManager.h"

@interface Quest (Utils)

+ (Quest *)getQuestForParseId:(NSString *)parseId;

@end

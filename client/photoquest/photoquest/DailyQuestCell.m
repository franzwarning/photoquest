//
//  DailyQuestCell.m
//  photoquest
//
//  Created by Raymond kennedy on 11/11/13.
//  Copyright (c) 2013 Randomay Designs. All rights reserved.
//

#import "DailyQuestCell.h"

@implementation DailyQuestCell

@synthesize timeView = _timeView;
@synthesize timeLabel = _timeLabel;
@synthesize questLabel = _questLabel;
@synthesize xpLabel = _xpLabel;
@synthesize xpView = _xpView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//
//  DefaultQuestCell.m
//  photoquest
//
//  Created by Raymond kennedy on 11/11/13.
//  Copyright (c) 2013 Randomay Designs. All rights reserved.
//

#import "DefaultQuestCell.h"

@implementation DefaultQuestCell

@synthesize questLabel = _questLabel;
@synthesize xpView = _xpView;
@synthesize xpLabel = _xpLabel;

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

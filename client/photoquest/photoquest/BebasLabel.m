//
//  BebasLabel.m
//  photoquest
//
//  Created by Raymond Kennedy on 7/13/13.
//  Copyright (c) 2013 Randomay Designs. All rights reserved.
//

#import "BebasLabel.h"

@implementation BebasLabel

#define SPACING 2

// Set the label to use custom fonts
- (void)awakeFromNib
{
  [super awakeFromNib];
  self.font = [UIFont fontWithName:@"BebasNeue" size:self.font.pointSize];
  [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y + SPACING, self.frame.size.width, self.frame.size.height)];
}

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    self.font = [UIFont fontWithName:@"BebasNeue" size:self.font.pointSize];
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y + SPACING, self.frame.size.width, self.frame.size.height)];
  }
  return self;
}
@end

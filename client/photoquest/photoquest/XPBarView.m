//
//  XPBarView.m
//  photoquest
//
//  Created by Raymond Kennedy on 8/3/13.
//  Copyright (c) 2013 Randomay Designs. All rights reserved.
//

#import "XPBarView.h"

@interface XPBarView()

@property (nonatomic, strong) UIView *filledView;

@end

@implementation XPBarView

@synthesize filledView = _filledView;

#define TOP_PADDING 4.0
#define SIDE_PADDING 4.0

/*
 * Setup the XPBarView
 */
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      // Initialization code
      self.layer.borderColor = [UIColor blackColor].CGColor;
      self.layer.borderWidth = 3.0f;
      self.layer.cornerRadius = 6.0f;
      [self.layer setMasksToBounds:YES];
      
      self.filledView = [[UIView alloc] initWithFrame:CGRectMake(SIDE_PADDING, TOP_PADDING, 0, frame.size.height - (TOP_PADDING *2))];
      self.filledView.layer.cornerRadius = 3.0f;
      [self.filledView.layer setMasksToBounds:YES];
      [self.filledView setBackgroundColor:[UIColor colorWithRed:0.20f green:0.60f blue:0.86f alpha:1.00f]];
      [self addSubview:self.filledView];

    }
    return self;
}

/*
 * Animates the bar to a given ratio
 */
- (void)updateToRatio:(float)ratio
{
  if (ratio > 1.0f) ratio = 1.0f;
  if (ratio < 0.0f) ratio = 0.0f;
  float maxWidth = self.frame.size.width - (SIDE_PADDING *2);
  float calculatedWidth = maxWidth*ratio;
  [UIView animateWithDuration:2.0f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
      [self.filledView setFrame:CGRectMake(self.filledView.frame.origin.x, self.filledView.frame.origin.y, calculatedWidth, self.filledView.frame.size.height)];
  }completion:^(BOOL finished) {}];

}


@end

//
//  DefaultQuestBoxView.h
//  photoquest
//
//  Created by Raymond Kennedy on 7/14/13.
//  Copyright (c) 2013 Randomay Designs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "BebasLabel.h"
#import "Quest.h"

@interface DefaultQuestBoxView : UIView

@property (nonatomic, strong) UIGestureRecognizer *singleTap;

- (id)initWithFrame:(CGRect)frame quest:(Quest *)currentQuest;

@end


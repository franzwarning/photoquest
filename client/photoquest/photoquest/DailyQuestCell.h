//
//  DailyQuestCell.h
//  photoquest
//
//  Created by Raymond kennedy on 11/11/13.
//  Copyright (c) 2013 Randomay Designs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DailyQuestCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *questLabel;
@property (nonatomic, weak) IBOutlet UILabel *xpLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet UIView *xpView;
@property (nonatomic, weak) IBOutlet UIView *timeView;

@end

//
//  QuestDetailViewController.h
//  photoquest
//
//  Created by Matt Portner on 7/5/13.
//  Copyright (c) 2013 Randomay Designs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <Parse/Parse.h>
#import "Quest.h"
#import "DataManager.h"
#import "Quest+Utils.h"
#import "Submission.h"
#import "User+Utils.h"
#import "User.h"

@interface QuestDetailViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) Quest *currentQuest;

@end

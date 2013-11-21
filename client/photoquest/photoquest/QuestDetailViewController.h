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
#import "JLActionSheet.h"

@interface QuestDetailViewController : UIViewController <JLActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) Quest *currentQuest;
@property (nonatomic) BOOL isDaily;

@end

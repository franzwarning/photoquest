//
//  AppDelegate.h
//  photoquest
//
//  Created by Paul Julius Martinez on 6/30/13.
//  Copyright (c) 2013 Randomay Designs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <GameKit/GameKit.h>
#import "User+Utils.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void)setupUser;

@end

//
//  QuestDetailViewController.m
//  photoquest
//
//  Created by Matt Portner on 7/5/13.
//  Copyright (c) 2013 Randomay Designs. All rights reserved.
//

#import "QuestDetailViewController.h"

@interface QuestDetailViewController ()

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UILabel *questLabel;
@property (nonatomic, weak) IBOutlet UILabel *xpLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet UIView *timeView;
@property (nonatomic, weak) IBOutlet UIButton *questButton;
@property (nonatomic, weak) IBOutlet UIView *statsView;
@property (nonatomic, weak) IBOutlet UIImageView *imageView;

@end

@implementation QuestDetailViewController

#define QUEST_LABEL_Y_SPACING 75
#define QUEST_LABEL_X_SPACING 20
#define QUEST_LABEL_WIDTH 280
#define QUEST_LABEL_BOTTOM_PADDING 20

/*
 * Called when the view first loads
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.questButton.layer.cornerRadius = 6.0f;
    self.questButton.layer.borderColor = [UIColor colorWithRed:0.18f green:0.80f blue:0.44f alpha:1.00f].CGColor;
    self.questButton.layer.borderWidth = 3.0f;
    [self.questButton.layer setMasksToBounds:YES];
    
    self.imageView.layer.cornerRadius = 3.0f;
    self.imageView.layer.borderColor = [UIColor colorWithRed:0.93f green:0.94f blue:0.95f alpha:1.00f].CGColor;
    self.imageView.layer.borderWidth = 3.0f;
    [self.imageView.layer setMasksToBounds:YES];
}

/*
 * Setup the view
 */
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Setup the labels
    if (self.isDaily) {
        self.questLabel.text = self.dailyQuest.text;
        self.xpLabel.text = [NSString stringWithFormat:@"%02d XP", self.dailyQuest.xp];
    } else {
        self.questLabel.text = self.currentQuest.text;
        self.xpLabel.text = [NSString stringWithFormat:@"%02d XP", [self.currentQuest.xp intValue]];
    }
    
    // Adjust the size of the label accordingly
    CGSize maximumLabelSize = CGSizeMake(QUEST_LABEL_WIDTH, 9999); 
    CGSize expectedLabelSize = [self.questLabel.text sizeWithFont:[UIFont fontWithName:@"HelveticaNeue" size:19] constrainedToSize:maximumLabelSize lineBreakMode:NSLineBreakByTruncatingTail];
    
    // Do the spacing for the quests
    [self.questLabel setFrame:CGRectMake(QUEST_LABEL_X_SPACING, QUEST_LABEL_Y_SPACING, self.questLabel.frame.size.width, expectedLabelSize.height + 1)];
    
    [self.statsView setFrame:CGRectMake(QUEST_LABEL_X_SPACING, self.questLabel.frame.origin.y + self.questLabel.frame.size.height + QUEST_LABEL_BOTTOM_PADDING, self.statsView.frame.size.height, self.statsView.frame.size.width)];
    
    [self.questButton setFrame:CGRectMake(self.questButton.frame.origin.x, self.statsView.frame.origin.y + self.statsView.frame.size.height + QUEST_LABEL_BOTTOM_PADDING, self.questButton.frame.size.width, self.questButton.frame.size.height)];
    
    if (self.imageView.image) self.statsView.hidden = YES;
    else self.imageView.hidden = YES;
}

/*
 * Begin quest button pressed
 */
- (IBAction)questButtonPressed:(id)sender
{
    if ([self.questButton.titleLabel.text isEqualToString:@"Begin Quest"]) {
        JLActionSheet *actnSheet = [JLActionSheet sheetWithTitle:@"Select a source" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:[NSArray arrayWithObjects:@"Camera", @"Photo Library", nil]];
        [actnSheet setStyle:JLSTYLE_SUPERCLEAN];
        [actnSheet showInView:self.view];
    } else {
        
        // Submit the quest
        NSLog(@"User wants to submit a photo");
        
    }
}

/*
 * Action sheet delegate methods
 */
- (void)actionSheet:(JLActionSheet *)actionSheet didDismissButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        // User hit cancel
    } else {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        
        if (buttonIndex == 2) {
            // User wants photo library
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
                [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
            
        } else if (buttonIndex == 1) {
            // User wants camera
            [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        }
        
        [picker setAllowsEditing:YES];
        [picker setDelegate:self];
        [self presentViewController:picker animated:YES completion:nil];
        
    }
}

/*
 * Did finish picking with info
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    if (image) {
        // Animate the stats view off and the other view in.
        [self.imageView setFrame:CGRectMake(-320, self.questLabel.frame.origin.y + self.questLabel.frame.size.height + QUEST_LABEL_BOTTOM_PADDING, self.imageView.frame.size.width, self.imageView.frame.size.height)];
        [self.imageView setContentMode:UIViewContentModeScaleAspectFit];
        [self.imageView setImage:image];
        self.imageView.hidden = NO;
        
        [self.questButton setTitle:@"Submit" forState:UIControlStateNormal];
        [self.questButton setTitleColor:[UIColor colorWithRed:0.61f green:0.35f blue:0.71f alpha:1.00f] forState:UIControlStateNormal];
        self.questButton.layer.borderColor = [UIColor colorWithRed:0.61f green:0.35f blue:0.71f alpha:1.00f].CGColor;
        self.questButton.titleLabel.textColor = [UIColor colorWithRed:0.61f green:0.35f blue:0.71f alpha:1.00f];
        [self animateChange];
    }
}

/*
 * Animate the stats view off and the quest view on...
 */
- (void)animateChange
{
    [UIView animateWithDuration:0.3f delay:0.2f options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.statsView setFrame:CGRectMake(self.statsView.frame.origin.x + 320, self.statsView.frame.origin.y, self.statsView.frame.size.width, self.statsView.frame.size.height)];
        [self.imageView setFrame:CGRectMake(QUEST_LABEL_X_SPACING, self.imageView.frame.origin.y, self.imageView.frame.size.width, self.imageView.frame.size.height)];
    } completion:^(BOOL completion) {
        
    }];
}

@end

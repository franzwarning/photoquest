//
//  QuestDetailViewController.m
//  photoquest
//
//  Created by Matt Portner on 7/5/13.
//  Copyright (c) 2013 Randomay Designs. All rights reserved.
//

#import "QuestDetailViewController.h"

@interface QuestDetailViewController ()

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UIButton *submitButton;
@property (nonatomic, weak) IBOutlet UIButton *takePhotoButton;
@property (nonatomic, weak) IBOutlet UIButton *chosePhotoButton;
@property (nonatomic, weak) IBOutlet UIProgressView *progressView;

@end

@implementation QuestDetailViewController

/*
 * Called when the view first loads
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
}

/*
 * Setup the view
 */
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tabBarController.tabBar setHidden:YES];

    self.submitButton.hidden = YES;
    self.progressView.progress = 0.0f;
}

/*
 * Did finish picking with info
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    if (image) {
        
        self.submitButton.hidden = NO;
        
        [self.imageView setContentMode:UIViewContentModeScaleAspectFit];
        [self.imageView setImage:image];
        self.imageView.hidden = NO;
        
    }
}

/*
 * When the take photo button is hit
 */
- (IBAction)takePhotoButtonHit:(id)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
    [picker setAllowsEditing:YES];
    [picker setDelegate:self];
    [self presentViewController:picker animated:YES completion:nil];

}

/*
 * When the choose photo button is hit
 */
- (IBAction)choosePhotoButtonHit:(id)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [picker setAllowsEditing:YES];
    [picker setDelegate:self];
    [self presentViewController:picker animated:YES completion:nil];
}


/*
 * When the submitButtonIsHit
 */
- (IBAction)submitButtonHit:(id)sender
{
    [self uploadPhoto];
}

/*
 * Takes the image and puts it in a 640x640 square #lol
 */
- (UIImage *)resizeImage:(UIImage *)imageViewImage
{
    float yHeight = (640 - imageViewImage.size.height)/2;
    NSLog(@"yHeight: %f", yHeight);
    
    UIGraphicsBeginImageContext(CGSizeMake(640, 640));
    
    // Fill the background with black just in case the image doesn't fill the 640x640 box
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, 640, 640));
    
    [imageViewImage drawInRect: CGRectMake(0, yHeight, imageViewImage.size.width, imageViewImage.size.height)];
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resizedImage;
}

/*
 * Upload the photo to parse
 */
- (void)uploadPhoto
{
    NSData *imageData = UIImageJPEGRepresentation([self resizeImage:self.imageView.image], 1.0f);
    NSString *fileName = [NSString stringWithFormat:@"%@-%@", self.currentQuest.parseId, [[PFUser currentUser] objectForKey:@"gameCenterAlias"]];
    NSLog(@"Uploading image with file name: %@", fileName);
    
    PFFile *imageFile = [PFFile fileWithName:fileName data:imageData];
    
    //HUD creation here (see example for code)
    [self setUILoading];
    
    // Save PFFile
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {

            [self.submitButton setTitle:@"Finishing Up..." forState:UIControlStateNormal];

            // Create a PFObject around a PFFile and associate it with the current user
            PFObject *userPhoto = [PFObject objectWithClassName:@"Submission"];
            [userPhoto setObject:imageFile forKey:@"image"];
            [userPhoto setObject:[PFUser currentUser] forKey:@"owner"];
            [userPhoto setObject:[PFObject objectWithoutDataWithClassName:@"Quest" objectId:self.currentQuest.parseId] forKey:@"quest"];
            [userPhoto setObject:[NSNumber numberWithInt:0] forKey:@"upVotes"];
            [userPhoto setObject:[NSNumber numberWithInt:0] forKey:@"downVotes"];
            [userPhoto setObject:[NSNumber numberWithBool:NO] forKey:@"success"];
            [userPhoto setObject:[NSNumber numberWithBool:NO] forKey:@"votingClosed"];

            [userPhoto saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    [self.submitButton setTitle:@"Done!" forState:UIControlStateNormal];
                    [self createCoreDataSubmissionForParseObject:userPhoto];
                    [self performSelector:@selector(leavePage) withObject:nil afterDelay:1.0f];
                }
                else{
                    // Log details of the failure
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                }
            }];
        }
        else{
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    } progressBlock:^(int percentDone) {
        // Update your progress spinner here. percentDone will be between 0 and 100.
        self.progressView.progress = (float)percentDone/100;
    }];
}

/*
 * Add the submission to xcdata
 */
- (void)createCoreDataSubmissionForParseObject:(PFObject *)parseObject
{
    // First get the quest object
    NSManagedObjectContext *moc = [[DataManager sharedInstance] managedObjectContext];
    Submission *newSubmission = (Submission *)[NSEntityDescription insertNewObjectForEntityForName:@"Submission" inManagedObjectContext:moc];
    
    newSubmission.quest = [Quest getQuestForParseId:self.currentQuest.parseId];
    newSubmission.owner = [User getCurrentUser];
    newSubmission.upVotes = [NSNumber numberWithInt:0];
    newSubmission.downVotes = [NSNumber numberWithInt:0];
    newSubmission.parseId = [parseObject objectId];
    newSubmission.creationDate = [parseObject createdAt];
    newSubmission.votingClosed = [NSNumber numberWithBool:NO];
    newSubmission.success = [NSNumber numberWithBool:NO];
    
    NSError *saveError = nil;
    if (![moc save:&saveError]) NSLog(@"Error saving managedobjectcontext: %@", saveError.localizedDescription);
    else  NSLog(@"Created new submission in core data with objectid: %@", newSubmission.parseId);
    
}

/*
 * Leaves the page -- called after image uploading is complete
 */
- (void)leavePage
{
    [self.navigationController popViewControllerAnimated:YES];
}

/*
 * Set the ui for image uploading
 */
- (void)setUILoading
{
    // Disable all the buttons
    self.submitButton.enabled = NO;
    self.takePhotoButton.enabled = NO;
    self.submitButton.enabled = NO;
    [self.submitButton setTitle:@"Loading..." forState:UIControlStateNormal];
    self.title = @"submitting...";
    
    self.navigationItem.hidesBackButton = YES;
}

@end

//
//  SiriusNewPhotoViewController.m
//  SiriusProject
//
//  Created by Silvia Galuzzi on 19/02/15.
//
//

#import "SiriusNewPhotoViewController.h"
#import "UIImage+ResizeAdditions.h"
//#import "SVProgressHUD.h"
#import "PAPConstants.h"
#import "PAPCache.h"
#import <Parse/Parse.h>
#import "SiriusPhoto.h"
#import "SiriusActivity.h"

@interface SiriusNewPhotoViewController ()

@property (nonatomic, strong) UIImage* photo;
@property (nonatomic, strong) PFFile *photoFile;
@property (nonatomic, strong) PFFile *thumbnailFile;
@property (nonatomic, assign) UIBackgroundTaskIdentifier fileUploadBackgroundTaskId;
@property (nonatomic, assign) UIBackgroundTaskIdentifier photoPostBackgroundTaskId;

@end

@implementation SiriusNewPhotoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil photo:(UIImage*)photo
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        self.photo = photo;
        self.fileUploadBackgroundTaskId = UIBackgroundTaskInvalid;
        self.photoPostBackgroundTaskId = UIBackgroundTaskInvalid;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"New Photo";
    
    UIBarButtonItem* savePhoto = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(savePhoto:)];
//    [savePhoto setTintColor:COLORS_NAV_TEXT];
    self.navigationItem.rightBarButtonItem = savePhoto;
    
    
/*  TODO: we will set button when we will have an layout
    UIButton *buttonBack =  [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonBack setFrame:CGRectMake(0, 0, 50, 50)];
    [buttonBack setImageEdgeInsets:UIEdgeInsetsMake(-10, 0, 0, 0)];
    [buttonBack setImage:[UIImage imageNamed:@"button_back_custom_24"] forState:UIControlStateNormal];
    [buttonBack addTarget:self action:@selector(doCancel:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonBack];
*/
    
    CGPoint imageCenter = self.imageView.center;
    self.imageView.frame = CGRectMake(self.imageView.frame.origin.x,
                                      self.imageView.frame.origin.y,
                                      120,
                                      120);
    self.imageView.center = CGPointMake(imageCenter.x, imageCenter.y - 20);
    
    self.comment.frame = CGRectMake(self.comment.frame.origin.x,
                                    self.comment.frame.origin.y-40,
                                    self.comment.frame.size.width,
                                    self.comment.frame.size.height-40);

    self.imageView.image = self.photo;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.comment becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)savePhoto:(id)sender {
    
    
    //TODO: save photo
    [self requestPhotoSaveWithImage:self.photo];
}


- (BOOL)requestPhotoSaveWithImage:(UIImage *)anImage {
    //[SVProgressHUD showProgress:0 status:@"Saving photo..."];
    UIImage *resizedImage = [anImage resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(640.0f, 640.0f) interpolationQuality:kCGInterpolationHigh];
    UIImage *thumbnailImage = [anImage thumbnailImage:144.0f transparentBorder:0.0f cornerRadius:10.0f interpolationQuality:kCGInterpolationDefault];
    
    // JPEG to decrease file size and enable faster uploads & downloads
    NSData *imageData = UIImageJPEGRepresentation(resizedImage, 0.9f);
    NSData *thumbnailImageData = UIImageJPEGRepresentation(thumbnailImage, 0.9f);
    
    if (!imageData || !thumbnailImageData) {
      //  [SVProgressHUD showErrorWithStatus:@"Unable to save photo!"];
        return NO;
    }
    
    self.photoFile = [PFFile fileWithData:imageData];
    self.thumbnailFile = [PFFile fileWithData:thumbnailImageData];
    
    // Request a background execution task to allow us to finish uploading the photo even if the app is backgrounded
    self.fileUploadBackgroundTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [[UIApplication sharedApplication] endBackgroundTask:self.fileUploadBackgroundTaskId];
    }];
    
    [self.photoFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            
            //photo was saved, now it's time to save the thumbnail
            
            [self.thumbnailFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    
                    //also the thumbnail was saved. Now it's time to save the Activity
                    [[UIApplication sharedApplication] endBackgroundTask:self.fileUploadBackgroundTaskId];
                    //[SVProgressHUD dismiss];
                    
                    [self savePhotoActivity];
                    
                } else {
                    //error
                    [[UIApplication sharedApplication] endBackgroundTask:self.fileUploadBackgroundTaskId];
                    //[SVProgressHUD showErrorWithStatus:@"Unable to save photo!"];
                }
                
            } progressBlock:^(int percentDone) {
                float progress = percentDone / 100.0f;
                //[SVProgressHUD showProgress:progress status:@"Saving photo..."];
            }];
            
            
        } else {
            //error
            [[UIApplication sharedApplication] endBackgroundTask:self.fileUploadBackgroundTaskId];
            //[SVProgressHUD showErrorWithStatus:@"Unable to save photo!"];
        }
    } progressBlock:^(int percentDone) {
        float progress = percentDone / 100.0f;
        //[SVProgressHUD showProgress:progress status:@"Saving photo..."];
    }];
    
    
    return YES;
}

- (void)savePhotoActivity {
    
    
    NSDictionary *userInfo = nil;
    NSString *trimmedComment = [self.comment.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (trimmedComment.length != 0) {
        userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                    trimmedComment,kPAPEditPhotoViewControllerUserInfoCommentKey,
                    nil];
    }
    
    // Make sure there were no errors creating the image files
    if (!self.photoFile || !self.thumbnailFile) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Couldn't post your photo" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
        [alert show];
        return;
    }
    
    // both files have finished uploading
    
    // create a photo object
    SiriusPhoto *photo = [SiriusPhoto object];
    
    photo.user		= [SiriusUser currentUser];
    photo.image		= self.photoFile;
    photo.thumbnail	= self.thumbnailFile;
    
    // photos are public, but may only be modified by the user who uploaded them
    PFACL *photoACL = [PFACL ACLWithUser:[SiriusUser currentUser]];
    [photoACL setPublicReadAccess:YES];
    photo.ACL = photoACL;
    
    // Request a background execution task to allow us to finish uploading the photo even if the app is backgrounded
    self.photoPostBackgroundTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [[UIApplication sharedApplication] endBackgroundTask:self.photoPostBackgroundTaskId];
    }];
    
    // Save the Photo PFObject
    [photo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            
            NSMutableArray* comments = [NSMutableArray array];
            NSMutableArray* commenters = [NSMutableArray array];
            
            // userInfo might contain any caption which might have been posted by the uploader
            if (userInfo) {
                NSString *commentText = [userInfo objectForKey:kPAPEditPhotoViewControllerUserInfoCommentKey];
                
                if (commentText && commentText.length != 0) {
                    // create and save photo caption
                    SiriusActivity *comment = [SiriusActivity object];
                    
                    comment.type		= kPAPActivityTypeComment;
                    comment.photo		= photo;
                    comment.fromUser	= [SiriusUser currentUser];
                    comment.toUser		= [SiriusUser currentUser];
                    comment.message		= commentText;
                    
                    PFACL *ACL = [PFACL ACLWithUser:[SiriusUser currentUser]];
                    [ACL setPublicReadAccess:YES];
                    comment.ACL = ACL;
                    
                    [comment saveEventually];
                    
                    [comments addObject:comment];
                    [commenters addObject:[SiriusUser currentUser]];
                }
            }
            
            [[PAPCache sharedCache] setAttributesForPhoto:photo likers:[NSArray array] commenters:commenters comments:comments likedByCurrentUser:NO];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:PAPTabBarControllerDidFinishEditingPhotoNotification object:photo];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Couldn't post your photo" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
            [alert show];
        }
        [[UIApplication sharedApplication] endBackgroundTask:self.photoPostBackgroundTaskId];
    }];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)doCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

//
//  SiriusCameraNavControllerViewController.m
//  Sirius
//
//  Created by Silvia Galuzzi on 04/02/15.
//  Copyright (c) 2015 Silvia Galuzzi. All rights reserved.
//

#import "SiriusCameraNavController.h"
#import "SiriusNewPhotoViewController.h"
#import "SiriusChooseFrame.h"
#import "SiriusSubmitImageViewController.h"

@interface SiriusCameraNavController ()

@end

@implementation SiriusCameraNavController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) imagePickerControllerDidCancel:(DLCImagePickerController *)picker{
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(void) imagePickerController:(DLCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
    
    self.photo = [UIImage imageWithData:[info objectForKey:@"data"]];
    
/*    SiriusNewPhotoViewController* newPhoto = [[SiriusNewPhotoViewController alloc] initWithNibName:@"SiriusNewPhotoViewController" bundle:nil photo:self.photo];
    
    [self pushViewController:newPhoto animated:YES];
  */
    //[self dismissViewControllerAnimated:YES completion:nil];

    SiriusChooseFrame *chooseFrame = [[SiriusChooseFrame alloc] initWithNibName:@"SiriusChooseFrame" bundle:nil photo:self.photo];
    chooseFrame.delegate = self;

    [self pushViewController:chooseFrame animated:YES];
   // [self presentViewController:chooseFrame animated:YES completion:nil];

}

-(void) completedCompositionofImage:(UIImage *)image {
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
    
    SiriusSubmitImageViewController *submitPhoto = [[SiriusSubmitImageViewController alloc] initWithNibName:@"SiriusSubmitImageViewController" bundle:nil photo:image];
    [self.navigationController pushViewController:submitPhoto animated:YES];
}


@end

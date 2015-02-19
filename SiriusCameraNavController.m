//
//  SiriusCameraNavControllerViewController.m
//  Sirius
//
//  Created by Silvia Galuzzi on 04/02/15.
//  Copyright (c) 2015 Silvia Galuzzi. All rights reserved.
//

#import "SiriusCameraNavController.h"
#import "SiriusNewPhotoViewController.h"

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
    
    SiriusNewPhotoViewController* newPhoto = [[SiriusNewPhotoViewController alloc] initWithNibName:@"SiriusNewPhotoViewController" bundle:nil photo:self.photo];
    
    [self pushViewController:newPhoto animated:YES];
}



@end

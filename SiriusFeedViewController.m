//
//  SiriusFeedViewController.m
//  Sirius
//
//  Created by Silvia Galuzzi on 04/02/15.
//  Copyright (c) 2015 Silvia Galuzzi. All rights reserved.
//

#import "SiriusFeedViewController.h"
#import "SiriusCameraNavController.h"
#import "DLCImagePickerController.h"


@interface SiriusFeedViewController ()

@end

@implementation SiriusFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //per ora aggiungiamo il button a mano dove serve, ma bisogna capire quando deve essere visibile
    UIImage* image = [UIImage imageNamed:@"ic_btn_photo"];

    UIButton* cameraButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    cameraButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [cameraButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cameraButton setImage:image forState:UIControlStateNormal];
    [cameraButton addTarget:self action:@selector(openCamera) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = cameraButton;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)openCamera {
    
    DLCImagePickerController *picker = [[DLCImagePickerController alloc] init];
    SiriusCameraNavController* navController = [[SiriusCameraNavController alloc] initWithRootViewController:picker];
    picker.delegate = navController;
    
    [navController setNavigationBarHidden:YES];
    
    [self presentViewController:navController animated:YES completion:nil];
    
}


@end

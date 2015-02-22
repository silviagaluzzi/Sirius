//
//  SiriusCameraNavControllerViewController.h
//  Sirius
//
//  Created by Silvia Galuzzi on 04/02/15.
//  Copyright (c) 2015 Silvia Galuzzi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DLCImagePickerController.h"
#import "SiriusChooseFrame.h"


@interface SiriusCameraNavController : UINavigationController<DLCImagePickerDelegate,SiriusChooseFrameDelegate>
@property (nonatomic, strong) UIImage* photo;


@end

//  SiriusViewController.h
//  Sirius
//
//  Created by Silvia Galuzzi on 22/02/15.
//  Copyright (c) 2015 Silvia Galuzzi. All rights reserved.
//
//

#import "SiriusViewController.h"
#import <MessageUI/MessageUI.h>

@interface SiriusSubmitImageViewController : SiriusViewController <UITextFieldDelegate, UITextViewDelegate, MFMailComposeViewControllerDelegate>

-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil photo:(UIImage *)photo;
@property (weak, nonatomic) IBOutlet UIButton *btbSave;

@end

//  SiriusViewController.h
//  Sirius
//
//  Created by Silvia Galuzzi on 22/02/15.
//  Copyright (c) 2015 Silvia Galuzzi. All rights reserved.
//


#import "SiriusSubmitImageViewController.h"
#import "SiriusNewPhotoViewController.h"
//#import "AFNetworking.h"
//#import "NSString+SHA512.h"
//#import "Base64.h"
#import "MainController.h"
#import "Notifications.h"
#import <MessageUI/MessageUI.h>

#import <AVFoundation/AVAudioSettings.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVAudioPlayer.h>


#define degreesToRadians(degrees) (M_PI * degrees / 180.0)

@interface SiriusSubmitImageViewController ()<UINavigationControllerDelegate>

@property (strong, nonatomic) UIImage * thePhoto;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property BOOL showAnimation;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

@property BOOL counterUpdated;

@end

@implementation SiriusSubmitImageViewController

-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil photo:(UIImage *)photo {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.thePhoto = photo;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTranslucent:NO];
    
    [self.navigationItem setTitle:@"Invia"];
    
    self.showAnimation = NO;
    self.imageView.image = self.thePhoto;
    
    self.counterUpdated = NO;
}

#pragma mark - verifica lunghezza testo
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return textView.text.length + (text.length - range.length) <= 140;
}

#pragma mark - chiusura tastiera su fine edit
- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - photo submission
- (IBAction)saveImg:(id)sender {
    
    SiriusNewPhotoViewController* newPhoto = [[SiriusNewPhotoViewController alloc] initWithNibName:@"SiriusNewPhotoViewController" bundle:nil photo:self.thePhoto];
    
    [self.navigationController pushViewController:newPhoto animated:YES];

}

@end

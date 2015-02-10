//
//  SiriusTabBarControllerViewController.h
//  SiriusProject
//
//  Created by Silvia Galuzzi on 09/02/15.
//
//

#import <UIKit/UIKit.h>
#import <ParseUI/ParseUI.h>

@interface SiriusTabBarControllerViewController : UITabBarController<PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>

-(void) addCenterButtonWithImage:(UIImage*)buttonImage highlightImage:(UIImage*)highlightImage;

@end

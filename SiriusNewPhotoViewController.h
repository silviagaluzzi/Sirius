//
//  SiriusNewPhotoViewController.h
//  SiriusProject
//
//  Created by Silvia Galuzzi on 19/02/15.
//
//

#import "SiriusViewController.h"

@interface SiriusNewPhotoViewController : SiriusViewController
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextView *comment;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil photo:(UIImage*)photo;

@end

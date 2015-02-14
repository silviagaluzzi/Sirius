//
//  SiriusProfileEditViewController.m
//  Sirius
//
//  Created by Silvia Galuzzi on 04/02/15.
//  Copyright (c) 2015 Silvia Galuzzi. All rights reserved.
//

#import "SiriusProfileEditViewController.h"
//#import "SiriusNotificationsTableController.h"
//#import "SiriusUserSearchViewController.h"
#import "MainController.h"
#import "UIImage+ResizeAdditions.h"
#import "PAPConstants.h"
//#import "SVProgressHUD.h"
//#import "Devices.h"

static NSArray	*shoeSizes;

@interface SiriusProfileEditViewController ()

@property (strong, nonatomic) UIImagePickerController	*imagePicker;

- (void)askForEmailAddress;


@end

@implementation SiriusProfileEditViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	self.navigationItem.title	= NSLocalizedString(@"Account", nil);
	
	if (!self.imagePicker) {
		self.imagePicker					= [[UIImagePickerController alloc] init];
		self.imagePicker.delegate			= self;
		self.imagePicker.allowsEditing		= YES;
	//	self.imagePicker.mediaTypes			= [NSArray arrayWithObject: (id)kUTTypeImage];
	}
	
	CALayer* l = self.imageView.layer;
	
	l.cornerRadius = self.imageView.bounds.size.width/2;
	l.masksToBounds = YES;
	[l setBorderWidth:1.0];
	//[l setBorderColor:[COLORS_HOME_TEXTHIGH CGColor]];
	
	self.settingsTableView.tableFooterView	= [[UIView alloc] initWithFrame: CGRectZero];
    
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear: animated];
	
    // if facebook user we disable image change
    NSString *fbId = self.aUser.facebookId;
    if (fbId) {
        self.choosePhotoButton.enabled &= NO;
    }

    if (self.aUser)
        self.userNameLabel.text	= [self.aUser displayName];
	if (self.userImage)
		self.imageView.image	= self.userImage;
}

- (void)viewWillDisappear:(BOOL)animated
{
	if (!self.sizeView.hidden)
		[self hideChooseSize];
	
	[super viewWillDisappear: animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)choosePhoto:(id)sender
{
    
	if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
		self.imagePicker.sourceType		= UIImagePickerControllerSourceTypePhotoLibrary;
		[self presentViewController: self.imagePicker animated: YES completion: nil];
	} else {
		UIActionSheet *actionSheet =[[UIActionSheet alloc] initWithTitle: NSLocalizedString(@"Pick a source for the image", nil)
									 delegate: self
							cancelButtonTitle: NSLocalizedString(@"Cancel", nil)
					   destructiveButtonTitle: nil
							otherButtonTitles: NSLocalizedString(@"Camera", nil), NSLocalizedString(@"Library", nil), nil];
        //if (IS_IPHONE) {
            [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
        //} else {
          //  [actionSheet showFromRect:self.imageView.frame inView:self.view animated:YES];
        //}
	}
}


- (void)askForEmailAddress
{
	UIAlertView	*av	= [[UIAlertView alloc] initWithTitle: NSLocalizedString(@"Change email", nil)
												 message: NSLocalizedString(@"Please enter your new email address", nil)
												delegate: self
									   cancelButtonTitle: NSLocalizedString(@"Cancel", nil)
									   otherButtonTitles: NSLocalizedString(@"OK", nil), nil];
	
	av.alertViewStyle	= UIAlertViewStylePlainTextInput;
	
	[av show];
}

- (void)showChooseSize
{
    
    //self.sizeView.backgroundColor = [UIColor redColor];
    CGRect	pRect	= self.sizeView.frame;
	
	pRect.origin.y			= self.view.bounds.origin.y + self.view.bounds.size.height;
    
	self.sizeView.frame		= pRect;
	self.sizeView.hidden	= NO;
	
	[UIView animateWithDuration: 0.3
					 animations: ^{
						 CGRect	pRect		= self.sizeView.frame;
						 pRect.origin.y			= self.view.bounds.origin.y + self.view.bounds.size.height - pRect.size.height;
                         //if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                             //pRect.origin.y = 0;
                         //}
						 self.sizeView.frame	= pRect;
					 } completion: ^(BOOL finished) {
						 if ([[SiriusUser currentUser] objectForKey: @"shoeSize"])
							 [self.sizePicker selectRow: [shoeSizes indexOfObject: [[SiriusUser currentUser] objectForKey: @"shoeSize"]]
											inComponent: 0
											   animated: YES];
						 else
							 [self.sizePicker selectRow: 0
											inComponent: 0
											   animated: YES];
						 self.settingsTableView.userInteractionEnabled	= NO;
					 }];
 
}

- (void)hideChooseSize
{
	[UIView animateWithDuration: 0.3
					 animations: ^{
						 CGRect	pRect			= self.sizeView.frame;
						 
						 pRect.origin.y			= self.view.bounds.origin.y + self.view.bounds.size.height;
						 self.sizeView.frame	= pRect;
					 } completion: ^(BOOL finished) {
						 self.sizeView.hidden							= YES;
						 self.settingsTableView.userInteractionEnabled	= YES;
					 }];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	switch (buttonIndex) {
		case 0:
			self.imagePicker.sourceType	= UIImagePickerControllerSourceTypeCamera;
			break;
			
		case 1:
			self.imagePicker.sourceType	= UIImagePickerControllerSourceTypePhotoLibrary;
			break;
			
		default:
			return;
	}
	[self presentViewController: self.imagePicker animated: YES completion: nil];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if (buttonIndex) {
		NSString	*emailAddress	= [alertView textFieldAtIndex: 0].text;
		
		if (([emailAddress rangeOfString: @"@"].length == 0) || ([emailAddress length] < 5)) {
			dispatch_async(dispatch_get_main_queue(), ^{
				[self askForEmailAddress];
			});
			return;
		}
		
		[SiriusUser currentUser].email	= emailAddress;
		[[SiriusUser currentUser] saveEventually];
	}
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	UIImage	*anImage			= [info objectForKey: UIImagePickerControllerEditedImage];
    UIImage *mediumImage		= [anImage thumbnailImage:280 transparentBorder:0 cornerRadius:0 interpolationQuality:kCGInterpolationHigh];
    UIImage *smallImage			= [anImage thumbnailImage:64 transparentBorder:0 cornerRadius:9 interpolationQuality:kCGInterpolationLow];
    NSData	*mediumImageData	= UIImageJPEGRepresentation(mediumImage, 0.5); // using JPEG for larger pictures
    NSData	*smallImageData		= UIImagePNGRepresentation(smallImage);
	SiriusUser	*user				= [SiriusUser currentUser];
	
    if (mediumImageData.length > 0) {
        PFFile *fileMediumImage = [PFFile fileWithName: @"MediumPhoto.jpg" data: mediumImageData];
		
		//[SVProgressHUD show];
        [fileMediumImage saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                user.profilePictureMedium	= fileMediumImage;
                [user saveEventually];
            }
			//[SVProgressHUD popActivity];
        }];
    }
    
    if (smallImageData.length > 0) {
        PFFile *fileSmallRoundedImage = [PFFile fileWithName: @"SmallPhoto.png" data:smallImageData];
		
		//[SVProgressHUD show];
        [fileSmallRoundedImage saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                user.profilePictureSmall	= fileSmallRoundedImage;
                [user saveEventually];
				self.imageView.image	= smallImage;
            } else {
				self.imageView.image	= nil;//[UIImage imageNamed: @"AvatarPlaceholder"];
			}
		//	[SVProgressHUD popActivity];
        }];
    }
	
	[self dismissViewControllerAnimated: YES completion: nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	[self dismissViewControllerAnimated: YES completion: nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell	*cell;
	
    cell	= [tableView dequeueReusableCellWithIdentifier: @"StandardCell"];
    if (!cell) {
        cell	= [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleValue1
                                         reuseIdentifier: @"StandardCell"];
    }
    cell.detailTextLabel.text	= nil;
	cell.accessoryType			= UITableViewCellAccessoryNone;
	switch (indexPath.row) {
		case 0:
			cell.textLabel.text	= NSLocalizedString(@"Change email", nil);
			break;
		case 1:
			cell.textLabel.text	= NSLocalizedString(@"Reset password", nil);
			break;
		case 2:
			break;
		case 3:
			cell.textLabel.text	= NSLocalizedString(@"Find Friends", nil);
			cell.accessoryType	= UITableViewCellAccessoryDisclosureIndicator;
			break;
		case 4:
			cell.textLabel.text	= NSLocalizedString(@"Notifications", nil);
			cell.accessoryType	= UITableViewCellAccessoryDisclosureIndicator;
			break;
        case 5:
			cell.textLabel.text	= NSLocalizedString(@"Privacy Policy", nil);
			cell.accessoryType	= UITableViewCellAccessoryDisclosureIndicator;
			break;
		case 6:
			cell.textLabel.text	= NSLocalizedString(@"User Policy", nil);
			cell.accessoryType	= UITableViewCellAccessoryDisclosureIndicator;
			break;

		case 7:
			cell.textLabel.text	= NSLocalizedString(@"Sign out", nil);
			break;
	}
	
	return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	switch (indexPath.row) {
		case 0:
			[self askForEmailAddress];
			break;
		case 1:
			[SiriusUser requestPasswordResetForEmailInBackground: [[SiriusUser currentUser] email]];
			[[[UIAlertView alloc] initWithTitle: NSLocalizedString(@"Password Reset", nil)
										message: NSLocalizedString(@"An email to reset your password has been sent to your registered address", nil)
									   delegate: nil
							  cancelButtonTitle: NSLocalizedString(@"OK", nil)
							  otherButtonTitles: nil] show];
			break;
		case 2:
			break;
		case 3:
/*			{
				SiriusUserSearchViewController	*vc	= [[SiriusUserSearchViewController alloc] initWithNibName: @"SiriusUserSearchViewController"
																								bundle: nil];
				
				if (vc.view) {
					vc.following	= self.following;
					
					[self.navigationController pushViewController: vc animated: YES];
				}
			}
 */
			break;
		case 4:
/*			{

				SiriusNotificationsTableController	*vc	= [[SiriusNotificationsTableController alloc] initWithNibName: @"SiriusNotificationsTableController"
																										bundle: nil];
				if (vc.view) {
					vc.aUser	= [SiriusUser currentUser];
					
					[self.navigationController pushViewController: vc animated: YES];
				}
			}
 */
			break;
		case 7:
			[self.navigationController popToRootViewControllerAnimated: YES];
			//[[MainController sharedController] logOut];
			break;
	}
	[tableView deselectRowAtIndexPath: indexPath animated: YES];
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}

            
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 1;
}

 
#pragma mark - UIPickerViewDelegate

/*- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
}
*/

    
    
@end

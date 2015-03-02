//
//  SiriusProfileEditViewController.h
//  Sirius
//
//  Created by Silvia Galuzzi on 04/02/15.
//  Copyright (c) 2015 Silvia Galuzzi. All rights reserved.
//

#import "SiriusViewController.h"
#import "SiriusUser.h"

@interface SiriusProfileEditViewController : SiriusViewController
<UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate,
UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate>

@property (weak, nonatomic) SiriusUser	*aUser;
@property (weak, nonatomic) UIImage	*userImage;

@property (weak, nonatomic) NSMutableArray			*following;
@property (weak, nonatomic) NSMutableArray			*followers;

@property (weak, nonatomic) IBOutlet UIImageView	*imageView;
@property (weak, nonatomic) IBOutlet UILabel		*userNameLabel;
@property (weak, nonatomic) IBOutlet UITableView	*settingsTableView;
@property (weak, nonatomic) IBOutlet UIButton *choosePhotoButton;

@end

//
//  SiriusProfileViewController.m
//  Sirius
//
//  Created by Silvia Galuzzi on 04/02/15.
//  Copyright (c) 2015 Silvia Galuzzi. All rights reserved.
//

#import "SiriusProfileViewController.h"
#import "SiriusProfileEditViewController.h"

@interface SiriusProfileViewController ()

@end

@implementation SiriusProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    SiriusProfileEditViewController	*vc	= [[SiriusProfileEditViewController alloc] initWithNibName: @"SiriusProfileEditViewController"
                                                                                      bundle: nil];
    
    if (vc.view) {
/*        vc.aUser		= self.user;
        vc.userImage	= self.headerView.profileImage.image;
        vc.followers	= self.followers;
        vc.following	= self.following;
*/
        [self.navigationController pushViewController: vc animated: YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

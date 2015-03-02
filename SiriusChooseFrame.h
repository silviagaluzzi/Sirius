//  SiriusChooseFrame.h
//  Sirius
//
//  Created by Silvia Galuzzi on 22/02/15.
//  Copyright (c) 2015 Silvia Galuzzi. All rights reserved.
//
//

#import "SiriusViewController.h"


@protocol SiriusChooseFrameDelegate <NSObject>
@optional
- (void) completedCompositionofImage:(UIImage *)image;
@end

@interface SiriusChooseFrame : SiriusViewController
@property (nonatomic, weak) id <SiriusChooseFrameDelegate> delegate;

-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil photo:(UIImage *)photo;
@property (weak, nonatomic) IBOutlet UIButton *btbOK;

@end

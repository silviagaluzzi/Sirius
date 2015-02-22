//
//  SiriusChooseFrame.m
//  Sirius
//
//  Created by Silvia Galuzzi on 22/02/15.
//  Copyright (c) 2015 Silvia Galuzzi. All rights reserved.
//

#import "SiriusChooseFrame.h"
#import "SiriusFrameCollectionViewCell.h"

@interface SiriusChooseFrame ()

@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *framesImageNames;

@property int currentFrameIndex ;
@property int currentRotation;

@property (strong, nonatomic) UIImage * thePhoto;

@end

@implementation SiriusChooseFrame

static NSString *frameCellId = @"frameCellId";

-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil photo:(UIImage *)photo {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.thePhoto = photo;
        self.framesImageNames = @[@"skin01", @"skin02", @"skin03", @"skin04", @"skin05",
                                  @"skin06", @"skin07", @"skin08", @"skin09", @"skin10",
                                  @"skin11", @"skin12", @"skin13", @"skin14", @"skin15",
                                  @"skin16", @"skin17", @"skin18", @"skin19", @"skin20",
                                  @"skin21", @"skin22", @"skin23", @"skin24", @"skin25",
                                  @"skin26", @"skin27", @"skin28", @"skin29", @"skin30",
                                  ];
        
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTranslucent:NO];
    
    [self.navigationItem setTitle:@"Cornici"];
    
    UIButton *rotateButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    [rotateButton setFrame:CGRectMake(0, 0, 44, 44)];
    [rotateButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [rotateButton setImage:[UIImage imageNamed:@"camera_rotate"] forState:UIControlStateNormal];
    [rotateButton addTarget:self action:@selector(rotatePhoto) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rotateButton];

    
    /*
    UIButton *buttonBack =  [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonBack setFrame:CGRectMake(0, 0, 50, 50)];
    [buttonBack setImageEdgeInsets:UIEdgeInsetsMake(-10, 0, 0, 0)];
    [buttonBack setImage:[UIImage imageNamed:@"camera_back"] forState:UIControlStateNormal];
    //[buttonBack addTarget:self action:@selector(doCancel:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonBack];
     */
    
    self.photoImageView.image = [UIImage imageWithCGImage:self.thePhoto.CGImage];

    UINib *cellNib = [UINib nibWithNibName:@"SiriusFrameCollectionViewCell" bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:frameCellId];
    
    self.currentFrameIndex = -1;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - rotate photo
-(void) rotatePhoto {
    self.currentRotation = ++self.currentRotation % 4;
    [self updatePhoto];
}

#pragma mark - UICollectionViewDataSource delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.framesImageNames.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    if ( screenHeight == 480.0) {
        // 4s
        return CGSizeMake(55, 80);
    } else if (screenHeight == 568.0) {
        // 5 5s
        return CGSizeMake(55, 160);
    } else if (screenHeight == 667.0) {
        // 6
        return CGSizeMake(55, 160);
    } else if (screenHeight == 736.0) {
        // 6 plus
        return CGSizeMake(55, 160);
    }
    return CGSizeMake(80, 100);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    SiriusFrameCollectionViewCell *cell = (SiriusFrameCollectionViewCell *) [collectionView dequeueReusableCellWithReuseIdentifier:frameCellId forIndexPath:indexPath];
    
    cell.imageView.image = [UIImage imageNamed:[self.framesImageNames objectAtIndex:indexPath.row]];
    
    [cell.imageView.layer setBorderColor: [[UIColor blackColor] CGColor]];
    [cell.imageView.layer setBorderWidth: 1.0];
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    return cell;
}


#pragma mark - UICollectionViewDelegate delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.currentFrameIndex = indexPath.row;
    [self updatePhoto];
    [self.delegate completedCompositionofImage:self.photoImageView.image];
}


- (void) updatePhoto {
    
    UIImage *thePhoto;
    
    if (self.currentRotation == 0) {
        thePhoto = [UIImage imageWithCGImage:self.thePhoto.CGImage]; //background image
    } else if (self.currentRotation == 1) {
        thePhoto = [UIImage imageWithCGImage:self.thePhoto.CGImage scale:1.0 orientation:UIImageOrientationRight];
    } else if (self.currentRotation == 2) {
        thePhoto = [UIImage imageWithCGImage:self.thePhoto.CGImage scale:1.0 orientation:UIImageOrientationDown];
    } else if (self.currentRotation == 3) {
        thePhoto = [UIImage imageWithCGImage:self.thePhoto.CGImage scale:1.0 orientation:UIImageOrientationLeft];
    }
    
    CGSize newSize = CGSizeMake(640, 640);
    UIGraphicsBeginImageContext( newSize );
    
    [thePhoto drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    if (self.currentFrameIndex >=0 ) {
        // Apply supplied opacity if applicable
        UIImage *theFrame = [UIImage imageNamed:[self.framesImageNames objectAtIndex:self.currentFrameIndex]]; //frame image
        [theFrame drawInRect:CGRectMake(0,0,newSize.width,newSize.height) blendMode:kCGBlendModeNormal alpha:1];
    }
    self.photoImageView.image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();

}

@end

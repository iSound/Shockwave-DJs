//
//  SWDJs.m
//  Shockwave DJs
//
//  Created by Victor Ilisei on 3/15/14.
//  Copyright (c) 2014 Tech Genius. All rights reserved.
//

#import "SWDJs.h"

@interface SWDJs ()

@end

@implementation SWDJs

- (id)initWithDJ:(NSString *)djName withColor:(UIColor *)djColor {
    self = [super init];
    if (self) {
        // Custom initialization
        self.djName = djName;
        self.djColor = djColor;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Tint color
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor blackColor];
    // Set mix class list
    self.mixClassList = [NSString stringWithFormat:@"DJ%@Mixes", [self.djName lowercaseString]];
    // Setup cover
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.cover = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.navigationController.view.frame.size.width, 20 + 10 + self.navigationController.view.frame.size.width/4 + 10)];
    } else {
        self.cover = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.navigationController.view.frame.size.width, 10 + self.navigationController.view.frame.size.width/4 + 10)];
    }
    self.cover.backgroundColor = [UIColor blackColor];
    self.cover.layer.masksToBounds = YES;
    self.cover.contentMode = UIViewContentModeScaleAspectFill;
    // Setup cover cover
    self.coverCover = [[UIView alloc] initWithFrame:self.cover.frame];
    self.coverCover.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.75f];
    [self.view addSubview:self.coverCover];
    // Setup poster
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.profilePic = [[UIImageView alloc] initWithFrame:CGRectMake(10, 20 + 10, self.navigationController.view.frame.size.width/4, self.navigationController.view.frame.size.width/4)];
    } else {
        self.profilePic = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, self.navigationController.view.frame.size.width/4, self.navigationController.view.frame.size.width/4)];
    }
    self.profilePic.layer.cornerRadius = self.profilePic.frame.size.height/2;
    self.profilePic.layer.masksToBounds = YES;
    // self.profilePic.layer.borderColor = [UIColor whiteColor].CGColor;
    self.profilePic.layer.borderColor = self.djColor.CGColor;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.profilePic.layer.borderWidth = 2.4f;
    } else {
        self.profilePic.layer.borderWidth = 1.0f;
    }
    if ([self.profilePic respondsToSelector:@selector(addMotionEffect:)]) {
        UIInterpolatingMotionEffect *xTilt = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
        xTilt.minimumRelativeValue = [NSNumber numberWithFloat: -10];
        xTilt.maximumRelativeValue = [NSNumber numberWithFloat: 10];
        
        UIInterpolatingMotionEffect *yTilt = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
        yTilt.minimumRelativeValue = [NSNumber numberWithFloat: -10];
        yTilt.maximumRelativeValue = [NSNumber numberWithFloat: 10];
        
        UIMotionEffectGroup *group = [[UIMotionEffectGroup alloc] init];
        group.motionEffects = @[xTilt, yTilt];
        [self.profilePic addMotionEffect:group];
    }
    // Setup DJ Name Label
    self.djNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 + self.profilePic.frame.size.width + 10, self.profilePic.frame.origin.y, self.navigationController.view.frame.size.width - 10 - self.profilePic.frame.size.width - 10 - 10, self.profilePic.frame.size.height/2)];
    self.djNameLabel.textAlignment = NSTextAlignmentCenter;
    self.djNameLabel.textColor = [UIColor whiteColor];
    self.djNameLabel.text = [NSString stringWithFormat:@"DJ %@", self.djName];
    self.djNameLabel.font = [UIFont fontWithName:self.djNameLabel.font.fontName size:self.djNameLabel.frame.size.height];
    self.djNameLabel.adjustsFontSizeToFitWidth = YES;
    if ([self.djNameLabel respondsToSelector:@selector(addMotionEffect:)]) {
        UIInterpolatingMotionEffect *xTilt = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
        xTilt.minimumRelativeValue = [NSNumber numberWithFloat: -10];
        xTilt.maximumRelativeValue = [NSNumber numberWithFloat: 10];
        
        UIInterpolatingMotionEffect *yTilt = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
        yTilt.minimumRelativeValue = [NSNumber numberWithFloat: -10];
        yTilt.maximumRelativeValue = [NSNumber numberWithFloat: 10];
        
        UIMotionEffectGroup *group = [[UIMotionEffectGroup alloc] init];
        group.motionEffects = @[xTilt, yTilt];
        [self.djNameLabel addMotionEffect:group];
    }
    [self.navigationController.view addSubview:self.djNameLabel];
    // Setup DJ Mix Amount Label
    self.djMixAmountLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.djNameLabel.frame.origin.x, self.djNameLabel.frame.origin.y + self.djNameLabel.frame.size.height, self.djNameLabel.frame.size.width, self.djNameLabel.frame.size.height)];
    self.djMixAmountLabel.text = @"Loading mixes...";
    self.djMixAmountLabel.textAlignment = self.djNameLabel.textAlignment;
    self.djMixAmountLabel.textColor = [UIColor lightTextColor];
    self.djMixAmountLabel.font = [UIFont fontWithName:self.djNameLabel.font.fontName size:self.djNameLabel.font.pointSize/2];
    if ([self.djMixAmountLabel respondsToSelector:@selector(addMotionEffect:)]) {
        UIInterpolatingMotionEffect *xTilt = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
        xTilt.minimumRelativeValue = [NSNumber numberWithFloat: -10];
        xTilt.maximumRelativeValue = [NSNumber numberWithFloat: 10];
        
        UIInterpolatingMotionEffect *yTilt = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
        yTilt.minimumRelativeValue = [NSNumber numberWithFloat: -10];
        yTilt.maximumRelativeValue = [NSNumber numberWithFloat: 10];
        
        UIMotionEffectGroup *group = [[UIMotionEffectGroup alloc] init];
        group.motionEffects = @[xTilt, yTilt];
        [self.djMixAmountLabel addMotionEffect:group];
    }
    [self.navigationController.view addSubview:self.djMixAmountLabel];
    
    // Setup mixes
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
    flow.itemSize = CGSizeMake(128, 128);
    flow.minimumInteritemSpacing = 15;
    flow.minimumLineSpacing = 15;
    flow.headerReferenceSize = CGSizeMake(self.navigationController.view.frame.size.width - 15 - 15, 15);
    flow.footerReferenceSize = CGSizeMake(self.navigationController.view.frame.size.width - 15 - 15, 15);
    
    self.mixView = [[UICollectionView alloc] initWithFrame:CGRectMake(15, self.cover.frame.origin.y + self.cover.frame.size.height, self.navigationController.view.frame.size.width - 15 - 15, self.navigationController.view.frame.size.height - 15 - 15 - self.cover.frame.size.height) collectionViewLayout:flow];
    self.mixView.delegate = self;
    self.mixView.dataSource = self;
    self.mixView.alwaysBounceVertical = YES;
    
    [self.view addSubview:self.mixView];

    // Load stuff
    [self refresh];
    
    // Add mix manually
    /*
    PFObject *object = [PFObject objectWithClassName:@"<#string#>"];
    object[@"artist"] = @"<#string#>";
    object[@"iconURL"] = @"<#string#>";
    object[@"mixDate"] = [NSDate date];
    object[@"name"] = @"<#string#>";
    object[@"plays"] = @0;
    object[@"url"] = @"<#string#>";
    [object saveEventually:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"Saved");
        }
    }];
     */
}

- (void)refresh {
    // Download needed stuff
    PFQuery *query = [PFQuery queryWithClassName:self.mixClassList];
    query.limit = 1000;
    [query whereKey:@"url" notEqualTo:@"<#string#>"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        // Clear mixList
        self.mixList = [[NSMutableArray alloc] init];
        for (PFObject *object in objects) {
            [self.mixList addObject:object];
        }
        // Update # of mixes
        self.djMixAmountLabel.text = [NSString stringWithFormat:@"♫ %lu", (unsigned long)[self.mixList count]];
        // Sort mixes by latest - top
        [self.mixList sortUsingComparator:^NSComparisonResult(id dict1, id dict2) {
            NSDate *date1 = [(PFObject *)dict1 objectForKey:@"mixDate"];
            NSDate *date2 = [(PFObject *)dict2 objectForKey:@"mixDate"];
            return [date2 compare:date1];
        }];
        [self.mixView reloadData];
        // Async loading of posters
        NSURL *url = [NSURL URLWithString:[[self.mixList firstObject] objectForKey:@"iconURL"]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        url = nil;
        
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            self.cover.image = nil;
            self.profilePic.image = nil;
            if (!error) {
                // Init UIImage editing
                // CIContext *context = [CIContext contextWithOptions:nil];
                // CIImage *inputImage = [[CIImage alloc] initWithImage:[UIImage imageWithData:data]];
                // Darken cover
                // CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
                // [filter setValue:inputImage forKey:@"inputImage"];
                // [filter setValue:[NSNumber numberWithFloat:5.0] forKey:@"inputRadius"];
                // Your output image
                // self.cover.image = [UIImage imageWithCGImage:[context createCGImage:filter.outputImage fromRect:filter.outputImage.extent]];
                self.cover.image = [UIImage imageWithData:data];
                // Add cover
                [self.view insertSubview:self.cover belowSubview:self.coverCover];
                // Set profilePic
                self.profilePic.image = [UIImage imageWithData:data];
                // Add profilePic
                [self.navigationController.view addSubview:self.profilePic];
            }
        }];
        request = nil;
    }];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    // Reset frame of cover
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        [self.cover setFrame:CGRectMake(0, 0, self.navigationController.view.frame.size.width, 20 + 10 + self.navigationController.view.frame.size.width/4 + 10)];
    } else {
        [self.cover setFrame:CGRectMake(0, 0, self.navigationController.view.frame.size.width, 10 + self.navigationController.view.frame.size.width/4 + 10)];
    }
    
    // Reset frame of coverCover
    [self.coverCover setFrame:self.cover.frame];
    
    // Reset frame of profilePic
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        [self.profilePic setFrame:CGRectMake(10, 20 + 10, self.navigationController.view.frame.size.width/4, self.navigationController.view.frame.size.width/4)];
    } else {
        [self.profilePic setFrame:CGRectMake(10, 10, self.navigationController.view.frame.size.width/4, self.navigationController.view.frame.size.width/4)
         ];
    }
    self.profilePic.layer.cornerRadius = self.profilePic.frame.size.height/2;
    
    // Reset frame of djNameLabel
    [self.djNameLabel setFrame:CGRectMake(10 + self.profilePic.frame.size.width + 10, self.profilePic.frame.origin.y, self.navigationController.view.frame.size.width - 10 - self.profilePic.frame.size.width - 10 - 10, self.profilePic.frame.size.height/2)];
    
    // Reset frame of djMixAmountLabel
    [self.djMixAmountLabel setFrame:CGRectMake(self.djNameLabel.frame.origin.x, self.djNameLabel.frame.origin.y + self.djNameLabel.frame.size.height, self.djNameLabel.frame.size.width, self.djNameLabel.frame.size.height)];
    self.djMixAmountLabel.font = [UIFont fontWithName:self.djNameLabel.font.fontName size:self.djNameLabel.font.pointSize/2];
    
    // Reset mixView
    [self.mixView setFrame:CGRectMake(15, self.cover.frame.origin.y + self.cover.frame.size.height, self.navigationController.view.frame.size.width - 15 - 15, self.navigationController.view.frame.size.height - 15 - 15 - self.cover.frame.size.height)];
}

#pragma mark - Collection view data source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.mixList count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    [collectionView registerClass:[SWMixCell class] forCellWithReuseIdentifier:CellIdentifier];
    SWMixCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    // Configure the cell...
    PFObject  *object = [self.mixList objectAtIndex:indexPath.row];
    
    [cell setAlbumCover:[NSURL URLWithString:[object objectForKey:@"iconURL"]]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    SWMixCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    [cell highlightCell];
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    SWMixCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    [cell unHighlightCell];
}

@end
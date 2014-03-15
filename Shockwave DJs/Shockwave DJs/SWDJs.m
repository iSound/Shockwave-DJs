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
        self.title = [NSString stringWithFormat:@"DJ %@", self.djName];
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
    self.coverCover.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
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
    // Setup DJ Name Label

    // Load stuff
    [self refresh];
    
    // Add mix manually
    /*
    PFObject *object = [PFObject objectWithClassName:@"DJlovellMixes"];
    object[@"artist"] = @"DJ Lovell";
    object[@"iconURL"] = @"http://images-mix.netdna-ssl.com/w/600/h/600/q/85/upload/images/extaudio/6c7f9d6c-9d18-4936-9579-3924ebceeb57.png";
    object[@"mixDate"] = [NSDate date];
    object[@"name"] = @"Live at Electro";
    object[@"plays"] = @13;
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
        self.mixList = [[NSMutableArray alloc] init];
        for (PFObject *object in objects) {
            [self.mixList addObject:object];
        }
        [self.mixList sortUsingComparator:^NSComparisonResult(id dict1, id dict2) {
            NSDate *date1 = [(PFObject *)dict1 objectForKey:@"mixDate"];
            NSDate *date2 = [(PFObject *)dict2 objectForKey:@"mixDate"];
            return [date2 compare:date1];
        }];
        // Async loading of posters
        NSURL *url = [NSURL URLWithString:[[self.mixList firstObject] objectForKey:@"iconURL"]];
        NSURLRequest* request = [NSURLRequest requestWithURL:url];
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
}

@end
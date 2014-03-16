//
//  SWHomeViewController.m
//  Shockwave DJs
//
//  Created by Victor Ilisei on 3/2/14.
//  Copyright (c) 2014 Tech Genius. All rights reserved.
//

#import "SWHomeViewController.h"

@interface SWHomeViewController ()

@end

@implementation SWHomeViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        self.title = @"Home";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBarTintColor:)]) {
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.25f alpha:1.0f];
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    } else {
        self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.25f alpha:1.0f];
    }
    self.navigationController.navigationBar.translucent = YES;
    
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.tintColor = [UIColor blackColor];
    [refresh addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
    
    // iAds
    iAd = [[ADBannerView alloc] initWithFrame:CGRectZero];
    iAd.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [self refresh];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePlayerToolbar:) name:@"playingMix" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePlayerToolbar:) name:@"pausedMix" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePlayerToolbar:) name:@"doneMix" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"playingMix" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"pausedMix" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"doneMix" object:nil];
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner {
    if (self.navigationController.toolbarHidden) {
        [banner setFrame:CGRectMake(banner.frame.origin.x, self.navigationController.view.frame.size.height - banner.frame.size.height, banner.frame.origin.x, banner.frame.size.height)];
    } else {
        [banner setFrame:CGRectMake(banner.frame.origin.x, self.navigationController.view.frame.size.height - self.navigationController.navigationBar.frame.size.height - banner.frame.size.height, banner.frame.origin.x, banner.frame.size.height)];
    }
    [self.navigationController.view addSubview:banner];
    bannerIsVisible = YES;
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    [banner removeFromSuperview];
    bannerIsVisible = NO;
}

- (void)refresh {
    [self.refreshControl beginRefreshing];
    PFQuery *query1 = [PFQuery queryWithClassName:@"DJamatterfactMixes"];
    query1.limit = 1000;
    [query1 whereKey:@"url" notEqualTo:@"<#string#>"];
    [query1 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        feedContent = [[NSMutableArray alloc] init];
        for (PFObject *object in objects) {
            [feedContent addObject:object];
        }
        [feedContent sortUsingComparator:^NSComparisonResult(id dict1, id dict2) {
            NSDate *date1 = [(PFObject *)dict1 objectForKey:@"mixDate"];
            NSDate *date2 = [(PFObject *)dict2 objectForKey:@"mixDate"];
            return [date2 compare:date1];
        }];
        
        PFQuery *query2 = [PFQuery queryWithClassName:@"DJunknownMixes"];
        query2.limit = 1000;
        [query2 whereKey:@"url" notEqualTo:@"<#string#>"];
        [query2 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            for (PFObject *object in objects) {
                [feedContent addObject:object];
            }
            [feedContent sortUsingComparator:^NSComparisonResult(id dict1, id dict2) {
                NSDate *date1 = [(PFObject *)dict1 objectForKey:@"mixDate"];
                NSDate *date2 = [(PFObject *)dict2 objectForKey:@"mixDate"];
                return [date2 compare:date1];
            }];
            
            PFQuery *query3 = [PFQuery queryWithClassName:@"DJbloodshotMixes"];
            query3.limit = 1000;
            [query3 whereKey:@"url" notEqualTo:@"<#string#>"];
            [query3 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                for (PFObject *object in objects) {
                    [feedContent addObject:object];
                }
                [feedContent sortUsingComparator:^NSComparisonResult(id dict1, id dict2) {
                    NSDate *date1 = [(PFObject *)dict1 objectForKey:@"mixDate"];
                    NSDate *date2 = [(PFObject *)dict2 objectForKey:@"mixDate"];
                    return [date2 compare:date1];
                }];
                
                PFQuery *query4 = [PFQuery queryWithClassName:@"DJlovellMixes"];
                query4.limit = 1000;
                [query4 whereKey:@"url" notEqualTo:@"<#string#>"];
                [query4 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    for (PFObject *object in objects) {
                        [feedContent addObject:object];
                    }
                    [feedContent sortUsingComparator:^NSComparisonResult(id dict1, id dict2) {
                        NSDate *date1 = [(PFObject *)dict1 objectForKey:@"mixDate"];
                        NSDate *date2 = [(PFObject *)dict2 objectForKey:@"mixDate"];
                        return [date2 compare:date1];
                    }];
                    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
                    [self.refreshControl endRefreshing];
                }];
            }];
        }];
    }];
}

- (void)updatePlayerToolbar:(NSNotification *)notification {
    if ([[notification name] isEqualToString:@"playingMix"]) {
        [iAd removeFromSuperview];
        // Move iAd if visible
        if (bannerIsVisible) {
            [iAd setFrame:CGRectMake(iAd.frame.origin.x, self.navigationController.view.frame.size.height - iAd.frame.size.height, iAd.frame.origin.x, iAd.frame.size.height)];
        } else {
            [iAd setFrame:CGRectMake(iAd.frame.origin.x, self.navigationController.view.frame.size.height - self.navigationController.navigationBar.frame.size.height - iAd.frame.size.height, iAd.frame.origin.x, iAd.frame.size.height)];
        }
        [self.navigationController.view addSubview:iAd];
        
        self.navigationController.toolbarHidden = NO;
        self.navigationController.toolbar.barStyle = UIBarStyleBlack;
        if ([self.navigationController.toolbar respondsToSelector:@selector(barTintColor)]) {
            self.navigationController.toolbar.tintColor = [UIColor whiteColor];
        }
        self.toolbarItems = @[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil], [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPause target:self action:nil], [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:nil], [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil]];
    } else if ([[notification name] isEqualToString:@"pausedMix"]) {
        self.toolbarItems = @[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil], [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:nil], [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:nil], [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil]];
    } else if ([[notification name] isEqualToString:@"doneMix"]) {
        [iAd removeFromSuperview];
        // Move iAd if visible
        if (bannerIsVisible) {
            [iAd setFrame:CGRectMake(iAd.frame.origin.x, self.navigationController.view.frame.size.height - iAd.frame.size.height, iAd.frame.origin.x, iAd.frame.size.height)];
        } else {
            [iAd setFrame:CGRectMake(iAd.frame.origin.x, self.navigationController.view.frame.size.height - self.navigationController.navigationBar.frame.size.height - iAd.frame.size.height, iAd.frame.origin.x, iAd.frame.size.height)];
        }
        [self.navigationController.view addSubview:iAd];
        self.navigationController.toolbarHidden = YES;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return iAd.frame.size.height;
    } else {
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (section == 0) {
        return [feedContent count];
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    if (indexPath.section == 0) {
        PFObject *object = [feedContent objectAtIndex:indexPath.row];
        
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
        cell.textLabel.adjustsLetterSpacingToFitWidth = YES;
        cell.textLabel.text = object[@"name"];
        
        cell.detailTextLabel.adjustsFontSizeToFitWidth = NO;
        cell.detailTextLabel.adjustsLetterSpacingToFitWidth = NO;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"▶︎ %d", [[object objectForKey:@"plays"] intValue]];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        // Async loading of posters
        NSURL *url = [NSURL URLWithString:[object objectForKey:@"iconURL"]];
        NSURLRequest* request = [NSURLRequest requestWithURL:url];
        url = nil;
        
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            cell.imageView.image = nil;
            if (!error) {
                cell.imageView.image = [UIImage imageWithData:data];
                // cell.imageView.layer.cornerRadius = cell.frame.size.height/2;
                // cell.imageView.layer.masksToBounds = YES;
            }
            [cell setNeedsLayout];
        }];
        request = nil;
    } else if (indexPath.section == 1) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = @"";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"playRecordedMix" object:[feedContent objectAtIndex:indexPath.row]];
}

@end
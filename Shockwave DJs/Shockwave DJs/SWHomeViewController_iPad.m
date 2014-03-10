//
//  SWHomeViewController_iPad.m
//  Shockwave DJs
//
//  Created by Victor Ilisei on 3/3/14.
//  Copyright (c) 2014 Tech Genius. All rights reserved.
//

#import "SWHomeViewController_iPad.h"

@interface SWHomeViewController_iPad ()

@end

@implementation SWHomeViewController_iPad

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Home";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.translucent = YES;
    
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.tintColor = [UIColor blueColor];
    [refresh addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
    
    // iAds
    iAd = [[ADBannerView alloc] initWithFrame:CGRectZero];
    iAd.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [self refresh];
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner {
    [banner setFrame:CGRectMake(banner.frame.origin.x, self.navigationController.view.frame.size.height - banner.frame.size.height, banner.frame.origin.x, banner.frame.size.height)];
    [self.navigationController.view addSubview:banner];
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    [banner removeFromSuperview];
}

- (void)refresh {
    [self.refreshControl beginRefreshing];
    PFQuery *query1 = [PFQuery queryWithClassName:@"DJamatterfactMixes"];
    query1.limit = 1000;
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
                [query4 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    for (PFObject *object in objects) {
                        [feedContent addObject:object];
                    }
                    [feedContent sortUsingComparator:^NSComparisonResult(id dict1, id dict2) {
                        NSDate *date1 = [(PFObject *)dict1 objectForKey:@"mixDate"];
                        NSDate *date2 = [(PFObject *)dict2 objectForKey:@"mixDate"];
                        return [date2 compare:date1];
                    }];
                    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
                    
                    [self.refreshControl endRefreshing];
                }];
            }];
        }];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    } else if (indexPath.section == 2) {
        return iAd.frame.size.height;
    } else {
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (section == 1) {
        return [feedContent count];
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    if (indexPath.section == 0) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = @"Banners";
    } else if (indexPath.section == 1) {
        PFObject *object = [feedContent objectAtIndex:indexPath.row];
        
        cell.textLabel.text = object[@"name"];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"▶ %d", [[object objectForKey:@"plays"] intValue]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        // Async loading of posters
        NSURL *url = [NSURL URLWithString:[object objectForKey:@"iconURL"]];
        NSURLRequest* request = [NSURLRequest requestWithURL:url];
        url = nil;
        
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            cell.imageView.image = nil;
            if (!error) {
                cell.imageView.image = [UIImage imageWithData:data];
                cell.imageView.layer.cornerRadius = cell.frame.size.height/2;
                cell.imageView.layer.masksToBounds = YES;
            }
            [cell setNeedsLayout]; 
        }];
        request = nil;
    } else if (indexPath.section == 2) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = @"";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
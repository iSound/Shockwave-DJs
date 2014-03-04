//
//  SWMenuViewController.m
//  Shockwave DJs
//
//  Created by Victor Ilisei on 3/2/14.
//  Copyright (c) 2014 Tech Genius. All rights reserved.
//

#import "SWMenuViewController.h"

@interface SWMenuViewController ()

@end

@implementation SWMenuViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.title = @"Menu";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!self.navigationController.navigationBarHidden) {
        self.navigationController.navigationBarHidden = YES;
    }
    
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"menuBackground"]];
    backgroundImage.frame = CGRectMake(0, 0, self.navigationController.view.frame.size.width, self.tableView.contentSize.height);
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        backgroundImage.contentMode = UIViewContentModeBottomLeft;
    } else {
        backgroundImage.contentMode = UIViewContentModeBottom;
    }
    self.tableView.backgroundView = backgroundImage;
    
    section0 = [[NSArray alloc] initWithObjects:@"Home", nil];
    section1 = [[NSArray alloc] initWithObjects:@"AMatterFact", @"Unknown", @"Bloodshot", @"Lovell", nil];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        section2 = [[NSArray alloc] initWithObjects:@"Facebook", @"Twitter", @"Instagram", @"Tumblr", @"Google+", @"Website", @"Email", @"Chat", nil];
    } else {
        section2 = [[NSArray alloc] initWithObjects:@"Facebook", @"Twitter", @"Instagram", @"Tumblr", @"Google+", @"Website", @"Email", nil];
    }
}

#pragma mark - Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return @"DJs";
    } else if (section == 2) {
        return @"Social";
    } else {
        return @"";
    }
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor lightTextColor]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (section == 0) {
        return [section0 count];
    } else if (section == 1) {
        return [section1 count];
    } else if (section == 2) {
        return [section2 count];
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    cell.backgroundView = nil;
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Neue-Light" size:cell.textLabel.font.pointSize];
    
    if (indexPath.section == 0) {
        cell.textLabel.text = [section0 objectAtIndex:indexPath.row];
    } else if (indexPath.section == 1) {
        cell.textLabel.text = [section1 objectAtIndex:indexPath.row];
    } else if (indexPath.section == 2) {
        cell.textLabel.text = [section2 objectAtIndex:indexPath.row];
    }
    
    UIView *selectedView = [[UIView alloc] initWithFrame:cell.frame];
    selectedView.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.5f];
    
    cell.selectedBackgroundView = selectedView;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self home];
        }
    }
}

- (void)home {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
    } else {
        SWHomeViewController *home = [[SWHomeViewController alloc] init];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:home];
        
        [self.slidingViewController setTopViewController:navController];
        [self.slidingViewController resetTopView];
    }
}

@end
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
    if ([self.navigationController.navigationBar respondsToSelector:@selector(barTintColor)]) {
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    }
    if ([self.navigationController.toolbar respondsToSelector:@selector(barTintColor)]) {
        self.navigationController.toolbar.tintColor = [UIColor whiteColor];
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
        section2 = [[NSArray alloc] initWithObjects:@"Facebook", @"Twitter", @"Instagram", @"Google+", @"Website", @"Email", @"Chat", nil];
    } else {
        section2 = [[NSArray alloc] initWithObjects:@"Facebook", @"Twitter", @"Instagram", @"Google+", @"Website", @"Email", nil];
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
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [self amatterfact];
        } else if (indexPath.row == 1) {
            [self unknown];
        } else if (indexPath.row == 2) {
            [self bloodshot];
        } else if (indexPath.row == 3) {
            [self lovell];
        }
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            [self facebook];
        } else if (indexPath.row == 1) {
            [self twitter];
        } else if (indexPath.row == 2) {
            [self instagram];
        } else if (indexPath.row == 3) {
            [self google];
        } else if (indexPath.row == 4) {
            [self website];
        } else if (indexPath.row == 5) {
            [self email];
        } else if (indexPath.row == 6) {
            [self chat];
        }
    }
}

- (void)home {
    SWHomeViewController *home = [[SWHomeViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:home];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.splitViewController.viewControllers = @[self, navController];
    } else {
        [self.slidingViewController setTopViewController:navController];
        [self.slidingViewController resetTopView];
    }
}

- (void)amatterfact {
    
}

- (void)unknown {
    
}

- (void)bloodshot {
    
}

- (void)lovell {
    
}

- (void)facebook {
    // Check if Facebook app is installed
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"fb://"]]) {
        // Open Facebook app to our page
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"fb://profile/423286087746906"]];
    } else {
        // Open safari to our facebook page
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.facebook.com/pages/Shockwave-DJs/423286087746906"]];
    }
}

- (void)twitter {
    // Check if Twitter app is installed
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter://"]]) {
        // Open Twitter app to our page
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"twitter://user?screen_name=ShockWaveDJs"]];
    } else {
        // Open safari to our twitter page
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://twitter.com/ShockWaveDJs"]];
    }
}

- (void)instagram {
    // Check if Instagram app is installed
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"instagram://"]]) {
        // Open Instagram app to our page
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"instagram://user?username=shockwavedjs"]];
    } else {
        // Open safari to our instagram page
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://instagram.com/shockwavedjs?ref=badge"]];
    }
}

- (void)google {
    // Check if Google+ app is installed
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"gplus://"]]) {
        // Open Google+ app to our page
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"gplus://plus.google.com/101251117847008761406/posts"]];
    } else {
        // Open safari to our Google+ page
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://plus.google.com/101251117847008761406/posts"]];
    }
}

- (void)website {
    // Open safari to our website
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://shockwavedjs.clanteam.com"]];
}

- (void)email {
    // Email
    if ([MFMailComposeViewController canSendMail]) {
        // Init
        MFMailComposeViewController *emailer = [[MFMailComposeViewController alloc] init];
        // Set the delegate to self
        emailer.mailComposeDelegate = self;
        // Set the title
        emailer.title = @"Email Us";
        // Set the to field
        [emailer setToRecipients:[NSArray arrayWithObjects:@"shockwavedjs.radiobroadcast@gmail.com", nil]];
        // present controller
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            self.splitViewController.viewControllers = @[self, emailer];
        } else {
            [self.slidingViewController setTopViewController:emailer];
            [self.slidingViewController resetTopView];
        }
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self home];
}

- (void)chat {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        SWChatViewController *chat = [[SWChatViewController alloc] init];
        [self.navigationController pushViewController:chat animated:YES];
    }
}

@end
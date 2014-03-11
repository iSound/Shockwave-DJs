//
//  SWChatViewController.m
//  Shockwave DJs
//
//  Created by Victor Ilisei on 3/4/14.
//  Copyright (c) 2014 Tech Genius. All rights reserved.
//

#import "SWChatViewController.h"

@interface SWChatViewController ()

@end

@implementation SWChatViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Chat";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor viewFlipsideBackgroundColor];
    self.tableView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
	self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        CGImageRef imageRef = CGImageCreateWithImageInRect([UIImage imageNamed:@"menuBackground"].CGImage, CGRectMake(0, 1024 - self.navigationController.view.frame.size.height, 320, 64));
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithCGImage:imageRef] forBarMetrics:UIBarMetricsDefault];
        CGImageRelease(imageRef);
    } else {
        CGImageRef imageRef = CGImageCreateWithImageInRect([UIImage imageNamed:@"menuBackground"].CGImage, CGRectMake(0, 1024 - self.navigationController.view.frame.size.height, 320, 64));
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithCGImage:imageRef] forBarMetrics:UIBarMetricsDefault];
        CGImageRelease(imageRef);
    }
    CGImageRef imageRef = CGImageCreateWithImageInRect([UIImage imageNamed:@"menuBackground"].CGImage, CGRectMake(0, 980, 320, 44));
    [self.navigationController.toolbar setBackgroundImage:[UIImage imageWithCGImage:imageRef] forToolbarPosition:UIBarPositionBottom barMetrics:UIBarMetricsDefault];
    CGImageRelease(imageRef);
    
    // Username
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *PREusername = [defaults objectForKey:@"chat_name"];
    NSString *FINALusername = [PREusername stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *checkIfDJ = [[FINALusername lowercaseString] stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([PFUser currentUser]) {
        if ([FINALusername isEqualToString:@""] || [FINALusername length] <= 0) {
            FINALusername = [NSString stringWithFormat:@"%@", [UIDevice currentDevice].name];
        }
    } else {
        if ([FINALusername isEqualToString:@""] || [FINALusername length] <= 0 || [checkIfDJ isEqualToString:@"djamatterfact"] || [checkIfDJ isEqualToString:@"djunknown"] || [checkIfDJ isEqualToString:@"djbloodshot"] || [checkIfDJ isEqualToString:@"djlovell"] || [checkIfDJ isEqualToString:@"system"]) {
            FINALusername = [NSString stringWithFormat:@"%@", [UIDevice currentDevice].name];
        }
    }
    [defaults setObject:FINALusername forKey:@"chat_name"];
    [defaults synchronize];
    username = FINALusername;
    
    messageBox = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 213, 25)];
    if ([messageBox respondsToSelector:@selector(tintColor)]) {
        messageBox.tintColor = [UIColor whiteColor];
    }
    messageBox.clearButtonMode = UITextFieldViewModeWhileEditing;
    messageBox.keyboardAppearance = UIKeyboardAppearanceAlert;
    messageBox.textColor = [UIColor whiteColor];
    messageBox.returnKeyType = UIReturnKeySend;
    if (![self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        messageBox.borderStyle = UITextBorderStyleRoundedRect;
    } else {
        messageBox.attributedPlaceholder = [[NSAttributedString alloc] initWithString:username attributes:@{NSForegroundColorAttributeName:[UIColor lightTextColor]}];
    }
    
    self.navigationController.toolbar.barStyle = UIBarStyleBlack;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.toolbarItems = @[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil], [[UIBarButtonItem alloc] initWithCustomView:messageBox], [[UIBarButtonItem alloc] initWithTitle:@"Send" style:UIBarButtonItemStyleDone target:self action:@selector(submitMessage)], [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil]];
    } else {
        self.toolbarItems = @[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil], [[UIBarButtonItem alloc] initWithCustomView:messageBox], [[UIBarButtonItem alloc] initWithTitle:@"Send" style:UIBarButtonItemStyleDone target:self action:@selector(submitMessage)]];
    }
    
    if ([PFUser currentUser]) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:[PFUser currentUser].username style:UIBarButtonItemStyleBordered target:self action:@selector(showAdminOptions:)];
    } else {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Login" style:UIBarButtonItemStyleBordered target:self action:@selector(loginUser)];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [self refresh];
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.toolbarHidden = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(liftToolbarWhenKeybordAppears:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(returnToolbarToInitialposition:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.toolbarHidden = YES;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if ([adminOptions isVisible]) {
        [adminOptions dismissWithClickedButtonIndex:[adminOptions cancelButtonIndex] animated:YES];
    }
}

- (void)refresh {
    PFQuery *query = [PFQuery queryWithClassName:@"chat"];
    query.limit = 1000;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            UIAlertView *errorLoadingChat = [[UIAlertView alloc] initWithTitle:@"Error loading chat" message:error.localizedDescription delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
            [errorLoadingChat show];
        } else {
            chatArray = [[NSMutableArray alloc] init];
            for (PFObject *object in objects) {
                [chatArray addObject:object];
            }
            [chatArray sortUsingComparator:^NSComparisonResult(id dict1, id dict2) {
                NSDate *date1 = [(PFObject *)dict1 createdAt];
                NSDate *date2 = [(PFObject *)dict2 createdAt];
                return [date1 compare:date2];
            }];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
            NSIndexPath *ipath = [NSIndexPath indexPathForRow:[chatArray count]-1 inSection:0];
            if ([chatArray count] > 0) {
                [self.tableView scrollToRowAtIndexPath:ipath atScrollPosition:UITableViewScrollPositionTop animated:YES];
            }
        }
        [refreshTimer invalidate];
        refreshTimer = nil;
        refreshTimer = [NSTimer scheduledTimerWithTimeInterval:15.0 target:self selector:@selector(refresh) userInfo:nil repeats:NO];
    }];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [messageBox endEditing:messageBox.editing];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        CGImageRef imageRef = CGImageCreateWithImageInRect([UIImage imageNamed:@"menuBackground"].CGImage, CGRectMake(0, 1024 - self.navigationController.view.frame.size.height, 320, 64));
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithCGImage:imageRef] forBarMetrics:UIBarMetricsDefault];
        CGImageRelease(imageRef);
    } else {
        CGImageRef imageRef = CGImageCreateWithImageInRect([UIImage imageNamed:@"menuBackground"].CGImage, CGRectMake(0, 1024 - self.navigationController.view.frame.size.height, 320, 64));
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithCGImage:imageRef] forBarMetrics:UIBarMetricsDefault];
        CGImageRelease(imageRef);
    }
}

- (void)liftToolbarWhenKeybordAppears:(NSNotification *)aNotification {
    NSDictionary *userInfo = [aNotification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardFrame;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrame];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    if (UIDeviceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
        [self.navigationController.toolbar setFrame:CGRectMake(self.navigationController.toolbar.frame.origin.x, self.navigationController.toolbar.frame.origin.y - keyboardFrame.size.width, self.navigationController.toolbar.frame.size.width, self.navigationController.toolbar.frame.size.height)];
        [self.tableView setFrame:CGRectMake(0, self.tableView.frame.origin.y, 320, self.navigationController.view.frame.size.height - keyboardFrame.size.width)];
    } else {
        [self.navigationController.toolbar setFrame:CGRectMake(self.navigationController.toolbar.frame.origin.x, self.navigationController.toolbar.frame.origin.y - keyboardFrame.size.height, self.navigationController.toolbar.frame.size.width, self.navigationController.toolbar.frame.size.height)];
        [self.tableView setFrame:CGRectMake(0, self.tableView.frame.origin.y, 320, self.navigationController.view.frame.size.height - keyboardFrame.size.height)];
    }
    [UIView commitAnimations];
    // NSIndexPath *ipath = [NSIndexPath indexPathForRow:[chatArray count]-1 inSection:0];
    // [self.tableView scrollToRowAtIndexPath:ipath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)returnToolbarToInitialposition:(NSNotification *)aNotification {
    NSDictionary* userInfo = [aNotification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardFrame;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrame];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    if (UIDeviceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
        [self.navigationController.toolbar setFrame:CGRectMake(self.navigationController.toolbar.frame.origin.x, self.navigationController.toolbar.frame.origin.y + keyboardFrame.size.width, self.navigationController.toolbar.frame.size.width, self.navigationController.toolbar.frame.size.height)];
    } else {
        [self.navigationController.toolbar setFrame:CGRectMake(self.navigationController.toolbar.frame.origin.x, self.navigationController.toolbar.frame.origin.y + keyboardFrame.size.height, self.navigationController.toolbar.frame.size.width, self.navigationController.toolbar.frame.size.height)];
    }
    [self.tableView setFrame:CGRectMake(0, self.tableView.frame.origin.y, 320, self.navigationController.view.frame.size.height)];
    [UIView commitAnimations];
    // NSIndexPath *ipath = [NSIndexPath indexPathForRow:[chatArray count]-1 inSection:0];
    // [self.tableView scrollToRowAtIndexPath:ipath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)submitMessage {
    [messageBox endEditing:self.editing];
    PFObject *object = [PFObject objectWithClassName:@"chat"];
    object[@"content"] = messageBox.text;
    object[@"userName"] = username;
    [object saveEventually:^(BOOL succeeded, NSError *error) {
        if (!error) {
            messageBox.text = @"";
            [self refresh];
        }
    }];
}

- (void)loginUser {
    PFLogInViewController *logInController = [[PFLogInViewController alloc] init];
    logInController.delegate = self;
    logInController.fields = PFLogInFieldsUsernameAndPassword | PFLogInFieldsLogInButton | PFLogInFieldsSignUpButton | PFLogInFieldsPasswordForgotten | PFLogInFieldsDismissButton;
    [self presentViewController:logInController animated:YES completion:nil];
}

- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    if ([PFUser currentUser]) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:[PFUser currentUser].username style:UIBarButtonItemStyleBordered target:self action:@selector(showAdminOptions:)];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Login" style:UIBarButtonItemStyleBordered target:self action:@selector(loginUser)];
}

- (void)logoutUser {
    if ([PFUser currentUser]) {
        [PFUser logOut];
    }
    if (![PFUser currentUser]) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Login" style:UIBarButtonItemStyleBordered target:self action:@selector(loginUser)];
    }
}

- (IBAction)showAdminOptions:(id)sender {
    adminOptions = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Logout" otherButtonTitles:@"Clear Chat", nil];
    adminOptions.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [adminOptions showFromBarButtonItem:sender animated:YES];
    } else {
        [adminOptions showFromToolbar:self.navigationController.toolbar];
    }
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 88;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [chatArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"ChatListItem"];
    if (cell == nil) {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ChatCell_iPad" owner:self options:nil];
            cell = (UITableViewCell *)[nib objectAtIndex:0];
        } else {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ChatCell" owner:self options:nil];
            cell = (UITableViewCell *)[nib objectAtIndex:0];
        }
    }
    // Configure the cell...
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    PFObject *object = [chatArray objectAtIndex:indexPath.row];
    
    UITextView *textLabel = (UITextView *)[cell viewWithTag:1];
    textLabel.text = object[@"content"];
    
    UILabel *userLabel = (UILabel *)[cell viewWithTag:2];
    userLabel.adjustsFontSizeToFitWidth = YES;
    userLabel.adjustsLetterSpacingToFitWidth = YES;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    userLabel.text = [NSString stringWithFormat:@"%@ - %@", [dateFormatter stringFromDate:[object createdAt]], object[@"userName"]];
    [userLabel sizeToFit];
    
    return cell;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != [actionSheet cancelButtonIndex]) {
        if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Clear Chat"]) {
            // Clear chat
        } else if (buttonIndex == [actionSheet destructiveButtonIndex]) {
            [self logoutUser];
        }
        
        [self refresh];
    }
}

- (void)dealloc {
    [refreshTimer invalidate];
    refreshTimer = nil;
}

@end
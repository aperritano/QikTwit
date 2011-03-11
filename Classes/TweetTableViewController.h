//
//  TweetTableViewController.h
//  QikTwit
//
//  Created by Anthony John Perritano on 10/24/09.
//

#import <UIKit/UIKit.h>
#import "AboutViewController.h"
#import "LoginViewController.h"
#import "CustomCell.h"
#import "LoadingView.h"

@interface TweetTableViewController : UIViewController <UITableViewDelegate> {

	IBOutlet UITableView *tablView;
	
	
	IBOutlet UIBarButtonItem *sendSavedTweetsButton;
	IBOutlet UIBarButtonItem *infoButton;

	IBOutlet AboutViewController *aboutViewController;

	IBOutlet UIToolbar *tableToolbar;
	IBOutlet CustomCell *customCell;

	LoadingView *loadingView;

}

@property (nonatomic, retain) IBOutlet UITableView *tablView;
@property (nonatomic, retain) IBOutlet AboutViewController *aboutViewController;
@property (nonatomic, retain) IBOutlet UIToolbar *tableToolbar;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *sendSavedTweetsButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *infoButton;

- (IBAction)bulkTweet:(id)sender;
- (IBAction)infoPaneShow:(id)sender;
- (IBAction)atAction:(id)sender;

- (void) logoutAction;
- (void) stopAnimating;
-(void) disableSendButton;
-(void) enableSendButton;
@end

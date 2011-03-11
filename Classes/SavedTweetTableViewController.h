//
//  SavedTweetTableViewController.h
//  QuikTwit
//
//  Created by Anthony John Perritano on 9/27/09.
//

#import <UIKit/UIKit.h>
#import "AboutViewController.h"


@interface SavedTweetTableViewController : UITableViewController <UIAlertViewDelegate> {
	IBOutlet UITableView *tablView;
	IBOutlet UIBarButtonItem *sendSavedTweetsButton;
	IBOutlet UIToolbar *toolbar;
	IBOutlet AboutViewController *aboutViewController;

	NSMutableArray *numbers;
}

@property (nonatomic, retain) IBOutlet UITableView *tablView;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *sendSavedTweetsButton;
@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) IBOutlet AboutViewController *aboutViewController;
- (IBAction)bulkTweet;
- (void)infoPaneShow;


@end

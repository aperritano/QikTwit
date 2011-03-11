//
//  TweeterTabViewController.h
//  QikTwitter
//
//  Created by Anthony John Perritano on 9/26/09.
//

#import <UIKit/UIKit.h>
#import "TweetTableViewController.h"
#import "MGTwitterEngine.h"
#import "AudioToolbox/AudioServices.h"
#import "UILabel2.h"

@class Reachability;
@interface TweeterViewController : UIViewController <UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource,MGTwitterEngineDelegate>  {
	IBOutlet UITextView *tweetTextView;
	IBOutlet UILabel *charLabel;
	IBOutlet UILabel *connectedLabel;
	IBOutlet UILabel2 *usernameLabel;
	IBOutlet UILabel *statusLabel;
	IBOutlet UIButton *tweetButton;
	IBOutlet UIButton *logoutButton;
	IBOutlet TweetTableViewController *savedTweetTableViewController;
	IBOutlet LoginViewController *loginViewController;
	IBOutlet UIActivityIndicatorView *indicatorView;
	IBOutlet UIView *greenViewBar;
	IBOutlet UIView *invisLoadingView;
	IBOutlet UIButton *atButton;
	IBOutlet UIView *invisLoadingTweetView;
	IBOutlet UIBarButtonItem *loginButton;

	IBOutlet UIPickerView *pickerView;
	NSString *numOfChars;
	
	NSMutableArray* newStatuses;
	NSMutableArray *credentials;
	NSMutableDictionary *pickerDataDick;
	UILabel2 *userLabel;
	MGTwitterEngine *twitterEngine;
	LoadingView *loadingView;
	Reachability* hostReach;
    Reachability* internetReach;
    Reachability* wifiReach;
	
	//constants
	BOOL isBulkTweet;
	BOOL isLoginIn;
	BOOL isSendTweet;
	BOOL isOnline;
	BOOL loginSuccess;
	BOOL canceled;
	BOOL isChoosingAt;
	BOOL connected;
	
	
}

@property (nonatomic, retain) IBOutlet UITextView *tweetTextView;
@property (nonatomic, retain) IBOutlet UILabel *charLabel;
@property (nonatomic, retain) IBOutlet UILabel *connectedLabel;
@property (nonatomic, retain) IBOutlet TweetTableViewController *savedTweetTableViewController;
@property (nonatomic, retain) IBOutlet UIButton *tweetButton;
@property (nonatomic, retain) IBOutlet UIButton *logoutButton;
@property (nonatomic, retain) IBOutlet UILabel *usernameLabel;
@property (nonatomic, retain) IBOutlet UILabel *statusLabel;
@property (nonatomic, retain) IBOutlet UIView *greenViewBar;
@property (nonatomic, retain) IBOutlet UIButton *atButton;
@property (nonatomic, retain) IBOutlet UIPickerView *pickerView;
@property (nonatomic, retain) IBOutlet UIView *invisLoadingView;
@property (nonatomic, retain) IBOutlet UIView *invisLoadingTweetView;
@property (nonatomic, retain) IBOutlet LoginViewController *loginViewController;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *loginButton;

- (IBAction)navigateSaveAction:(id)sender;
- (IBAction)tweetTextAction:(id)sender;
- (IBAction)switchAction:(id)sender;
- (IBAction)signoutAction;
- (IBAction)atAction:(id)sender;
- (IBAction)pickerDoneAction:(id)sender;
- (IBAction)loginPaneShow:(id)sender;

-(void)checkForLoginPassword;
-(void)setUsername:(NSString *)newUsername password:(NSString *)newPassword;
-(void)reloadTableView;
-(void)setTweet:(int)count;

//Alerts
-(void)showAlert;

-(void)makeHorizontalLayout;

-(void)makeVerticalLayout;

- (UIView *)keyboardView;

-(BOOL) connected;

@end

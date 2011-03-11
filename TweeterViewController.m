//
//  TweeterTabViewController.m
//  QikTwitter
//
//  Created by Anthony John Perritano on 9/26/09.
//

#import "TweeterViewController.h"
#import "MGTwitterEngine.h"
#import "AudioToolbox/AudioServices.h"
#import "UICustomSwitch.h" 
#import <QuartzCore/CAAnimation.h>
#import "UILabel2.h"
#import "LoadingView.h"
#import "Reachability.h"
#import "AlertCrediationalPrompt.h"
#import "LoginViewController.h"

@implementation TweeterViewController

@synthesize tweetTextView;
@synthesize charLabel;
@synthesize connectedLabel;
@synthesize savedTweetTableViewController;
@synthesize tweetButton;
@synthesize logoutButton;
@synthesize usernameLabel;
@synthesize statusLabel;
@synthesize greenViewBar;
@synthesize atButton;
@synthesize invisLoadingView;
@synthesize loginViewController;


UIView *gBar;

int tweetDeleteIndex = 0;
int tweetCount = 0;
BOOL isLoading = NO;
BOOL hasConnection = NO;
BOOL isTweeting = NO;
BOOL checkingConnection = NO;

NSString *deleteTweet;
NSString *oldTextAreaText;

#define allTrim( object ) [object stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet] ]


-(BOOL) connected{
	return connected;
}

- (IBAction)navigateSaveAction:(id)sender {
	
	if( isLoading == NO ) {
		[[self navigationController] pushViewController:savedTweetTableViewController animated:YES];
		NSLog(@"navigate");
	}
	
}


- (void)awakeFromNib {
	
	//[loginViewController initWithNibName:@"LoginViewController" bundle:nil];
	//frameWithPositionAboveScreen = CGRectMake(0,244, 320.0f, 216.0f);
	//frameWithPositionBelowScreen = CGRectMake(0,-1, 320.0f, 216.0f);
	//pickerView.frame = frameWithPositionBelowScreen;
	
	isBulkTweet = NO;
	isLoginIn = NO;
	isSendTweet = NO;
	isOnline = NO;
	loginSuccess = NO;
	canceled = NO;
	isChoosingAt = NO;
	
	CGFloat v = 125.0f;
	
	usernameLabel = [[UILabel2 alloc] initWithFrame:CGRectMake(0.0f, v+20.0f, 320.0f, 54.0f)];
	usernameLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0];
	usernameLabel.numberOfLines = 3;
	usernameLabel.textColor = [UIColor greenColor];
	usernameLabel.backgroundColor = [UIColor blackColor];
	[self.view addSubview:usernameLabel];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(signOutAction) name:@"SignOut" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(signInAction) name:@"SignIn" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess) name:@"LoginSuccess" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginFailed) name:@"LoginFailed" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tweetSuccess) name:@"TweetSuccess" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tweetFailed) name:@"TweetFailed" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendBulkTweetAction) name:@"BulkTweet" object:nil];

	// Observe the kNetworkReachabilityChangedNotification. When that notification is posted, the
    // method "reachabilityChanged" will be called. 
    
	
	[super initWithNibName:@"TweeterViewController" bundle:nil];

	
	pickerDataDick = [[NSMutableDictionary alloc] init];
	
	NSMutableArray *ts = [self retrieveFromUserDefaultsTweets];
	
	if( ts == nil || [ts count] == 0 ) {
		[self saveToUserDefaults: [[NSMutableArray alloc] init]];
	}
	
    [ts release];
	
	credentials = [self retrieveFromUserDefaultsCreds];
	
	
	[self checkForLoginPassword];
	
	
}

- (void) cut: (id)sender {
    NSLog(@"cuuuuuuuuuut");
}


- (void) copy: (id)sender {
    NSLog(@"copyyy");
}


- (void) paste: (id)sender {
	NSLog(@"pasting......");
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
	[UIMenuController sharedMenuController].menuVisible = YES;
	if (action == @selector(copy:))
		return YES;
	if (action == @selector(cut:))
		return YES;
	if (action == @selector(paste:))
		return YES;
	if (action == @selector(select:))
		return YES;
	if (action == @selector(selectAll:))
		return YES;
	
	return NO;
}


//Called by Reachability whenever status changes.
- (void) reachabilityChanged: (NSNotification* )note
{
	Reachability* curReach = [note object];
	NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
	[self updateInterfaceWithReachability: curReach];
}

- (void) updateInterfaceWithReachability: (Reachability*) curReach
{
	
    if(curReach == hostReach) {
		
        NetworkStatus netStatus = [curReach currentReachabilityStatus];
        BOOL connectionRequired= [curReach connectionRequired];
		
        
        NSString* baseLabel=  @"";
        if(connectionRequired) {
			connected = NO;
            NSLog(@"Cellular data network is available.\n  Internet traffic will be routed through it after a connection is established.");
        } else {
			connected = YES;
            NSLog(@"Cellular data network is active.\n  Internet traffic will be routed through it.");
        }
        
    }
	if(curReach == internetReach) {	
		 connected = [self reachability: curReach];
	}
	if(curReach == wifiReach) {	
		 connected =  [self reachability: curReach];
	}
	checkingConnection = YES;
	[twitterEngine testService];
	

	
}
			   
- (BOOL) reachability: (Reachability*) curReach{
			NetworkStatus netStatus = [curReach currentReachabilityStatus];
			BOOL connectionRequired= [curReach connectionRequired];
			NSString* statusString= @"";
			switch (netStatus)
			{
				case NotReachable:
				{
					statusString = @"Access Not Available";

					//Minor interface detail- connectionRequired may return yes, even when the host is unreachable.  We cover that up here...
					connectionRequired= NO;  
					return NO;
					break;
				}
					
				case ReachableViaWWAN:
				{
					statusString = @"Reachable WWAN";
					return YES;
					break;
				}
				case ReachableViaWiFi:
				{
					statusString= @"Reachable WiFi";
					return YES;
					break;
				}
			}
			if(connectionRequired) {
				statusString= [NSString stringWithFormat: @"%@, Connection Required", statusString];
			}
			NSLog(@"status %@",statusString);
	return NO;
}


			
#pragma mark TextView methods

-(void)textViewDidChange:(UITextView *)textView {
	
	
	int textLength = [tweetTextView.text length];
	NSLog(@"textcount = %d",textLength );
	
	if( textLength == 0 ) {
		
	}
	
	if( textLength > 140 ) {
		numOfChars = [NSString stringWithFormat:@"%d:",[tweetTextView.text length]];
		statusLabel.text = @"Over the text limit.";
		charLabel.textColor = [UIColor redColor];
	} else if( textLength < 140 ) {
		
		if( textLength < 10 ) {
			numOfChars = [NSString stringWithFormat:@"00%d*",[tweetTextView.text length]];
		} else if(textLength < 100 ) {
			numOfChars = [NSString stringWithFormat:@"0%d*",[tweetTextView.text length]];
		} else {
			numOfChars = [NSString stringWithFormat:@"%d*",[tweetTextView.text length]];
		}
		statusLabel.text = @"You are Success.";
		charLabel.textColor = [UIColor blackColor];
	}
	
	[charLabel setText:numOfChars] ;
	

}

-(void)setupTextView{
	
	tweetTextView.font = [UIFont fontWithName:@"Helvetica" size:17];
	
	[tweetTextView setDelegate:self];
	[tweetTextView becomeFirstResponder];
	

	
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range 
 replacementText:(NSString *)text {
	

	
	    // Any new character added is passed in as the "text" parameter
	
    if ([text isEqualToString:@"\n"]) {
       
		[self tweetTextAction:nil];
	
        // Return FALSE so that the final '\n' character doesn't get added
       return FALSE;
    } else if([text isEqualToString: @"@"]) {
		NSLog(@" found");
	}
	
	if([tweetTextView.text length] > 150 ){
		return TRUE;
	}
    // For any other character return TRUE so that the text gets added to the view
    return TRUE;
}

#pragma mark pickerview methods

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	return [newStatuses count];
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component { // This method asks for what the title or label of each row will be.
	
	
	
	NSDictionary *dick =[newStatuses objectAtIndex:row];
	
	NSDictionary *user = [dick objectForKey: @"user"];
	
	//NSLog(@"user %@ %@",[user objectForKey:@"screen_name"], [dick objectForKey:@"text"]);

	
	return [[NSString alloc] initWithFormat: @"@%@: %@", [user objectForKey:@"screen_name"], [dick objectForKey:@"text"]];
	

	//return [pickerViewArray objectAtIndex:row]; // We will set a new row for every string used in the array.
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component { // And now the final part of the UIPickerView, what happens when a row is selected.
	/*
	tipSelected = row + 1; // We will set the float 'tipSelected' to row + 1 because the row count starts at 0, so it is 1 number behind our array.
	tipSelected = tipSelected / 100; // We will now divide 'tipSelected' by 100 to give us the decimal value of the percentage.
	float tipTotal = [billTotal.text floatValue] * tipSelected; // Now we will set the tipTotal to the text inserted in the Bill Total UITextField multiplied by 'tipSelected'.
	tipAmount.text = [NSString stringWithFormat:@"Tip: $%.2f", tipTotal]; // Set the tipAmount labels text to the tipTotal amount.
	 */
	[tweetTextView setText: oldTextAreaText ];
	
	self.tweetTextView.editable = YES;
	
	NSDictionary *dick =[newStatuses objectAtIndex:row];
	
	if( [dick count] != 0) {
	
		NSDictionary *user = [dick objectForKey: @"user"];
		
		NSString *t = [[NSString alloc] initWithFormat: @"@%@", [user objectForKey:@"screen_name"]];
		
		NSLog(@"old text %@", oldTextAreaText );
		[tweetTextView setText: [ oldTextAreaText stringByAppendingString: t ]];
		
		usernameLabel.text = [dick objectForKey:@"text"];

		NSLog(@"user %@ %@",[user objectForKey:@"screen_name"], [dick objectForKey:@"text"]);
		
		[t release];
	}
	[oldTextAreaText release];
	
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
	
	NSDictionary *dick =[newStatuses objectAtIndex:row];
	
	NSDictionary *user = [dick objectForKey: @"user"];
	
	//NSLog(@"user %@ %@",[user objectForKey:@"screen_name"], [dick objectForKey:@"text"]);
	
	
	NSString *s = [[NSString alloc] initWithFormat: @"@%@: %@", [user objectForKey:@"screen_name"], [dick objectForKey:@"text"]];
	

	UILabel *l;
	
	l = (view != nil)? view : [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 44)] autorelease];
	//if( self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft || self.interfaceOrientation == UIInterfaceOrientationLandscapeRight ) {
	//	l = (view != nil)? view : [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 460, 44)] autorelease];
	//} else if( self.interfaceOrientation == UIInterfaceOrientationPortrait ) {
		l = (view != nil)? view : [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 44)] autorelease];
	//}

	
     
    l.text = [NSString stringWithFormat:@"%@", s];
    l.font = [UIFont boldSystemFontOfSize:11];
	l.textColor = [UIColor blackColor];
    l.textAlignment = UITextAlignmentLeft;
    l.backgroundColor = [UIColor clearColor];
	
	
    return l;
}

- (IBAction)atAction:(id)sender {
	
	oldTextAreaText = [[NSString alloc] initWithString:tweetTextView.text];

	[tweetTextView resignFirstResponder];


	NSLog(@" at");
}

-(void)checkForLoginPassword{
	
	if( [credentials count] == 0 ) {
		//popup the alert
		[self loginPaneShow:nil];
		
	} else {
		
		// Put your Twitter username and password here:
		
		NSMutableArray *c = [self retrieveFromUserDefaultsCreds];
		[self setUsername: [c objectAtIndex:0] password: [c objectAtIndex:1]];
		
		
		[c release];

	}
}

-(void)doAlert:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	//cancel
	if( buttonIndex == 0 ) {

		canceled = YES;
		loginSuccess = NO;
		tweetTextView.editable = YES;
		[tweetTextView resignFirstResponder];
		[tweetTextView becomeFirstResponder];
	} else if(buttonIndex == 1){
		tweetTextView.editable = YES;
		[tweetTextView becomeFirstResponder];
		
		NSString *username = [(AlertCrediationalPrompt *)alertView enteredText1];
		NSString *password = [(AlertCrediationalPrompt *)alertView enteredText2];
		
		if( username != nil && password != nil ) {
			
			//if( credentials == nil )
			//credentials = [[NSMutableArray alloc] init];
			NSMutableArray *temp = [[NSMutableArray alloc] init];
			
			[temp insertObject:username	atIndex:0];
			[temp insertObject:password	atIndex:1];
			
			[self saveToUserDefaultsCreds: temp];
			
			[temp release];
			//login 
			[self setUsername: username password: password];
			
			
		}
		
		//NSLog(@"NSUserDefaults dump: %@", [[NSUserDefaults standardUserDefaults] dictionaryRepresentation]);
		
		//twitter this shit
		
		[tweetButton setEnabled:YES];
		NSLog(@"l %@, p %@", username, password);
		[username release];
		[password release];
		
	}
	
	
	
	
}

-(void)setTweet:(int)count{
	tweetCount = count;
}



// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)orientation {

	
	//if ((orientation == UIInterfaceOrientationLandscapeLeft) || (orientation == UIInterfaceOrientationLandscapeRight)) {
	//	[self makeHorizontalLayout];
	//} else {
		[self makeVerticalLayout];
	//}
	
    return NO;
}


-(void)makeHorizontalLayout{
	CGFloat v = 65.0f;
	tweetTextView.frame = CGRectMake(0.0f, 0.0f, 480.0f, 64.0f);
	greenViewBar.frame = CGRectMake(0.0f, v, 400.0f, 18.0f);
	usernameLabel.frame = CGRectMake(0.0f, v+20.0f, 480.0f, 18.0f);
	atButton.frame =  CGRectMake(410.0f, v-3, 60.0f, 25.0f);
	
	//CGRect rect = pickerView.frame;
	//CGPoint origin = CGPointMake(200, 400); // Some off-screen y-offset here.
	
	//rect.origin = origin;
	pickerView.frame = CGRectMake(0.0f, 105.0f, 480.0f, 170.0f);
	[pickerView reloadAllComponents];
	
	
}

-(void)makeVerticalLayout {
	CGFloat v = 125.0f;

	tweetTextView.frame = CGRectMake(0.0f, 0.0f, 320.0f, 120.0f);
	//tweetTextView.bounds = CGRectMake(0.0f, 0.0f, 320.0, tvh);
	greenViewBar.frame = CGRectMake(0.0f, v, 240.0f, 18.0f);
	usernameLabel.frame = CGRectMake(0.0f, v+20.0f, 320.0f, 54.0f);
	atButton.frame = CGRectMake(250.0f, v-3, 60.0f, 25.0f);
	

	pickerView.frame = CGRectMake(0.0f, 200.0f, 320.0f, 216.0f);
	[pickerView reloadAllComponents];
	
}

-(void)setupPickerView{
	pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0, 200.0, 320.0, 216.0)];
	[pickerView setBackgroundColor:[UIColor blackColor]];
	
	//CGRect rect = pickerView.frame;
	//CGPoint origin = CGPointMake(0,	481); // Some off-screen y-offset here.
	
	//rect.origin = origin;
	//pickerView.frame = rect;
	
	[self.view addSubview:pickerView];
	[pickerView setShowsSelectionIndicator:TRUE];
	[pickerView setDelegate: self];
	[pickerView setDataSource:self];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
	

	
	
	self.navigationItem.titleView = [[[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 100.0f, 36.0f)] autorelease];
	
	[(UILabel *)self.navigationItem.titleView setText:@""];
	[(UILabel *)self.navigationItem.titleView setBackgroundColor:[UIColor clearColor]];
	[(UILabel *)self.navigationItem.titleView setTextColor:[UIColor whiteColor]];
	[(UILabel *)self.navigationItem.titleView setTextAlignment:UITextAlignmentCenter];
	[(UILabel *)self.navigationItem.titleView setFont:[UIFont boldSystemFontOfSize:[UIFont systemFontSize]]];
	
	//[indicatorView startAnimating];
	
	[self makeVerticalLayout];
	[self setupTextView];
	[self setupPickerView];
	
	
	[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];
	
	hostReach = [[Reachability reachabilityWithHostName: @"www.apple.com"] retain];
	[hostReach startNotifer];
	[self updateInterfaceWithReachability: hostReach];
	
    internetReach = [[Reachability reachabilityForInternetConnection] retain];
	[internetReach startNotifer];
	[self updateInterfaceWithReachability: internetReach];
	
    wifiReach = [[Reachability reachabilityForLocalWiFi] retain];
	[wifiReach startNotifer];
	 
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

	
	[self updateTweetBoxButton];
	[tweetTextView becomeFirstResponder];
	
	[self.navigationItem.backBarButtonItem setImage:[UIImage imageNamed:@"arrow.png"]];
	//titleString = [[NSString alloc] initWithFormat: @"TweetBox(%d)", [numbers count]];
	
	
}


-(void)updateTweetBoxButton {
	NSString *titleString;
	
	int tweetCount = [[self retrieveFromUserDefaultsTweets] count];
	if( tweetCount == 0 ) {
		titleString = @"TweetBox";
	} else {
		titleString = [[NSString alloc] initWithFormat: @"TweetBox(%d)", tweetCount];
	}
	
	[self.navigationItem.rightBarButtonItem setTitle: titleString];
	[titleString release];
}



-(void)setUsername:(NSString *)newUsername password:(NSString *)newPassword {
	
	[newUsername retain];
	[newPassword retain];
	if( newUsername != nil && newPassword != nil ) {
		//[indicatorView startAnimating];
		// Make sure you entered your login details before running this code... ;)
		if ([newUsername isEqualToString:@""] || [newPassword isEqualToString:@""]) {
			NSLog(@"You forgot to specify your username/password in AppController .m!");
			[self loginFailed];
			//[NSApp terminate:self];
			statusLabel.text = @"touch the heart.";
			
			loginSuccess = NO;
			[[NSNotificationCenter defaultCenter] postNotificationName:@"SwitchToSignInButton" object:self];
			//needs to change
			NSMutableArray *temp = [self retrieveFromUserDefaultsCreds];
			[temp removeAllObjects];
			[self saveToUserDefaultsCreds:temp];
			[temp release];
			

		} else {
		
			//[self bringSubviewToFront:invisLoadingView];
			//disable it
			pickerView.hidden = YES;
			tweetTextView.editable = FALSE;
			greenViewBar.hidden = YES;
			usernameLabel.hidden = YES;
			atButton.hidden = YES;
			invisLoadingView.hidden = NO;
			
			loadingView = [LoadingView loadingViewInView: self.view message: @"Loading your twitter account...."];
			
			isLoading = YES;
			isLoginIn = YES;
			
			twitterEngine = [[MGTwitterEngine alloc] initWithDelegate:self];
			[twitterEngine setUsername:newUsername password:newPassword];
			[twitterEngine setClientName:@"qiktwit" version:@"1.0" URL:@"https://twitter.com/oauth/authorize" token:@"https://twitter.com/oauth/access_token"];
			[twitterEngine checkUserCredentials];
			
			
			//[twitterEngine getFollowedTimelineFor:nil since:nil startingAtPage:2];
			//NSString *status = [twitterEngine checkUserCredentials];
			
						
			
			
			
		}		
	}
}



- (IBAction)signOutAction {
	
	statusLabel.text = @"signed out.";
	connectedLabel.text = @"offline --";
	usernameLabel.text = @"whoami: no one, your tweets will be saved for later :)";
	loginButton.image = [UIImage imageNamed:@"heart-white.png"];
	loginViewController.statusLabel.text = @"signed out.";
	loginViewController.loginTextField.text = @"";
	loginViewController.passwordTextField.text = @"";
	[(UILabel *)self.navigationItem.titleView setText:@""];
	[savedTweetTableViewController disableSendButton];
	[self saveToUserDefaultsCreds: nil ];
	
	if( twitterEngine != nil ) {
		[twitterEngine closeAllConnections];
		[twitterEngine release];
		twitterEngine = nil;
	}
	
	loginSuccess = NO;
	
	NSLog(@"log the fuck out" );
}

- (IBAction)signInAction {
	
	isLoginIn = YES;
	
	NSMutableArray *c = [self retrieveFromUserDefaultsCreds];
	[self setUsername: [c objectAtIndex:0] password: [c objectAtIndex:1]];
	
	[savedTweetTableViewController checkSendButtonEnabled];

	[c release];
}

-(void)sendBulkTweetAction {
	
			isBulkTweet = YES;
		
			int tweetCount = [[self retrieveFromUserDefaultsTweets] count];
			
			for (int i = 0; i < tweetCount; i++) {
				
				
				NSEnumerator *e = [[self retrieveFromUserDefaultsTweets] reverseObjectEnumerator];
				NSString *tweet;
				while (tweet = [e nextObject]) {
					
					NSArray *split = [tweet componentsSeparatedByString:@"ajp6594"];
				
					[twitterEngine sendUpdate: [split objectAtIndex: 0] ];
				}
				
				
			}
			
}

- (IBAction)tweetTextAction:(id)sender {
	
	isSendTweet = YES;
	
	loadingView = [LoadingView loadingViewInView: invisLoadingTweetView message: @"Sending your tweet...."];
	

	NSLog(@"number of connections %d",[twitterEngine numberOfConnections] );
	if( twitterEngine != nil || [twitterEngine numberOfConnections] != 0)
		[twitterEngine sendUpdate:tweetTextView.text];
	else {
		[self tweetFailed];
	}


}

-(void) switchHeartToFilled {

	loginButton.image = [UIImage imageNamed:@"heart-filled.png"];
	
}

-(void) switchHeartToEmpty {
	loginButton.image = [UIImage imageNamed:@"heart-white.png"];
}

-(void)loginSuccess {
	
	//unload the view
	//loginViewController.
	[[NSNotificationCenter defaultCenter] postNotificationName:@"StopLoading" object:self];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"SwitchToSignOutButton" object:self];

	[loginViewController dismissModalViewControllerAnimated:YES];
	[self switchHeartToFilled];
	[tweetButton setEnabled:YES];
	loginViewController.statusLabel.text = @"Successful login.";
	isLoading = NO;
	pickerView.hidden = NO;
	greenViewBar.hidden = NO;
	usernameLabel.hidden = NO;
	atButton.hidden = NO;
	invisLoadingView.hidden =YES;
	
	[loadingView removeView];
	tweetTextView.editable = YES;
	[tweetTextView becomeFirstResponder];

	NSString *username = [[self retrieveFromUserDefaultsCreds] objectAtIndex:0];
	connectedLabel.text = @"online --";
	statusLabel.text =  @"You are success.";
	
	 NSLog(@"%d",username);
	
	[(UILabel *)self.navigationItem.titleView setText:username];
	usernameLabel.text  = [@"whoami: " stringByAppendingString:username];
	isLoginIn = NO;
	loginSuccess = YES;
	
	AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
	
	[twitterEngine getFollowedTimelineFor:username since:nil startingAtPage:0];
	
	[username release];
	
   
	
	
}

- (IBAction)loginPaneShow:(id)sender {
	[[self navigationController] presentModalViewController:loginViewController	animated:YES];
}

-(void)loginFailed {
	

	[[NSNotificationCenter defaultCenter] postNotificationName:@"StopLoading" object:self];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"SwitchToSignInButton" object:self];
	loginViewController.statusLabel.text = @"Login failed.";
	
	[self switchHeartToEmpty];
	
	statusLabel.text = @"login was incorrect.";
	//[self resetLoginButton];
	connectedLabel.text = @"offline --";
	usernameLabel.text = @"whoami: no one, your tweets will be saved for later :)";
	loginSuccess = NO;
	isLoginIn = NO;
	
	[loadingView removeView];
	tweetTextView.editable = YES;
	[tweetTextView becomeFirstResponder];
	isLoading = NO;
	pickerView.hidden = NO;
	greenViewBar.hidden = NO;
	usernameLabel.hidden = NO;
	atButton.hidden = NO;
	invisLoadingView.hidden =YES;
}

-(void)tweetSuccess {
	statusLabel.text = @"success. Do another.";
	isSendTweet = NO;

	[self clearTextView];
	[twitterEngine getFollowedTimelineFor:[[self retrieveFromUserDefaultsCreds] objectAtIndex: 0] since:nil startingAtPage:0];
	[loadingView removeView];
}

-(void)tweetFailed {
	
	if ( [allTrim( tweetTextView.text  ) length] != 0 || [tweetTextView hasText] == YES) {
		NSDateFormatter *df = [[NSDateFormatter alloc] init];
		
		//df.dateStyle = NSDateFormatterLongStyle;
		[df setDateFormat:@"MMMM dd, yyyy HH:mm"];
		
		NSDate *nsdata = [[NSDate alloc] init];
		
		NSString *dateString = [df stringFromDate:nsdata];
		
		NSLog(@" date %@",dateString);
		
		NSLog(@" the tweeet! %@",tweetTextView.text);
		
		NSMutableArray *someTweets = [self retrieveFromUserDefaultsTweets];
		[someTweets addObject: [tweetTextView.text stringByAppendingString:[@"ajp6594" stringByAppendingString:dateString]]];
		[self saveToUserDefaults:someTweets];
		
		
		[someTweets release];
		
		[self updateTweetBoxButton];
		
		tweetTextView.text = @"";
		
		[self updateTweetBoxButton];
		statusLabel.text = @"tweeted saved";
		isSendTweet = NO;
		[loadingView removeView];
		[self clearTextView];
	}

	
}

#pragma mark MGTwitterEngineDelegate methods

- (void)requestSucceeded:(NSString *)requestIdentifier {
    NSLog(@"Request succeeded (%@)", requestIdentifier);
	
	if (isLoginIn == YES ) {
		[[NSNotificationCenter defaultCenter] postNotificationName:@"LoginSuccess" object:self];
	} else if(isSendTweet == YES){
		[[NSNotificationCenter defaultCenter] postNotificationName:@"TweetSuccess" object:self];
	} else if( isBulkTweet == YES ) {
		NSMutableArray *ta = [self retrieveFromUserDefaultsTweets];
		if( [ta count] > 0 ) {
			[ta removeLastObject];
			[self saveToUserDefaults:ta];
			[self updateTweetBoxButton];
			[self reloadTableView];
			if ([ta count] == 0 ) {
				isBulkTweet = NO;
				[[NSNotificationCenter defaultCenter] postNotificationName:@"StopIndicator" object:self];
				[twitterEngine getFollowedTimelineFor:[[self retrieveFromUserDefaultsCreds] objectAtIndex: 0] since:nil startingAtPage:0];
				
			}
			
			
		}
		[ta release];
		statusLabel.text = @"tweet success.";
	} else if(checkingConnection == YES){
		
		
		BOOL myBool = !([connectedLabel.text rangeOfString:@"online"].location == NSNotFound);
		
		if( !myBool ) {
			connectedLabel.text = @"online --";
			statusLabel.text = @"yay reconnected.";
			usernameLabel.text  = [@"whoami: " stringByAppendingString:[[self retrieveFromUserDefaultsCreds] objectAtIndex:0]];
		}
			
		checkingConnection = NO;
	}
	[self switchHeartToFilled];
	
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"CheckBulkTweetButton" object:self];
}

-(void)reloadTableView {
	[[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadTable" object:self];
	
}

- (void)clearTextView {
	tweetTextView.text = @"";
}
- (void)requestFailed:(NSString *)requestIdentifier withError:(NSError *)error {
    NSLog(@"Twitter request failed! (Error code: %d) (%@) Error: %@ (%@)", 
		  [error code],
          requestIdentifier, 
          [error localizedDescription], 
          [[error userInfo] objectForKey:NSErrorFailingURLStringKey]);
	
	if( [error code] == 401 ) {
		if( isLoginIn == YES ) {
			[[NSNotificationCenter defaultCenter] postNotificationName:@"LoginFailed" object:self];
			[[NSNotificationCenter defaultCenter] postNotificationName:@"DisableBulkTweetButton" object:self];
		} else if( isSendTweet == YES ) {
			[[NSNotificationCenter defaultCenter] postNotificationName:@"TweetFailed" object:self];
		} else if( isBulkTweet == YES ) {
			statusLabel.text = @"bulk tweet failed.";
			isBulkTweet = NO;
			[[NSNotificationCenter defaultCenter] postNotificationName:@"StopIndicator" object:self];
			[[NSNotificationCenter defaultCenter] postNotificationName:@"DisableBulkTweetButton" object:self];
		}
	} else if([error code] == -1009) {
		if( isLoginIn == YES ) {
			[[NSNotificationCenter defaultCenter] postNotificationName:@"LoginFailed" object:self];
		} if(isSendTweet == YES ) {
			[[NSNotificationCenter defaultCenter] postNotificationName:@"TweetFailed" object:self];
		} else if (isBulkTweet == YES) {
			[savedTweetTableViewController disableSendButton];
			statusLabel.text = @"bulk tweet failed. Check login.";
			[[NSNotificationCenter defaultCenter] postNotificationName:@"StopIndicator" object:self];
			[[NSNotificationCenter defaultCenter] postNotificationName:@"DisableBulkTweetButton" object:self];
			isBulkTweet = NO;
		} else {
			connectedLabel.text = @"offline --";
			statusLabel.text = @"oops network is flaky.";
			[[NSNotificationCenter defaultCenter] postNotificationName:@"DisableBulkTweetButton" object:self];
		}
	} else if([error code] == 502 ) {
		
		if( isBulkTweet == YES ){
			[savedTweetTableViewController disableSendButton];
			statusLabel.text = @"bulk tweet failed. Check login.";
			[[NSNotificationCenter defaultCenter] postNotificationName:@"StopIndicator" object:self];
			[[NSNotificationCenter defaultCenter] postNotificationName:@"DisableBulkTweetButton" object:self];
			isBulkTweet = NO;
		}
	} else if([error code] == -1001 ) {
		
		statusLabel.text = @"we timed out.";
		[loadingView removeView];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"DisableBulkTweetButton" object:self];
	} else if ([error code ] == -1004 || [error code ] == -1200 ) {
		connectedLabel.text = @"offline --";
		statusLabel.text = @"oops network is flaky.";
		if( loadingView != nil) 
			[loadingView removeView];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"DisableBulkTweetButton" object:self];
	}
	
	
	[self switchHeartToEmpty];
}


- (void)statusesReceived:(NSArray *)statuses forRequest:(NSString *)identifier {
    NSLog(@"Got statuses:\r%@", statuses);
	//newStatuses = statuses;
	//[statuses retain];
	
	//newStatuses = malloc(sizeof(NSDictionary *) * [statuses count]);
	//memcpy(newStatuses, statuses, sizeof(NSDictionary *) * [statuses count]);
	
	newStatuses = [[NSMutableArray alloc] initWithArray:statuses copyItems:YES];
	//[tableData retain];
	[pickerView reloadAllComponents];
	/*
	int arrayCount = [statuses count];
	NSAutoreleasePool *pool =  [[NSAutoreleasePool alloc] init];
	for (int i = 0; i < arrayCount; i++) {
		
		NSDictionary *user = [[statuses objectAtIndex:i] objectForKey:@"user"];
		
		//[[customerArray objectAtIndex:i] doSomething]];
	}
	[pool release];
	*/
	
	
	
		
	
}


- (void)directMessagesReceived:(NSArray *)messages forRequest:(NSString *)identifier {
    NSLog(@"Got direct messages:\r%@", messages);
}


- (void)userInfoReceived:(NSArray *)userInfo forRequest:(NSString *)identifier {
    NSLog(@"Got user info:\r%@", userInfo);
}


- (void)miscInfoReceived:(NSArray *)miscInfo forRequest:(NSString *)identifier {
	NSLog(@"Got misc info:\r%@", miscInfo);
}

- (void)imageReceived:(UIImage *)image forRequest:(NSString *)identifier {
    NSLog(@"Got an image: %@", image);
        // Save image to the Desktop.
    NSString *path = [[NSString stringWithFormat:@"~/Desktop/%@.tiff", identifier] 
                      stringByExpandingTildeInPath];
    //[[image TIFFRepresentation] writeToFile:path atomically:NO];
}

-(void)saveToUserDefaultsCreds:(NSMutableArray*)creds {
	NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
	
	if (standardUserDefaults) {
		[standardUserDefaults setObject:creds forKey:@"credentials"];
		[standardUserDefaults synchronize];
	}
}

-(NSMutableArray*)retrieveFromUserDefaultsCreds
{
	NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
	NSMutableArray *val = nil;
	
	if (standardUserDefaults) 
		val = [[standardUserDefaults objectForKey:@"credentials"] mutableCopy ];
	
	return val;
}

-(void)saveToUserDefaults:(NSMutableArray*)ATweet {
	NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
	
	if (standardUserDefaults) {
		[standardUserDefaults setObject:ATweet forKey:@"tweets"];
		[standardUserDefaults synchronize];
	}
}

-(NSMutableArray*)retrieveFromUserDefaultsTweets
{
	NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
	NSMutableArray *val = nil;
	
	if (standardUserDefaults) 
		val = [[standardUserDefaults objectForKey:@"tweets"] mutableCopy ];
	
	return val;
}

- (void)dealloc {
	
	[loginButton release];
	[pickerDataDick release];
	[tweetButton release];
	[logoutButton release];
	[credentials release];
	[numOfChars release];
	[tweetTextView release];
	[twitterEngine release];
	[deleteTweet release];
	[pickerView release];
    [super dealloc];
}

@end

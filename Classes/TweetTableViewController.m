//
//  TweetTableViewController.m
//  QikTwit
//
//  Created by Anthony John Perritano on 10/24/09.
//

#import "TweetTableViewController.h"
#import "TweeterViewController.h"
#import "LoadingView.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import "Reachability.h"

#include <arpa/inet.h>


@implementation TweetTableViewController

@synthesize infoButton;
@synthesize aboutViewController;
@synthesize tableToolbar;
@synthesize tablView;

- (void)awakeFromNib {
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTable) name:@"ReloadTable" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopAnimating) name:@"StopIndicator" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(disableSendButton) name:@"DisableBulkTweetButton" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkSendButtonEnabled) name:@"CheckBulkTweetButton" object:nil];
	[super initWithNibName:@"TweetTableViewController" bundle:nil];	
}

- (IBAction)bulkTweet:(id)sender {	
	if( [[self retrieveFromUserDefaultsTweets] count ] > 0 ) {
			sendSavedTweetsButton.enabled = NO;
			loadingView =
			[LoadingView loadingViewInView:[self.view.window.subviews objectAtIndex:0] message: @"Sending all your Tweets :)"];
			
			[[NSNotificationCenter defaultCenter] postNotificationName:@"BulkTweet" object:self];		
	}
	
}

- (IBAction)infoPaneShow:(id)sender {
	[[self navigationController] presentModalViewController:aboutViewController	animated:YES];
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.titleView = [[[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 100.0f, 36.0f)] autorelease];
	
	
	[(UILabel *)self.navigationItem.titleView setBackgroundColor:[UIColor clearColor]];
	[(UILabel *)self.navigationItem.titleView setTextColor:[UIColor whiteColor]];
	[(UILabel *)self.navigationItem.titleView setTextAlignment:UITextAlignmentCenter];
	[(UILabel *)self.navigationItem.titleView setFont:[UIFont boldSystemFontOfSize:[UIFont systemFontSize]]];
	
	
	tablView.separatorColor = [UIColor blackColor];
	
	sendSavedTweetsButton = [[UIBarButtonItem alloc] initWithTitle: @"Bulk Tweet" style: UIBarButtonItemStylePlain target: self action: @selector(bulkTweet:) ];
	
	
    self.navigationItem.rightBarButtonItem = sendSavedTweetsButton;
	
	[self checkSendButtonEnabled];
	
	[self updateTitleView];
	[sendSavedTweetsButton release];
	
}

-(void)checkSendButtonEnabled {
	int count = [[self retrieveFromUserDefaultsTweets] count];
	
	if( count == 0 ) {
		[self disableSendButton];
	} else {
		[self enableSendButton];
	}
	
}

-(void) disableSendButton {
	sendSavedTweetsButton.enabled = NO;
}

-(void) enableSendButton {
	sendSavedTweetsButton.enabled = YES;
}

-(void)updateTitleView {
	NSString *titleString;
	NSMutableArray *ts = [self retrieveFromUserDefaultsTweets];
	if( [ts count] == 0 ) {
		titleString = [[NSString alloc] initWithString: @"TweetBox"];
	} else {
		titleString = [[NSString alloc] initWithFormat: @"TweetBox(%d)", [ts count]];
	}

	[(UILabel *)self.navigationItem.titleView setText:titleString];
	[titleString release];
	[ts release];
}

-(void)stopAnimating {
	
	if( !loadingView == nil )
		[loadingView removeView];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

	
	[self.tablView reloadData];
	[self updateTitleView];
	[self checkSendButtonEnabled];
	[self.navigationItem.backBarButtonItem setTitle:@" "];
	
	UIButton *info = [UIButton buttonWithType:UIButtonTypeInfoLight];

	
	[info addTarget:self action:@selector(infoPaneShow:) forControlEvents:UIControlEventTouchUpInside];
	infoButton = [[UIBarButtonItem alloc] initWithCustomView:info];
	
	
	
	UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil]; 

	[tableToolbar setItems:[NSArray arrayWithObjects:fixedSpace,infoButton,nil]];
	
	[info release];
	[fixedSpace release];
	
}

-(void)reloadTable {
	[self.tablView reloadData];
	[self checkSendButtonEnabled];
	[self updateTitleView];
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	//TweeterViewController *tc =  [[[self navigationController] viewControllers ] objectAtIndex: 0 ];
	//[tc makeVerticalLayout];
	//[tc release];
    return NO;
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

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	int count = [[self retrieveFromUserDefaultsTweets] count];

	if( count == 0 ) {
		return 0;
	} else {
		return count;
	}
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   	static NSString *CellIdentifier = @"customCell";
	customCell = (CustomCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (customCell == nil) {
		[[NSBundle mainBundle] loadNibNamed:@"CustomCell" owner:self options:nil];
	}
	
	NSMutableArray *numbers = [self retrieveFromUserDefaultsTweets];
	NSArray *split = [[numbers objectAtIndex:[indexPath row]] componentsSeparatedByString:@"ajp6594"];
	
	NSLog(@"1 %@ ", [split objectAtIndex: 0] );
	NSLog(@"2 %@ ", [split objectAtIndex: 1] );
	//NSLog(@"1 %@ 2 %@", [NSString stringWithFormat:@"%@", split[0]], [NSString stringWithFormat:@"%@", split[1]]);	
	[[customCell indexLabel] setText: [NSString stringWithFormat:@"%d", [ indexPath row]+1] ];
	[[customCell tweetLabel] setText: [split objectAtIndex: 0]];
	[[customCell timestampLabel] setText:[split objectAtIndex: 1] ];

	[numbers release];
	return customCell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
	
	
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
		NSLog(@"row %d",[indexPath row]);
		NSMutableArray *numbers = [self retrieveFromUserDefaultsTweets];
		[numbers removeObjectAtIndex:indexPath.row];
		[self saveToUserDefaults:numbers];
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
		[tablView endUpdates];
		[tablView setEditing:NO animated:YES];
		[numbers release];
		
		
	}   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
	
	[self updateTitleView];
	[self checkSendButtonEnabled];
	[tableView reloadData];
	[tablView reloadData];
	
}




// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
	
	int idxToMove = [fromIndexPath row];
	int idxToBe = [toIndexPath row];
	
	NSMutableArray *numbers = [self retrieveFromUserDefaultsTweets];

	NSString *itemToMove = [numbers objectAtIndex:idxToMove];
	
	[numbers removeObjectAtIndex:idxToMove];
	[numbers insertObject:itemToMove atIndex:idxToBe];
	[self saveToUserDefaults: numbers];
	
	[itemToMove release];
	[numbers release];
	[tablView reloadData];
	
}

-(void)saveToUserDefaults:(NSMutableArray*)tweets {
	NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
	if (standardUserDefaults) {
		[standardUserDefaults setObject:tweets forKey:@"tweets"];
		[standardUserDefaults synchronize];
	}
}

-(NSMutableArray*)retrieveFromUserDefaultsTweets {
	NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
	NSMutableArray *val = nil;
	
	if (standardUserDefaults) 
		val = [[standardUserDefaults objectForKey:@"tweets"] mutableCopy ];
	
	return val;
}

- (void)dealloc {
	[aboutViewController release];
	[tablView release];
	[tableToolbar release];
	[infoButton release];
	[sendSavedTweetsButton release];
    [super dealloc];
}


@end

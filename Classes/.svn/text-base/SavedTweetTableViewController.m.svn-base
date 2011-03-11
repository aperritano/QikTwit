//
//  SavedTweetTableViewController.m
//  QuikTwit
//
//  Created by Anthony John Perritano on 9/27/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SavedTweetTableViewController.h"
#import "MGTwitterEngine.h"
#import "TweeterViewController.h"

@implementation SavedTweetTableViewController
@synthesize tablView;
@synthesize sendSavedTweetsButton;
@synthesize toolbar;
@synthesize aboutViewController;

MGTwitterEngine *twitterEngine;
TweeterViewController *tc;

- (id)initWithCoder:(NSCoder *)decoder {
	self = [super initWithCoder:decoder];
	if(self != nil) {
		
		
	}
	
	return self;
}

- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
    return self;
}

- (IBAction)bulkTweet{

	NSLog(@"bulk Tweet");
	[tc setTweet: [numbers count]];
	
	for (int i = 0; i < [numbers count]; i++ ){
		
		NSString *t = [numbers objectAtIndex:i];
		if( t != nil ) {
			[twitterEngine sendUpdate: t ];
			NSLog(@"new sent sent%@",t);
			[tc setIsBulkTweet:YES];
		}
	}
	
	

}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if( buttonIndex == 0 ) {
		//do nothing
	} else if(buttonIndex == 1){
		tc =  [[[self navigationController] viewControllers ] objectAtIndex: 0 ];
		[[self navigationController] popToViewController:tc animated:YES];
		NSLog(@"navigate");
		[tc logoutAction:nil];
	}
	
	[alertView release];
	
}


- (void)loadView {
	[super loadView];
	
	// Add each inset subview
	
	aboutViewController = [[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:[NSBundle mainBundle]];
	[aboutViewController release];
	
	
	//[self.view addSubview:aboutViewController.view];

	/*
	UIView *sv = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
   // [sv setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
    [sv setBackgroundColor: [UIColor blueColor]];
    [self.navigationItem. addSubview:sv];
    [sv release];
	*/
	//[infoView release];
	
}


- (void)viewDidLoad {
    [super viewDidLoad];
	numbers = 
	self.navigationItem.titleView = [[[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 100.0f, 36.0f)] autorelease];
	
	// Prepare the Navigation Item
	[(UILabel *)self.navigationItem.titleView setText:@"Saved"];
	[(UILabel *)self.navigationItem.titleView setBackgroundColor:[UIColor clearColor]];
	[(UILabel *)self.navigationItem.titleView setTextColor:[UIColor whiteColor]];
	[(UILabel *)self.navigationItem.titleView setTextAlignment:UITextAlignmentCenter];
	[(UILabel *)self.navigationItem.titleView setFont:[UIFont boldSystemFontOfSize:[UIFont systemFontSize]]];
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
	
	
	sendSavedTweetsButton = [[[UIBarButtonItem alloc] initWithTitle: @"Bulk Tweet" style: UIBarButtonItemStylePlain target: self action: @selector(bulkTweet) ] autorelease ];
	
	
    self.navigationItem.rightBarButtonItem = sendSavedTweetsButton;
	
	
	
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	//Initialize the toolbar
	toolbar = [[UIToolbar alloc] init];
	toolbar.barStyle = UIBarStyleDefault;
	
	//Set the toolbar to fit the width of the app.
	[toolbar sizeToFit];
	
	//Caclulate the height of the toolbar
	CGFloat toolbarHeight = [toolbar frame].size.height;
	
	//Get the bounds of the parent view
	CGRect rootViewBounds = self.parentViewController.view.bounds;
	
	//Get the height of the parent view.
	CGFloat rootViewHeight = CGRectGetHeight(rootViewBounds);
	
	//Get the width of the parent view,
	CGFloat rootViewWidth = CGRectGetWidth(rootViewBounds);
	
	//Create a rectangle for the toolbar
	CGRect rectArea = CGRectMake(0, rootViewHeight - toolbarHeight, rootViewWidth, toolbarHeight);
	
	//Reposition and resize the receiver
	[toolbar setFrame:rectArea];
	
	//Create a button
	UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil]; 
	
	 UIButton *info = [UIButton buttonWithType:UIButtonTypeInfoLight];
	
	
	
	//[infoButton setTarget:self];
	//[infoButton setAction:@selector(infoPaneShow)];
	[info addTarget:self action:@selector(infoPaneShow) forControlEvents:UIControlEventTouchUpInside];

	UIBarButtonItem *infoButton = [[UIBarButtonItem alloc] initWithCustomView:info];
	
//								   

	UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc]
								   initWithTitle:@"Logout" style:UIBarButtonItemStyleBordered target:self action:@selector(logoutAction)];
	
	
	
	[toolbar setItems:[NSArray arrayWithObjects:infoButton,fixedSpace,logoutButton,nil]];
	toolbar.barStyle = UIBarStyleBlackOpaque;
	//Add the toolbar as a subview to the navigation controller.
	[self.navigationController.view addSubview:toolbar];
	
	//Reload the table view
	[self.tableView reloadData];
	
}

-(void)infoPaneShow{
	
	//aboutViewController.view.alpha = 0.0;
	[[self navigationController] presentModalViewController:aboutViewController	animated:YES];
	//[UIView beginAnimations: nil context: nil];
	//[UIView setAnimationDuration:.4];
	//aboutViewController.view.alpha = 1.0;
	
	//[UIView commitAnimations];
		
	
	
		
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	numbers = [[NSUserDefaults standardUserDefaults] objectForKey:@"tweets"];
	[self.tableView reloadData];
	
	//NSArray *vcs =];
	tc =  [[[self navigationController] viewControllers ] objectAtIndex: 0 ];
	twitterEngine = [tc twitterEngine];
}

/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)orientation {

    return NO;
}
 */

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
    return [numbers count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Set up the cell...
	
	NSLog(@"tweet %@", [numbers objectAtIndex:[indexPath row]]);
	cell.textLabel.text = [numbers objectAtIndex:[indexPath row]];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
	
		
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
		NSLog(@"row %d",[indexPath row]);
		[numbers removeObjectAtIndex:indexPath.row];
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
		[tablView endUpdates];
		[tablView setEditing:NO animated:YES];

		
	}   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
	

}




// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {

	int idxToMove = [fromIndexPath row];
	int idxToBe = [toIndexPath row];
	
	NSString *itemToMove = [numbers objectAtIndex:idxToMove];
	
	[numbers removeObjectAtIndex:idxToMove];
	[numbers insertObject:itemToMove atIndex:idxToBe];
	[itemToMove release];

}

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


- (void)dealloc {
	[tablView release];
	[twitterEngine release];
	[numbers release];
	[toolbar release];
	[aboutViewController release];
    [super dealloc];
	
}


@end


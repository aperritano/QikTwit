//
//  AboutViewController.m
//  QikTwit
//
//  Created by Anthony John Perritano on 10/14/09.
//

#import "AboutViewController.h"

@implementation AboutViewController

- (void)awakeFromNib {
	
}
- (IBAction)doneAction:(id)sender {
	[self dismissModalViewControllerAnimated:YES];
}

- (IBAction) pushWebPage {
	NSURL *target = [[NSURL alloc] initWithString:@"https://sites.google.com/site/qiktwit/"];
	[[UIApplication sharedApplication] openURL:target];
	[target release];
}

-(IBAction)pushEmail {
	MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
	mail.mailComposeDelegate = self;
	if ([MFMailComposeViewController canSendMail]) {
		//Setting up the Subject, recipients, and message body.
		[mail setToRecipients:[NSArray arrayWithObjects:@"iphonetwitbot@gmail.com",nil]];
		[mail setSubject:@"QikTwit Comments"];
		//[mail setMessageBody:@"Meditations on QikTwit" isHTML:NO];
		//Present the mail view controller
		[self presentModalViewController:mail animated:YES];
		
		//UIImage *picture = [UIImage imageNamed:@"Funny.png"];
		//	NSData *data = UIImageJPEGRepresentation(pic ,1.0);
		//[mail addAttachmentData:data mimeType:@"image/jpeg" fileName:@"Picture.jpeg"];
	}
	//release the mail
	[mail release];
}

//This is one of the delegate methods that handles success or failure
//and dismisses the mail
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
	[self dismissModalViewControllerAnimated:YES];
	if (result == MFMailComposeResultFailed) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message Failed!" message:@"Your email has failed to send" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
}



/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
		[webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.apple.com"]]];

    }
    return self;
}
 */



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)orientation {
    // Return YES for supported orientations
	if ((orientation == UIInterfaceOrientationLandscapeLeft) || (orientation == UIInterfaceOrientationLandscapeRight)) {
		//apprect.size = CGSizeMake(480.0f, 300.0f);
		
			
	//	toolbar.bounds = CGRectMake(0.0f, 100.0f, 480.0f, 44.0f);
	//	webView.bounds = CGRectMake(0.0f, 45.0f, 480.0f, 100.0f);
	} else {
		
	//	toolbar.frame = CGRectMake(0.0f, 0.0f, 320.0f, 44.0f);
	//	webView.frame = CGRectMake(0.0f, 45.0f, 480.0f, 100.0f);
		//apprect.size = CGSizeMake(320.0f, 460.0f);
		//greenViewBar.frame = CGRectMake(0.0f, 0.0f, 300.0f, 18.0);
	}
    return YES;
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


- (void)dealloc {
    [super dealloc];
}


@end

//
//  LoginViewController.m
//  QikTwit
//
//  Created by Anthony John Perritano on 1/16/10.
//  Copyright 2010 anthony perritano. All rights reserved.
//

#import "LoginViewController.h"
#import "TweeterViewController.h"



@implementation LoginViewController

@synthesize signoutButton;
@synthesize invisloadingView;
@synthesize statusLabel;
@synthesize loginTextField;
@synthesize passwordTextField;


- (id) init {
	NSLog(@"inint LoginViewController");
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchToSignInButton) name:@"SwitchToSignInButton" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchToSignOutButton) name:@"SwitchToSignOutButton" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doneAction:) name:@"CloseLoginView" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopAnimating) name:@"StopLoading" object:nil];

}
- (void)awakeFromNib {
	NSLog(@"awake from nib loginViewController");	
	[self init];
}

- (id)initWithNibName:(NSString *)n bundle:(NSBundle *)b {
    return [self init];
}


-(void) updateFields {
	
	NSMutableArray *temp = [self retrieveFromUserDefaultsCreds];
	
	loginTextField.text = [temp objectAtIndex:0];
	passwordTextField.text = [temp objectAtIndex:1];
	
	[temp release];
	
	NSLog(@"signout %@", signoutButton.title);
	
	if( [signoutButton.title isEqualToString:@"Sign Out"] ) {
		loginTextField.enabled = NO;
		passwordTextField.enabled = NO;
		loginTextField.textColor = [UIColor grayColor];
		passwordTextField.textColor = [UIColor grayColor];
	}
	
	
}
-(void) changeStatusFailed: (id)sender {
	statusLabel.text = @"your are NOT logged in!";
}
- (IBAction)doneAction:(id)sender {
	[self dismissModalViewControllerAnimated:YES];
}

-(void)switchToSignInButton {
	signoutButton.title = @"Sign In";
}

-(void)switchToSignOutButton {
	signoutButton.title = @"Sign Out";
}


- (BOOL)textFieldShouldReturn:(UITextField *)whichTextField {        
	if (whichTextField == loginTextField)  {
		NSLog(@"Done pressed whilst in account name field, pass focus");
		[passwordTextField becomeFirstResponder];
	} else if (whichTextField == passwordTextField) {
		[self loginCheck];
	} else {
		NSLog(@"No next text field, closing keyboard");
		[whichTextField resignFirstResponder];  
	}
	
	return YES;
}

- (NSString *) stripNewLine:(NSString *)string {
	NSMutableString *mstring = [NSMutableString stringWithString:string];
	NSRange wholeShebang = NSMakeRange(0, [string length]);
	
	[mstring replaceOccurrencesOfString: @"\n"
							 withString: @""
								options: 0
								  range: wholeShebang];
	
	return [NSString stringWithString: mstring];
	
}

- (void) doLogin {
	
	NSMutableArray *temp = [[NSMutableArray alloc] init];
	
	[temp insertObject:loginTextField.text atIndex:0];
	[temp insertObject:passwordTextField.text atIndex:1];
	
	[self saveToUserDefaultsCreds: temp];
	loadingView = [LoadingView loadingViewInView: invisloadingView message: @"logging into your account...."];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"SignIn" object:self];

	signoutButton.enabled = NO;
	
	[temp release];
}

-(void)stopAnimating {
	[loadingView removeView];
	signoutButton.enabled = YES;
}

- (void) loginCheck {

	NSString *login = [ [self stripNewLine: loginTextField.text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	NSString *pass = [ [self stripNewLine: passwordTextField.text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	if( [login length] == 0 || [pass length] == 0 ) {
		statusLabel.text = @"no blanks.";
	} else {
		statusLabel.text = @"";
		[self doLogin];		
		
	}	

}

- (IBAction) presentSheet:(id)sender {
	
	
	if( [ signoutButton.title isEqualToString:@"Sign In"] ) {
		
		[self loginCheck];

	} else {
		UIActionSheet *menu = [[UIActionSheet alloc] 
							   initWithTitle: @"Sign out of Twitter?" 
							   delegate:self
							   cancelButtonTitle:@"NO"
							   destructiveButtonTitle:@"YES"
							   otherButtonTitles:nil];
		[menu showInView:self.view];
		[menu release];
	}
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	printf("User Pressed Button %d\n", buttonIndex + 1);
	
	if( buttonIndex == 0 ) {
		
		signoutButton.title = @"Sign In";
		
		
		
		loginTextField.enabled = YES;
		passwordTextField.enabled = YES;

		passwordTextField.enabled = YES;
		loginTextField.textColor = [UIColor blackColor];
		passwordTextField.textColor = [UIColor blackColor];
		statusLabel.text = @"signed out.";
		[loginTextField becomeFirstResponder];
		
		[[NSNotificationCenter defaultCenter] postNotificationName:@"SignOut" object:self];
	} else {
		//do nothing
	}
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	NSMutableArray *credentials = [self retrieveFromUserDefaultsCreds];
	
	if( ![credentials count]  == 0 ) {
		[self updateFields];
	}
	
	[self.loginTextField becomeFirstResponder];
	[credentials release];
	
	
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	NSMutableArray *credentials = [self retrieveFromUserDefaultsCreds];
	NSLog(@"vd status %@",statusLabel.text);
	
	if( [credentials count]  == 0 ) {
		signoutButton.title = @"Sign In";
	} else {
		[self updateFields];
		signoutButton.title = @"Sign Out";
	}
	
	[credentials release];
	
	
	
	[self.loginTextField becomeFirstResponder];

}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
}


- (void)dealloc {
	[loginTextField release];
	[passwordTextField release];
	[signoutButton release];
	[statusLabel release];
    [super dealloc];
}


@end

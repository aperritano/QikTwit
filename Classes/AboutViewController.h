//
//  AboutViewController.h
//  QikTwit
//
//  Created by Anthony John Perritano on 10/14/09.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface AboutViewController : UIViewController <MFMailComposeViewControllerDelegate> {

	IBOutlet UIBarButtonItem *signoutButton;
	
}

- (IBAction) pushEmail; 
- (IBAction) pushWebPage;

@end

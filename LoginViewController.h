//
//  LoginViewController.h
//  QikTwit
//
//  Created by Anthony John Perritano on 1/16/10.
//  Copyright 2010 anthony perritano. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingView.h"

@interface LoginViewController : UIViewController <UIActionSheetDelegate,UITextFieldDelegate> {
	
	IBOutlet UIBarButtonItem *signoutButton;
	IBOutlet UIView *invisloadingView;
	IBOutlet UILabel *statusLabel;
	IBOutlet UITextField *loginTextField;
	IBOutlet UITextField *passwordTextField;
	LoadingView *loadingView;
}

@property (nonatomic, retain) IBOutlet UIBarButtonItem *signoutButton;
@property (nonatomic, retain) IBOutlet UIView *invisloadingView;
@property (nonatomic, retain) IBOutlet UILabel *statusLabel;
@property (nonatomic, retain) IBOutlet UITextField *loginTextField;
@property (nonatomic, retain) IBOutlet UITextField *passwordTextField;

- (IBAction) doneAction:(id)sender;
- (IBAction) presentSheet:(id)sender;




@end

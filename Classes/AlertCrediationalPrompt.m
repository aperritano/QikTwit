//
//  AlertCrediationalPrompt.m
//
//  Created by Anthony Perritano on 16/01/2010.
//

#import "AlertCrediationalPrompt.h"


@implementation AlertCrediationalPrompt
@synthesize textField1;
@synthesize textField2;
@synthesize enteredText1;
@synthesize enteredText2;

- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle okButtonTitle:(NSString *)okayButtonTitle
{

	if (self = [super initWithTitle:title message:@"\n\n\n" delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:okayButtonTitle, nil])
	{
				
		UITextField *alertTextField1 = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 50.0, 260.0, 25.0)]; 
		alertTextField1.delegate = self;
		alertTextField1.borderStyle = UITextBorderStyleRoundedRect;
		alertTextField1.keyboardType = UIKeyboardTypeAlphabet;
		alertTextField1.keyboardAppearance =  UIKeyboardAppearanceAlert;
		alertTextField1.autocapitalizationType = UITextAutocapitalizationTypeNone;
		alertTextField1.autocorrectionType = UITextAutocorrectionTypeNo;
		
		[alertTextField1 setPlaceholder:@"Username"];

		[self addSubview:alertTextField1];
				[textField1 becomeFirstResponder];
		self.textField1 = alertTextField1;
				[textField1 becomeFirstResponder];
		[alertTextField1 release];
		
		UITextField *alertTextField2 = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 85.0, 260.0, 25.0)]; 

		alertTextField2.delegate = self;
		alertTextField2.borderStyle = UITextBorderStyleRoundedRect;
		alertTextField2.borderStyle = UITextBorderStyleRoundedRect;
		alertTextField2.keyboardType = UIKeyboardTypeAlphabet;
		alertTextField2.keyboardAppearance =  UIKeyboardAppearanceAlert;
		alertTextField2.autocapitalizationType = UITextAutocapitalizationTypeNone;
		alertTextField2.autocorrectionType = UITextAutocorrectionTypeNo;
		[alertTextField2 setPlaceholder:@"Password"];

		[self addSubview:alertTextField2];
		self.textField2 = alertTextField2;
		[alertTextField2 release];
		
		
		
		CGAffineTransform translate = CGAffineTransformMakeTranslation(0.0, 110.0); 
		[self setTransform:translate];
	}
	return self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)whichTextField {        
	if (whichTextField == textField1)  {
		NSLog(@"Done pressed whilst in account name field, pass focus");
		[textField2 becomeFirstResponder];
	} else if (whichTextField == textField2) {
		[self dismissWithClickedButtonIndex:1 animated:YES];
	} else {
		NSLog(@"No next text field, closing keyboard");
		[whichTextField resignFirstResponder];  
	}
	
	return YES;
}

- (void)show
{
	//[textField1 becomeFirstResponder];
	[textField2 resignFirstResponder];
	[textField1 becomeFirstResponder];
	[super show];
}
- (NSString *)enteredText1
{
	return textField1.text;
}
- (NSString *)enteredText2
{
	return textField2.text;
}
- (void)dealloc
{
	[textField1 release];
	[textField2 release];
	[super dealloc];
}
@end

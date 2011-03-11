//
//  AlertCrediationalPrompt.h
//  
//
//  Created by Anthony Perritano 16/1/2010
//

#import <Foundation/Foundation.h>


@interface AlertCrediationalPrompt : UIAlertView <UITextFieldDelegate> {
	UITextField	*textField1;
	UITextField	*textField2;
	NSString *enteredText1;
	NSString *enteredText2;
}
@property (nonatomic, retain) UITextField *textField1;
@property (nonatomic, retain) UITextField *textField2;

@property (readonly) NSString *enteredText1;
@property (readonly) NSString *enteredText2;

- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle okButtonTitle:(NSString *)okButtonTitle;
@end

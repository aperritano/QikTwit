//
//  UICustomSwitch.h
//  QikTwit
//
//  Created by Anthony John Perritano on 10/8/09.
//

#import <UIKit/UIKit.h>
#include "time.h"

@interface UISwitch (extended)
- (void) setAlternateColors:(BOOL) boolean;
@end

@interface _UISwitchSlider : UIView
@end

@interface UICustomSwitch : UISwitch
- (void) setLeftLabelText: (NSString *) labelText;
- (void) setRightLabelText: (NSString *) labelText;
@end

//
//  UICustomSwitch.m
//  QikTwit
//
//  Created by Anthony John Perritano on 10/8/09.
//

#import "UICustomSwitch.h"


@implementation UICustomSwitch


- (_UISwitchSlider *) slider { 
	return [[self subviews] lastObject]; 
}
- (UIView *) textHolder { 
	return [[[self slider] subviews] objectAtIndex:2]; 
}
- (UILabel *) leftLabel { 
	return [[[self textHolder] subviews] objectAtIndex:0]; 
}
- (UILabel *) rightLabel { 
	return [[[self textHolder] subviews] objectAtIndex:1]; 
}
- (void) setLeftLabelText: (NSString *) labelText { 
	[[self leftLabel] setText:labelText]; 
}
- (void) setRightLabelText: (NSString *) labelText { 
	[[self rightLabel] setText:labelText]; 
}


@end

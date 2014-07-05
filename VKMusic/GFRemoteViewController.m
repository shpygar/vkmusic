

#import "GFRemoteViewController.h"

@interface GFRemoteViewController (Private)

@end

@implementation GFRemoteViewController

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];

    UIApplication *app = [UIApplication sharedApplication];
	if ([app respondsToSelector:@selector(beginReceivingRemoteControlEvents)]) {
		[app beginReceivingRemoteControlEvents];
	}
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	
	[self resignFirstResponder];
}

- (BOOL) canBecomeFirstResponder {
    return YES;
}

- (void)dealloc {
	[[UIApplication sharedApplication] endReceivingRemoteControlEvents];
}

@end

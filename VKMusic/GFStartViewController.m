//
//  GFViewController.m
//  VKMusic
//
//  Created by Sergey Shpygar on 20.06.14.
//  Copyright (c) 2014 Sergey Shpygar. All rights reserved.
//

#import "GFStartViewController.h"
#import "GFAudiosViewController.h"
#import "VKSdk.h"

static NSString *const APP_ID = @"4423585";
static NSString *const TOKEN_KEY = @"ZzQn3IIiASAkOos3ckSi";
static NSArray  * SCOPE = nil;

@interface GFStartViewController () <VKSdkDelegate>

-(IBAction)authorize:(id)sender;

@end

@implementation GFStartViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
//    SCOPE = @[VK_PER_FRIENDS, VK_PER_WALL, VK_PER_AUDIO, VK_PER_PHOTOS, VK_PER_NOHTTPS];
    SCOPE = @[VK_PER_AUDIO];
	[super viewDidLoad];
    
	[VKSdk initializeWithDelegate:self andAppId:APP_ID];
    if ([VKSdk wakeUpSession])
    {
        [self startWorkingWithAnimated:NO];
    }
}

-(IBAction)authorize:(id)sender{
//	[VKSdk authorize:SCOPE revokeAccess:YES];
//	[VKSdk authorize:SCOPE revokeAccess:YES forceOAuth:YES];
	[VKSdk authorize:SCOPE revokeAccess:YES forceOAuth:YES inApp:YES display:VK_DISPLAY_IOS];
}

- (void)startWorkingWithAnimated:(BOOL)animated {
    GFAudiosViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"GFAudiosViewController"];
    [self.navigationController pushViewController:controller animated:animated];
}

- (void)vkSdkNeedCaptchaEnter:(VKError *)captchaError {
	VKCaptchaViewController *vc = [VKCaptchaViewController captchaControllerWithError:captchaError];
	[vc presentIn:self];
}

- (void)vkSdkTokenHasExpired:(VKAccessToken *)expiredToken {
	[self authorize:nil];
}

- (void)vkSdkReceivedNewToken:(VKAccessToken *)newToken {
    [self startWorkingWithAnimated:YES];
}

- (void)vkSdkShouldPresentViewController:(UIViewController *)controller {
	[self presentViewController:controller animated:YES completion:nil];
}

- (void)vkSdkAcceptedUserToken:(VKAccessToken *)token {
    [self startWorkingWithAnimated:YES];
}

- (void)vkSdkUserDeniedAccess:(VKError *)authorizationError {
	[[[UIAlertView alloc] initWithTitle:nil
                                message:@"Доступ запрещён"
                               delegate:nil
                      cancelButtonTitle:@"Закрыть"
                      otherButtonTitles:nil]
     show];
}


@end

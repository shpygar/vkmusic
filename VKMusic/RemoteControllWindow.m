//
//  RemoteControllWindow.m
//  frod

#import "RemoteControllWindow.h"
#import "GFAudioPlayer.h"

@interface RemoteControllWindow ()

@end

@implementation RemoteControllWindow


#pragma mark Remote Control
- (void) remoteControlReceivedWithEvent: (UIEvent *) receivedEvent {
	
    if (receivedEvent.type == UIEventTypeRemoteControl) {
        GFAudioPlayer* player = [GFAudioPlayer sharedManager];
        switch (receivedEvent.subtype) {
				
            case UIEventSubtypeRemoteControlPlay:
            case UIEventSubtypeRemoteControlPause:
            case UIEventSubtypeRemoteControlTogglePlayPause:{
                if (player.isPlaying) {
					[player pause];
				}
				else {
					[player play];
				}
				break;
			}
			case UIEventSubtypeRemoteControlNextTrack:
                [player next];
              	break;
			case UIEventSubtypeRemoteControlPreviousTrack:
                [player previous];
              	break;
				
            default:
                break;
        }
    }
}


@end

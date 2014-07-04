//
//  GFPlayerViewController.h
//  VKMusic
//
//  Created by Sergey Shpygar on 21.06.14.
//  Copyright (c) 2014 Sergey Shpygar. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GFAudio;

@interface GFPlayerViewController : UIViewController

-(void)configureWithAudio:(GFAudio *)audio;

@end

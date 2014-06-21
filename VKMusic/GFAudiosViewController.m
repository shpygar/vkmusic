//
//  GFAudiosViewController.m
//  VKMusic
//
//  Created by Sergey Shpygar on 21.06.14.
//  Copyright (c) 2014 Sergey Shpygar. All rights reserved.
//

#import "GFAudiosViewController.h"
#import "VKSdk.h"

@interface GFAudiosViewController ()

@property (nonatomic, strong) NSArray *items;

@end

@implementation GFAudiosViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.hidesBackButton = YES;
    
    self.items = @[];
    [self update];
}

-(void)update{
    VKRequest * audioReq = [VKApi requestWithMethod:@"audio.get"
                                      andParameters:@{VK_API_OWNER_ID : @"2446593"} andHttpMethod:@"GET"];
	[audioReq executeWithResultBlock: ^(VKResponse *response) {
	    VKAudios *audios = [[VKAudios alloc] initWithDictionary:response.json objectClass:[VKAudio class]];
        self.items = audios.items;
        [self.tableView reloadData];
	}
                          errorBlock: ^(NSError *error) {
	    ;
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.items count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GFAudioViewCell" forIndexPath:indexPath];
    // Configure the cell...
    VKAudio *audio = self.items[indexPath.row];
    cell.textLabel.text = audio.title;
    cell.detailTextLabel.text = audio.artist;

    return cell;
}

@end

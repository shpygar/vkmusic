//
//  GFAudiosViewController.m
//  VKMusic
//
//  Created by Sergey Shpygar on 21.06.14.
//  Copyright (c) 2014 Sergey Shpygar. All rights reserved.
//

#import "GFAudiosViewController.h"
#import "VKSdk.h"
#import "GFPlayerViewController.h"

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
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.items = @[];
    [self update];
}

-(void)update{
    NSString *userId = [VKSdk getAccessToken].userId;
    VKRequest * audioReq = [VKApi requestWithMethod:@"audio.get"
                                      andParameters:@{VK_API_OWNER_ID : userId} andHttpMethod:@"GET"];
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    GFPlayerViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"GFPlayerViewController"];
    controller.audio = self.items[indexPath.row];
    [self.navigationController pushViewController:controller animated:YES];

}

@end

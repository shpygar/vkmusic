//
//  GFAudiosViewController.m
//  VKMusic
//
//  Created by Sergey Shpygar on 21.06.14.
//  Copyright (c) 2014 Sergey Shpygar. All rights reserved.
//

#import "GFAudiosViewController.h"
#import "GFHTTPClient.h"
#import "GFPlayerViewController.h"
#import "GFAudioPlayer.h"

@interface GFAudiosViewController () <UISearchDisplayDelegate>

@property (nonatomic, strong) NSOrderedSet *items;

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
    self.items = [NSOrderedSet orderedSet];
    [self updateData:nil];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(updateData:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
}

-(void)updateData:(UIRefreshControl*)sender{
    [[GFHTTPClient sharedClient] getAudiosWithCompletion:^(GFPlaylist *playlist, BOOL success, NSError *error) {
        [sender endRefreshing];
        self.items = playlist.audios;
        [self.tableView reloadData];
	}];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    UIBarButtonItem *playerItem = nil;
    if ([[GFAudioPlayer sharedManager] currentItem]) {
        playerItem = [[UIBarButtonItem alloc] initWithTitle:@"Плеер" style:UIBarButtonItemStylePlain target:self action:@selector(showPlayer)];
    }
    self.navigationItem.rightBarButtonItem = playerItem;
}

-(void)showPlayer{
    [self showPlayerWithAudio:nil];
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
    GFAudio *audio = self.items[indexPath.row];
    cell.textLabel.text = audio.title;
    cell.detailTextLabel.text = audio.artist;

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    [self showPlayerWithAudio:self.items[indexPath.row]];
}

-(void)showPlayerWithAudio:(GFAudio *)audio{
    GFPlayerViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"GFPlayerViewController"];
    [controller configureWithAudio:audio];
    [self.navigationController pushViewController:controller animated:YES];
}

@end

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

@interface GFAudiosViewController () <UISearchDisplayDelegate, NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

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
//    [self updateData:nil];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(updateData:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
}

-(void)updateData:(UIRefreshControl*)sender{
    [[GFHTTPClient sharedClient] getAudiosOfPlaylist:kDefaultPlaylistID completion:^(GFPlaylist *playlist, BOOL success, NSError *error) {
        [sender endRefreshing];
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

- (NSFetchedResultsController *)fetchedResultsController
{
    if (! _fetchedResultsController) {
        NSFetchRequest *fetchRequest = [[GFModelManager sharedManager] fetchRequestWithPlaylistID:kDefaultPlaylistID sortKey:[NSSortDescriptor sortDescriptorWithKey:@"audioID" ascending:NO]];
        _fetchedResultsController = [[NSFetchedResultsController alloc]
                                     initWithFetchRequest:fetchRequest
                                     managedObjectContext:[GFModelManager sharedManager].managedObjectContext
                                     sectionNameKeyPath:nil cacheName:nil];
        _fetchedResultsController.delegate = self;
        [_fetchedResultsController performFetch:NULL];
    }
    return _fetchedResultsController;
}

#pragma mark - NSFetchedResultsControllerDelegate

-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.fetchedResultsController = nil;
        [self.tableView reloadData];
    });
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.fetchedResultsController sections][section] numberOfObjects];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GFAudioViewCell" forIndexPath:indexPath];
    // Configure the cell...
    GFAudio *audio = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = audio.title;
    cell.detailTextLabel.text = audio.artist;

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    GFAudio *audio = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self showPlayerWithAudio:audio];
}

-(void)showPlayerWithAudio:(GFAudio *)audio{
    GFPlayerViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"GFPlayerViewController"];
    [controller configureWithAudio:audio];
    [self.navigationController pushViewController:controller animated:YES];
}

@end

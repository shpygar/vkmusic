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
#import "GFAudioViewCell.h"

@interface GFAudiosViewController () <UISearchDisplayDelegate, NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

- (IBAction)logout:(id)sender;

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
    
    [self updateData:nil];
    
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

- (IBAction)logout:(id)sender{
    [[GFHTTPClient sharedClient] logout];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (! _fetchedResultsController) {
        NSFetchRequest *fetchRequest = [[GFModelManager sharedManager] fetchRequestWithPlaylistID:kDefaultPlaylistID sortKey:[NSSortDescriptor sortDescriptorWithKey:@"audioID" ascending:NO]];
        
        if(self.searchDisplayController.isActive){
            fetchRequest.predicate = [GFAudio predicateForSearchText:self.searchDisplayController.searchBar.text];
        }
        
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
        self.fetchedResultsController.delegate = nil;
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
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"GFAudioViewCell" forIndexPath:indexPath];

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

#pragma mark UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    self.fetchedResultsController.delegate = nil;
    self.fetchedResultsController = nil;
    [controller.searchResultsTableView reloadData];
    
    return YES;
}

- (void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView{
    tableView.backgroundColor = self.tableView.backgroundColor;
    tableView.backgroundView = self.tableView.backgroundView;
    tableView.separatorColor = self.tableView.separatorColor;
    tableView.separatorStyle = self.tableView.separatorStyle;
    tableView.rowHeight  = self.tableView.rowHeight;
}

-(void)searchDisplayController:(UISearchDisplayController *)controller didHideSearchResultsTableView:(UITableView *)tableView{
    self.fetchedResultsController.delegate = nil;
    self.fetchedResultsController = nil;
    [self.tableView reloadData];
}

- (void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView
{
    [tableView registerClass:[GFAudioViewCell class] forCellReuseIdentifier:@"GFAudioViewCell"];
}

@end

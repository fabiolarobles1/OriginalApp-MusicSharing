//
//  ReccommendedVC.m
//  Music_Sharing_App
//
//  Created by Fabiola E. Robles Vega on 8/3/20.
//  Copyright © 2020 Fabiola E. Robles Vega. All rights reserved.
//

#import "RecommendedVC.h"
#import "SpotifyManager.h"
#import <Parse/Parse.h>
#import "Post.h"
#import "AppDelegate.h"
#import "RecommendedCell.h"
#import "UIImageView+AFNetworking.h"
#import "SongInfoVC.h"
#import <Parse/Parse.h>
#import "SceneDelegate.h"
#import "LoginVC.h"


@interface RecommendedVC ()
@property (strong, nonatomic) NSString *songs;
@property (strong, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) NSMutableArray *recommendedSongs;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UILabel *label;
@end

@implementation RecommendedVC

-(void)viewWillAppear:(BOOL)animated{
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.user = [User currentUser];
    self.songs = [[NSString alloc]init];
    self.recommendedSongs = [[NSMutableArray alloc]init];
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.refreshControl addTarget:self action:@selector(fetchSongs) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
    [self fetchSongs];
    
}

-(void)fetchSongs{
    [self.refreshControl beginRefreshing];
    User *user = [User currentUser];
    PFRelation *relation = [user relationForKey:@"posts"];
    PFQuery *postsQuery = [relation query];
    [postsQuery includeKey:@"songURI"];
    
    [postsQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable objects, NSError * _Nullable error) {
        int count=0;
        if(objects.count==0){
            self.label.text = @"Sorry, we don't have any recommendations at the moment";
            [self.refreshControl endRefreshing];
        }else{
            for(Post *post in objects){
                count++;
                NSString *URI = [[post.songURI substringFromIndex:14] stringByAppendingString:@","];
                self.songs = [self.songs stringByAppendingString:URI];
                if(count>=5){
                    break;
                }
            }
            self.songs = [self.songs substringToIndex:[self.songs length]-1];
            
            [[SpotifyManager shared] getRecommendedSongs:self.appDelegate.sessionManager.session.accessToken songsCommaSeparated:self.songs completion:^(NSDictionary * _Nonnull songs, NSError * _Nonnull error) {
                if(!error){
                    [self.recommendedSongs removeAllObjects];
                    for(NSDictionary *dic in songs[@"tracks"]){
                        [self.recommendedSongs addObject:dic];
                    }
                    
                    NSLog(@"Songs: %ld", [self.recommendedSongs count]);
                }else{
                    NSLog(@"Error: %@", error.description);
                }
                [self.refreshControl endRefreshing];
                [self.tableView reloadData];
                self.songs = @"";
                
                if(self.recommendedSongs.count==0){
                    self.label.text = @"Sorry, we don't have any recommendations at the moment";
                }else{
                    self.label.text = @"We found some recommended songs based on your last posts.";
                }
            }];
        }
    }];
}


- (IBAction)didTapLogout:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        if(error ==nil){
            NSLog(@"Successfully logged out user.");
        }
        else{
            NSLog(@"Error loggin out user.");
        }
    }];
    
    SceneDelegate *myDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginVC *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginNavigationController"];
    myDelegate.window.alpha = 0.50;
    myDelegate.window.rootViewController = loginViewController;
    
    [UIView animateWithDuration:2 animations:^{
        myDelegate.window.alpha = 1;
    }];
}


-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    RecommendedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"recommendedCell"];
    NSDictionary *song = self.recommendedSongs[indexPath.row];
    NSArray *artist = song[@"artists"];
    NSDictionary *insideArtists = artist[0];
    NSDictionary *songName = song[@"name"];
    
    NSDictionary *album = song[@"album"];
    NSDictionary *albumName = album[@"name"];
    NSArray *albumImage =album[@"images"];
    NSDictionary *image = albumImage[0];
    NSString *albumimageURL = [NSString stringWithFormat:@"%@", image[@"url"]];
    
    NSDictionary *spotifyURL = song[@"external_urls"];
    cell.songSpotifyURL = spotifyURL[@"spotify"];
    cell.album =  [NSString stringWithFormat:@"%@",albumName];
    cell.artist = [NSString stringWithFormat:@"%@",insideArtists[@"name"]];
    cell.albumURLString = albumimageURL;
    cell.songname = [NSString stringWithFormat:@"%@",songName];
    
    cell.songURI = [NSString stringWithFormat:@"%@",song[@"uri"]];
    cell.artistLabel.text = cell.artist;
    cell.songNameLabel.text = cell.songname;
    
    [cell.albumCoverImage setImageWithURL:[NSURL URLWithString:albumimageURL]];
    
    return cell;
}


- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.recommendedSongs.count;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"toSongInfo"]){
        RecommendedCell *tappedCell = sender;
        SongInfoVC *songInfoViewController = [segue destinationViewController];
        songInfoViewController.senderCell = tappedCell;
        songInfoViewController.songSpotifyURL = tappedCell.songSpotifyURL;
    }
}



@end

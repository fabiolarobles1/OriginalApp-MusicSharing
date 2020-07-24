//
//  SearchVC.m
//  Music_Sharing_App
//
//  Created by Fabiola E. Robles Vega on 7/24/20.
//  Copyright © 2020 Fabiola E. Robles Vega. All rights reserved.
//

#import "SearchVC.h"
#import "SearchCell.h"
#import "Parse/Parse.h"
#import "SpotifyManager.h"
#import "Post.h"
#import "AppDelegate.h"
#import "PostCell.h"
#import "DateTools.h"
#import "DetailsVC.h"

@interface SearchVC ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSArray *data;
@property (strong, nonatomic) NSArray *filteredData;
@property (strong, nonatomic) AppDelegate *delegate;
@property (strong, nonatomic) Post *post;

@end

@implementation SearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.searchBar.delegate = self;
    self.delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [self fetchPosts];
}

-(void)fetchPosts{
    // construct query
    
    PFQuery *postQuery = [Post query];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery includeKey:@"author"];
    postQuery.limit = 20;
    
    // fetch data asynchronously
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {
        if (posts) {
            self.data= posts;
            self.filteredData = self.data;
            NSLog(@"Searched post count = %lu", (unsigned long)self.data.count);
            
        } else {
            NSLog(@"Error getting posts: %@", error.description);
        }
        
        [self.tableView reloadData];
    }];
    
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    SearchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchCell"];
    Post *post =self.filteredData[indexPath.row];
  //  cell.textLabel.text = post.title;
    [cell.postView setWithPost:post];
    cell.postView.dateLabel.text = post.createdAt.shortTimeAgoSinceNow;
    cell.delegate= self;
    [cell layoutIfNeeded];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredData.count;
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if(searchText.length !=0){
        NSPredicate *predicate = [[NSPredicate alloc]init];
//        if([[searchText substringToIndex:3] isEqualToString:@"song"]){
//
//            predicate = [NSPredicate predicateWithBlock:^BOOL(Post * _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
//                [[SpotifyManager shared] getSong:evaluatedObject.musicLink accessToken:self.delegate.sessionManager.session.accessToken completion:^(NSDictionary * _Nonnull song, NSError * _Nonnull error) {
//                       NSDictionary *songName = song[@"name"];
//                   }];
//                return [evaluatedObject.title containsString:searchText];
//            }];
//
//        }else{
            
            predicate = [NSPredicate predicateWithBlock:^BOOL(Post * _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
                return [evaluatedObject.title containsString:searchText];
            }];
//     }
        self.filteredData = [self.data filteredArrayUsingPredicate:predicate];
        NSLog(@"%@", self.filteredData);
    }else{
        self.filteredData = self.data;
        
    }
    [self.tableView reloadData];
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    self.searchBar.showsCancelButton = YES;
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    self.searchBar.showsCancelButton = NO;
    self.searchBar.text = @"";
    [self.searchBar resignFirstResponder];
}




 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
     if([[segue identifier] isEqualToString:@"toDetailsVCSegue"]){
         DetailsVC *detailViewController = [segue destinationViewController];
         detailViewController.post = self.post;
     }
 }
 

-(void)postCell:(SearchCell *)postCell didTap:(Post *)post{
    self.post = post;
    [self performSegueWithIdentifier:@"toDetailsVCSegue" sender:nil];
}
@end

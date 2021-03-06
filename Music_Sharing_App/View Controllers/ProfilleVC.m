//
//  ProfilleVC.m
//  Music_Sharing_App
//
//  Created by Fabiola E. Robles Vega on 7/28/20.
//  Copyright © 2020 Fabiola E. Robles Vega. All rights reserved.
//

#import "ProfilleVC.h"
#import <Parse/Parse.h>
#import "LoginVC.h"
#import "SceneDelegate.h"
#import "Post.h"
#import "HomePostCell.h"
#import "DateTools.h"
#import "InfiniteScrollActivityView.h"
#import "ComposeVC.h"
#import "DetailsVC.h"
#import "CreateProfileVC.h"
#import "User.h"
#import "Comment.h"
#import "CommentCell.h"
#import <ChameleonFramework/Chameleon.h>

@interface ProfilleVC ()<UITableViewDelegate,UITableViewDataSource, ProfileViewDelegate>
@property (strong, nonatomic) InfiniteScrollActivityView *loadingMoreView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *posts;
@property (strong, nonatomic) Post *post;
@property (nonatomic) NSInteger segmentIndex;
@property (strong, nonatomic) User *user;
@property (weak, nonatomic) IBOutlet UIButton *editProfileButton;

@end

@implementation ProfilleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.profileView.delegate = self;
    [self.profileView setWithUser:[User currentUser]];
    [self.tableView reloadData];
    self.isMoreDataLoading = NO;
    self.skipcount = 0;
    
}


-(PFQuery *)defineQuery{
    PFQuery *postQuery = [Post query];
    [postQuery whereKey:@"author" equalTo:[User currentUser]];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery includeKey:@"author"];
    postQuery.limit = 20;
    return postQuery;
}


-(void)fetchPosts{
     
    if(self.segmentIndex==0){
        [super fetchPosts];
        
    }else if(self.segmentIndex==1){
        [self.posts removeAllObjects];
        [self.refreshControl beginRefreshing];
        PFQuery *query = [User query];
        [query whereKey:@"objectId" equalTo:[User currentUser].objectId];
        [query findObjectsInBackgroundWithBlock:^(NSArray<User *> *_Nullable objects, NSError * _Nullable error) {
            for(User *user in objects){
                PFRelation *relation = [user relationForKey:@"likes"];
                PFQuery *relationQuery = [relation query];
                [relationQuery includeKey:@"author"];
                [relationQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable objects, NSError * _Nullable error) {
                    self.posts = [objects mutableCopy];
                    [self.tableView reloadData];
                    [self.refreshControl endRefreshing];
                    if(self.posts.count == 0){
                        [super checkEmptyData:@"No likes yet."];
                    }else{
                        [self.tableView.backgroundView setHidden:YES];
                        [self.tableView reloadData];
                    }
                }];
            }
        }];
        
    }else if(self.segmentIndex==2){
        [self.posts removeAllObjects];
        [self.refreshControl beginRefreshing];
        PFQuery *commentQuery = [Comment query];
        [commentQuery includeKey:@"author"];
        [commentQuery includeKey:@"post"];
        [commentQuery orderByDescending:@"createdAt"];
        [commentQuery findObjectsInBackgroundWithBlock:^(NSArray<Comment *> * _Nullable objects, NSError * _Nullable error) {
            for(Comment *comment in objects){
                if([comment.author.objectId isEqualToString:[User currentUser].objectId]){
                    [self.posts addObject:comment];
                }
            }
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
            if(self.posts.count == 0){
                [super checkEmptyData:@"No comments yet."];
            }else{
                [self.tableView.backgroundView setHidden:YES];
                [self.tableView reloadData];
            }
        }];
    }
}


- (IBAction)didTapLogout:(id)sender {
    [super logout];
}


- (IBAction)didTapAddButton:(id)sender {
    [self performSegueWithIdentifier:@"toComposeSegue" sender:nil];
}


- (IBAction)didTapEdit:(id)sender {
    [self performSegueWithIdentifier:@"toEditProfile" sender:nil];
}


-(void) scrollViewDidScroll:(UIScrollView *)scrollView{
    [super scrollViewDidScroll:scrollView];
}


-(void)profileView:(ProfileView *)profileView didTap:(UISegmentedControl *)segmentedControl{
    NSLog(@"Selected: %ld", (long)segmentedControl.selectedSegmentIndex);
    self.segmentIndex = segmentedControl.selectedSegmentIndex;
    [self.posts removeAllObjects];
    [self.tableView reloadData];
    [self fetchPosts];
}


-(void)postCell:(HomePostCell *)postCell didTap:(Post *)post{
    [super postCell:postCell didTap:post];
}


#pragma mark - Table View

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if(self.segmentIndex == 2){
        CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell"];
        cell.layer.backgroundColor = [[UIColor clearColor] CGColor];
        Comment *comment = self.posts[indexPath.row];
        [comment.author fetchIfNeeded];
        cell.commentBackground.layer.cornerRadius = 16;
        cell.commentBackground.clipsToBounds = true;
        cell.commentLabel.text = comment.text;
        cell.usernameLabel.text =comment.author.username;
        return cell;
    }else{
        HomePostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProfilePostCell"];
        Post *post = self.posts[indexPath.row];
        [post fetchIfNeeded];
        [cell.postView setWithPost:post];
        cell.postView.dateLabel.text = post.createdAt.shortTimeAgoSinceNow;
        cell.delegate= self;
        [cell layoutIfNeeded];
        
        return cell;
    }
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.posts.count;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    //Unselect cell after entering details
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    [super prepareForSegue:segue sender:sender];
    if([[segue identifier] isEqualToString:@"toEditProfile"]){
        CreateProfileVC *editProfileViewController = [segue destinationViewController];
        editProfileViewController.userImage = self.profileView.profileImageView.image;
        
    }
    else if([[segue identifier] isEqualToString:@"toDetailsFromComment"]){
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        Comment *comment = self.posts[indexPath.row];
        DetailsVC *detailViewController = [segue destinationViewController];
        Post *post = comment.post;
        [post fetchIfNeeded];
        [detailViewController setPost:post];
        PFRelation *relation = [[User currentUser] relationForKey:@"likes"];
        PFQuery *relationQuery = [relation query];
        [relationQuery whereKey:@"objectId" equalTo:post.objectId];
        [relationQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable objects, NSError * _Nullable error) {
            if(objects.count==1){
                detailViewController.isFavorited = YES;
            }else{
                detailViewController.isFavorited = NO;
            }
            [detailViewController.detailsView.favoriteButton setSelected:detailViewController.isFavorited];
        }];
        [detailViewController refreshComments];
    }
    
}


@end

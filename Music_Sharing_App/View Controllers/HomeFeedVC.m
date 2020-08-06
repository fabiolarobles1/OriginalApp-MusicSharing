//
//  HomeFeedVC.m
//  Music_Sharing_App
//
//  Created by Fabiola E. Robles Vega on 7/13/20.
//  Copyright © 2020 Fabiola E. Robles Vega. All rights reserved.
//

#import "HomeFeedVC.h"
#import "LoginVC.h"
#import "SceneDelegate.h"
#import "Post.h"
#import "HomePostCell.h"
#import "DateTools.h"
#import "InfiniteScrollActivityView.h"
#import "ComposeVC.h"
#import "DetailsVC.h"

@interface HomeFeedVC () <UITableViewDelegate,UITableViewDataSource, UINavigationControllerDelegate>

@property (strong, nonatomic) InfiniteScrollActivityView *loadingMoreView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *posts;
@property (assign, nonatomic) BOOL isMoreDataLoading;
@property (assign, nonatomic) int skipcount;
@property (strong, nonatomic) Post *post;

@end

@implementation HomeFeedVC

-(void)viewWillAppear:(BOOL)animated{
    [self.tableView reloadData];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.isMoreDataLoading = NO;
    self.skipcount = 0;
    
    //setting up refresh control
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.refreshControl addTarget:self action:@selector(fetchPosts) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
    // Set up Infinite Scroll loading indicator
    CGRect frame = CGRectMake(0, self.tableView.contentSize.height, self.tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight);
    self.loadingMoreView = [[InfiniteScrollActivityView alloc] initWithFrame:frame];
    self.loadingMoreView.hidden = true;
    [self.tableView addSubview:self.loadingMoreView];
    
    UIEdgeInsets insets = self.tableView.contentInset;
    insets.bottom += InfiniteScrollActivityView.defaultHeight;
    self.tableView.contentInset = insets;

    [self fetchPosts];
}


- (IBAction)didTapCompose:(id)sender {
    [self performSegueWithIdentifier:@"toComposeSegue" sender:nil];
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    HomePostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostCell"];
    Post *post = self.posts[indexPath.row];
    [cell.postView setWithPost:post];
    cell.postView.dateLabel.text = post.createdAt.shortTimeAgoSinceNow;
    cell.delegate= self;
    [cell layoutIfNeeded];
    
    return cell;
    
}


-(void)postCell:(HomePostCell *)postCell didTap:(Post *)post{
    self.post = post;
    [self performSegueWithIdentifier:@"toDetailsVCSegue" sender:postCell];
}


- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.posts.count;
}


-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    //Unselect cell after entering details
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (IBAction)didTapLogout:(id)sender {
    [self logout];
}


-(void)logout{
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


-(PFQuery *)defineQuery{
    PFQuery *postQuery = [Post query];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery includeKey:@"author"];
    postQuery.limit = 20;
    
    return postQuery;
}


-(void)fetchPosts{
    // construct query
    if([self.refreshControl isRefreshing]){
        self.skipcount = 0;
    }
   
    PFQuery *postQuery = [self defineQuery];
    if(self.isMoreDataLoading){
        postQuery.skip = self.skipcount;
    }
    
    // fetch data asynchronously
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {
        if (posts) {
            
            if(self.isMoreDataLoading){
                [self.posts addObjectsFromArray:posts];
            }else{
                self.posts= [posts mutableCopy];
            }
            //update flag
            self.isMoreDataLoading = NO;
            
            [self.tableView reloadData];
            NSLog(@"Post count = %lu", (unsigned long)self.posts.count);
            // stop indicators
            [self.refreshControl endRefreshing];
            [self.loadingMoreView stopAnimating];
            [self.tableView reloadData];
            
        } else {
            NSLog(@"Error getting posts: %@", error.description);
            //ADD TO CHECK IF IT IS BECAUSE NO CONNECTION!!
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Cannot Load Feed" message:@"An error occured while trying to load feed. Please, try again." preferredStyle:(UIAlertControllerStyleAlert)];
            
            //creating cancel action
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"  style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                // doing nothing will dismiss the view
            }];
            //   adding cancel action to the alertController
            [alert addAction:cancelAction];
            
            //creating OK action
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Try Again" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //try to load post again
                [self fetchPosts];
            }];
            
            //adding OK action to the alertController
            [alert addAction:okAction];
            
            [self presentViewController:alert animated:YES completion:^{
                // stop indicators
                [self.refreshControl endRefreshing];
                [self.loadingMoreView stopAnimating];
                
            }];
        }
        if(self.posts.count == 0){
            [self checkEmptyData:@"No posts yet."];
        }else{
           
            [self.tableView.backgroundView setHidden:YES];
            [self.tableView reloadData];
            [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        }
    }];
}


-(void)checkEmptyData:(NSString *)message{
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    UILabel *emptyMessageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, self.tableView.bounds.size.height)];
    emptyMessageLabel.text = message;
    emptyMessageLabel.textColor = [UIColor blackColor];
    emptyMessageLabel.numberOfLines = 0;
    emptyMessageLabel.textAlignment = NSTextAlignmentCenter;
    [emptyMessageLabel setFont:[UIFont fontWithName:@"TrebuchetMS" size:20]];
    [emptyMessageLabel sizeToFit];
    [self.tableView.backgroundView setHidden:NO];
    self.tableView.backgroundView = emptyMessageLabel;
    self.tableView.backgroundView.backgroundColor = [UIColor lightGrayColor];
    
}


-(void) scrollViewDidScroll:(UIScrollView *)scrollView{
    if(!self.isMoreDataLoading){
        // Calculate the position of one screen length before the bottom of the results
        int scrollViewContentHeight = self.tableView.contentSize.height;
        int scrollOffsetThreshold = scrollViewContentHeight - self.tableView.bounds.size.height;
        
        // When the user has scrolled past the threshold, start requesting
        if(scrollView.contentOffset.y > scrollOffsetThreshold && self.tableView.isDragging) {
            self.skipcount +=20;    
            self.isMoreDataLoading = YES;
            
            // Update position of loadingMoreView, and start loading indicator
            CGRect frame = CGRectMake(0, self.tableView.contentSize.height, self.tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight);
            self.loadingMoreView.frame = frame;
            [self.loadingMoreView startAnimating];
            
            //load more results
            if (self.posts.count>=self.skipcount){
                [self fetchPosts];
                NSLog(@"Loading MORE Posts.");
            }else{
                [self.loadingMoreView stopAnimating];
                self.isMoreDataLoading = NO;
            }
        }
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if([[segue identifier] isEqualToString:@"toDetailsVCSegue"]){
        HomePostCell *senderCell = sender;
        NSLog(@"sender: %d", senderCell.postView.favoriteButton.isSelected);
        DetailsVC *detailViewController = [segue destinationViewController];
        detailViewController.post = self.post;
        detailViewController.isFavorited = senderCell.postView.favoriteButton.isSelected;
        [detailViewController refreshComments];
    }
    
}



@end

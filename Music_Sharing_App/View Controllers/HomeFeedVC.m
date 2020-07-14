//
//  HomeFeedVC.m
//  Music_Sharing_App
//
//  Created by Fabiola E. Robles Vega on 7/13/20.
//  Copyright © 2020 Fabiola E. Robles Vega. All rights reserved.
//

#import "HomeFeedVC.h"
#import <Parse/Parse.h>
#import "LoginVC.h"
#import "SceneDelegate.h"
#import "Post.h"
#import "PostCell.h"
#import "DateTools.h"

@interface HomeFeedVC () <UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *posts;

@end

@implementation HomeFeedVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //setting up refresh control
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.refreshControl addTarget:self action:@selector(fetchPosts) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
    [self fetchPosts];
}

- (IBAction)didTapCompose:(id)sender {
    [self performSegueWithIdentifier:@"toComposeSegue" sender:nil];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    PostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostCell"];
       Post *post = self.posts[indexPath.row];
       [cell.postView setWithPost:post];
       cell.postView.dateLabel.text = post.createdAt.shortTimeAgoSinceNow;
    
       return cell;
    
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.posts.count;
   
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


-(void)fetchPosts{
    // construct query
    PFQuery *postQuery = [Post query];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery includeKey:@"author"];
    postQuery.limit = 20;
    //    if(self.isMoreDataLoading && self.posts.count>self.skipcount ){
    //        postQuery.skip = self.skipcount;
    //    }
    
    // fetch data asynchronously
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {
        if (posts) {
            
            self.posts= [posts mutableCopy];
            [self.tableView reloadData];
            NSLog(@"Post count = %lu", (unsigned long)self.posts.count);
            // stop indicators
            [self.refreshControl endRefreshing];
        } else {
            NSLog(@"%@", error.localizedDescription);
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Cannot Load Feed" message:@"The internet connection appears to be offline." preferredStyle:(UIAlertControllerStyleAlert)];
            
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
            }];
        }
    }];
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


@end

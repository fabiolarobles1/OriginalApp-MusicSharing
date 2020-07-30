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
#import "MBProgressHUD.h"

@interface ProfilleVC ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) InfiniteScrollActivityView *loadingMoreView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *posts;
@property (assign, nonatomic) BOOL isMoreDataLoading;
@property (assign, nonatomic) int skipcount;
@property (strong, nonatomic) Post *post;

@end

@implementation ProfilleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.profileView setWithUser:[User currentUser]];
    [self.tableView reloadData];
}
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
   
       HomePostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProfilePostCell"];
       Post *post = self.posts[indexPath.row];
       [cell.postView setWithPost:post];
       cell.postView.dateLabel.text = post.createdAt.shortTimeAgoSinceNow;
       cell.delegate= self;
       [cell layoutIfNeeded];

       return cell;
       
   }

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.posts.count;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    //Unselect cell after entering details
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)postCell:(HomePostCell *)postCell didTap:(Post *)post{
    [super postCell:postCell didTap:post];
}

- (IBAction)didTapLogout:(id)sender {
    [super logout];
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
    [super fetchPosts];
}

-(void) scrollViewDidScroll:(UIScrollView *)scrollView{
    [super scrollViewDidScroll:scrollView];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    [super prepareForSegue:segue sender:sender];
}
*/

@end

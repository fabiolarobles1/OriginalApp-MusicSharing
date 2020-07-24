//
//  DetailsVC.m
//  Music_Sharing_App
//
//  Created by Fabiola E. Robles Vega on 7/22/20.
//  Copyright © 2020 Fabiola E. Robles Vega. All rights reserved.
//

#import "DetailsVC.h"
#import "Comment.h"
#import "CommentCell.h"
#import "MBProgressHUD.h"
@import Parse;

@interface DetailsVC ()
@property (strong, nonatomic) NSMutableArray *comments;
@property (weak, nonatomic) IBOutlet PFImageView *backgroundImageView;

@end

@implementation DetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.backgroundColor = [UIColor clearColor];
    self.backgroundImageView.alpha = 0.5;
    self.backgroundImageView.file = self.post.image;
    [self.backgroundImageView loadInBackground];
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellAccessoryNone;
    [self.detailsView setView:self.post];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self refreshComments];
    
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refreshComments) userInfo:nil repeats:true];
    
    
    //SET THE POST TO COMMENTS ALSO
}
-(void)refreshComments{
    
    // construct query
    PFQuery *query = [Post query];
    [query whereKey:@"objectId" equalTo:self.post.objectId];
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray<Post *> *posts, NSError *error) {
        
        for(Post *post in posts){
            PFRelation *relation = [post relationForKey:@"comments"];
            PFQuery *relationQuery = [relation query];
            [relationQuery includeKey:@"author"];
            [relationQuery orderByDescending:@"createdAt"];
            [relationQuery findObjectsInBackgroundWithBlock:^(NSArray<Comment *> * _Nullable objects, NSError * _Nullable error) {
                if(error==nil){
                    NSLog(@"Comments: %lu", (unsigned long)objects.count);
                    self.comments = [objects mutableCopy];
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                }
            }];
        }
    }];
    
    [self.tableView reloadData];
    
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell"];
    cell.layer.backgroundColor = [[UIColor clearColor] CGColor];
    Comment *comment = self.comments[indexPath.row];
    [comment fetchIfNeeded];
    cell.commentBackground.layer.cornerRadius = 16;
    cell.commentBackground.clipsToBounds = true;
    cell.commentLabel.text = comment.text;
    cell.usernameLabel.text =comment.author.username;

    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.comments.count;
}


@end

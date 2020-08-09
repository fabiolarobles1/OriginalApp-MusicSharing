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
#import "SongInfoVC.h"
#import <ChameleonFramework/Chameleon.h>

@import Parse;

@interface DetailsVC ()
@property (strong, nonatomic) NSMutableArray *comments;
@property (weak, nonatomic) IBOutlet PFImageView *backgroundImageView;
@property (weak, nonatomic) NSTimer *commentLoad;

@end

@implementation DetailsVC

-(void)viewWillAppear:(BOOL)animated{    
    [self refreshComments];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.backgroundColor = [UIColor clearColor];
    self.backgroundImageView.alpha = 0.5;
    self.backgroundImageView.file = self.post.image;
    [self.backgroundImageView loadInBackground];
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellAccessoryNone;
    self.detailsView.delegate = self;
    self.detailsView.commentView.delegate = self;
    [self.tableView setAllowsSelection:NO];
    [self.detailsView setView:self.post isFavorited:self.isFavorited];
    
    self.commentLoad= [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(refreshComments) userInfo:nil repeats:true];
}


-(void)viewWillDisappear:(BOOL)animated{
    [self.commentLoad invalidate];
}


-(void)refreshComments{
    PFQuery *commentQuery = [Comment query];
    [commentQuery whereKey:@"post" equalTo:self.post];
    [commentQuery includeKey:@"author"];
    [commentQuery orderByDescending:@"createdAt"];
    [commentQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if(error==nil){
            NSLog(@"Comments: %lu", (unsigned long)objects.count);
            self.comments = [objects mutableCopy];
            [self.tableView reloadData];
        }
    }];
}


- (IBAction)didTapScreen:(id)sender {
    [self.view endEditing:YES];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([[segue identifier] isEqualToString:@"toSongInfo"]){
        SongInfoVC *songInfoViewController = [segue destinationViewController];
        songInfoViewController.post = self.post;
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


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


- (void)detailsView:(nonnull DetailsView *)detailsView didTap:(nonnull UIButton *)infoButton {
    [self performSegueWithIdentifier:@"toSongInfo" sender:nil];
}


- (void)commentView:(nonnull CommentView *)commentView didTap:(nonnull UIButton *)sendButton {
    [self refreshComments];
}

@end

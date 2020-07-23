//
//  DetailsVC.m
//  Music_Sharing_App
//
//  Created by Fabiola E. Robles Vega on 7/22/20.
//  Copyright © 2020 Fabiola E. Robles Vega. All rights reserved.
//

#import "DetailsVC.h"
#import "CommentCell.h"

@interface DetailsVC ()
@property (strong, nonatomic) NSMutableArray *comments;
@end

@implementation DetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.dataSource = self;

    [self.detailsView setView:self.post];
    [self.commentView setPost:self.post];
    
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
            [relationQuery orderByDescending:@"createdAt"];
            [relationQuery findObjectsInBackgroundWithBlock:^(NSArray<PFObject *> * _Nullable objects, NSError * _Nullable error) {
                self.comments = [objects mutableCopy];
                NSLog(@"Comments: %lu", (unsigned long)objects.count);
//                for(PFObject *comment in objects){
//                    [self.comments addObject:comment[@"text"]];
//                }
            }];
        }
    }];
    NSLog(@"Comments: %lu", (unsigned long)self.comments.count);
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
    PFObject *comment = self.comments[indexPath.row];
    cell.commentLabel.text = comment[@"text"];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.comments.count;
}


@end

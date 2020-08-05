//
//  PostView.m
//  Music_Sharing_App
//
//  Created by Fabiola E. Robles Vega on 7/13/20.
//  Copyright © 2020 Fabiola E. Robles Vega. All rights reserved.
//

#import "PostView.h"
#import <ChameleonFramework/Chameleon.h>

@interface PostView()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageWidthConstraint;
@end

@implementation PostView


-(instancetype)initWithCoder:(NSCoder *)coder{
    self = [super initWithCoder:coder];
    if(self){
        [self customInit];
    }
    return self;
}


-(instancetype) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self customInit];
    }
    return self;
}


-(void) customInit{
    
    //grabbing xib
    [[NSBundle mainBundle] loadNibNamed:@"PostView" owner:self options:nil];
    
    //adding the content view as a subview of class
    [self addSubview:self.postView];
    
    //contrain xib so it takes entire view
    self.postView.frame = self.bounds;
    self.userImageView.layer.cornerRadius = self.userImageView.frame.size.height/2;
    self.userImageView.clipsToBounds = YES;
}


-(void) setWithPost:(Post *)post{
    self.post = post;
    self.usernameLabel.textColor = [UIColor colorWithComplementaryFlatColorOf: [UIColor colorWithRed:0.00 green:0.90 blue:1.00 alpha:1.00]];
    self.userImageView.tintColor = [UIColor colorWithComplementaryFlatColorOf: [UIColor colorWithRed:0.00 green:0.90 blue:1.00 alpha:1.00]];
    self.favoriteButton.tintColor = [UIColor colorWithComplementaryFlatColorOf: [UIColor colorWithRed:0.00 green:0.90 blue:1.00 alpha:1.00]];
    self.postImageView.tintColor = [UIColor colorWithComplementaryFlatColorOf: [UIColor colorWithRed:0.00 green:0.90 blue:1.00 alpha:1.00]];
    PFQuery *picQuery = [User query];
    [picQuery whereKey:@"objectId" equalTo:post.author.objectId];
    [picQuery includeKey:@"profilePic"];
    
    [picQuery findObjectsInBackgroundWithBlock:^(NSArray<User *> * _Nullable objects, NSError * _Nullable error) {
        if(!error){
            self.user = objects[0];
            if(self.user.profilePic){
                self.userImageView.file = self.user.profilePic;
                [self.userImageView loadInBackground];
            }else{
                self.userImageView.image = [UIImage systemImageNamed:@"person.circle.fill"];
            }
        }
    }];
    

    self.titleLabel.text = post.title;
   // self.titleLabel.text  = post.songName;
    if(post.genre!=nil){
        self.genreLabel.text = [@"Genre: " stringByAppendingString:post.genre];
    }
    if(post.mood!=nil){
        self.moodLabel.text = [@"Mood: " stringByAppendingString:post.mood];
    }
    if(post.caption.length!=0){
        [self.captionLabel setHidden:NO];
        self.captionLabel.text = post.caption;
       // self.captionLabel.text = [@"Caption: " stringByAppendingString:post.caption];
    }else{
        self.captionLabel.text = @"";
        [self.captionLabel setHidden:YES];
    }
    
    self.date = post.createdAt;
    
    //see if works
    if(post.image == nil){
        [self.postImageView setHidden:YES];
        self.imageHeightConstraint.constant = 0.0;
        self.imageWidthConstraint.constant = 0.0;
       
    }else{
        [self.postImageView setHidden:NO];
        self.imageHeightConstraint.constant = 100.0;
        self.imageWidthConstraint.constant = 100.0;
    }
    self.postImageView.file = post.image;
    [self.postImageView loadInBackground];
    __block BOOL isFavorited = NO;
    PFQuery *query = [User query];
    [query whereKey:@"objectId" equalTo:[User currentUser].objectId];
    [query findObjectsInBackgroundWithBlock:^(NSArray<User *> *_Nullable objects, NSError * _Nullable error) {
        for(User *user in objects){
            PFRelation *relation = [user relationForKey:@"likes"];
            PFQuery *relationQuery = [relation query];
            [relationQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable objects, NSError * _Nullable error) {
                for(Post *post in objects){
                    if([post.objectId isEqual:self.post.objectId]){
                        isFavorited = YES;
                        [self.favoriteButton setSelected:YES];
                    }
                }
                if(!isFavorited){
                    [self.favoriteButton setSelected:NO];
                }
            }];
        }
    }];
    
    self.likeCountLabel.text =[@(self.post.likesCount)stringValue];
    self.usernameLabel.text = [@"@" stringByAppendingString:post.author.username];
}


- (IBAction)didTapLike:(id)sender {
    [self.favoriteButton setSelected:!self.favoriteButton.selected];
    User *user = [User currentUser];
    PFRelation *relation = [user relationForKey:@"likes"];
    
    if([self.favoriteButton isSelected]){
        self.post.likesCount +=1;
        [relation addObject:self.post];
    }else{
        self.post.likesCount -=1;
        [relation removeObject:self.post];
    }
    
    [Post updatePost:self.post];
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded){
            NSLog(@"Relation succeded.");
        }else{
            NSLog(@"Error on relation: %@", error.description );
        }
    }];
    
    self.likeCountLabel.text = [@(self.post.likesCount)stringValue];
    
}

@end

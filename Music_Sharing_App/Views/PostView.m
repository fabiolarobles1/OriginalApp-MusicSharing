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
    
    //setting colors
    UIColor  *customRed = [UIColor colorWithComplementaryFlatColorOf: [UIColor colorWithRed:0.00 green:0.90 blue:1.00 alpha:1.00]];
    self.usernameLabel.textColor = customRed;
    self.userImageView.tintColor = customRed;
    self.favoriteButton.tintColor = customRed;
    self.postImageView.tintColor = customRed;
}


-(void) setWithPost:(Post *)post{
    self.post = post;
    self.user = post.author;
    self.date = post.createdAt;
    
    [self.user fetchIfNeeded];
    
    if(self.user.profilePic){
        //setting profile image
        self.userImageView.file = self.user.profilePic;
        [self.userImageView loadInBackground];
        
    }else{
        //if not available setting default image to avoid reusing another user's profile image
        self.userImageView.image = [UIImage systemImageNamed:@"person.circle.fill"];
    }
    
    if(post.caption.length!=0){
        [self.captionLabel setHidden:NO];
        self.captionLabel.text = post.caption;
    }else{
        [self.captionLabel setHidden:YES];
    }
    
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
    
    //making query to see if post was already liked
    PFRelation *relation = [[User currentUser] relationForKey:@"likes"];
    PFQuery *relationQuery = [relation query];
    [relationQuery whereKey:@"objectId" equalTo:post.objectId];
    [relationQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable objects, NSError * _Nullable error) {
        if(objects.count==1){
            [self.favoriteButton setSelected:YES];
        }else{
            [self.favoriteButton setSelected:NO];
        }
    }];
    
    //setting up labels
    self.titleLabel.text  = post.songName;
    self.genreLabel.text = [@"Genre: " stringByAppendingString:post.genre];
    self.moodLabel.text = [@"Mood: " stringByAppendingString:post.mood];
    self.likeCountLabel.text =[@(self.post.likesCount)stringValue];
    self.usernameLabel.text = [@"@" stringByAppendingString:post.author.username];
    
}


- (IBAction)didTapLike:(id)sender {
    
    //setting like selected/unselected
    [self.favoriteButton setSelected:!self.favoriteButton.selected];
    
    //making post like relation
    if([self.favoriteButton isSelected]){
        [self.post likePost:YES];
    }else{
        [self.post likePost:NO];
    }
    
    //updating like count on label
    self.likeCountLabel.text = [@(self.post.likesCount) stringValue];
    
}

@end

//
//  PostView.m
//  Music_Sharing_App
//
//  Created by Fabiola E. Robles Vega on 7/13/20.
//  Copyright © 2020 Fabiola E. Robles Vega. All rights reserved.
//

#import "PostView.h"
#import "Post.h"
@import Parse;

@interface PostView()

@property (strong, nonatomic) IBOutlet UIView *postView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *genreLabel;
@property (weak, nonatomic) IBOutlet UILabel *moodLabel;
@property (weak, nonatomic) IBOutlet UILabel *musicLinkLabel;
@property (weak, nonatomic) IBOutlet PFImageView *postImageView;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) NSDate *date;
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
}

-(void) setWithPost:(Post *)post{
    self.titleLabel.text = post.title;
    self.genreLabel.text = post.genre;
    self.moodLabel.text = post.mood;
    self.musicLinkLabel.text = post.musicLink;
    self.captionLabel.text = post.caption;
    
    self.date = post.createdAt;
    self.postImageView.file = post[@"image"];
    [self.postImageView loadInBackground];
    
}

- (IBAction)didTapView:(id)sender {
    [self.postView.layer setBackgroundColor:[UIColor grayColor].CGColor];
    [self.postView.layer setOpacity:0.5];
    [UIView animateWithDuration:1 animations:^{
          [self.postView.layer setBackgroundColor:[UIColor clearColor].CGColor];
        [self.postView.layer setOpacity:1.0];;
       }];
}


@end

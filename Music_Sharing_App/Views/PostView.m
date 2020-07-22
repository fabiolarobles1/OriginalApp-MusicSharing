//
//  PostView.m
//  Music_Sharing_App
//
//  Created by Fabiola E. Robles Vega on 7/13/20.
//  Copyright © 2020 Fabiola E. Robles Vega. All rights reserved.
//

#import "PostView.h"
#import "Post.h"


@interface PostView()
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
    if(post.genre!=nil){
        self.genreLabel.text = [@"Genre: " stringByAppendingString:post.genre];
    }
    if(post.mood!=nil){
        self.moodLabel.text = [@"Mood: " stringByAppendingString:post.mood];
    }
    if(post.caption.length!=0){
        self.captionLabel.text = [@"Caption: " stringByAppendingString:post.caption];
    }else{
        self.captionLabel.text = @"";
        [self.captionLabel removeFromSuperview];
    }
    self.post = post;
    self.date = post.createdAt;
    
    if(post.image == nil){
        [self.postImageView removeFromSuperview];
    }
    
    self.postImageView.file = post.image;
    [self.postImageView loadInBackground];
    
}




@end

//
//  ProfileView.m
//  Music_Sharing_App
//
//  Created by Fabiola E. Robles Vega on 7/28/20.
//  Copyright © 2020 Fabiola E. Robles Vega. All rights reserved.
//

#import "ProfileView.h"

@implementation ProfileView


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
    [[NSBundle mainBundle] loadNibNamed:@"ProfileView" owner:self options:nil];
    
    //adding the content view as a subview of class
    [self addSubview:self.profileView];
    
    //contrain xib so it takes entire view
    self.profileView.frame = self.bounds;
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height/2;
    self.profileImageView.clipsToBounds = YES;
}


-(void)setWithUser:(User *)user{
    self.user = user;
    self.profileImageView.file = user.profilePic;
    [self.profileImageView loadInBackground];
    self.bioLabel.text = user.bio;
    self.usernameLabel.text = [@"@" stringByAppendingString:user.username];
}
@end

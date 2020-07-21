//
//  PostCell.m
//  Music_Sharing_App
//
//  Created by Fabiola E. Robles Vega on 7/13/20.
//  Copyright © 2020 Fabiola E. Robles Vega. All rights reserved.
//

#import "PostCell.h"


@implementation PostCell

- (void)awakeFromNib {
    [super awakeFromNib];
     UITapGestureRecognizer *postTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapPost:)];
    
    [self.postView addGestureRecognizer:postTapGestureRecognizer];
    [self.postView setUserInteractionEnabled:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


- (void) didTapPost:(UITapGestureRecognizer *)sender{
   
    [self.delegate postCell:self didTap:self.postView.post];
    [self.postView.layer setBackgroundColor:[UIColor grayColor].CGColor];
       [self.postView.layer setOpacity:0.5];
       [UIView animateWithDuration:1 animations:^{
             [self.postView.layer setBackgroundColor:[UIColor clearColor].CGColor];
           [self.postView.layer setOpacity:1.0];;
          }];
}

@end

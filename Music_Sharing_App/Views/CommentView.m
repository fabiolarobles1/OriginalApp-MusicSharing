//
//  CommentView.m
//  Music_Sharing_App
//
//  Created by Fabiola E. Robles Vega on 7/23/20.
//  Copyright © 2020 Fabiola E. Robles Vega. All rights reserved.
//

#import "CommentView.h"
#import "Comment.h"
#import <ChameleonFramework/Chameleon.h>
#import <Parse/Parse.h>

@interface CommentView() <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *commentTextField;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UILabel *addCommentLabel;

@end

@implementation CommentView

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
    [[NSBundle mainBundle] loadNibNamed:@"CommentView" owner:self options:nil];
    
    //adding the content view as a subview of class
    [self addSubview:self.commentView];
    
    //contrain xib so it takes entire view
    self.commentView.frame = self.bounds;
    self.commentTextField.layer.cornerRadius = 8;
    self.commentTextField.clipsToBounds = true;
    self.sendButton.tintColor = [UIColor colorWithComplementaryFlatColorOf:[UIColor colorWithHexString:@"09F0FA"]];
    self.commentTextField.delegate = self;
    
}

/**
 *Hides add comment message when editing begins
 */
-(void)textViewDidBeginEditing:(UITextView *)textView{
    [self.addCommentLabel setHidden:YES];
}

/**
 *If comment field is empty puts "add comment" message again
 */
-(void)textViewDidEndEditing:(UITextView *)textView{
    if([[self.commentTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0){
        [self.addCommentLabel setHidden:NO];
    }
}


- (IBAction)didTapSend:(id)sender {
    
    //avoids posting a empty comments
    if([[self.commentTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] != 0){
        [self.sendButton setEnabled:NO];
        
        //creating comment
        Comment *comment = [[Comment alloc]init];
        comment.text = self.commentTextField.text;
        comment.author = [User currentUser];
        comment.post = self.post;
        
        //creating relation of comment to the post
        PFRelation *relation = [self.post relationForKey:@"comments"];
        
        //sending to parse
        [comment saveInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
            if (succeeded) {
                self.post.commentsCount +=1;
                [relation addObject:comment];
                NSLog(@"The comment was saved!");
                [self.post saveInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
                    if (succeeded) {
                        NSLog(@"Relation created");
                        
                    } else {
                        NSLog(@"Error on relation: %@", error.localizedDescription);
                    }
                }];
            } else {
                NSLog(@"Problem saving comment: %@", error.localizedDescription);
            }
            
            //setting delegate
            [self.delegate commentView:self didTap:self.sendButton];
        }];
    }
    
    //reset to default empty comment view
    [self.sendButton setEnabled:YES];
    [self.commentView endEditing:YES];
    self.commentTextField.text = @"";
    [self.addCommentLabel setHidden:NO];
    
}



@end

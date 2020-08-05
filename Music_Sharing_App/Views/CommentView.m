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
@import Parse;

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
   // self.sendButton.layer.cornerRadius = self.sendButton.layer.frame.size.height/4;
    //self.sendButton.backgroundColor =  [UIColor colorWithComplementaryFlatColorOf:[UIColor colorWithHexString:@"09F0FA"]];
   
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    [self.addCommentLabel setHidden:YES];
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    if([[self.commentTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0){
        [self.addCommentLabel setHidden:NO];
    }
}

- (IBAction)didTapSend:(id)sender {
    if([[self.commentTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] != 0){
        [self.sendButton setEnabled:NO];
        Post *post = self.post;
        Comment *comment = [[Comment alloc]init];
        comment.text =self.commentTextField.text;
        comment.author = [User currentUser];
        comment.post = post;
        PFRelation *relation = [post relationForKey:@"comments"];
        
        [comment saveInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
            if (succeeded) {
                post.commentsCount +=1;
                [relation addObject:comment];
                NSLog(@"The comment was saved!");
                [post saveInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
                    if (succeeded) {
                        NSLog(@"Relation created");
                        
                    } else {
                        NSLog(@"Error on relation: %@", error.localizedDescription);
                        //MAYBE ADDING AN ALERT
                    }
                }];
            } else {
                NSLog(@"Problem saving comment: %@", error.localizedDescription);
                //MAYBE ADDING AN ALERT
            }
        }];
        
    }
        [self.sendButton setEnabled:YES];
        [self.commentView endEditing:YES];
        self.commentTextField.text = @"";
        [self.addCommentLabel setHidden:NO];
  
}



@end

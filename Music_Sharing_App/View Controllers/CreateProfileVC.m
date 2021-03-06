//
//  CreateProfileVC.m
//  Music_Sharing_App
//
//  Created by Fabiola E. Robles Vega on 7/29/20.
//  Copyright © 2020 Fabiola E. Robles Vega. All rights reserved.
//

#import "CreateProfileVC.h"
#import "User.h"
#import "SceneDelegate.h"
#import "HomeFeedVC.h"
#import <ChameleonFramework/Chameleon.h>
#import "DGActivityIndicatorView.h"

@interface CreateProfileVC ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (strong, nonatomic) UIImagePickerController *imagePickerVC;
@property (weak, nonatomic) IBOutlet UILabel *addBioWatermarkLabel;
@property (weak, nonatomic) IBOutlet DGActivityIndicatorView *activityIndicatorView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;


@end

@implementation CreateProfileVC
BOOL imageDidChange = NO;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.usernameLabel.text =[@"@" stringByAppendingString:[User currentUser].username];
    self.bioTextView.layer.borderWidth = 1.0;
    self.bioTextView.layer.cornerRadius = 5;
    self.bioTextView.clipsToBounds = true;
    self.bioTextView.layer.borderColor =[[UIColor grayColor] CGColor];
    self.bioTextView.text = [User currentUser].bio;
    self.bioTextView.delegate = self;
    if(self.bioTextView.text.length != 0){
        [self.addBioWatermarkLabel setHidden:YES];
    }
    self.profilePicImageButton.tintColor = [UIColor colorWithComplementaryFlatColorOf: [UIColor colorWithRed:0.00 green:0.90 blue:1.00 alpha:1.00]];
    self.usernameLabel.textColor = [UIColor colorWithComplementaryFlatColorOf: [UIColor colorWithRed:0.00 green:0.90 blue:1.00 alpha:1.00]];
    self.imagePickerVC = [UIImagePickerController new];
    self.imagePickerVC.delegate = self;
    self.imagePickerVC.allowsEditing = YES;
    if(self.userImage!=nil){
        [self.profilePicImageButton setImage:self.userImage forState:self.profilePicImageButton.state];
    }
    
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        self.imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        NSLog(@"Camera Not available.");
        self.imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    [self.activityIndicatorView setType:DGActivityIndicatorAnimationTypeLineScale];
    [self.activityIndicatorView setTintColor:[UIColor colorWithHexString:@"1B3E5F" withAlpha:1.00]];
    [self.activityIndicatorView setSize:50.0];
    
}


- (IBAction)didTapDeletePrifilePic:(id)sender {
    self.userImage = nil;
    imageDidChange = YES;
    [self.profilePicImageButton setImage:[UIImage systemImageNamed:@"person.circle.fill"] forState:self.profilePicImageButton.state];
}


-(void)textViewDidEndEditing:(UITextView *)textView{
    if(self.bioTextView.text.length == 0){
        [self.addBioWatermarkLabel setHidden:NO];
    }
}


-(void)textViewDidBeginEditing:(UITextView *)textView{
    
    [self.addBioWatermarkLabel setHidden:YES];
    
}


- (IBAction)didTapScreen:(id)sender {
    [self.view endEditing:YES];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    //  UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    
    // Do something with the images (based on your use case)
    NSLog(@"Image Uploaded.");
    
    [self.profilePicImageButton setImage:editedImage forState:self.profilePicImageButton.state];
    self.userImage = editedImage;
    imageDidChange = YES;
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)didTapImageButton:(id)sender {
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *gallery = [UIAlertAction actionWithTitle:@"Gallery" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:self.imagePickerVC animated:YES completion:nil];
        }];
        [alert addAction:gallery];
        
        UIAlertAction *camera = [UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:self.imagePickerVC animated:YES completion:nil];
        }];
        [alert addAction:camera];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        
        [alert addAction:cancel];
        
        [self presentViewController:alert animated:YES completion:^{
            
        }];
    }
    else {
        NSLog(@"Camera NOT available.");
        self.imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:self.imagePickerVC animated:YES completion:nil];
    }
}


- (IBAction)didTapSave:(id)sender {
    self.saveButton.enabled = !self.saveButton.enabled;
    [self.activityIndicatorView setHidden:NO];
    [self.activityIndicatorView startAnimating];
    if(imageDidChange){
        [User updateUser:[User currentUser] withProfilePic:self.userImage withBio:self.bioTextView.text withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
            if(succeeded){
                NSLog(@"Succesfully posted image. %@", [User currentUser].profilePic);
                [self.activityIndicatorView setHidden:YES];
                [self.activityIndicatorView stopAnimating];
                [self toFeed];
            }else{
                NSLog(@"ERROR: %@", error.description);
            }
            self.saveButton.enabled = !self.saveButton.enabled;
        }];
    }else{
        [User currentUser].bio = self.bioTextView.text;
        [[User currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if(succeeded){
                [self.activityIndicatorView setHidden:YES];
                [self.activityIndicatorView stopAnimating];
                [self toFeed];
            }
            self.saveButton.enabled = !self.saveButton.enabled;
        }];
        
    }
}

- (IBAction)didTapSkip:(id)sender {
    [self toFeed];
}

-(void) toFeed{
    SceneDelegate *myDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    HomeFeedVC *feedViewController = [storyboard instantiateViewControllerWithIdentifier:@"AuthenticatedController"];
    
    myDelegate.window.alpha = 0.25;
    myDelegate.window.rootViewController = feedViewController;
    
    [UIView animateWithDuration:1 animations:^{
        myDelegate.window.alpha = 1;
    }];
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

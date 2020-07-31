//
//  CreateProfileVC.m
//  Music_Sharing_App
//
//  Created by Fabiola E. Robles Vega on 7/29/20.
//  Copyright © 2020 Fabiola E. Robles Vega. All rights reserved.
//

#import "CreateProfileVC.h"
#import "User.h"
#import "MBProgressHUD.h"
#import "SceneDelegate.h"
#import "HomeFeedVC.h"

@interface CreateProfileVC ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (strong, nonatomic) UIImagePickerController *imagePickerVC;
@property (weak, nonatomic) IBOutlet UILabel *addBioWatermarkLabel;


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
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        self.imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
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
    [self presentViewController:self.imagePickerVC animated:YES completion:nil];
}

- (IBAction)didTapSave:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if(self.userImage!=nil && imageDidChange){
        [User updateUser:[User currentUser] withProfilePic:self.userImage withBio:self.bioTextView.text withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
            if(succeeded){
                NSLog(@"Succesfully posted image.");
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self toFeed];
            }else{
                NSLog(@"ERROR: %@", error.description);
            }
        }];
    }else{
        [User currentUser].bio = self.bioTextView.text;
        [[User currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if(succeeded){
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self toFeed];
            }
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

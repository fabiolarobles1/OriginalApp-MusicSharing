//
//  ComposeVC.m
//  Music_Sharing_App
//
//  Created by Fabiola E. Robles Vega on 7/14/20.
//  Copyright © 2020 Fabiola E. Robles Vega. All rights reserved.
//

#import "ComposeVC.h"
#import "SceneDelegate.h"
#import "HomeFeedVC.h"
#import "Post.h"

@interface ComposeVC ()<UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIPickerView *genrePickerView;
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UIPickerView *moodPickerView;
@property (strong, nonatomic)NSMutableArray *genres;
@property (strong, nonatomic)NSMutableArray *moods;
@property (strong, nonatomic)Post *post;
@property (strong, nonatomic) UIImage *postImage;
@property (strong, nonatomic) NSString *mood;
@property (strong, nonatomic) NSString *genre;
@property (strong, nonatomic)UIImagePickerController *imagePickerVC;
@property (weak, nonatomic) IBOutlet UIButton *addPhotoButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *postButton;
@property (weak, nonatomic) IBOutlet UITextField *musicLinkField;
@property (weak, nonatomic) IBOutlet UITextField *captionField;

@end

@implementation ComposeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.genres = [NSMutableArray arrayWithObjects: @"Pop", @"Latin", @"Rock",@"R&B", @"House", @"Other", nil];
    self.moods = [NSMutableArray arrayWithObjects: @"Loving", @"Lazy", @"Happy",@"Sad", @"Relax", @"Other", nil];
    self.titleField.delegate = self;
    self.genrePickerView.delegate = self;
    self.genrePickerView.dataSource = self;
    self.moodPickerView.delegate = self;
    self.moodPickerView.dataSource = self;
    
    self.imagePickerVC = [UIImagePickerController new];
    self.imagePickerVC.delegate = self;
    self.imagePickerVC.allowsEditing = YES;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        self.imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        self.imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
}


- (IBAction)didTapPost:(id)sender {
    self.postButton.enabled = !self.postButton.enabled;
    [Post createUserPost:self.titleField.text withGenre:self.genre withMood:self.mood withLink:self.musicLinkField.text withCaption:self.captionField.text withImage:self.postImage withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded){
                      NSLog(@"Succesfully posted image.");
                      [self toFeed];
                  }
              }];
       NSLog(@"Tapping post.");
}


- (IBAction)didTapPicture:(id)sender {
   
    [self presentViewController:self.imagePickerVC animated:YES completion:nil];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
  //  UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];

    // Do something with the images (based on your use case)
    NSLog(@"IMAGE UPLOADED");
    [self.addPhotoButton setImage:editedImage forState:self.addPhotoButton.state];
    self.postImage = editedImage;
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSUInteger maxTittleLenght = [textField.text length] +[string length] - range.length;
    if(maxTittleLenght>30){
        self.titleField.textColor = [UIColor redColor];
    }else{
        self.titleField.textColor = [UIColor blackColor];
    }
    return maxTittleLenght<=30;
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if([pickerView.restorationIdentifier isEqualToString:@"moodPicker"]){
        return self.moods.count;
    }else{
        return self.genres.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if([pickerView.restorationIdentifier isEqualToString:@"moodPicker"]){
        return [NSString stringWithFormat:@"%@",self.moods[(long)row]];
    }else{
        return [NSString stringWithFormat:@"%@",self.genres[(long)row]];
    }
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if([pickerView.restorationIdentifier isEqualToString:@"moodPicker"]){
        self.mood= [self.moods objectAtIndex:row];
        self.moodPickerView.backgroundColor = [UIColor greenColor];
    }else{
        self.genre =[self.genres objectAtIndex:row];
        self.genrePickerView.backgroundColor = [UIColor greenColor];
    }
    
}

- (IBAction)didTapCancel:(id)sender {
    [self toFeed];
}

//-(void) viewWillAppear:(BOOL)animated{
//    self.view.alpha = 0.5;
//}
//
//-(void)viewDidAppear:(BOOL)animated{
//    [UIView animateWithDuration:.25 animations:^{
//                  self.view.alpha = 1;
//              }];
//}

-(void) toFeed{
    SceneDelegate *myDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    HomeFeedVC *feedViewController = [storyboard instantiateViewControllerWithIdentifier:@"HomeFeedController"];
    
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

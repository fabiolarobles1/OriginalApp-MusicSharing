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
#import "SpotifyManager.h"

@interface ComposeVC ()<UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIPickerView *genrePickerView;
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UIPickerView *moodPickerView;
@property (strong, nonatomic)NSMutableArray *moods;
@property (strong, nonatomic)Post *post;
@property (strong, nonatomic) UIImage *postImage;
@property (strong, nonatomic) NSString *mood;
@property (strong, nonatomic) NSString *genre;
@property (strong, nonatomic)UIImagePickerController *imagePickerVC;
@property (weak, nonatomic) IBOutlet UIButton *addPhotoButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *postButton;
@property (weak, nonatomic) IBOutlet UITextField *musicLinkField;
@property (weak, nonatomic) IBOutlet UITextView *captionField;
@property (weak, nonatomic) IBOutlet UIButton *selectGenreButton;
@property (weak, nonatomic) IBOutlet UIButton *selectMoodButton;


@end

@implementation ComposeVC
-(void)viewWillAppear:(BOOL)animated{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.captionField.layer.borderWidth = 1.0;
    self.captionField.layer.cornerRadius = 5;
    self.captionField.layer.borderColor =[[UIColor grayColor] CGColor];
    [[SpotifyManager shared] getGenres:self.delegate.sessionManager.session.accessToken completion:^(NSDictionary *genres, NSError *error) {
        if(!error){
            self.genres =[[NSMutableArray alloc]initWithArray:genres[@"genres"]];
            NSLog(@"finally: %@", self.genres);
            
        }else{
            NSLog(@"SUPER ERROR: %@", error);
        }
    }];
    
    self.moods = [NSMutableArray arrayWithObjects: @"Active",@"Bored", @"Chill", @"Happy", @"Lazy", @"Loving",@"Sad", @"Relax", @"Other", nil];
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
- (IBAction)didTapScreen:(id)sender {
   [self.view endEditing:YES];
}


- (IBAction)didTapPost:(id)sender {
    NSLog(@"Tapping post.");
//    if(self.postImage==nil){
//        self.postImage = [UIImage imageNamed:@"camera.circle.fill"];
//    }
    self.postButton.enabled = !self.postButton.enabled;
    [Post createUserPost:self.titleField.text withGenre:self.genre withMood:self.mood withLink:self.musicLinkField.text withCaption:self.captionField.text withImage:self.postImage withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded){
                      NSLog(@"Succesfully posted image.");
                      [self toFeed];
                  }
              }];
}


- (IBAction)didTapPicture:(id)sender {
   
    [self presentViewController:self.imagePickerVC animated:YES completion:nil];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
  //  UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];

    // Do something with the images (based on your use case)
    NSLog(@"Image Uploaded.");
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
        [self.moodPickerView setHidden:YES];
        [self.selectMoodButton setTitle:self.mood.capitalizedString forState:self.selectMoodButton.state];
        [self.selectMoodButton setHidden:NO];
        [self.selectGenreButton setHidden:NO];
    }else{
        self.genre =[self.genres objectAtIndex:row];
        [self.genrePickerView setHidden:YES];
        [self.selectGenreButton setTitle:self.genre.capitalizedString forState:self.selectGenreButton.state];
        [self.selectGenreButton setHidden:NO];
        [self.selectMoodButton setHidden:NO];
       
    }
    
}

- (IBAction)didTapCancel:(id)sender {
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
- (IBAction)didTapSelectGenre:(id)sender {
    [self.genrePickerView reloadAllComponents];
    [self.genrePickerView setHidden:NO];
    [self.selectGenreButton setHidden:YES];
    [self.selectMoodButton setHidden:YES];
}
- (IBAction)didTapSelectMood:(id)sender {
    [self.moodPickerView reloadAllComponents];
    [self.moodPickerView setHidden:NO];
    [self.selectMoodButton setHidden:YES];
    [self.selectGenreButton setHidden:YES];
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

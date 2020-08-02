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
#import "MBProgressHUD.h"

@interface ComposeVC ()<UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIPickerView *genrePickerView;
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UIPickerView *moodPickerView;
@property (strong, nonatomic) IBOutlet UIView *fullView;
@property (strong, nonatomic) NSMutableArray *moods;
@property (strong, nonatomic) Post *post;
@property (strong, nonatomic) UIImage *postImage;
@property (strong, nonatomic) NSString *mood;
@property (strong, nonatomic) NSString *genre;
@property (strong, nonatomic) UIImagePickerController *imagePickerVC;
@property (weak, nonatomic) IBOutlet UIButton *addPhotoButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *postButton;
@property (weak, nonatomic) IBOutlet UITextField *musicLinkField;
@property (weak, nonatomic) IBOutlet UITextView *captionField;
@property (weak, nonatomic) IBOutlet UIButton *selectGenreButton;
@property (weak, nonatomic) IBOutlet UIButton *selectMoodButton;

@property (nonatomic) CGFloat initialY;
@property (nonatomic) CGFloat offset;
@property (nonatomic) BOOL captionSelected;

@end

@implementation ComposeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerForKeyboardEvents];
    self.initialY = self.fullView.frame.origin.y;
    self.captionField.delegate = self;
    self.delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.captionField.layer.borderWidth = 1.0;
    self.captionField.layer.cornerRadius = 5;
    self.captionField.clipsToBounds = true;
    self.captionField.layer.borderColor =[[UIColor grayColor] CGColor];
    [[SpotifyManager shared] getGenres:self.delegate.sessionManager.session.accessToken completion:^(NSDictionary *genres, NSError *error) {
        if(!error){
            self.genres =[[NSMutableArray alloc]initWithArray:genres[@"genres"]];
            NSLog(@"finally: %@", self.genres);
            
        }else{
            NSLog(@"SUPER ERROR: %@", error);
        }
    }];
    
    
    //Do enum for moods
    self.moods = [NSMutableArray arrayWithObjects: @"Active",@"Bored", @"Chill", @"Happy",@"Hype", @"Lazy", @"Loving",@"Sad", @"Relax", @"Other", nil];
    
    self.titleField.delegate = self;
    self.genrePickerView.delegate = self;
    self.genrePickerView.dataSource = self;
    self.moodPickerView.delegate = self;
    self.moodPickerView.dataSource = self;
    
    self.imagePickerVC = [UIImagePickerController new];
    self.imagePickerVC.delegate = self;
    self.imagePickerVC.allowsEditing = YES;
    
}

-(NSString *)moodToString:(MusicSharingAppMood)mood{
    switch(mood){
        case  MusicSharingAppMoodActive:
            return @"Active";
        case  MusicSharingAppMoodBored:
            return @"Bored";
        case  MusicSharingAppMoodChill:
            return @"Chill";
        case  MusicSharingAppMoodHappy:
            return @"Happy";
        case  MusicSharingAppMoodHype:
            return @"Hype";
        case  MusicSharingAppMoodLazy:
            return @"Lazy";
        case  MusicSharingAppMoodLoving:
            return @"Loving";
        case  MusicSharingAppMoodSad:
            return @"Sad";
        case  MusicSharingAppMoodRelax:
            return @"Relax";
        case enum_count:
            return nil;
    }
}

- (IBAction)didTapScreen:(id)sender {
    [self.view endEditing:YES];
}


- (IBAction)didTapPost:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.postButton.enabled = !self.postButton.enabled;
    NSString *song = self.musicLinkField.text;
    if([song length]==71){
        song = [song substringWithRange:NSMakeRange(31, 22)];
        [[SpotifyManager shared] getSong:song accessToken:self.delegate.sessionManager.session.accessToken completion:^(NSDictionary * _Nonnull song, NSError * _Nonnull error) {
            if(error!=nil){
                
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Invalid Spotify Link" message:@"The link provided for the song on spotify is invalid. Please, try again with a valid SONG spotify link." preferredStyle:(UIAlertControllerStyleAlert)];
                
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    self.musicLinkField.text = @"";
                    
                }];
                
                [alert addAction:okAction];
                [self presentViewController:alert animated:YES completion:^{ }];
            }else{
                NSArray *artist = song[@"artists"];
                NSDictionary *insideArtists = artist[0];
                NSDictionary *songName = song[@"name"];
                NSDictionary *album = song[@"album"];
                NSDictionary *albumName = album[@"name"];
                NSArray *albumImage =album[@"images"];
                NSDictionary *image = albumImage[0];
                NSString *imageURL = [NSString stringWithFormat:@"%@", image[@"url"]];
                NSString *songID = [self.musicLinkField.text substringWithRange:NSMakeRange(31, 22)];
                NSString *songURI = [@"spotify:track:" stringByAppendingString:songID];
                
                [Post createUserPost:self.titleField.text withGenre:self.genre withMood:self.mood withLink:self.musicLinkField.text withCaption:self.captionField.text withImage:self.postImage withAlbum: [NSString stringWithFormat:@"%@",albumName] withAlbumCoverURLString:imageURL withSong:[NSString stringWithFormat:@"%@",songName] withArtist:[NSString stringWithFormat:@"%@",insideArtists[@"name"]] withSongURI:songURI withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
                    if(succeeded){
                        NSLog(@"Succesfully posted image.");
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        [self toFeed];
                    }
                    //IF ERROR
                }];
            }
        }];
    }else{
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Invalid Spotify Link" message:@"The link provided for the song on spotify is invalid. Please, try again with a valid SONG spotify link." preferredStyle:(UIAlertControllerStyleAlert)];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.musicLinkField.text = @"";
            
        }];
        
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    }
    
    NSLog(@"Tapping post.");
    self.postButton.enabled = !self.postButton.enabled;
    
}


- (IBAction)didTapPicture:(id)sender {
    
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
        return enum_count;
        // return self.moods.count;
    }else{
        return self.genres.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if([pickerView.restorationIdentifier isEqualToString:@"moodPicker"]){
        //  return [NSString stringWithFormat:@"%@",self.moods[(long)row]];
        return  [self moodToString:row];
    }else{
        
        //When user is not authorize it doesn't work!!!!
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


-(void)registerForKeyboardEvents{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}

-(void)keyboardWillShow:(NSNotification *) notification{
    NSDictionary* info = [notification userInfo];
    self.offset = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
}

-(void)keyboardWillHide:(NSNotification *)notification{
    
    self.fullView.frame = CGRectMake(self.fullView.frame.origin.x, self.initialY , self.fullView.frame.size.width, self.fullView.frame.size.height);
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    
    [UIView animateWithDuration:.5 animations:^{
        self.fullView.frame = CGRectMake(self.fullView.frame.origin.x, self.initialY - self.offset/2, self.fullView.frame.size.width, self.fullView.frame.size.height);
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

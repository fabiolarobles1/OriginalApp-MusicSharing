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
#import "DGActivityIndicatorView.h"
#import <ChameleonFramework/Chameleon.h>

@interface ComposeVC ()<UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIPickerView *genrePickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *moodPickerView;
@property (strong, nonatomic) IBOutlet UIView *fullView;
@property (weak, nonatomic) IBOutlet UIButton *addPhotoButton;
@property (weak, nonatomic) IBOutlet UITextField *musicLinkField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *postButton;
@property (weak, nonatomic) IBOutlet UITextView *captionField;
@property (weak, nonatomic) IBOutlet UIButton *selectGenreButton;
@property (weak, nonatomic) IBOutlet UIButton *selectMoodButton;
@property (weak, nonatomic) IBOutlet UILabel *addCaptionLabel;
@property (weak, nonatomic) IBOutlet DGActivityIndicatorView *activityIndicatorView;

@property (strong, nonatomic) UIImagePickerController *imagePickerVC;
@property (strong, nonatomic) Post *post;
@property (strong, nonatomic) UIImage *postImage;
@property (strong, nonatomic) NSString *mood;
@property (strong, nonatomic) NSString *genre;

@property (nonatomic) BOOL captionSelected;
@property (nonatomic) CGFloat initialY;
@property (nonatomic) CGFloat offset;

@end

@implementation ComposeVC

-(void)viewWillAppear:(BOOL)animated{
    if(self.songURL){
        self.musicLinkField.text = self.songURL;
    }
    //requesting available genres in Spotify
    [[SpotifyManager shared] getGenres:self.delegate.sessionManager.session.accessToken completion:^(NSDictionary *genres, NSError *error) {
        if(!error){
            self.genres =[[NSMutableArray alloc]initWithArray:genres[@"genres"]];
            NSLog(@"Genres: %@", self.genres);
        }else{
            NSLog(@"Error loading genres: %@", error);
        }
    }];
    
    [self.activityIndicatorView setType:DGActivityIndicatorAnimationTypeLineScale];
    [self.activityIndicatorView setTintColor:[UIColor colorWithHexString:@"1B3E5F" withAlpha:1.00]];
    [self.activityIndicatorView setSize:50.0];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerForKeyboardEvents];
    
    //making some UI changes
    self.initialY = self.fullView.frame.origin.y;
    self.captionField.layer.borderWidth = 1.0;
    self.captionField.layer.cornerRadius = 5;
    self.captionField.clipsToBounds = true;
    self.captionField.layer.borderColor =[[UIColor lightGrayColor] CGColor];
    
    //setting up delegates
    self.captionField.delegate = self;
    self.genrePickerView.delegate = self;
    self.genrePickerView.dataSource = self;
    self.moodPickerView.delegate = self;
    self.moodPickerView.dataSource = self;
    self.delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    //setting image picker for post optional image
    self.imagePickerVC = [UIImagePickerController new];
    self.imagePickerVC.delegate = self;
    self.imagePickerVC.allowsEditing = YES;
}

/**
 *Returns String value of mood
 */
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
    //dismiss keyboard when tapping screen
    [self.view endEditing:YES];
}

/**
 *Cancel post
 */
- (IBAction)didTapCancel:(id)sender {
    [self toFeed];
}


-(void)invalidLinkAlert{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Invalid Spotify Link" message:@"The link provided for the song on spotify is invalid. Please, try again with a valid SONG spotify link." preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.musicLinkField.text = @"";
    }];
    [alert addAction:okAction];
    
    [self presentViewController:alert animated:YES completion:^{
        [self.activityIndicatorView setHidden:YES];
        [self.activityIndicatorView stopAnimating];
    }];
}


- (IBAction)didTapPost:(id)sender {
    [self.activityIndicatorView setHidden:NO];
    [self.activityIndicatorView startAnimating];
    [self.view endEditing:YES];
    NSString *song = self.musicLinkField.text;
    //avoiding multiple posting of same post
    self.postButton.enabled = !self.postButton.enabled;
    
    if([self.mood length]==0 || [self.genre length]==0 || [self.musicLinkField.text length]==0){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Required Fields." message:@"Mood, Genre, and Spotify Link are required for a post. Please, complete all required fields." preferredStyle:(UIAlertControllerStyleAlert)];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alert addAction:okAction];
        
        [self presentViewController:alert animated:YES completion:^{
            [self.activityIndicatorView setHidden:YES];
            [self.activityIndicatorView stopAnimating];
            self.postButton.enabled = !self.postButton.enabled;
        }];
    }
    //validating link
    else if([song length]>=53 &&([[song substringToIndex:31] isEqualToString:@"https://open.spotify.com/track/"])){
        song = [song substringWithRange:NSMakeRange(31, 22)];
        [[SpotifyManager shared] getSong:song accessToken:self.delegate.sessionManager.session.accessToken completion:^(NSDictionary * _Nonnull song, NSError * _Nonnull error) {
            if(error!=nil){
                [self invalidLinkAlert];
                self.postButton.enabled = !self.postButton.enabled;
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
                
                [Post createUserPost:self.genre withMood:self.mood withLink:self.musicLinkField.text withCaption:self.captionField.text withImage:self.postImage withAlbum: [NSString stringWithFormat:@"%@",albumName] withAlbumCoverURLString:imageURL withSong:[NSString stringWithFormat:@"%@",songName] withArtist:[NSString stringWithFormat:@"%@",insideArtists[@"name"]] withSongURI:songURI withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
                    if(succeeded){
                        NSLog(@"Succesfully posted image.");
                        [self.activityIndicatorView setHidden:YES];
                        [self.activityIndicatorView stopAnimating];
                        [self toFeed];
                    }else if(error){
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"An error occurred while posting." preferredStyle:(UIAlertControllerStyleAlert)];
                        
                        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        }];
                        [alert addAction:okAction];
                        
                        [self presentViewController:alert animated:YES completion:^{
                            [self.activityIndicatorView setHidden:YES];
                            [self.activityIndicatorView stopAnimating];
                        }];
                    }
                    self.postButton.enabled = !self.postButton.enabled;
                }];
            }
        }];
        
    }else{
        [self invalidLinkAlert];
        self.postButton.enabled = !self.postButton.enabled;
    }
    
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
    // UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    
    // Do something with the images (based on your use case)
    NSLog(@"Image Uploaded.");
    [self.addPhotoButton setImage:editedImage forState:self.addPhotoButton.state];
    self.postImage = editedImage;
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
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
        self.mood= [self moodToString:row];
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


-(void)registerForKeyboardEvents{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}


-(void)keyboardWillShow:(NSNotification *) notification{
    NSDictionary* info = [notification userInfo];
    self.offset = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
}


-(void)keyboardWillHide:(NSNotification *)notification{
    self.fullView.frame = CGRectMake(self.fullView.frame.origin.x, self.initialY + self.offset/4, self.fullView.frame.size.width, self.fullView.frame.size.height);
    
}


-(void)textViewDidBeginEditing:(UITextView *)textView{
    [self.addCaptionLabel setHidden:YES];
    [UIView animateWithDuration:.5 animations:^{
        self.fullView.frame = CGRectMake(self.fullView.frame.origin.x, self.initialY - self.offset/2, self.fullView.frame.size.width, self.fullView.frame.size.height);
    }];
}


-(void)textViewDidEndEditing:(UITextField *)textField{
    if([[self.captionField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0){
        [self.addCaptionLabel setHidden:NO];
    }
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

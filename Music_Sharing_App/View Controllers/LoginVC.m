//
//  LoginVC.m
//  Music_Sharing_App
//
//  Created by Fabiola E. Robles Vega on 7/13/20.
//  Copyright © 2020 Fabiola E. Robles Vega. All rights reserved.
//

#import "LoginVC.h"
#import <Parse/Parse.h>
#import "SpotifyManager.h"
#import "User.h"
#import "Chameleon.h"
#import "DGActivityIndicatorView.h"

@interface LoginVC ()
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (weak, nonatomic) IBOutlet DGActivityIndicatorView *activityIndicatorView;

@end

@implementation LoginVC


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.passwordField setSecureTextEntry:YES];
    self.loginButton.layer.cornerRadius = self.loginButton.frame.size.height/2;
    self.signUpButton.layer.cornerRadius = self.signUpButton.frame.size.height/2;
    [self.activityIndicatorView setType:DGActivityIndicatorAnimationTypeLineScale];
    [self.activityIndicatorView setTintColor:[UIColor colorWithHexString:@"1B3E5F" withAlpha:1.00]];
    [self.activityIndicatorView setSize:50.0];
}

/**
 *Logs in a user in the backgroud
 */
-(void) loginUser{
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * _Nullable user, NSError * _Nullable error) {
        if(error != nil){
            NSLog(@"User login failed : %@" , error.description);
            UIAlertController *alert = [[UIAlertController alloc]init];
            if(error.code == 101){
                alert = [UIAlertController alertControllerWithTitle:@"Invalid username/password" message:@"The username and password do not match. Try again." preferredStyle:(UIAlertControllerStyleAlert)];
            }else{
                alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"An error ocurred while trying to login. Please, try again later." preferredStyle:(UIAlertControllerStyleAlert)];
            }
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                self.usernameField.text = @"";
                self.passwordField.text = @"";
            }];
            
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:^{ }];
            
        }else{
            NSLog(@"User logged in successfully.");
            [self performSegueWithIdentifier:@"toFeedSegue" sender:nil];
        }
        
        [self.loginButton setHidden:NO];
        [self.activityIndicatorView setHidden:YES];
        [self.activityIndicatorView stopAnimating];
    }];
}


- (IBAction)didTapScreen:(id)sender {
    //dismiss keyboard when screen is tapped
    [self.view endEditing:YES];
}


- (IBAction)didTapLoginButton:(id)sender {
    [self.view endEditing:YES];
    [self.loginButton setHidden:YES];
    [self.activityIndicatorView setHidden:NO];
    [self.activityIndicatorView startAnimating];
    //check required fields to login
    if (!self.usernameField.hasText || !self.passwordField.hasText ){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Required Fields" message:@"Username and password are required to login. Please fill out all the information." preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) { }];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:^{ }];
        [self.loginButton setHidden:NO];
        [self.activityIndicatorView setHidden:YES];
        [self.activityIndicatorView stopAnimating];
    }else{
        [self loginUser];
    }
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

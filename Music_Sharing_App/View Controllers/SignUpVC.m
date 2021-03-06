//
//  SignUpVC.m
//  Music_Sharing_App
//
//  Created by Fabiola E. Robles Vega on 7/13/20.
//  Copyright © 2020 Fabiola E. Robles Vega. All rights reserved.
//

#import "SignUpVC.h"
#import "LoginVC.h"
#import "SceneDelegate.h"
#import <Parse/Parse.h>
#import "User.h"

@interface SignUpVC ()
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordField;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;

@end

@implementation SignUpVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.passwordField setSecureTextEntry:YES];
    [self.confirmPasswordField setSecureTextEntry:YES];
    self.signUpButton.layer.cornerRadius = self.signUpButton.frame.size.height/2;
}


/**
 *Registers a new user account
 */
-(void) registerUser{
    
    //initializing user
    User *newUser = [User new];
    
    //setting up properties
    newUser.username = self.usernameField.text;
    
    if(![self.passwordField.text isEqual:self.confirmPasswordField.text]){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Invalid Password Confirmation" message:@"Please, your confirmation password must be equal to your password to complete the register." preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.passwordField.text = @"";
            self.confirmPasswordField.text = @"";
        }];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:^{ }];
        
    }else if([[self.passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Empty Password" message:@"Password cannot be whitespaces only, please insert a valid password." preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.passwordField.text = @"";
            self.confirmPasswordField.text = @"";
        }];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:^{ }];
        
    }else{
        newUser.password = self.passwordField.text;
        
        //call sign up function on the object
        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if(error !=nil){
                NSLog(@"Sign up user error: %@", error.description);
                
                if(error.code == 202){
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Invalid Username" message:@"The username is already taken. Please, try anpther one." preferredStyle:(UIAlertControllerStyleAlert)];
                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        self.usernameField.text = @"";
                    }];
                    [alert addAction:okAction];
                    [self presentViewController:alert animated:YES completion:^{ }];
                }
            }else{
                [self performSegueWithIdentifier:@"createProfile" sender:nil];
            }
        }];
    }
}


- (IBAction)didTapSignUp:(id)sender {
    
    //checks required fields
    if (!self.usernameField.hasText || !self.passwordField.hasText || !self.confirmPasswordField ){
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Required Fields" message:@" Username and password are required to create an account. Please fill all the information." preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) { }];
        [alert addAction:okAction];
        
        [self presentViewController:alert animated:YES completion:^{ }];
        
    }else{
        [self registerUser];
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

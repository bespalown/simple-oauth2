//
//  ViewController.m
//  Simple-OAuth2
//
//  Created by Christian Hansen on 08/11/12.
//  Copyright (c) 2012 Lifebeat. All rights reserved.
//

#import "ViewController.h"
#import "GTMOAuth2Authentication.h"
#import "GTMOAuth2ViewControllerTouch.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self signInToGoogle];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//Creat your Google APP here: https://code.google.com/apis/console/ and get the key and secret

#define GoogleClientID    @"YOUR CLIENT ID"
#define GoogleClientSecret @"YOUR CLIENT SECRET"
#define GoogleAuthURL   @"https://accounts.google.com/o/oauth2/auth"
#define GoogleTokenURL  @"https://accounts.google.com/o/oauth2/token"


- (GTMOAuth2Authentication * )authForGoogle
{
    //This URL is defined by the individual 3rd party APIs, be sure to read their documentation
    
    NSURL * tokenURL = [NSURL URLWithString:GoogleTokenURL];
    // We'll make up an arbitrary redirectURI.  The controller will watch for
    // the server to redirect the web view to this URI, but this URI will not be
    // loaded, so it need not be for any actual web page. This needs to match the URI set as the
    // redirect URI when configuring the app with Instagram.
    NSString * redirectURI = @"urn:ietf:wg:oauth:2.0:oob";
    GTMOAuth2Authentication * auth;
    
    auth = [GTMOAuth2Authentication authenticationWithServiceProvider:@"lifebeat"
                                                             tokenURL:tokenURL
                                                          redirectURI:redirectURI
                                                             clientID:GoogleClientID
                                                         clientSecret:GoogleClientSecret];
    auth.scope = @"https://www.googleapis.com/auth/userinfo.profile";
    return auth;
}


- (void)signInToGoogle
{
    GTMOAuth2Authentication * auth = [self authForGoogle];

    // Display the authentication view
    GTMOAuth2ViewControllerTouch * viewController = [[GTMOAuth2ViewControllerTouch alloc] initWithAuthentication:auth
                                                                                                authorizationURL:[NSURL URLWithString:GoogleAuthURL]
                                                                                                keychainItemName:@"GoogleKeychainName"
                                                                                                        delegate:self
                                                                                                finishedSelector:@selector(viewController:finishedWithAuth:error:)];
    [self.navigationController pushViewController:viewController animated:YES];
}


- (void)viewController:(GTMOAuth2ViewControllerTouch * )viewController
      finishedWithAuth:(GTMOAuth2Authentication * )auth
                 error:(NSError * )error
{
    NSLog(@"finished");
    NSLog(@"auth access token: %@", auth.accessToken);
    
    [self.navigationController popToViewController:self animated:NO];
    if (error != nil) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error Authorizing with Google"
                                                         message:[error localizedDescription]
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
        [alert show];
    } else {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Success Authorizing with Google"
                                                         message:[error localizedDescription]
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
        [alert show];
    }
}

@end

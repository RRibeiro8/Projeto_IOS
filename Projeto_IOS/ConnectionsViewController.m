//
//  ConnectionsViewController.m
//  Projeto_IOS
//
//  Created by RRibeiro on 13/01/17.
//  Copyright © 2017 RRibeiro. All rights reserved.
//

#import "ConnectionsViewController.h"
#import "AppDelegate.h"

@interface ConnectionsViewController ()

    @property (nonatomic, strong) AppDelegate *appDelegate;

@end

@implementation ConnectionsViewController

    - (void)viewDidLoad
    {
        [super viewDidLoad];
    
        _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [[_appDelegate mcManager] setupPeerAndSessionWithDisplayName:[UIDevice currentDevice].name];
        [[_appDelegate mcManager] advertiseSelf:_swVisible.isOn];
        [_txtName setDelegate:self];
    }

    -(BOOL)textFieldShouldReturn:(UITextField *)textField{
        [_txtName resignFirstResponder];
    
        _appDelegate.mcManager.peerID = nil;
        _appDelegate.mcManager.session = nil;
        _appDelegate.mcManager.browser = nil;
        
        if ([_swVisible isOn]) {
            [_appDelegate.mcManager.advertiser stop];
        }
        _appDelegate.mcManager.advertiser = nil;
    
    
        [_appDelegate.mcManager setupPeerAndSessionWithDisplayName:_txtName.text];
        [_appDelegate.mcManager setupMCBrowser];
        [_appDelegate.mcManager advertiseSelf:_swVisible.isOn];
    
        return YES;
    }

    - (void)didReceiveMemoryWarning {
        [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
    }

    - (IBAction)toggleVisibility:(id)sender {
        [_appDelegate.mcManager advertiseSelf:_swVisible.isOn];
    }

    - (IBAction)browseForDevices:(id)sender {
        [[_appDelegate mcManager] setupMCBrowser];
        [[[_appDelegate mcManager] browser] setDelegate:self];
        [self presentViewController:[[_appDelegate mcManager] browser] animated:YES completion:nil];
    }

    -(void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController{
        [_appDelegate.mcManager.browser dismissViewControllerAnimated:YES completion:nil];
    }


    -(void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController{
        [_appDelegate.mcManager.browser dismissViewControllerAnimated:YES completion:nil];
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

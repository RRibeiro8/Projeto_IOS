//
//  FirstViewController.m
//  Projeto_IOS
//
//  Created by RRibeiro on 13/01/17.
//  Copyright © 2017 RRibeiro. All rights reserved.
//

#import "FirstViewController.h"
#import "AppDelegate.h"

@interface FirstViewController ()

    @property (nonatomic, strong) AppDelegate *appDelegate;

    -(void)sendMyMessage;

    -(void)didReceiveDataWithNotification:(NSNotification *)notification;

@end

@implementation FirstViewController

    - (void)viewDidLoad {
        [super viewDidLoad];
        // Do any additional setup after loading the view, typically from a nib.
        
        _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        _txtMessage.delegate = self;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didReceiveDataWithNotification:)
                                                     name:@"MCDidReceiveDataNotification"
                                                   object:nil];
    }

    -(void)didReceiveDataWithNotification:(NSNotification *)notification{
        MCPeerID *peerID = [[notification userInfo] objectForKey:@"peerID"];
        NSString *peerDisplayName = peerID.displayName;
        
        NSData *receivedData = [[notification userInfo] objectForKey:@"data"];
        NSString *receivedText = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    
        [_tvChat performSelectorOnMainThread:@selector(setText:) withObject:[_tvChat.text stringByAppendingString:[NSString stringWithFormat:@"%@ wrote:\n%@\n\n", peerDisplayName, receivedText]] waitUntilDone:NO];
    }

    -(void)sendMyMessage{
        NSData *dataToSend = [_txtMessage.text dataUsingEncoding:NSUTF8StringEncoding];
        NSArray *allPeers = _appDelegate.mcManager.session.connectedPeers;
        NSError *error;
    
        [_appDelegate.mcManager.session sendData:dataToSend
                                     toPeers:allPeers
                                    withMode:MCSessionSendDataReliable
                                       error:&error];
    
        if (error) {
            NSLog(@"%@", [error localizedDescription]);
        }
    
        [_tvChat setText:[_tvChat.text stringByAppendingString:[NSString stringWithFormat:@"I wrote:\n%@\n\n", _txtMessage.text]]];
        [_txtMessage setText:@""];
        [_txtMessage resignFirstResponder];
    }

    -(BOOL)textFieldShouldReturn:(UITextField *)textField{
        [self sendMyMessage];
        return YES;
    }

    - (IBAction)sendMessage:(id)sender {
        [self sendMyMessage];
    }

    - (IBAction)cancelMessage:(id)sender {
        [_txtMessage resignFirstResponder];
    }

    - (void)didReceiveMemoryWarning {
        [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
    }

@end

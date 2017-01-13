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

    -(void)peerDidChangeStateWithNotification:(NSNotification *)notification;

    @property (nonatomic, strong) NSMutableArray *arrConnectedDevices;

@end

@implementation ConnectionsViewController

    - (void)viewDidLoad
    {
        [super viewDidLoad];
    
        _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [[_appDelegate mcManager] setupPeerAndSessionWithDisplayName:[UIDevice currentDevice].name];
        [[_appDelegate mcManager] advertiseSelf:_swVisible.isOn];
        
        [_txtName setDelegate:self];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(peerDidChangeStateWithNotification:)
                                                     name:@"MCDidChangeStateNotification"
                                                   object:nil];
        
        _arrConnectedDevices = [[NSMutableArray alloc] init];
        
        [_tblConnectedDevices setDelegate:self];
        [_tblConnectedDevices setDataSource:self];
    }

    -(void)peerDidChangeStateWithNotification:(NSNotification *)notification{
        MCPeerID *peerID = [[notification userInfo] objectForKey:@"peerID"];
        NSString *peerDisplayName = peerID.displayName;
        MCSessionState state = [[[notification userInfo] objectForKey:@"state"] intValue];
        
        if (state != MCSessionStateConnecting) {
            if (state == MCSessionStateConnected) {
                [_arrConnectedDevices addObject:peerDisplayName];
                
                [_tblConnectedDevices reloadData];
                
                BOOL peersExist = ([[_appDelegate.mcManager.session connectedPeers] count] == 0);
                [_btnDisconnect setEnabled:!peersExist];
                [_txtName setEnabled:peersExist];
            }
            else if (state == MCSessionStateNotConnected){
                if ([_arrConnectedDevices count] > 0) {
                    int indexOfPeer = [_arrConnectedDevices indexOfObject:peerDisplayName];
                    [_arrConnectedDevices removeObjectAtIndex:indexOfPeer];
                }
            }
        }
    }

    -(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
        return 1;
    }


    -(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        return [_arrConnectedDevices count];
    }


    -(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellIdentifier"];
        }
    
        cell.textLabel.text = [_arrConnectedDevices objectAtIndex:indexPath.row];
    
        return cell;
    }


    -(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        return 60.0;
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

    - (IBAction)disconnect:(id)sender {
        [_appDelegate.mcManager.session disconnect];
    
        _txtName.enabled = YES;
    
        [_arrConnectedDevices removeAllObjects];
        [_tblConnectedDevices reloadData];
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

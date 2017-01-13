//
//  ConnectionsViewController.h
//  Projeto_IOS
//
//  Created by RRibeiro on 13/01/17.
//  Copyright © 2017 RRibeiro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface ConnectionsViewController : UIViewController <MCBrowserViewControllerDelegate>

    @property (weak, nonatomic) IBOutlet UITextField *txtName; // for the sharing name definition
    @property (weak, nonatomic) IBOutlet UISwitch *swVisible; // for enable or disable visibility to other
    @property (weak, nonatomic) IBOutlet UITableView *tblConnectedDevices; // to show current connected peers
    @property (weak, nonatomic) IBOutlet UIButton *btnDisconnect; // for disconnecting a peer


    - (IBAction)browseForDevices:(id)sender;
    - (IBAction)toggleVisibility:(id)sender;
    - (IBAction)disconnect:(id)sender;

@end

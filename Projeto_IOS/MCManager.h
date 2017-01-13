//
//  MCManager.h
//  Projeto_IOS
//
//  Created by RRibeiro on 13/01/17.
//  Copyright © 2017 RRibeiro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface MCManager : NSObject <MCSessionDelegate>

    @property (nonatomic, strong) MCPeerID *peerID;// identifies the device
    @property (nonatomic, strong) MCSession *session;//session created by this peer
    @property (nonatomic, strong) MCBrowserViewController *browser; // default ui provided by apple
    @property (nonatomic, strong) MCAdvertiserAssistant *advertiser;//to advertise itself

    -(void)setupPeerAndSessionWithDisplayName:(NSString *)displayName;
    -(void)setupMCBrowser;
    -(void)advertiseSelf:(BOOL)shouldAdvertise;

@end

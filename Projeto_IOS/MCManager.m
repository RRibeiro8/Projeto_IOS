//
//  MCManager.m
//  Projeto_IOS
//
//  Created by RRibeiro on 13/01/17.
//  Copyright © 2017 RRibeiro. All rights reserved.
//

#import "MCManager.h"

@implementation MCManager

    -(id)init{
        self = [super init];
    
        if (self) {
            _peerID = nil;
            _session = nil;
            _browser = nil;
            _advertiser = nil;
        }
    
        return self;
    }

#pragma mark - Public method implementation

    -(void)setupPeerAndSessionWithDisplayName:(NSString *)displayName{
        _peerID = [[MCPeerID alloc] initWithDisplayName:displayName];
        
        _session = [[MCSession alloc] initWithPeer:_peerID];
        _session.delegate = self;
    }

    -(void)setupMCBrowser{
        _browser = [[MCBrowserViewController alloc] initWithServiceType:@"chat-files" session:_session];
    }

    -(void)advertiseSelf:(BOOL)shouldAdvertise{
        if (shouldAdvertise) {
            _advertiser = [[MCAdvertiserAssistant alloc] initWithServiceType:@"chat-files"
                                                           discoveryInfo:nil
                                                                 session:_session];
            [_advertiser start];
        }
        else{
            [_advertiser stop];
            _advertiser = nil;
        }
    }


#pragma mark - MCSession Delegate method implementation

    -(void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state{
    
    }


    -(void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID{
    
    }


    -(void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress{
    
    }


    -(void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error{
        
    }


    -(void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID{
    
    }

@end

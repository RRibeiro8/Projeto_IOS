//
//  ColorViewController.m
//  MCDemo
//
//  Created by horta on 1/18/17.
//  Copyright © 2017 Appcoda. All rights reserved.
//

#import "ColorViewController.h"
#import "AppDelegate.h"

@interface ColorViewController ()

@property (nonatomic, strong) AppDelegate *appDelegate;

-(void)changeColor:(NSString *)color;
-(void)changeBackground:(NSString *)color;
-(void)didReceiveDataWithNotification:(NSNotification *)notification;
@end

@implementation ColorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveDataWithNotification:)
                                                 name:@"MCDidReceiveDataNotification"
                                               object:nil];}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)changeColorGreen:(id)sender{
    [self changeColor:@"LimeGreen"];
    
}
- (IBAction)changeColorGold:(id)sender{
    [self changeColor:@"Gold"];
}

+ (UIColor*)LimeGreen {
    return [UIColor colorWithRed:154.0f/255.0f green:205.0f/255.0f blue:50.0f/255.0f alpha:1.0f];
}
+ (UIColor*)Gold {
    return [UIColor colorWithRed:218.0f/255.0f green:165.0f/255.0f blue:32.0f/255.0f alpha:1.0f];
}
#pragma mark - Private method implementation
-(void)changeColor:(NSString *)color{
    NSData *dataToSend = [color dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *allPeers = _appDelegate.mcManager.session.connectedPeers;
    NSError *error;
    
    [_appDelegate.mcManager.session sendData:dataToSend
                                     toPeers:allPeers
                                    withMode:MCSessionSendDataReliable
                                       error:&error];
    
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
}
-(void)changeBackground:(NSString *)color
{
    UIColor* selectedColor;
    if( [color isEqual:@"Gold"] )
    {
        selectedColor = [ColorViewController LimeGreen];
    }else
    {
        selectedColor = [ColorViewController Gold];
    }
    self.view.backgroundColor = selectedColor;
}

-(void)didReceiveDataWithNotification:(NSNotification *)notification{
    MCPeerID *peerID = [[notification userInfo] objectForKey:@"peerID"];
    NSString *peerDisplayName = peerID.displayName;
    
    NSData *receivedData = [[notification userInfo] objectForKey:@"data"];
    NSString *receivedText = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    
    [self changeBackground:receivedText];
    [_lastCommand performSelectorOnMainThread:@selector(setText:) withObject:[_lastCommand.text stringByAppendingString:[NSString stringWithFormat:@"%@ wrote:\n%@\n\n", peerDisplayName, receivedText]] waitUntilDone:NO];
}
@end

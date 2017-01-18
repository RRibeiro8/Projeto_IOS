//
//  FirstViewController.m
//  MCDemo
//
//  Created by RRibeiro on 13/01/17.
//  Copyright © 2017 RRibeiro. All rights reserved.
//

#import "FirstViewController.h"
#import "AppDelegate.h"
#import <CoreData/CoreData.h>

@interface FirstViewController ()

@property (nonatomic, strong) AppDelegate *appDelegate;


-(void)sendMyMessage;
-(void)didReceiveDataWithNotification:(NSNotification *)notification;

@end

@implementation FirstViewController


NSArray *messages;

- (void)loadCoreData
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* context = appDelegate.managedObjectContext;
    
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Message"
                                                  inManagedObjectContext:context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    
    // NSPredicate *pred =
    // [NSPredicate predicateWithFormat:@"(name = %@)",
    //  _name.text];
    //[request setPredicate:pred];
    
    NSError *error;
    messages = [context executeFetchRequest:request
                                              error:&error];
    [self.tableView reloadData];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    _txtMessage.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveDataWithNotification:)
                                                 name:@"MCDidReceiveDataNotification"
                                               object:nil];
    [self loadCoreData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UITableviewdelegate Delegate method implementation

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        return [messages count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
    }
    
    NSManagedObject *matches = nil;
    
    if ([messages count] != 0)  {
        matches = [messages objectAtIndex:indexPath.row];
        cell.textLabel.text = [matches valueForKey:@"msg"];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"From: %@ @  %@", [matches valueForKey:@"from"] , [NSDateFormatter localizedStringFromDate:[matches valueForKey:@"when"]
                                                                                                                                        dateStyle:NSDateFormatterShortStyle
                                                                                                            timeStyle:NSDateFormatterFullStyle]];
    }
    return cell;
}
#pragma mark - UITextField Delegate method implementation

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self sendMyMessage];
    return YES;
}


#pragma mark - IBAction method implementation

- (IBAction)sendMessage:(id)sender {
    [self sendMyMessage];
}

- (IBAction)cancelMessage:(id)sender {
    [_txtMessage resignFirstResponder];
}


#pragma mark - Private method implementation
- (void)saveMessage:(NSString *)from :(NSString *)msg
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* context = appDelegate.managedObjectContext;
    
    NSManagedObject *newMsg;
    newMsg = [NSEntityDescription
              insertNewObjectForEntityForName:@"Message"
              inManagedObjectContext:context];
    [newMsg setValue: from forKey:@"from"];
    [newMsg setValue: msg forKey:@"msg"];
    [newMsg setValue: [NSDate date] forKey:@"when"];
    NSError *error;
    [context save:&error];
}

-(void)sendMyMessage{
    NSData *dataToSend = [_txtMessage.text dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *allPeers = _appDelegate.mcManager.session.connectedPeers;
    NSError *error;
    
    [_appDelegate.mcManager.session sendData:dataToSend
                                     toPeers:allPeers
                                    withMode:MCSessionSendDataReliable
                                       error:&error];
    [self saveMessage:@"Me" : _txtMessage.text];
    [self loadCoreData];
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
    
    //[_tvChat setText:[_tvChat.text stringByAppendingString:[NSString stringWithFormat:@"I wrote:\n%@\n\n", _txtMessage.text]]];
    [_txtMessage setText:@""];
    [_txtMessage resignFirstResponder];
}


-(void)didReceiveDataWithNotification:(NSNotification *)notification{
    MCPeerID *peerID = [[notification userInfo] objectForKey:@"peerID"];
    NSString *peerDisplayName = peerID.displayName;
    
    NSData *receivedData = [[notification userInfo] objectForKey:@"data"];
    NSString *receivedText = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    
    [self saveMessage: peerDisplayName : receivedText];
    [self loadCoreData];
    //[_tvChat performSelectorOnMainThread:@selector(setText:) withObject:[_tvChat.text stringByAppendingString:[NSString stringWithFormat:@"%@ wrote:\n%@\n\n", peerDisplayName, receivedText]] waitUntilDone:NO];
}

@end

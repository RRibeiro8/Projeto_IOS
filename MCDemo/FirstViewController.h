//
//  FirstViewController.h
//  MCDemo
//
//  Created by RRibeiro on 13/01/17.
//  Copyright © 2017 RRibeiro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *txtMessage;
@property (weak, nonatomic) IBOutlet UITextView *tvChat;


- (IBAction)sendMessage:(id)sender;
- (IBAction)cancelMessage:(id)sender;


@end

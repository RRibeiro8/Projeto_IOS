//
//  ColorViewController.h
//  MCDemo
//
//  Created by horta on 1/18/17.
//  Copyright © 2017 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ColorViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *lastCommand;

- (IBAction)changeColorGreen:(id)sender;
- (IBAction)changeColorGold:(id)sender;
+ (UIColor *)LimeGreen;
+ (UIColor *)Gold;
@end

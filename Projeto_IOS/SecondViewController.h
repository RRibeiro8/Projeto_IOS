//
//  SecondViewController.h
//  Projeto_IOS
//
//  Created by RRibeiro on 13/01/17.
//  Copyright © 2017 RRibeiro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate>

    @property (weak, nonatomic) IBOutlet UITableView *tblFiles;

@end


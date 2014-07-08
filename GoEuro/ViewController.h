//
//  ViewController.h
//  GoEuro
//
//  Created by Muneer KK on 07/07/14.
//  Copyright (c) 2014 Muneer KK. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CustomTableViewDelegate;
@interface ViewController : UIViewController<UITextFieldDelegate,CustomTableViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *startTextField;
@property (weak, nonatomic) IBOutlet UITextField *endTextField;
- (IBAction)dateButtonPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UIButton *dateButton;
- (IBAction)searchButtonPressed:(id)sender;




@end

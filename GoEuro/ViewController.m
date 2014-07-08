//
//  ViewController.m
//  GoEuro
//
//  Created by Muneer KK on 07/07/14.
//  Copyright (c) 2014 Muneer KK. All rights reserved.
//

#import "ViewController.h"
#import "AFHTTPRequestOperation.h"
#import "AFNetworking.h"
#import "CustomTableView.h"

@interface ViewController ()
@property(nonatomic,strong) UIDatePicker *datePicker;
@property(nonatomic,strong) NSMutableArray *locationArray;
@property (nonatomic, strong) CustomTableView *autoCompleterforStartTextField;
@property (nonatomic, strong) CustomTableView *autoCompleterforEndTextField;

@end

@implementation ViewController
@synthesize autoCompleterforEndTextField = _autoCompleterforEndTextField;
@synthesize autoCompleterforStartTextField = _autoCompleterforStartTextField;

- (CustomTableView *)autoCompleter
{
    if (!_autoCompleterforEndTextField)
    {
        NSMutableDictionary *options = [NSMutableDictionary dictionaryWithCapacity:2];
        [options setValue:[NSNumber numberWithBool:YES] forKey:CaseSensitive];
        [options setValue:nil forKey:UseSourceFont];
        
        _autoCompleterforEndTextField = [[CustomTableView alloc] initWithTextField:self.endTextField inViewController:self withOptions:options];
        _autoCompleterforEndTextField.autoCompleteDelegate = self;
        _autoCompleterforEndTextField.suggestionsDictionary = nil;
    }
    return _autoCompleterforEndTextField;
}
- (CustomTableView *)autoCompleter1
{
    if (!_autoCompleterforStartTextField)
    {
        NSMutableDictionary *options = [NSMutableDictionary dictionaryWithCapacity:2];
        [options setValue:[NSNumber numberWithBool:YES] forKey:CaseSensitive];
        [options setValue:nil forKey:UseSourceFont];
        
        _autoCompleterforStartTextField = [[CustomTableView alloc] initWithTextField:self.startTextField inViewController:self withOptions:options];
        _autoCompleterforStartTextField.autoCompleteDelegate = self;
        _autoCompleterforStartTextField.suggestionsDictionary =  nil;
    }
    return _autoCompleterforStartTextField;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 250, 325, 300)];
	self.datePicker.datePickerMode = UIDatePickerModeDate;
	self.datePicker.hidden = YES;
	self.datePicker.date = [NSDate date];
    
	[self.datePicker addTarget:self
	               action:@selector(dateButtonPressed:)
	     forControlEvents:UIControlEventValueChanged];
	[self.view addSubview:self.datePicker];
    
    [self.datePicker setMinimumDate:[NSDate date]];
    self.endTextField.delegate = self;
    self.startTextField.delegate = self;
    
    self.locationArray =[[NSMutableArray alloc]init];
    [self.endTextField addTarget:self.autoCompleter action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.startTextField addTarget:self.autoCompleter1 action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
    
    self.searchButton.hidden = YES;
 
	// Do any additional setup after loading the view, typically from a nib.
}
- (void)getLocationUsingTextFieldValue:(NSString*)fieldValue
{
    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"https://api.goeuro.com/api/v2/position/suggest/de/%@",fieldValue]];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
      
        for (NSDictionary *jsonObject  in JSON) {
            NSString *location = [jsonObject objectForKey:@"fullName"];
            [self.locationArray addObject:location];
        }
       
       
       
        
        
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Request Failed with Error: %@, %@", error, error.userInfo);
    }];
    
    [operation start];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self getLocationUsingTextFieldValue:textField.text];
}
- (void)textFieldValueChanged:(UITextField *)textField
{
    [_autoCompleterforEndTextField reloadData];
    [_autoCompleterforStartTextField reloadData];
    
}




- (IBAction)dateButtonPressed:(id)sender {
    
    [self exitTextFieldPressed:self];
    self.datePicker.hidden = NO;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
   	df.dateStyle = NSDateFormatterMediumStyle;
	self.dateButton.titleLabel.text = [NSString stringWithFormat:@"%@",
                                       [df stringFromDate:self.datePicker.date]];
    
    
    if(self.dateButton.titleLabel.text != nil && self.startTextField.text != nil && self.endTextField.text != nil)
        self.searchButton.hidden = NO;
    }






- (IBAction)exitTextFieldPressed:(id)sender
{
    [self.startTextField resignFirstResponder];
    [self.endTextField resignFirstResponder];
}


-(void)updateTextLabelsWithText:(NSString *)string
{
    
    [self getLocationUsingTextFieldValue:string];
}

#pragma mark UITextFieldDelegate methods

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
   
    
    NSString *substring = [NSString stringWithString:textField.text];
    substring = [substring stringByReplacingCharactersInRange:range withString:string];
    
     
    
    if (substring.length > 1)
    {
         [self getLocationUsingTextFieldValue:substring];
        [self.locationArray removeAllObjects];
      
    }
    
    
    
    
    return YES;
}

- (NSArray*) autoCompletion:(CustomTableView*) completer suggestionsFor:(NSString*) string{
    // with the prodided string, build a new array with suggestions - from DB, from a service, etc.
   
    return self.locationArray;
}

- (void) autoCompletion:(CustomTableView*) completer didSelectAutoCompleteSuggestionWithIndex:(NSInteger) index{
    // invoked when an available suggestion is selected
   
}
- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0){
        self.startTextField.text = @"";
        self.endTextField.text = @"";
        self.dateButton.titleLabel.text = @"Journey Date";
        self.datePicker.hidden = YES;
    }else{
        //reset clicked
    }
}

- (IBAction)searchButtonPressed:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Search is not yet implemented" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}
@end

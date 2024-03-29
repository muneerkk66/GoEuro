//
//  CustomTableView.m
//
//  Created by Muneer on 08.07.14.
//  Copyright (c) 2014 Muneer KK. All rights reserved.
//

#import <UIKit/UIKit.h>


// if YES - suggestions will be picked for display case-sensitive
// if NO - case will be ignored
#define CaseSensitive @"CaseSensitive"

// if "nil" each cell will copy the font of the source UITextField
// if not "nil" given UIFont will be used
#define UseSourceFont @"UseSourceFont"

// if YES substrings in cells will be highlighted with bold as user types in
// *** FOR FUTURE USE ***
#define HighlightSubstrWithBold @"HighlightSubstrWithBold"

// if YES - suggestions view will be on top of the source UITextField
// if NO - it will be on the bottom
// *** FOR FUTURE USE ***
#define ShowSuggestionsOnTop @"ShowSuggestionsOnTop"

@class CustomTableView;

/**
 @protocol Delegate methods for AutocompletionTableView
 */
@protocol CustomTableViewDelegate <NSObject>

@required
/**
 @method Ask delegate for the suggestions for the provided string - maybe need to ask DB, service, etc.
 @param string the "to-search" term
 @return an array of suggestions built dynamically
 */
- (NSArray*) autoCompletion:(CustomTableView*) completer suggestionsFor:(NSString*) string;

/**
 @method Invoked when user clicked an auto-complete suggestion UITableViewCell.
 @param index the index that was cicked
 */
- (void) autoCompletion:(CustomTableView*) completer didSelectAutoCompleteSuggestionWithIndex:(NSInteger) index;

@end

@interface CustomTableView : UITableView <UITableViewDataSource, UITableViewDelegate>
// Dictionary of NSStrings of your auto-completion terms
@property (nonatomic, strong) NSArray *suggestionsDictionary; 

// Delegate for AutocompletionTableView
@property (nonatomic, strong) id<CustomTableViewDelegate> autoCompleteDelegate;
// Dictionary of auto-completion options (check constants above)
@property (nonatomic, strong) NSDictionary *options;

// Call it for proper initialization
- (UITableView *)initWithTextField:(UITextField *)textField inViewController:(UIViewController *) parentViewController withOptions:(NSDictionary *)options;
@end

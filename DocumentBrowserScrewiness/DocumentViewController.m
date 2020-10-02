//
//  DocumentViewController.m
//  DocumentBrowserScrewiness
//
//  Created by Christopher Liscio on 2020-10-01.
//

#import "DocumentViewController.h"

@interface DocumentViewController()

@property IBOutlet UILabel *documentNameLabel;
@property IBOutlet UILabel *commandNameLabel;

@end

@implementation DocumentViewController
    
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Access the document
    [self.document openWithCompletionHandler:^(BOOL success) {
        if (success) {
            // Display the content of the document, e.g.:
            self.documentNameLabel.text = self.document.fileURL.lastPathComponent;
        } else {
            // Make sure to handle the failed import appropriately, e.g., by presenting an error message to the user.
        }
    }];
}

- (IBAction)dismissDocumentViewController {
    [self dismissViewControllerAnimated:YES completion:^ {
        [self.document closeWithCompletionHandler:nil];
    }];
}

- (IBAction)showPopoverContent:(UIButton *)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *pvc = [sb instantiateViewControllerWithIdentifier:@"popoverContent"];
    
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:pvc];
    
    [nc setModalPresentationStyle:UIModalPresentationPopover];
    [nc.popoverPresentationController setSourceView:sender];
    [nc.popoverPresentationController setSourceRect:sender.bounds];
    
    UIViewController *vcToPresent = nc;
    
    [self presentViewController:vcToPresent animated:YES completion:^{
        NSLog(@"The popover-presented VC's nextResponder is %@", vcToPresent.nextResponder);
    }];
}

- (NSArray<UIKeyCommand *> *)keyCommands {
    UIKeyCommand *findCommand = [UIKeyCommand keyCommandWithInput:@"F" modifierFlags:UIKeyModifierCommand action:@selector(performFind:)];
    [findCommand setDiscoverabilityTitle:@"Find"];
    
    UIKeyCommand *findNextCommand = [UIKeyCommand keyCommandWithInput:@"G" modifierFlags:UIKeyModifierCommand action:@selector(performFindNext:)];
    [findNextCommand setDiscoverabilityTitle:@"Find Next"];
    
    return @[
        findCommand,
        findNextCommand
    ];
}

- (void)performFind:(id)sender {
    self.commandNameLabel.text = @"Find";
    [self delayedClearCommand];
}

- (void)performFindNext:(id)sender {
    self.commandNameLabel.text = @"Find Next";
    [self delayedClearCommand];
}

- (void)delayedClearCommand {
    [[NSRunLoop currentRunLoop] cancelPerformSelectorsWithTarget:self];
    [self performSelector:@selector(clearCommandLabel) withObject:nil afterDelay:1 inModes:@[NSRunLoopCommonModes]];
}

- (void)clearCommandLabel {
    self.commandNameLabel.text = @"Command";
}

@end

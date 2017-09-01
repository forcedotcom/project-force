global class FeatureConsoleAPI {
    
    // called when budget tracking feature is enabled from the feature console page.
    global static void enableBudgetTracking(integer magic) {
        // since this class is global, this is just a means of making sure we are who we say we are.
        // this is by no means the gold standard of doing this, and we expect you'll come up with
        // something better.
        if (magic != 21367) {
            throw new FeatureAccessException('Incorrect Magic Number');
        }
        // check to see if the feature parameter boolean gating the budget tracking feature 
        // has been turned on by the LMO.  if not, throw an exception.
        if (!FeatureManagement.checkPackageBooleanValue('BudgetTrackingPermitted')) {
            throw new FeatureAccessException('Budget Tracking Feature not currently licensed');
        }
        // de-protect the BudgetLineItem custom object, which will also make its custom tab visible.
        FeatureManagement.changeProtection('BudgetLineItem__c', 'CustomObject', 'Unprotected');
        // set the BudgetTrackingEnabled feature param to true. this value reports back to the LMO
        // so that we know which features are enabled/disabled.  it also controls whether or not
        // the Total Budget column is visible on the Projects tab/page.
        FeatureManagement.setPackageBooleanValue('BudgetTrackingEnabled', true);
    }
    
    // called when the budget tracking feature is disabled from the feature console page
    global static void disableBudgetTracking(integer magic) {
        // since this class is global, this is just a means of making sure we are who we say we are.
        // this is by no means the gold standard of doing this, and we expect you'll come up with
        // something better.
        if (magic != 21367) {
            throw new FeatureAccessException('Incorrect Magic Number');
        }
        // note that we do NOT re-protect the BudgetLineItem object because this is not allowed.
        // set the BudgetTrackingEnabled feature param back to false so that we know in the LMO
        // that this feature is currently disabled in the subscriber org.  this will also hide
        // the Total Budget column on the Projects tab/page.
        FeatureManagement.setPackageBooleanValue('BudgetTrackingEnabled', false);
    }
    
    // accessor method to determine if the budget tracking feature is turned on
    global static boolean budgetTrackingEnabled(integer magic) {
        // since this class is global, this is just a means of making sure we are who we say we are.
        // this is by no means the gold standard of doing this, and we expect you'll come up with
        // something better.
        if (magic != 21367) {
            throw new FeatureAccessException('Incorrect Magic Number');
        }
        return FeatureManagement.checkPackageBooleanValue('BudgetTrackingEnabled') && FeatureManagement.checkPackageBooleanValue('BudgetTrackingPermitted');
    }
    
    // called when the expense tracking feature is enabled on the feature console page
    global static void enableExpenseTracking(integer magic) {
        // since this class is global, this is just a means of making sure we are who we say we are.
        // this is by no means the gold standard of doing this, and we expect you'll come up with
        // something better.
        if (magic != 21367) {
            throw new FeatureAccessException('Incorrect Magic Number');
        }
        // check to see if the feature parameter boolean gating the expense tracking feature 
        // has been turned on by the LMO.  if not, throw an exception.
        if (!FeatureManagement.checkPackageBooleanValue('ExpenseTrackingPermitted')) {
            throw new FeatureAccessException('Expense Tracking Feature not currently licensed');
        }
        // set the ExpenseTrackingEnabled boolean param to true so we'll know in the LMO
        // if this feature is turned on.  this will also make the Expense Tracking column
        // visible on the Projects tab/page.
        FeatureManagement.setPackageBooleanValue('ExpenseTrackingEnabled', true);
    }
    
    // accessor method to determine if the expense tracking feature is enabled.
    global static boolean expenseTrackingEnabled(integer magic) {
        // since this class is global, this is just a means of making sure we are who we say we are.
        // this is by no means the gold standard of doing this, and we expect you'll come up with
        // something better.
        if (magic != 21367) {
            throw new FeatureAccessException('Incorrect Magic Number');
        }
        return FeatureManagement.checkPackageBooleanValue('ExpenseTrackingEnabled') && FeatureManagement.checkPackageBooleanValue('ExpenseTrackingPermitted');
    }
    
    // called when the expense tracking feature is disabled on the feature console page
    global static void disableExpenseTracking(integer magic) {
        // since this class is global, this is just a means of making sure we are who we say we are.
        // this is by no means the gold standard of doing this, and we expect you'll come up with
        // something better.
        if (magic != 21367) {
            throw new FeatureAccessException('Incorrect Magic Number');
        }
        // set the ExpenseTrackingEnabled boolean param to false so we'll know in the LMO
        // that this feature is not currently enabled in the subscriber.  this will also hide
        // the Expense Tracking column on the Projects tab/page.
        FeatureManagement.setPackageBooleanValue('ExpenseTrackingEnabled', false);
    }
    
    // called to update the CurrentProjectCount integer param.  this param reports back to the
    // LMO and provides information on how many Project objects have been created.
    public @future static void updateProjectCount(integer newCount) {
        FeatureManagement.setPackageIntegerValue('CurrentProjectCount', newCount);
    }
}
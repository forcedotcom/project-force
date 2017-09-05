@isTest
private class FeatureConsoleTest {

    static testMethod void testExpenseTracking() {
        // reset the feature for the test execution.  
        resetExpenseTracking();
        
        // test that we cannot enable the expense tracking feature
        // before we've enabled the ExpenseTrackingPermitted boolean param.
        boolean caughtException = false;
        try {
            FeatureConsoleAPI.enableExpenseTracking(21367);
        }
        catch(FeatureAccessException e) {
            System.assert(e.getMessage().contains('not currently licensed'));
            caughtException = true;
        }
        System.assert(caughtException);
        caughtException = false;
        
        // enable the param so we can continue our testing
        FeatureManagement.setPackageBooleanValue('ExpenseTrackingPermitted',true);
        
        // test the access restriction exception handling
        try {
            FeatureConsoleAPI.expenseTrackingEnabled(23);
        }
        catch(FeatureAccessException e) {
            caughtException = true;
        }
        System.assert(caughtException);
        caughtException = false;
            
        try {
            FeatureConsoleAPI.enableExpenseTracking(23);
        }
        catch(FeatureAccessException e) {
            caughtException = true;
        }
        System.assert(caughtException);
        caughtException = false;
        
        try {
            FeatureConsoleAPI.disableExpenseTracking(23);
        }
        catch(FeatureAccessException e) {
            caughtException = true;
        }
        System.assert(caughtException);
        
        // test that the feature is currently disabled
        boolean enabled = FeatureConsoleAPI.expenseTrackingEnabled(21367);
        System.assert(!enabled);
        
        // enable the feature and then assert that it is enabled
        FeatureConsoleAPI.enableExpenseTracking(21367);
        
        enabled = FeatureConsoleAPI.expenseTrackingEnabled(21367);
        System.assert(enabled);
        
        // disable the feature and then assert that it is disabled
        FeatureConsoleAPI.disableExpenseTracking(21367);
        
        enabled = FeatureConsoleAPI.expenseTrackingEnabled(21367);
        System.assert(!enabled);
    }
    
    static testMethod void testBudgetTracking() {
        // reset the feature for the test execution
        resetBudgetTracking();
        
        // test that we cannot enable the budget tracking feature until
        // we enable the BudgetTrackingPermitted boolean param.
        boolean caughtException = false;
        try {
            FeatureConsoleAPI.enableBudgetTracking(21367);
        }
        catch(FeatureAccessException e) {
            System.assert(e.getMessage().contains('not currently licensed'));
            caughtException = true;
        }
        System.assert(caughtException);
        caughtException = false;
        // enable the param so we can continue our testing
        FeatureManagement.setPackageBooleanValue('BudgetTrackingPermitted',true);
        
        // test the access restriction exception handling
        try {
            FeatureConsoleAPI.budgetTrackingEnabled(23);
        }
        catch(FeatureAccessException e) {
            caughtException = true;
        }
        System.assert(caughtException);
        caughtException = false;
            
        try {
            FeatureConsoleAPI.enableBudgetTracking(23);
        }
        catch(FeatureAccessException e) {
            caughtException = true;
        }
        System.assert(caughtException);
        caughtException = false;
        
        try {
            FeatureConsoleAPI.disableBudgetTracking(23);
        }
        catch(FeatureAccessException e) {
            caughtException = true;
        }
        System.assert(caughtException);
    
        // assert that the feature is currently disabled
        boolean enabled = FeatureConsoleAPI.budgetTrackingEnabled(21367);
        System.assert(!enabled);
        
        // enable the feature and assert that it is now enabled
        FeatureConsoleAPI.enableBudgetTracking(21367);
        
        enabled = FeatureConsoleAPI.budgetTrackingEnabled(21367);
        System.assert(enabled);
        
        // disable the feature and assert that it is disabled
        FeatureConsoleAPI.disableBudgetTracking(21367);
        
        enabled = FeatureConsoleAPI.budgetTrackingEnabled(21367);
        System.assert(!enabled);
    }
    
    static testMethod void testProjectCount() {
        // create a probject so we can ensure we're getting test coverage 
        // of our project count trigger
        Project__c project = new Project__c(name='myProject23');
        project.TotalBudget__c = 37;
        
        insert project;
    }

    private static void resetExpenseTracking() {
        // turn off the gating feature param just in case it's turned on
        FeatureManagement.setPackageBooleanValue('ExpenseTrackingPermitted', false);
        // disable the feature just in case it's enabled
        FeatureConsoleAPI.disableExpenseTracking(21367);
    }

    private static void resetBudgetTracking() {
        // turn off the gating feature param just in case it's turned on
        FeatureManagement.setPackageBooleanValue('BudgetTrackingPermitted', false);
        // disable the feature just in case it's enabledd
        FeatureConsoleAPI.disableBudgetTracking(21367);
    }    
}

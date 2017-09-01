@isTest
private class FeatureConsoleControllerTest {

    static testMethod void testController() {
        resetParams();
        
        // create an instance of the controller and retrieve the list of Feature objects
        FeatureConsoleController controller = new FeatureConsoleController();
        List<FeatureConsoleController.Feature> features = controller.getFeatures();
        // assert that there are 2 features
        System.assertEquals(2, features.size());
        
        // test that we cannot currently enable either feature
        for(FeatureConsoleController.Feature feature:features) {
            feature.enabled = true;
        }
        // attempt save our changes in the controller
        controller.save();
        // verify that both features are still disabled
        boolean etEnabled = FeatureConsoleAPI.expenseTrackingEnabled(21367);
        boolean btEnabled = FeatureConsoleAPI.budgetTrackingEnabled(21367);
        System.assert(!etEnabled);
        System.assert(!btEnabled);
        
        // turn on the gating param for the expense tracking feature
        FeatureManagement.setPackageBooleanValue('ExpenseTrackingPermitted', true);
        // now enable the feature and save the controller
        for(FeatureConsoleController.Feature feature:features) {
            if(feature.name.equals('Expense Tracking')) {
                feature.enabled = true;
            }
        }        
        controller.save();
        
        // verify that the expense tracking feature is enabled, but not the budget tracking feature
        etEnabled = FeatureConsoleAPI.expenseTrackingEnabled(21367);
        btEnabled = FeatureConsoleAPI.budgetTrackingEnabled(21367);
        System.assert(etEnabled);
        System.assert(!btEnabled);
    }
    
    private static void resetParams() {
        // turn off the gating feature param if it is turned on
        boolean permitted = FeatureManagement.checkPackageBooleanValue('ExpenseTrackingPermitted');
        if(permitted) {
            FeatureManagement.setPackageBooleanValue('ExpenseTrackingPermitted', false);
        }
        
        permitted = FeatureManagement.checkPackageBooleanValue('BudgetTrackingPermitted');
        if(permitted) {
            FeatureManagement.setPackageBooleanValue('BudgetTrackingPermitted', false);
        }
    }
}
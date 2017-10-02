public class FeatureConsoleController {

    // controller class for the feature console tab/page

    List<Feature> features;
    String ET_FEATURE = 'Expense Tracking';
    String BT_FEATURE = 'Budget Tracking';
    
    // check the status of the expense/budget tracking features when the page loads.
    public FeatureConsoleController() {
        features = new List<Feature>();
        features.add(new Feature(FeatureConsoleAPI.expenseTrackingEnabled(21367), ET_FEATURE));
        features.add(new Feature(FeatureConsoleAPI.budgetTrackingEnabled(21367), BT_FEATURE));   
    }

    // simple sub-class to represent the status of a given feature.
    public class Feature {
       public Boolean enabled {get; set;}
       public String name{get;set;}
       public Feature(boolean enabled, String name) {
          this.enabled = enabled;
          this.name = name;
       }
    }

    // accessor method for the VF page to get the current features.
    public List<Feature> getFeatures() {
       return features;
    }
   

    // when the page saves, enable/disable features based on how they're set on the page.   
    public void save() {
       for (Feature feature : features) {
          if(feature.enabled) {
              try {
                  if(feature.name.equals(ET_FEATURE)) {
                      FeatureConsoleAPI.enableExpenseTracking(21367);
                  }
                  else if (feature.name.equals(BT_FEATURE)) {
                      FeatureConsoleAPI.enableBudgetTracking(21367);
                  }
              }
              catch(FeatureAccessException e) {
                  feature.enabled = false;
                  ApexPages.addMessages(e);
              }
          }
          else {
              if(feature.name.equals(ET_FEATURE)) {
                  FeatureConsoleAPI.disableExpenseTracking(21367);
              }
              else if (feature.name.equals(BT_FEATURE)) {
                  FeatureConsoleAPI.disableBudgetTracking(21367);
              }
          }
       }
    }
}
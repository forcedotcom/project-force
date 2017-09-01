public class FeatureConsoleController {

    // controller class for the feature console tab/page

    List<Feature> features;
    
    // check the status of the expense/budget tracking features when the page loads.
    public FeatureConsoleController() {
        features = new List<Feature>();
        features.add(new Feature(FeatureConsoleAPI.expenseTrackingEnabled(21367), 'Expense Tracking'));
        features.add(new Feature(FeatureConsoleAPI.budgetTrackingEnabled(21367), 'Budget Tracking'));   
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
          if  (feature.name.equals('Expense Tracking')) {
              if (feature.enabled) {
                  try {
                      FeatureConsoleAPI.enableExpenseTracking(21367);
                  }
                  catch(FeatureAccessException e) {
                      feature.enabled = false;
                      ApexPages.addMessages(e);
                  }
              } else {
                FeatureConsoleAPI.disableExpenseTracking(21367);
              }
          } else if (feature.name.equals('Budget Tracking')) {
              if (feature.enabled) {
                  try {
                      FeatureConsoleAPI.enableBudgetTracking(21367);
                  }
                  catch(FeatureAccessException e) {
                      feature.enabled = false;
                      ApexPages.addMessages(e);
                  }
              } else {
                  FeatureConsoleAPI.disableBudgetTracking(21367);
              }
          }
       }
    }
}
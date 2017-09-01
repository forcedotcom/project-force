public class ProjectExtension {

public Boolean expenseTrackingEnabled;
public Boolean budgetTrackingEnabled;

    public ProjectExtension(ApexPages.StandardController standardController) {
        this.expenseTrackingEnabled = FeatureConsoleAPI.expenseTrackingEnabled(21367);
        this.budgetTrackingEnabled = FeatureConsoleAPI.budgetTrackingEnabled(21367);
    }

    public ProjectExtension(ApexPages.StandardSetController controller) {
        this.expenseTrackingEnabled = FeatureConsoleAPI.expenseTrackingEnabled(21367);
        this.budgetTrackingEnabled = FeatureConsoleAPI.budgetTrackingEnabled(21367);
    }

    public Boolean getExpenseTrackingEnabled() {
        return this.expenseTrackingEnabled;
    }

    public Boolean getBudgetTrackingEnabled() {
        return this.budgetTrackingEnabled;
    }    
}
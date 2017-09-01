trigger CountTrigger on Project__c (after insert) {
    // trigger to update the CurrentProjectCount integer param each time a Project object is created.
    integer i = FeatureManagement.checkPackageIntegerValue('CurrentProjectCount');
    i = i + 1;
    FeatureConsoleApi.updateProjectCount(i);
}
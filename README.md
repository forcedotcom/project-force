# Project Force  App

This app is a reference implementation to showcase the capabilities of the Feature Management product offering.  It employs a basic feature console through which subscribers can enable/disable features that have been enabled via a License Management Organization (LMO) that also has the Feature Management App installed (FMA).  There are also various UI features that are only visible when these features are enabled in the subscriber organization.  There are also a couple of custom objects that are protected, one of which is de-protected when the Budget Tracking feature is enabled.  

We realize that you may not be able to or want to make a new managed, released version of this package and associate it with an LMO, so for the purposes of this repository, we’ve tried to put together a workflow that showcases most of the features of Feature Management with the use of a scratch org, with some caveats.  The first of those caveats is that since they are not in a managed, installed state, things like protected custom objects and protected custom permissions won’t behave the same way they would if this package were managed, released, and installed in a subscriber org.  We can, however, showcase the enabling/disabling of features for subscribers and how to write automated tests against this type of behavior.  

## Dev, Build and Test

The intent with this app and repository is that it should be used with Salesforce DX.  In order to use this app, you'll first want to clone the repository:

```
git clone https://github.com/forcedotcom/project-force
```

After that, you'll want to create your own branch:

```
cd ProjectForce	
git checkout -b myBranch
```

Once you've done that, you'll be working in your own branch and can make changes as you see fit.  To start, you may want to edit the JSON config files within the project structure to reflect your personal preferences.  From this point on, we’re going to assume you are using SFDX, you have created a Dev Hub and authorized SFDX to use it.

Create a scratch org and set as the default org for further SFDX commands:

```
sfdx force:org:create --setdefaultusername --setalias test --definitionfile config/project-scratch-def.json 
```

Push all of the Project Force metadata into your newly created scratch org:

```
sfdx force:source:push
```

Next, open your scratch org in the browser

```
sfdx force:org:open
```

For your scratch org user's profile, ensure the following selections are active:

![image](https://user-images.githubusercontent.com/45772/30082726-1464101c-9249-11e7-9cfb-d34e5889dccb.png)

Now, select the Project Force app from the app drop down or the app menu if you’re using Lightning Experience.

Then, click the Projects tab, and create a new Project__c object there.  Click the Projects tab again to see the list view.  Notice there are only two columns for the record ID and the record name.

![image](https://user-images.githubusercontent.com/31550188/30071448-f94d219e-9223-11e7-9db7-0877646b7b7c.png)

Next, click the Feature Console tab.  Select the Expense Tracking feature, and click the Save button.  You’ll receive an error message on the page that says “Expense Tracking feature not currently licensed.” 

![image](https://user-images.githubusercontent.com/31550188/30071402-c6374a46-9223-11e7-931e-6ad24d2b6745.png)

This is because the ExpenseTrackingPermitted feature parameter is currently set to false.  This feature parameter determines whether or not this feature can be enabled in a subscriber org.  Typically, this would be changed via an LMO with the FMA installed.  For our purposes working with a scratch org, we’ll do this in a different way to simulate this process.  

Edit the ExpenseTrackingPermitted.featureParameterBoolean-meta.xml file in the pf-app/main/default/featureParameters directory and set its value to true:

```
<?xml version="1.0" encoding="UTF-8"?>
<PackageBooleanValue xmlns="http://soap.sforce.com/2006/04/metadata">
    <dataflowDirection>LmoToSubscriber</dataflowDirection>
    <masterLabel>Expense Tracking Permitted</masterLabel>
    <value>true</value>
</PackageBooleanValue>
```

Save the file, and then push the source into the scratch org:

```
sfdx force:source:push
```

Back in your scratch org, return to the Feature Console tab and try to enable the Expense Tracking feature.  This should now be successful. 

![image](https://user-images.githubusercontent.com/31550188/30071529-42e21eae-9224-11e7-9d87-d6b5b4e1e131.png)

Click the Projects tab, and notice there is now a new column for Expense Tracking in the list view. 

![image](https://user-images.githubusercontent.com/31550188/30071557-5919a764-9224-11e7-9b82-790822c42f41.png)

If you disable the Expense Tracking feature in the Feature Console, this column will again be hidden.  You can also repeat this same process for the Budget Tracking feature, which is gated by the BudgetTrackingPermitted feature parameter.  

You cannot call FeatureManagement Apex methods to edit LMO to Subscriber feature parameters, and prior to the Winter ‘18 release, it was not possible to do this in an Apex test either.  We’ve now allowed this for Apex test executions in the same namespace as the feature parameter that is being edited.  This way, you can test your features by setting different values for your feature parameters in an Apex test, where the values will not be persisted in the DB afterwards.  Default values will remain unchanged, and you can test things like boolean parameters allowing access to features or UI components, integer parameters that set limits, or date parameters that may serve as expiration dates.  

We’ve tried to create a good example test class that does this very type of testing in pf-app/main/default/classes/FeatureConsoleTest.cls.  Lines like this one help us test the rest of the feature after we’ve verified the feature cannot be enabled without setting certain values:

```
// enable the param so we can continue our testing
FeatureManagement.setPackageBooleanValue('ExpenseTrackingPermitted',true);
```

To run FeatureConsoleTest, try this:

```
sfdx force:apex:test:run -n FeatureConsoleTest -r human
```

This should produce some results that look like this:

![image](https://user-images.githubusercontent.com/31550188/30071140-f456df28-9222-11e7-8c6a-9e93af46492c.png)

From here, to test things like protected custom objects and protected custom permissions, you can take the next step and deploy this metadata into a release org, export a version of a package containing this metadata, and install it in another scratch org for testing.  That is about as close as you can get to the full Feature Management experience without using an LMO to enable feature parameters.  

To get the best experience using this source, you'll want to export a package version and associate it with an LMO.  This way you can leverage the functionality of enabling features for a subscriber org from the LMO.  To enable the Budget Tracking feature, you'll want to edit the BudgetTrackingPermitted boolean feature parameter in your LMO and set the value to true.  In your subscriber org, you'll then be able to go to the Feature Console tab and enable the feature there.  Enabling the feature in the subscriber org does a couple things.  It sets the BudgetTrackingEnabled feature parameter to true so you can see the Total Budget column on the Projects tab (assuming you've created some Project objects), and it also removes the protection on the Budget Line Item custom object, and by association its custom tab.  It’s also important to note that the BudgetTrackingEnabled parameter serves two purposes.  First, it controls the visibility of a column on the Projects page, but it also reports back to the LMO to inform the LMO that this subscriber has enabled the Budget Tracking feature.  The Expense Tracking feature behaves almost identically to the Budget Tracking feature, except it has no custom objects associated with it.  It's important to note that in order for you to see the Budget Line Items tab after enabling the feature in your subscriber org, you'll have to navigate to one of the other tabs if in Aloha, or re-select the app from the app menu in Lightning Experience.  Either one of these actions should re-render the tabs in the app for you.  

On the subject of feature parameters that deliver metrics data back to the LMO from the subscriber, there are a few baked into this app. We discussed the BudgetTrackingEnabled metric above.  There is also a similar parameter for the expense tracking feature called ExpenseTrackingEnabled.  Lastly, there is an integer parameter called CurrentProjectCount, which is intended to keep track of how many Project objects have been created in the subscriber org.  The product is designed such that these metrics values are delivered to the LMO once a day.  

There are also a few things we've purposely left undone.  First, there is a custom object with a custom tab called Organization Budget.  This object is protected, and there is no mechanism built into the app with which to remove its protection.  After reviewing the source of the project, you can practice by adding another feature around this object, complete with new feature parameters, associated apex to manipulate your feature parameters and remove the protection on the object, and an item on the Feature Console tab so it can be enabled in the subscriber org.  There are also some date and integer parameters that are currently not in use that you can try to incorporate into the app to work with the various data types available to you.  


## Resources

Resources on SFDX and Feature Management should be referenced here.

## Description of Files and Directories

pf-app:
	This is the directory where all of the metadata for the app is contained.  It is currently in metadata API format, and would need to be converted using sfdx force:source:convert before it can be deployed to a release org.
 
config:
	This is the directory where the scratch org configuration JSON file, project-scratch-def.json, lives.  Edit this file as per your personal preferences.

sfdx-project.json:
	This is the main project configuration file in JSON format.  Edit this file as per your personal preferences.



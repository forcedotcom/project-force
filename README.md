# Project Force App

This app is a reference implementation to showcase the capabilities of the Feature Management product offering. The app employs a basic feature console through which subscribers can enable or disable features. These features have been enabled by a License Management Organization (LMO) that has installed the Feature Management App (FMA). There are various UI features that are visible only when these features are enabled in the subscriber organization. There are also a couple of custom objects that are protected, one of which is de-protected when the Budget Tracking feature is enabled. 

We realize that you might not be able to or want to make a new Managed - Released version of this package and associate it with an LMO. So, for the purposes of this repository, we’ve tried to put together a workflow that showcases most of the features of Feature Management using a scratch org, with some caveats. The first of these caveats is that, because the package isn’t in a Managed - Installed state, things like protected custom objects and protected custom permissions don’t behave the same way they would if this package were Managed - Released and installed in a subscriber org. We can, however, showcase the enabling and disabling of features for subscribers and show how to write automated tests against this type of behavior. 

## Dev, Build, and Test

This app and repository are designed to be used with the source-driven development flow introduced with Salesforce DX. Here's how to get started with this app and repository.

First, clone this repository:

```
git clone https://github.com/forcedotcom/project-force
```

Then, create your own branch:

```
cd ProjectForce	
git checkout -b myBranch
```

After you create your branch, you can work in that branch and make changes as you see fit. To start, you might want to edit the JSON config files within the project structure to reflect your personal preferences. 

From this point on, we’re going to assume you are using the Salesforce CLI, that you have created a Dev Hub, and that you’ve authorized the Salesforce CLI to use that Dev Hub. If you haven't completed those tasks, check out the _[Salesforce DX Setup Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_setup.meta/sfdx_setup)_.

Create a scratch org and set that org as the default org for further SFDX commands:

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

For your scratch org user’s profile, ensure the following selections are active:

![image](https://user-images.githubusercontent.com/45772/30082726-1464101c-9249-11e7-9cfb-d34e5889dccb.png)

Now, select the Project Force app the app menu (if you’re using Lightning Experience) or from the app dropdown (in Salesforce Classic).

Then, click the Projects tab, and create a new `Project__c` object there. Click the Projects tab again to see the list view. Notice that there are only two columns for the record ID and the record name.

![image](https://user-images.githubusercontent.com/45772/32290491-de179194-beff-11e7-8d77-567793c68e1a.png)

Next, click the Feature Console tab. Select the **Expense Tracking** feature, and click **Save**. An error message on the page says, “Expense Tracking feature not currently licensed.” 

![image](https://user-images.githubusercontent.com/31550188/30071402-c6374a46-9223-11e7-931e-6ad24d2b6745.png)

You’re seeing this error because the `ExpenseTrackingPermitted` feature parameter is currently set to false. This feature parameter determines whether or not this feature can be enabled in a subscriber org. Typically, this value would be changed via an LMO with the FMA installed. For our purposes, working with a scratch org, we’ll change the value in a different way to simulate this process. 

Edit the `ExpenseTrackingPermitted.featureParameterBoolean-meta.xml` file in the `pf-app/main/default/featureParameters` directory and set the feature parameter’s value to true:

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

Back in your scratch org, return to the Feature Console tab. Try again to enable the **Expense Tracking** feature, and then click **Save**. This should now be successful. 

![image](https://user-images.githubusercontent.com/31550188/30071529-42e21eae-9224-11e7-9d87-d6b5b4e1e131.png)

Click the Projects tab, and notice there is now a new column for Expense Tracking in the list view. 

![image](https://user-images.githubusercontent.com/45772/32290490-de0011f4-beff-11e7-8621-752fa5532d85.png)

If you disable the Expense Tracking feature in the Feature Console, this column will again be hidden. You can also repeat this process for the Budget Tracking feature, which is gated by the `BudgetTrackingPermitted` feature parameter. 

You can’t call `FeatureManagement` Apex methods to edit LMO-to-Subscriber feature parameters. Prior to the Winter ’18 release, it wasn’t possible to edit LMO-to-Subscriber feature parameters in an Apex test either. We’ve now allowed this for Apex test executions in the same namespace as the feature parameter that is being edited. This way, you can test your features by setting different values for your feature parameters in an Apex test, where the values aren’t persisted in the database at the end of your test run. Default values remain unchanged, and you can test things like boolean parameters that allow access to features or UI components, integer parameters that set limits, or date parameters that serve as expiration dates. 

A sample test class that does this type of testing is `pf-app/main/default/classes/FeatureConsoleTest.cls`. Lines like this one help us test the rest of the feature after we’ve verified that the feature can’t be enabled without setting certain values:

```
// enable the param so we can continue our testing
FeatureManagement.setPackageBooleanValue('ExpenseTrackingPermitted',true);
```

To run `FeatureConsoleTest`, try this:

```
sfdx force:apex:test:run -n FeatureConsoleTest -r human
```

This command should produce results that look like this:

![image](https://user-images.githubusercontent.com/31550188/30071140-f456df28-9222-11e7-8c6a-9e93af46492c.png)

From here, to test things like protected custom objects and protected custom permissions, you can take the next steps and deploy this metadata into a release org, upload a version of a package containing this metadata, and install it in another scratch org for testing. That is about as close as you can get to the full Feature Management experience without using an LMO to enable feature parameters. 

To get the best experience using this source, you’ll want to upload a package version and associate it with an LMO. This way you can leverage the functionality of enabling features for a subscriber org from the LMO. To enable the Budget Tracking feature,  edit the `BudgetTrackingPermitted` boolean feature parameter in your LMO and set its value to `true`. In your subscriber org, you’ll then be able to go to the Feature Console tab and enable the feature there. Enabling the feature in the subscriber org does a couple things. It sets the `BudgetTrackingEnabled` feature parameter to `true` so you can see the Total Budget column on the Projects tab (assuming you’ve created some Project records), and it also removes the protection on the Budget Line Item custom object—and by association its custom tab. It’s also important to note that the `BudgetTrackingEnabled` parameter serves two purposes. First, it controls the visibility of a column on the Projects page. It also reports back to the LMO to inform the LMO that this subscriber has enabled the Budget Tracking feature. The Expense Tracking feature behaves almost identically to the Budget Tracking feature, except it has no custom objects associated with it. It’s important to note that in order for you to see the Budget Line Items tab after enabling the feature in your subscriber org, you’ll need to re-select the app from the app menu (in Lightning Experience) or navigate to one of the other tabs (in Salesforce Classic). Either one of these actions re-renders the tabs in the app for you. 

On the subject of feature parameters that deliver metrics data back to the LMO from the subscriber: there are a few of these feature parameters baked into this app. We discussed the `BudgetTrackingEnabled` metric above. There is also a similar parameter for the expense tracking feature, called `ExpenseTrackingEnabled`. Lastly, there is an integer parameter called `CurrentProjectCount`, which is intended to keep track of how many Project objects have been created in the subscriber org. The product is designed such that these metrics’ values are delivered to the LMO once per day. 

There are also a few things we’ve purposely left undone. First, there is a custom object with a custom tab called Organization Budget. This object is protected, and there is no mechanism built into the app with which to remove its protection. After reviewing the source of the project, you can practice by adding another feature that uses this object. Be sure to add new feature parameters, associated Apex to manipulate your feature parameters and remove the protection on the object, and an item on the Feature Console tab so the feature can be enabled in the subscriber org. There are also some date and integer feature parameters that aren’t currently in use. You can try to incorporate these feature parameters into the app to work with the various data types available to you. 


## Resources

_ISVforce Guide_: [Manage Features](https://developer.salesforce.com/docs/atlas.en-us.packagingGuide.meta/packagingGuide/fma_manage_features.htm)

_[Salesforce DX Developer Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev)_

[Salesforce DX Dreamhouse App](https://github.com/DreamhouseApp/dreamhouse-sfdx)

## Description of Files and Directories

`pf-app`:
	This is the directory where all of the metadata for the app is contained. It is currently in the Salesforce DX source format, and would need to be converted using `sfdx force:source:convert` before it can be deployed to a release org.
 
`config`:
	This is the directory where the scratch org configuration JSON file, `project-scratch-def.json`, lives. Edit this file to match your personal preferences.

`sfdx-project.json`:
	This is the main project configuration file, in JSON format. Edit this file to match your personal preferences.



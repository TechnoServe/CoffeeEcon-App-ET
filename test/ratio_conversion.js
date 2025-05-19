describe('Test scripts on Unit Conversion', ()=>{
    const assert = require('assert');

    it('Test Script 1: check convert nav button redirects to coffee conversion screen', async()=>{
          //click convert nav bar
       const convertButton = await $('~Convert\nTab 3 of 5');
       await convertButton.waitForDisplayed({ timeout: 5000 });
       await convertButton.click();
       console.log('✅ coffee conversion screen is Successfully displayed.');
    });

    it('Test Script 2: convert 10 kg cherry to 5.50 pulped parchment', async()=>{
        //select pulped Parchement target coffee stage
     const target = await $('//android.widget.Button[@content-desc="Pulped Parchment"]');
     await target.waitForDisplayed({ timeout: 5000 });
     await target.click();
     const targetOption = await $('android=new UiSelector().description("Pulped Parchment")');
    await targetOption.waitForDisplayed({ timeout: 5000 });
    await targetOption.click();
     console.log('✅ Pulped Parchment is selected Successfully ');
     
     //enter input 10
    const inputField = await $('//android.widget.FrameLayout[@resource-id="android:id/content"]/android.widget.FrameLayout/android.view.View/android.view.View/android.view.View/android.view.View/android.view.View[8]');
    inputField.waitForDisplayed({ timeout: 5000 });
    await inputField.click();
    const val1= await $('//android.widget.Button[@content-desc="1"]');
    val1.click();
    const val2= await $('//android.widget.Button[@content-desc="0"]');
    val2.click();
    //await inputField.setValue('10');
    console.log("✅ Successfully entered '10' in the input field.");
    // click some space.
    const scrim = await $('//android.view.View[@content-desc="Scrim"]');
    scrim.click();

     //check value on target field
    const outputField = await $('//android.widget.FrameLayout[@resource-id="android:id/content"]/android.widget.FrameLayout/android.view.View/android.view.View/android.view.View/android.view.View/android.view.View[13]');
    outputField.waitForDisplayed({ timeout: 5000 });
    const value = await outputField.getText();
    console.log('output value is:', value);
    expect(value).toBe('5.50'); 

    });

    it('Test Script 3: convert 10 kg cherry to 3.90 Wet parchment', async()=>{

        //select Wet Parchment target coffee stage
     const target = await $('//android.widget.Button[@content-desc="Pulped Parchment"]');
     await target.waitForDisplayed({ timeout: 5000 });
     await target.click();
     const targetOption = await $('android=new UiSelector().description("Wet Parchment")');
    await targetOption.waitForDisplayed({ timeout: 5000 });
    await targetOption.click();
     console.log('✅ Wet Parchment is selected Successfully ');

     //check value on target field
    const outputField = await $('//android.widget.FrameLayout[@resource-id="android:id/content"]/android.widget.FrameLayout/android.view.View/android.view.View/android.view.View/android.view.View/android.view.View[13]');
    outputField.waitForDisplayed({ timeout: 5000 });
    const value = await outputField.getText();
    console.log('output value is:', value);
    expect(value).toBe('3.90'); 

    });
   
    it('Test Script 4: convert 10 kg cherry to 2.00 Dry parchment', async()=>{

        //select dry Parchment target coffee stage
     const target = await $('//android.widget.Button[@content-desc="Wet Parchment"]');
     await target.waitForDisplayed({ timeout: 5000 });
     await target.click();
     const targetOption = await $('android=new UiSelector().description("Dry Parchment")');
    await targetOption.waitForDisplayed({ timeout: 5000 });
    await targetOption.click();
     console.log('✅ Dry Parchment is selected Successfully ');

     //check value on target field
    const outputField = await $('//android.widget.FrameLayout[@resource-id="android:id/content"]/android.widget.FrameLayout/android.view.View/android.view.View/android.view.View/android.view.View/android.view.View[13]');
    outputField.waitForDisplayed({ timeout: 5000 });
    const value = await outputField.getText();
    console.log('output value is:', value);
    expect(value).toBe('2.00'); 

    });

    it('Test Script 5: convert 10 kg cherry to 1.60 Unsorted Green Coffee', async()=>{

        //select Unsorted Green Coffee target coffee stage
     const target = await $('//android.widget.Button[@content-desc="Dry Parchment"]');
     await target.waitForDisplayed({ timeout: 5000 });
     await target.click();
     const targetOption = await $('android=new UiSelector().description("Unsorted Green Coffee")');
    await targetOption.waitForDisplayed({ timeout: 5000 });
    await targetOption.click();
     console.log('✅ Unsorted Green Coffee is selected Successfully ');

     //check value on target field
    const outputField = await $('//android.widget.FrameLayout[@resource-id="android:id/content"]/android.widget.FrameLayout/android.view.View/android.view.View/android.view.View/android.view.View/android.view.View[13]');
    outputField.waitForDisplayed({ timeout: 5000 });
    const value = await outputField.getText();
    console.log('output value is:', value);
    expect(value).toBe('1.60'); 

    });

    it('Test Script 6: convert 10 kg cherry to 1.40 Export Green', async()=>{

        //select Export Green target coffee stage
     const target = await $('//android.widget.Button[@content-desc="Unsorted Green Coffee"]');
     await target.waitForDisplayed({ timeout: 5000 });
     await target.click();
     const targetOption = await $('android=new UiSelector().description("Export Green")');
    await targetOption.waitForDisplayed({ timeout: 5000 });
    await targetOption.click();
     console.log('✅ Export Green is selected Successfully ');

     //check value on target field
    const outputField = await $('//android.widget.FrameLayout[@resource-id="android:id/content"]/android.widget.FrameLayout/android.view.View/android.view.View/android.view.View/android.view.View/android.view.View[13]');
    outputField.waitForDisplayed({ timeout: 5000 });
    const value = await outputField.getText();
    console.log('output value is:', value);
    expect(value).toBe('1.40'); 

    });

    it('Test Script 7: convert 10 kg cPulped Parchment Export Green ', async()=>{

    //select pulp Parchment source coffee stage
    const source = await $('//android.widget.Button[@content-desc="Cherries"]');
    await source.waitForDisplayed({ timeout: 5000 });
    await source.click();

    const pulpOption = await $('android=new UiSelector().description("Pulped Parchment")');
    await pulpOption.waitForDisplayed({ timeout: 5000 });
    await pulpOption.click();
     console.log('✅ Pulped Parchment is selected Successfully ');

     //check value on target field
    const outputField = await $('//android.widget.FrameLayout[@resource-id="android:id/content"]/android.widget.FrameLayout/android.view.View/android.view.View/android.view.View/android.view.View/android.view.View[13]');
    outputField.waitForDisplayed({ timeout: 5000 });
    const value = await outputField.getText();
    console.log('output value is:', value);
    expect(value).toBe('2.55'); 

    });

    it('testcase 8: clear Result history', async()=>{
     //click units button
    const units= await $('//android.view.View[@content-desc="Units"]');
    units.waitForDisplayed({ timeout: 5000 });
    units.click();

     //click coffee button again to check the resultElement.
    const coffee= await $('//android.view.View[@content-desc="Coffee"]');
    coffee.waitForDisplayed({ timeout: 5000 });
    coffee.click();
     
    const clearAllButton = await $('//android.view.View[@content-desc="Clear All"]');
    // Click the Clear All button
    await clearAllButton.click();
    
    //  verify that result history is cleared
    //  check that the result list is empty or hidden
    const resultElement = await $('//android.view.View[@content-desc="Cherries"]');
    const isDisplayed = await resultElement.isDisplayed();
    
    // Assert that it is no longer displayed
    if (isDisplayed) {
        throw new Error("Result history was not cleared!");
    } else {
        console.log("✅Result history cleared successfully.");
    }
    })

})
describe('Test scripts on Unit Conversion', ()=>{
    const assert = require('assert');

    it('Test Script 1: Unit Button is Clickable and Display the Units conversion screen', async()=>{
          //click convert nav bar
       const convertButton = await $('~Convert\nTab 3 of 5');
       await convertButton.waitForDisplayed({ timeout: 5000 });
       await convertButton.click();

        // click units button
       const unitButton = await $('~Units');
       await unitButton.waitForDisplayed({ timeout: 5000 });
       await unitButton.click();
       console.log('✅ Unit conversion screen is Successfully displayed.');
    });

    it('Test Script 2: select kilogram as source input', async()=>{
        //click dropdown button
        const dropdownButton = await $('~Grams');
        await dropdownButton.waitForDisplayed({ timeout: 5000 });
        await dropdownButton.click();
    
        // Step 2: Click on the "Kilograms" option
        const kilogramsOption = await $('android=new UiSelector().description("Kilograms")');
        await kilogramsOption.waitForDisplayed({ timeout: 5000 });
        await kilogramsOption.click();
    
        // ✅ assert that the correct unit is now selected
       const selectedUnit = await $('~Kilograms');
       const isDisplayed = await selectedUnit.isDisplayed();
       expect(isDisplayed).toBe(true);
       console.log('✅ kilogram is Successfully selected');
    })

    it('Test Script 3: select gram as target Out', async()=>{
    //click dropdown button
    const targetDropdownButton = await $(`(//android.widget.Button[@content-desc="Kilograms"])[2]`);
    await targetDropdownButton.waitForDisplayed({ timeout: 5000 });
    await targetDropdownButton.click();

    // Step 2: Click on the "Kilograms" option
    const gramsOption = await $('android=new UiSelector().description("Grams")');
    await gramsOption.waitForDisplayed({ timeout: 5000 });
    await gramsOption.click();

    // ✅ assert that the correct unit is now selected
    const selectedUnit = await $('~Grams');
    const isDisplayed = await selectedUnit.isDisplayed();
    expect(isDisplayed).toBe(true);
    console.log('✅ Gram is Successfully selected');
   })

   it('Test Script 4: convert 10 kilogram is successfully converted to 10,000 gram', async()=>{
    
    const inputField = await $('//android.widget.FrameLayout[@resource-id="android:id/content"]/android.widget.FrameLayout/android.view.View/android.view.View/android.view.View/android.view.View/android.view.View[4]/android.view.View[1]');
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
    const outputField = await $('//android.widget.FrameLayout[@resource-id="android:id/content"]/android.widget.FrameLayout/android.view.View/android.view.View/android.view.View/android.view.View/android.view.View[4]/android.view.View[2]');
    outputField.waitForDisplayed({ timeout: 5000 });
    const value = await outputField.getText();
    console.log('output value is:', value);
    expect(value).toBe('10000.00'); 
   });


   it('Test Script 5: convert 10 kilogram is successfully converted to 0.59 feresula', async()=>{

      const targetDropdownButton = await $(`//android.widget.Button[@content-desc="Grams"]`);
      await targetDropdownButton.waitForDisplayed({ timeout: 5000 });
      await targetDropdownButton.click();
  
      // Step 2: Click on the "Kilograms" option
      const feresulaOption = await $('android=new UiSelector().description("Feresula")');
      await feresulaOption.waitForDisplayed({ timeout: 5000 });
      await feresulaOption.click();
  
      // ✅ assert that the correct unit is now selected
      const selectedUnit = await $('~Feresula');
      const isDisplayed = await selectedUnit.isDisplayed();
      expect(isDisplayed).toBe(true);
      console.log('✅ feresula is Successfully selected');
  
       //check value on target field
      const outputField = await $('//android.widget.FrameLayout[@resource-id="android:id/content"]/android.widget.FrameLayout/android.view.View/android.view.View/android.view.View/android.view.View/android.view.View[4]/android.view.View[2]');
      outputField.waitForDisplayed({ timeout: 5000 });
      const value = await outputField.getText();
      console.log('output value is:', value);
      expect(value).toBe('0.59'); 
     });

     it('Test Script 6: convert 10 kilogram is successfully converted to 0.1 quintal', async()=>{
 
      const targetDropdownButton = await $(`~Feresula`);
      await targetDropdownButton.waitForDisplayed({ timeout: 5000 });
      await targetDropdownButton.click();
  
      // Step 2: Click on the "Kilograms" option
      const quintalOption = await $('//android.widget.Button[@content-desc="Quintal"]');
      await quintalOption.waitForDisplayed({ timeout: 5000 });
      await quintalOption.click();
  
      // ✅ assert that the correct unit is now selected
      const selectedUnit = await $('~Quintal');
      const isDisplayed = await selectedUnit.isDisplayed();
      expect(isDisplayed).toBe(true);
      console.log('✅ Quintal is Successfully selected');
  
       //check value on target field
      const outputField = await $('//android.widget.FrameLayout[@resource-id="android:id/content"]/android.widget.FrameLayout/android.view.View/android.view.View/android.view.View/android.view.View/android.view.View[4]/android.view.View[2]');
      outputField.waitForDisplayed({ timeout: 5000 });
      const value = await outputField.getText();
      console.log('output value is:', value);
      expect(value).toBe('0.10'); 
     })

     it('testcase 7: clear Result history', async()=>{

       //click coffee button again to check the resultElement.
     const coffee= await $('//android.view.View[@content-desc="Coffee"]');
     coffee.waitForDisplayed({ timeout: 5000 });
     coffee.click();

      //click units button
     const units= await $('//android.view.View[@content-desc="Units"]');
     units.waitForDisplayed({ timeout: 5000 });
     units.click();
 
     const clearAllButton = await $('//android.view.View[@content-desc="Clear All"]');
     // Click the Clear All button
     await clearAllButton.click();
     
     //  verify that result history is cleared
     //  check that the result list is empty or hidden
     const resultElement = await $('//android.view.View[@content-desc="Kilograms"]');
     const isDisplayed = await resultElement.isDisplayed();
     
     // Assert that it is no longer displayed
     if (isDisplayed) {
         throw new Error("Result history was not cleared!");
     } else {
         console.log("✅Result history cleared successfully.");
     }
     })
}) 
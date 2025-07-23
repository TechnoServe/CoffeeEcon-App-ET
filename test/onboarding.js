
describe('TechnoServe App – Native Smoke', () => {
  const assert = require('assert');
  it('Test Scripts on OnBoarding Pages.', async () => {

    // Wait for the Welcome text to be visible
    const welcomeEl = await $('~Welcome'); 
    await welcomeEl.waitForDisplayed({ timeout: 10000 }); 

    console.log('TestCase 1: Assert if Welcome text is visible')
    const isVisible = await welcomeEl.isDisplayed();
    assert.ok(isVisible, '❌ Expected Welcome text to be visible, but it was not.');
    console.log('✅ Welcome text is visible!');

    // Wait for the "Next" button to be displayed
    console.log('click next button');
    const nextButton = await $('~Next');
    await nextButton.waitForDisplayed({ timeout: 5000 });
    await nextButton.click();
   
    //check convert Easily onboarding Page is displayed.
    console.log('TestCase 2: check successfully navigate to Convert easily page.')
    const secondScreenTitle = await $('~Convert Easily');
    await secondScreenTitle.waitForDisplayed({ timeout: 5000 });
    const isDisplayed = await secondScreenTitle.isDisplayed();
    assert.ok(isDisplayed, '❌ Failed to navigate to the second onboarding screen.');
    console.log('✅ Second onboarding screen is displayed!');

    console.log('click next button');
    const next2Button = await $('~Next');
    await next2Button.waitForDisplayed({ timeout: 5000 });
    await next2Button.click();

    //check Market Insight onboarding Page is displayed.
    console.log('TestCase 3: check successfully navigate to Market Insights page.')
    const thirdScreenTitle = await $('~Market Insight');
    await thirdScreenTitle.waitForDisplayed({ timeout: 5000 });
    const isAppear = await thirdScreenTitle.isDisplayed();
    assert.ok(isAppear, '❌ Failed to navigate to the Market Insight onboarding screen.');
    console.log('✅ third onboarding screen is displayed!');

    console.log('click next button');
    const next3Button = await $('~Next');
    await next3Button.waitForDisplayed({ timeout: 5000 });
    await next3Button.click();

    //check Lets begin! onboarding Page is displayed.
    console.log('TestCase 3: check successfully navigate to Lets Begin page.')
    const forthScreenTitle = await $('~Lets Begin!');
    await forthScreenTitle.waitForDisplayed({ timeout: 5000 });
    const display = await forthScreenTitle.isDisplayed();
    assert.ok(display, '❌ Failed to navigate to Lets Begin onboarding screen.');
    console.log('✅ fourth onboarding screen is displayed!');

    console.log('click Get Started button');
    const next4Button = await $('~Get Started');
    await next4Button.waitForDisplayed({ timeout: 5000 });
    await next4Button.click();

  // signUp
    console.log('TestCase 4: check successfully navigate to Sighn Up page.')
    const signUpTitle = await $('~Welcome! Let’s Get Started');
    await signUpTitle.waitForDisplayed({ timeout: 5000 });
    const signUp = await signUpTitle.isDisplayed();
    assert.ok(signUp, '❌ Failed to navigate to SignUp screen.');
    console.log('✅ SignUp Page is displayed!');

    const nameInput = await $('android=new UiSelector().className(\"android.widget.EditText\")');
    await nameInput.click();
    await nameInput.setValue('Abraham');

    console.log('click Get Started button');
    const signUpButton = await $('~Get Started');
    await signUpButton.waitForDisplayed({ timeout: 5000 });
    await signUpButton.click();

    // console.log('TestCase 5: check successfully navigate to Add wet Mill site page.')
    // const siteTitle = await $('~Do You Have a Wet Mill Site?');
    // await siteTitle.waitForDisplayed({ timeout: 5000 });
    // const siteAdd = await siteTitle.isDisplayed();
    // assert.ok(siteAdd, '❌ Failed to navigate to Wet Mill screen.');
    // console.log('✅ wet mill Page is displayed!');

    // const skipSite = await $('~Skip');
    // await skipSite.click();

     // Wait for Home page element to appear (you can change this to any unique element on Home)
    const homeTab = await $('~Home\nTab 1 of 5');
    await homeTab.waitForDisplayed({ timeout: 5000 });

    const isHomeDisplayed = await homeTab.isDisplayed();
    assert.ok(isHomeDisplayed, '❌ Failed to navigate to Home page.');
    console.log('✅ Home Page is displayed after skipping!');

    // Step 4: Check if Home tab is active (check for 'selected', 'focused', or style)
    const isSelected = await homeTab.getAttribute('selected'); // OR try 'focused'
    assert.strictEqual(isSelected, 'true', '❌ Home tab is not active.');
    console.log('✅ Home tab is active.');
    
    
});
});

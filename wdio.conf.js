exports.config = {
  // ====================
  // Runner Configuration
  // ====================
  runner: 'local',
  fullyParallel: false, 

  // ==================
  // Specify Test Files
  // ==================
  specs: [
    './test/onboarding.js',
    './test/ratio_conversion.js',
    './test/unit_convertion.js'
  ],
  exclude: [],
  suites: {
    onboarding: ['./test/onboarding.js'],
    ratioconversion: ['./test/ratio_conversion.js'],
    unitconversion: ['./test/unit_convertion.js'],
    all: [
      './test/onboarding.js',
      './test/ratio_conversion.js',
      './test/unit_convertion.js'
    ]
  },

  // ============
  // Capabilities
  // ============
  maxInstances: 1,
  capabilities: [
      {
          platformName: 'Android',
          'appium:deviceName': 'R9DN602KDXJ',
          'appium:platformVersion': '11.0',
          'appium:automationName': 'UiAutomator2',
          'appium:app': 'C:/Users/abrha/Downloads/techno-serve[0.0.14].apk',
          'appium:appPackage': 'com.example.flutter_template',
          'appium:appActivity': 'com.example.flutter_template.MainActivity',
          'appium:noReset': true,
          'appium:fullContextList': true,
          'appium:autoLaunch': true
      }
  ],

  // ===================
  // Test Configurations
  // ===================
  logLevel: 'info',
  bail: 0,
  waitforTimeout: 10000,
  connectionRetryTimeout: 120000,
  connectionRetryCount: 3,

  // ====================
  // Services Configuration
  // ====================
  services: [
      ['appium', {
          args: {
              address: 'localhost',
              port: 4723
          },
          command: 'appium'
      }]
  ],

  // =========
  // Framework
  // =========
  framework: 'mocha',
  reporters: ['spec'],
  mochaOpts: {
      ui: 'bdd',
      timeout: 60000
  }

  // =====
  // Hooks
  // =====
  // You can add hooks here if needed
};

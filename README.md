# FitgemOauth2Rails

This is a sample Rails application to test the [fitgem_oauth2](https://github.com/gupta-ankit/fitgem_oauth2) gem.

## Installation
NOTE: This application uses a local copy of fitgem_oauth. However, you can use the latest published version as well by just making changes to the Gemfile.

The following instructions assume that you are on a Linux system.

Step 1. Create a parent directory to contain this repository and the gem repository
```bash
mkdir ~/TestFitgemOauth2
cd ~/TestFitgemOauth2
```
Step 2. Clone this repository and the gem repository
```bash
git clone https://github.com/gupta-ankit/FitgemOAuth2Rails.git
git clone https://github.com/gupta-ankit/fitgem_oauth2.git
```

Step 3. Setup the application
```bash
cd ~/TestFitgemOauth2/FitgemOAuth2Rails
bundle install
bundle exec figaro install
```

Step 4. Store your Fitbit APP credentials in config/application.yml
```ruby
FITBIT_CLIENT_ID: "your_application_id"
FITBIT_CLIENT_SECRET: "your_application_secret"
```

Step 5. Migrate database and start rails server
```bash
rake db:migrate
rails s
```

# IMPORTANT NOTE:

For running this example on http://localhost:3000, make sure that you specify the correct callback url in your Fitbit application settings. It should be `http://localhost:3000/users/auth/fitbit/callback`. Looks the image below to see where to specify the callback url

![untitled](https://cloud.githubusercontent.com/assets/931331/14274522/b9cbcfe8-fac6-11e5-977f-34fcd650a720.png)

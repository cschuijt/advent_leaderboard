# Codam Advent of Code Leaderboard

This app provides a simple integration between [Advent of Code](https://adventofcode.com) and the [42 API](https://api.intra.42.fr). It will track a private leaderboard, associating users with intra accounts as it syncs data over. Users can sign in with 42 OAuth to link their accounts, after which they will appear on the leaderboard with their intra name and picture.

### Setup

To host this app yourself, just set the environment variables and `docker compose up`!
This will spin up the database and app containers. Background jobs run from the process
pool on the app container, so you do not need another container for them.
App is accessible through `localhost:3000` by default.

#### ⚠️ First time runners

To get started for the first time, follow these steps:
1. Start the containers and confirm you can log in with 42 on the site.
2. exec into the app container and run `bin/rails c`. This opens the rails console.
3. In the Rails console, give yourself admin rights: `User.find_by(username: "your_42_username").update(admin: true)`.
4. You should now be able to access the good_job dashboard in your browser at `/good_job`. If necessary, you can use the jobs listed under Cron to set up a new leaderboard, to refresh our cache of the coalitions and to open a day on the leaderboard.

#### 42 API setup

When requesting an API token from Intra, you need to add the right return URLs
for the app, so 42 knows when you try to log in that it is sending you back to
a trusted domain. The callback URI on the app's side is `/auth/marvin/callback`.
For me, this is the contents of the "Callback URI" box in Intra's app settings,
allowing both local development and production use:
```
http://127.0.0.1:3000/auth/marvin/callback
http://localhost:3000/auth/marvin/callback
https://adventofcode.codam.nl/auth/marvin/callback
```

#### Environment Variables
|Variable |Description|
|---------|-----------|
|**DB_HOST**|Hostname or container name for the database.|
|**DB_PORT**|Port through which we can reach the database.|
|**DB_USER**|Username for the database.|
|**DB_PASS**|Password for the database.|
|**SECRET_KEY_BASE**|Rails encryption key. You can generate this with `rails secret`.|
|**CAMPUS_ID**|Your campus ID on 42's side. If you do not set this, the app will default to only letting Codam students log in.|
|**FORTYTWO_KEY**|UID for the 42 API. You can generate this [here.](https://profile.intra.42.fr/oauth/applications)|
|**FORTYTWO_SECRET**|Secret for the 42 API. Make sure to schedule your life around their expiration and replacement dates.|
|**SENTRY_DSN**|Intake URL for Sentry. Leave this blank to not initialize Sentry at all.|
|**AOC_LEADERBOARD_ID**|The user ID of the owner of the private leaderboard you want to track. You can find yours [here.](https://adventofcode.com/2023/settings)|
|**AOC_LEADERBOARD_JOIN_TOKEN**|The code with which new users can join the private leaderboard. You can find it [here.](https://adventofcode.com/2023/leaderboard/private)|
|**AOC_LOGIN_TOKEN**|Session cookie from Advent of Code. Pull this from your browser, they last about a month.|
|**SENTRY_DSN**|Intake URL for error reporting to Sentry. Feel free to leave this blank.|


🚨 If you're going to deploy this app in a place where other people can access it, please regenerate the `SECRET_KEY_BASE` variable and do not use the one I generated for your convenience. It's not that hard.

#### Note for running locally

If you run the app locally, chances are you are not behind an SSL-terminating
reverse proxy. My deployment is, so the production environment is set up to
assume SSL. If you spin up this app in an environment where you will _not_ be
using HTTPS, make sure to change the following configuration options in
`config/environments/production.rb` before building the container:
```rb
# In config/environments/production.rb
config.assume_ssl = false
config.force_ssl = false
```
This way, you will be able to run everything without SSL or malformed requests.

### Contributing

The whole thing is a short and sweet Rails 7 app. A dev container file is included
in the repo, so after filling out the environment variables, getting started is easy.

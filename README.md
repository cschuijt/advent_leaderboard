# Codam Advent of Code Leaderboard

This app provides a simple integration between [Advent of Code](https://adventofcode.com) and the [42 API](https://api.intra.42.fr). It will track a private leaderboard, associating users with intra accounts as it syncs data over. Users can sign in with 42 OAuth to link their accounts, after which they will appear on the leaderboard with their intra name and picture.

### Setup

To host this app yourself, just set the environment variables and `docker compose up`! This will spin up the database and app containers. Background jobs run from the process pool on the app container, so you do not need another container for them. App is accessible through `localhost:3000` by default.

It is also possible to use just the `Dockerfile` for the app container, but then you have to set up the database yourself.

#### Environment Variables
|Variable |Description|
|---------|-----------|
|**DB_HOST**|Hostname or container name for the database.|
|**DB_PORT**|Port through which we can reach the database.|
|**DB_USER**|Username for the database.|
|**DB_PASS**|Password for the database.|
|**SECRET_KEY_BASE**|Rails encryption key. You can generate this with `rails secret`.|
|**FORTYTWO_KEY**|UID for the 42 API. You can generate this [here.](https://profile.intra.42.fr/oauth/applications)|
|**FORTYTWO_SECRET**|Secret for the 42 API. Make sure to schedule your life around their expiration and replacement dates.|
|**SENTRY_DSN**|Intake URL for Sentry. Leave this blank to not initialize Sentry at all.|
|**AOC_LEADERBOARD_ID**|The user ID of the owner of the private leaderboard you want to track. You can find yours [here.](https://adventofcode.com/2023/settings)|
|**AOC_LEADERBOARD_JOIN_TOKEN**|The code with which new users can join the private leaderboard. You can find it [here.](https://adventofcode.com/2023/leaderboard/private)|
|**AOC_LOGIN_TOKEN**|Session cookie from Advent of Code. Pull this from your browser, they last about a month.|
⚠ 🚨 If you're going to deploy this app in a place where other people can access it, please regenerate the SECRET_KEY_BASE variable and do not use the one I generated for your convenience. It's not that hard.

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

#### Getting admin status

Admins in our app cannot actually do much, but they can access the dashboard
for Good Job, our jobs backend. To give yourself admin access after logging in,
open a terminal in the app container, run `bin/rails console` and update your
details like so: `User.find_by(username: your-42-username).update(admin: true)`.
At this point, you will be able to access the dashboard through `127.0.0.1:3000/good_job`.

### Contributing

The whole thing is a short and sweet Rails 7 app. A dev container file is included in the repo, so after filling out the environment variables, getting started is easy.

Feel free to target the `main` branch with your pull requests. A separate
`deploy` branch automatically deploys the app to production.

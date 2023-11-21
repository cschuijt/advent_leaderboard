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
|**AOC_LEADERBOARD_ID**|The user ID of the owner of the private leaderboard you want to track.|
|**AOC_LOGIN_TOKEN**|Session cookie from Advent of Code. Pull this from your browser, they last about a month.|

### Contributing

The whole thing is a short and sweet Rails 7 app. A dev container file is included in the repo, so after filling out the environment variables, getting started is easy.

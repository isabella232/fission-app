# Fission App

Web application front end and user manager.

## About

This is a Rails application and framework for the website to manage users and track build
information. Allowing the creation and management of user data and permissions of what
each user can perform when building packages. Rails application is supported by a riak
database.

## Getting Started

_NOTE: these are the instructions for getting the Fission rails app running; currently these instructions are limited to packager.co development, but other fission apps will use similar instructions._

1. Setup a `fission` project directory, and clone the develop branch of the following fission repos:

    ~~~ shell
    mkdir fission && cd fission
    git clone -b develop git@github.com:heavywater/fission.git
    git clone -b develop git@github.com:heavywater/fission-data.git
    git clone -b develop git@github.com:heavywater/fission-app.git
    git clone -b develop git@github.com:heavywater/fission-app-jobs.git
    git clone -b develop git@github.com:heavywater/fission-app-static.git
    git clone -b develop git@github.com:heavywater/fission-app-stripe.git
    git clone -b develop git@github.com:heavywater/fission-app-docs.git
    ~~~

2. `cd fission-app && bundle install`

3. Install & start Riak

4. Create a `/config/riak.json` file with the following contents:

    ~~~ json
    {
      "nodes": [
        {
          "host": "IPADDRESS"
        }
      ]
    }
    ~~~

    _NOTE: replace `IPADDRESS` with the address of your local riak server_

5. Set some environment variables:

    ~~~ shell
    export FISSION_LOCALS=true
    export FISSION_DATA=true
    export FISSION_RIAK_CONFIG='config/riak.json'
    sudo echo "127.0.0.1  dev.packager.co" >> /etc/hosts
    ~~~

6. Edit the `/config/fission.json` config file, adding your GitHub user account here:

    ~~~ json
    ...
      "whitelist": {
          "users": [
              "chrisroberts",
              "calebhailey"
          ]
      },
    ...
    ~~~

7. Run the Fission Rails app!

    ~~~ shell
    bundle exec rails s
    ~~~

8. Visit your locally running instance at `http://dev.packager.co:3000`


### Helpful testing things:

* ALLOW_NO_AUTH=true - defaults to first user on request
* Sending JSON requests:
  * `curl http://localhost:3000/users/6 -H "Accept: application/json"`

## Usage examples

Run rails application. Do website stuff.

### Start without database

```
FISSION_DATA=false ./bin/rails s
```

It's important to note most of the app will not work.

### Using local repository checkouts

```
FISSION_LOCALS=true ./bin/rails s
```

This will use local paths instead of repos for fission
related gems. It assumes everything will be in the same
directory on the local machine. It requires all fission
used gems to be local. Look in the Gemfile to see the
full list.

### Enable github OAuth support

Use the hw-test for local testing:

```
GITHUB_KEY='KEY' GITHUB_SECRET='SECRET' bundle exec rails s
```

The key and secret and be found in the application section
on github: https://github.com/organizations/heavywater/settings/applications/69745

### Enable Stripe support

Add environment keys for stripe:

```
STRIPE_SECRET_KEY='fubar' STRIPE_PUBLISHABLE_KEY='fubar' bundle exec rails s
```

# Fission App

Web application front end and user manager.

## About

This is a Rails application and framework for the website to manage users and track build
information. Allowing the creation and management of user data and permissions of what
each user can perform when building packages. Rails application is supported by a postgresql
database.

## Getting Started

1. Install ruby and rails
  * add-apt-repository ppa:brightbox/ruby-ng
2. clone repository
  * git clone https://github.com/heavywater/fission-app
3. Change to repository directory
  * `bundle install`
  * `bundle --binutils`
4. Install postgresql (config/database.yml)
  * create user fission with password fission
  * alter user fission CREATEDB
  * create database named fission_app_development
  * alter database fission_app_development owner to fission
  * grant permission to database
5. `rake db:migrate`
6. `./bin/rails s`
  * RAILS_ENV=test ALLOW_NO_AUTH=true ./bin/rails s
7. `curl http://localhost:3000/users/6 -H "Accept: application/json"`

## Usage examples

Run rails application. Do website stuff.

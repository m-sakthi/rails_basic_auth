# rails_basic_auth
Boiler Plate - Rails-Postgres App with Basic Auth and swagger docs.

## Clone
Clone from the repository

```sh
git clone https://github.com/msv300/rails_basic_auth
```

## Features

* pre-build user and roles features
* basic authentication
* docs using swagger
* ... more yet to come


## Setup


Edit the following files in the `config/` folder as per your settings
* app_settings.yml
* dalli.yml
* mailer.yml
* database.yml

Once you are done with the settings do the following,

* install the dependent gems - `bundle install`
* create database with `rails db:create`
* generate swagger json files with `rails swagger:docs`
* start the server with `rails s`
* navigate to `localhost:3000` to see the swagger documentation

## Upcoming

* Unit test cases
* Dockerization
* ... more yet to come

## License
MIT License (MIT).

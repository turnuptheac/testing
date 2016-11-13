# README

This is a flashcard app powered by Rails and Angular.

## System dependencies
postgresql is required. It can be installed with

```
brew install postgresql
```
Bower is required, so that you can install browser assets with the following command

```
bower install
```

## Database setup
```
rake db:create
rake db:migrate
```

## Running the app
Finally, you can run the server which also serves the client-side code:
```
rails server
```

## How to run the test suite
To run server unit tests, you can run

```
rake spec
```

To run JavaScript unit tests in the browser, you can run

```
rake jasmine
```

To run JavaScript unit tests headless mode, you can run

```
rake jasmine:ci
```
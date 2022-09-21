# BITCOIN MARKET

## TLDR

### How to run the project

- rename sample.env as .env and provide database information if different
- in a terminal run the database `docker-compose -f integration/docker-compose.yml up`
- in another terminal, setup and seed the database `bundle exec dotenv rake setup_db`
- run the tests `bundle exec dotenv rspec`
- run the demonstration main.rb `bundle exec dotenv ruby main.rb`
- CTRL + C in the docker-compose terminal to stop the container

## Explanations on code and choices

### Modelisation

At first, i wanted to use ActiveRecord as an ORM for a more elegant code.
But it could have been a little bit tricky to use it without Rails as all documentation  and 
answer on stack-overflow will assume a Rails context.

using Sequel was a less satisfying solution but not as low-level as pure SQL query string.
It still was tricky in some cases

All the simplicity of the ORM is now the responsibility of the MysqlConnector
Where all the ugly querying is hidden

### Structure

The class Market is now a BTCMarket that derives from a Market::Base

The Market depends on a database connector that must derive from Database::Base
to ensure compatibility

___
 
the Market classes responsibility is to manage the Orders
it includes the Service::Order_Solver which responsibility is the 'algorithm'


The CRUD operations are the responsibility of the Database connector


models/orders.rb and database/in_memory_connectors.rb are artifacts from the Level 1 first POC

### Improvements

beside the bugs that might appear here and there, here are the main improvements i see

- Structure can be a lot cleaner with an ORM
- Depends on the first point but : model validation (negative balance, wrong datatype...)
- Database integrity : the matching operation should save the state before changing the users balance so if any part of the operation fails, we can restore to a snapshot
- testing : I was easy on integration tests since the main.rb acts like one


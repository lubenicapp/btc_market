# BITCOIN MARKET

## TLDR

### How to run the project

- rename sample.env as .env and provide database information if different
- in a terminal run the database `docker-compose -f integration/docker-compose.yml up`
- install dependencies with `bundle`
- in another terminal, setup and seed the database `bundle exec dotenv rake setup_db`
- run the tests `bundle exec dotenv rspec`
- run the demonstration main.rb `bundle exec dotenv ruby main.rb`
- same with main_eth.rb for eth market
- CTRL + C in the docker-compose terminal to stop the container
- to clear the database `bundle exec dotenv rake clear_db`


## Explanations on code and choices

### Modelisation

At first, i wanted to use ActiveRecord as an ORM for a more elegant code.
But it could have been a little bit tricky to use it without Rails as all documentation and 
answer on stack-overflow will assume a Rails context.

using Sequel was a less satisfying solution but not as low-level as pure SQL query string.
It still was tricky in some cases.

All the simplicity of the ORM is now the responsibility of the MysqlConnector
Where all the ugly querying is hidden

The database schema is pretty much described in the Rakefile in the setup database part.

here it is :

``` ruby
  unless DATABASE.table_exists?(:users)
    DATABASE.create_table :users do
      primary_key :id

      column :eur, String
      column :btc, String
      column :eth, String
    end
  end

  unless DATABASE.table_exists?(:orders)
    DATABASE.create_table :orders do
      primary_key :id
      foreign_key :user_id, :users

      column :amount, String
      column :price, String
      column :side, String
      column :state, String
      column :market, String
    end
  end
```


### Structure

The class Market is now a BTCMarket that derives from a Market::Base
This make the code DRY so the eth_market just has to declare the @base and @quote 

The DRYing of the Markets classes might be a mistake. sometimes, classes share code but it is accidental.
For the moment it work, but we might need to split the code differently with different protocols.

The Market depends on a database connector that must derive from Database::Base
to ensure compatibility

___
 
the Market classes responsibility is to manage the Orders
it includes the Service::Order_Solver which responsibility is the 'algorithm'


The CRUD operations are the responsibility of the Database connector


models/orders.rb and database/in_memory_connectors.rb are/contains artifacts from the Level 1 first POC

### Improvements

beside the bugs that might appear here and there, here are the main improvements i see

- Structure can be a lot cleaner with an ORM
- Depends on the first point but : model validation (negative balance, wrong datatype...)
- Database integrity : the matching operation should save the state before changing the users balance so if any part of the operation fails, we can restore to a snapshot, or at least a prepare/execute steps
- testing : I was easy on integration tests since the main.rb acts like one
- the storage of BigDecimal value as string might not be efficient

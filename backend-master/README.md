# BITCOIN MARKET

## Level 1

For this exercise to be done in two hours, I decided to keep it simple. Because it would take

too much time to make it as clean as I want

orders are stored in-memory

no unit tests were written

no validation is done for Order arguments



## Code explanation

I decided to include the files in a module 'BTCMarket'

lib/db/db_connector represents the mock database, to be replaced with a SQL connector

lib/models/order represent the object Order 

lib/market implements the required public methods. some private methods were added

lib/btc_market is the "header file"

## Run and test the implementation

A jupyter notebook is provided where you can run simple code examples and where i described the instructions

to run a jupyter notebook with a ruby kernel, please refer to this [page](https://github.com/SciRuby/iruby)

otherwise you can run `ruby main.rb`


## Next steps

- docker-compose with postgresql for order storage

- units tests and integrations tests with Rspec


- argument validation
- error handling


A sample data schema based off the [Chinook example database](https://github.com/cwoodruff/ChinookDatabase).

The Chinook data model represents a digital media store, including tables for artists, albums, media tracks, invoices and customers.

## Importing the data schema

Open a terminal in the Hasura directory. Now we apply the migrations, metadata, and seeds.

```bash
hasura migrate apply --endpoint <Remote Hasura URL if applicable> --admin-secret <admin secret> --database-name default

hasura metadata apply --endpoint <Remote Hasura URL> --admin-secret <admin secret>

hasura seeds apply --endpoint <Remote Hasura URL if applicable> --admin-secret <admin secret> --database-name default
```

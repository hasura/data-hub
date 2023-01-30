A sample data schema based off the [Chinook example database](https://github.com/cwoodruff/ChinookDatabase).

The Chinook data model represents a digital media store, including tables for artists, albums, media tracks, invoices and customers.

## Importing the data schema

You can use the one-click to deploy on Hasura Cloud to get started quickly

[![Deploy to Hasura Cloud](https://hasura.io/deploy-button.svg)](https://cloud.hasura.io/deploy?github_repo=https://github.com/hasura/data-hub&hasura_dir=data-models/postgres/chinook/hasura)

Alternatively, if you want to set it up manually, open a terminal in the Hasura directory. Now we apply the migrations, metadata, and seeds.

```bash
hasura migrate apply --endpoint <Remote Hasura URL if applicable> --admin-secret <admin secret> --database-name default

hasura metadata apply --endpoint <Remote Hasura URL> --admin-secret <admin secret>

hasura seeds apply --endpoint <Remote Hasura URL if applicable> --admin-secret <admin secret> --database-name default
```

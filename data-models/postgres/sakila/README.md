A sample data schema based off the [Sakila example database](https://github.com/jOOQ/sakila).

The Sakila database is a nicely normalised database modelling a DVD rental store.

## Importing the data schema

Open a terminal in the Hasura directory. Now we apply the migrations, metadata, and seeds.

```bash
hasura migrate apply --endpoint <Remote Hasura URL if applicable> --admin-secret <admin secret> --database-name default

hasura metadata apply --endpoint <Remote Hasura URL> --admin-secret <admin secret>

hasura seeds apply --endpoint <Remote Hasura URL if applicable> --admin-secret <admin secret> --database-name default
```

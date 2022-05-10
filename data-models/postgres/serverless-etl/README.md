Build an ETL process using event triggers on Hasura.

Read [the Github readme for step-by-step directions](https://github.com/hasura/graphql-engine/tree/master/community/sample-apps/serverless-etl).

## Setting Hasura enviroment Variables

You'll need the following environment variable in your Hasura instance.

```bash
CLOUD_FUNCTION_URL: <Cloud Function URL>
```

## Importing the data schema

Open a terminal in the Hasura directory. Now we apply the migrations, metadata, and seeds.

```bash
hasura migrate apply --endpoint <Remote Hasura URL if applicable> --admin-secret <admin secret> --database-name default

hasura metadata apply --endpoint <Remote Hasura URL> --admin-secret <admin secret>
```

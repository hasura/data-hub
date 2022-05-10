A ecommerce schema example from the [Hasura Super App](https://hasura.io/reference-app/).

To run the fullstack example please see the [Github repository](https://github.com/hasura/hasura-ecommerce).

## Setting enviroment Variables

You'll need the following environment variables in your Hasura instance, for a real project you'd use your own admin/JWT secret.

```bash
NEXTJS_SERVER_URL: <Your nextjs URL>
HASURA_GRAPHQL_ADMIN_SECRET: <admin secret>
HASURA_GRAPHQL_JWT_SECRET: '<JWT secret>'
HASURA_GRAPHQL_UNAUTHORIZED_ROLE: anonymous
```

## Importing the data schema

Open a terminal in the Hasura directory. Now we apply the migrations, metadata, and seeds.

```bash
hasura migrate apply --endpoint <Remote Hasura URL if applicable> --admin-secret <admin secret> --database-name default

hasura metadata apply --endpoint <Remote Hasura URL> --admin-secret <admin secret>

hasura seeds apply --endpoint <Remote Hasura URL if applicable> --admin-secret <admin secret> --database-name default
```

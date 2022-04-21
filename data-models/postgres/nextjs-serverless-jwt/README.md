Add Authentication and Authorization to Next.js 8 Serverless Apps using JWT and GraphQL.

Read [the blog post for step-by-step directions](https://hasura.io/blog/add-authentication-and-authorization-to-next-js-8-serverless-apps-using-jwt-and-graphql/).

## Setting Hasura enviroment Variables

You'll need the following environment variables in your Hasura instance.

```bash
HASURA_GRAPHQL_JWT_SECRET: { "type": "RS256", "key": "<AUTH_PUBLIC_KEY generated in blog post>" }
HASURA_GRAPHQL_JWT_SECRET: <secure secret phrase>
```

## Importing the data schema

Open a terminal in the Hasura directory. Now we apply the migrations, metadata, and seeds.

```bash
hasura migrate apply --endpoint <Remote Hasura URL if applicable> --admin-secret <admin secret> --database-name default

hasura metadata apply --endpoint <Remote Hasura URL> --admin-secret <admin secret>
```

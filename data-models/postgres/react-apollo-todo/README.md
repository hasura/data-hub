Build a Collaborative Realtime Todo App Backend Using Hasura GraphQL.

Read [the blog post for step-by-step directions](https://auth0.com/blog/building-a-collaborative-todo-app-with-realtime-graphql-using-hasura).

## Setting Hasura enviroment Variables

You'll need the following environment variables in your Hasura instance.

```bash
HASURA_GRAPHQL_JWT_SECRET: <HASURA_GRAPHQL_JWT_SECRET generated in blog post>
HASURA_GRAPHQL_JWT_SECRET: <secure secret phrase>
```

## Importing the data schema

Open a terminal in the Hasura directory. Now we apply the migrations, metadata, and seeds.

```bash
hasura migrate apply --endpoint <Remote Hasura URL if applicable> --admin-secret <admin secret> --database-name default

hasura metadata apply --endpoint <Remote Hasura URL> --admin-secret <admin secret>
```

Multiplayer Tic Tac Toe with GraphQL.

Read [the blog post for step-by-step directions](https://css-tricks.com/multiplayer-tic-tac-toe-with-graphql/).

## Setting Hasura enviroment Variables

You'll need the following environment variable in your Hasura instance.

```bash
TIC_TAC_REMOTE_SCHEMA_URL: <Custom server URL>
```

## Importing the data schema

Open a terminal in the Hasura directory. Now we apply the migrations, metadata, and seeds.

```bash
hasura migrate apply --endpoint <Remote Hasura URL if applicable> --admin-secret <admin secret> --database-name default

hasura metadata apply --endpoint <Remote Hasura URL> --admin-secret <admin secret>
```

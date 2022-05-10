Building a WhatsApp Clone with GraphQL, React Hooks and TypeScript.

Read [the blog post for step-by-step directions](https://hasura.io/blog/building-a-whatsapp-clone-with-graphql-react-hooks-typescript/).

## Setting Hasura enviroment Variables

You'll need the following environment variable in your Hasura instance.

```bash
HASURA_GRAPHQL_JWT_SECRET: <JWT config>
```

## Importing the data schema

Open a terminal in the Hasura directory. Now we apply the migrations, metadata, and seeds.

```bash
hasura migrate apply --endpoint <Remote Hasura URL if applicable> --admin-secret <admin secret> --database-name default

hasura metadata apply --endpoint <Remote Hasura URL> --admin-secret <admin secret>
```

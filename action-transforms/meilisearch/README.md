Meilisearch is a RESTful search API. It aims to be a ready-to-go solution for everyone who wants a fast and relevant search experience for their end-users ⚡️🔎

Leverage Meilisearch data through Hasura's API ecosystem by using this action transform.

We are going to define a GraphQL query maps the action search input type to the Meilisearch API and returns a response.

For example:

```graphql
query Meilisearch {
  meilisearchSearch(query: "botman", limit: 20, offset: 0) {
    hits
  }
}
```

## Configuring an Action Transform

You'll need the following environment variables.

```bash
MEILISEARCH_URL: "http://localhost:7700"
```

If you are using Docker you can provide these environment variables along with the rest of your Hasura configuration information.

## Importing an Action Transform

Importing actions and events into Hasura apply one or more actions. Actions based on request configurations and will need metadata to be applied. Events need underlying table structure to trigger the events.

Steps required for this integration:

- Metadata Apply

### Metatadata Apply

To apply metadata into your project. You will need:

1. The Hasura CLI installed.
2. Run "hasura metadata apply" from the root folder of your Hasura metadata project. In this project, you can find that folder under `/hasura`.

More [information about Hasura CLI](https://hasura.io/docs/latest/graphql/core/hasura-cli/index.html) can be found in the documentation.

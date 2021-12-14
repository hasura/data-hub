# Prismic Action Transform for Hasura

Prismic is a Content Management System, a tool for editing online content.

In this integration, we are making use of Prismic REST API for search by defining a GraphQL query and mapping the input argument to the REST API payload.

The GraphQL query would look something like:

```graphql
query MyQuery {
  prismicSearch(q: "product") {
    results
  }
}
```

## Configuring an Action Transform

You'll need the following environment variables.

```bash
PRISMIC_SEARCH_ENDPOINT: "https://test-tiru.prismic.io/api/v2/documents/search"
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

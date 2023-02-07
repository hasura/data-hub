Algolia provides composable APIs enabling developers to add search functionality to apps. With a global CDN, it can deliver results in milliseconds. Leverage Algolia data through Hasura's API ecosystem by using this action transform.

We are going to define a GraphQL query which accepts a search input and returns the response from Algolia. We are mapping the search input type to Algolia's REST API payload.

For example:

```graphql
{
  algoliaSearch(query: "Mobile Phone", hitsPerPage: 10, getRankingInfo: 1) {
    hits
  }
}
```

You can use the one-click to deploy on Hasura Cloud to get started quickly

[![Deploy to Hasura Cloud](https://hasura.io/deploy-button.svg)](https://cloud.hasura.io/deploy?github_repo=https://github.com/hasura/data-hub&hasura_dir=action-transforms/algolia/hasura)

## Configuring an Action Transform

You'll need the following environment variables.

```bash
ALGOLIA_APPLICATION_ID: "application-id"
ALGOLIA_INDEX_NAME: "some-index-name"
ALGOLIA_API_KEY: "xxxxxxxxxxxxxxxxx"
```

If you are using Docker you can provide these environment variables along with the rest of your Hasura configuration information.

Check out Algolia Docs on [Creating and Managing API key](https://www.algolia.com/doc/guides/security/api-keys/#creating-and-managing-api-keys)

## Importing an Action Transform

Importing actions and events into Hasura apply one or more actions. Actions based on request configurations and will need metadata to be applied. Events need underlying table structure to trigger the events.

Steps required for this integration:

- Metadata Apply

### Metatadata Apply

To apply metadata into your project. You will need:

1. The Hasura CLI installed.
2. Run "hasura metadata apply" from the root folder of your Hasura metadata project. In this project, you can find that folder under `/hasura`.

More [information about Hasura CLI](https://hasura.io/docs/latest/graphql/core/hasura-cli/index.html) can be found in the documentation.

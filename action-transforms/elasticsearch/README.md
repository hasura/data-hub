Elasticsearch is a search engine based on Lucene providing a full text search engine with an HTTP web interface.

In this integration, we are making use of Elastic's REST API for search by defining a GraphQL query and mapping the input argument to the REST API payload.

For example, the equivalent REST API would look like the following:

```bash
curl -XGET 'https://test-tiru.es.us-central1.gcp.cloud.es.io:9243/kibana_sample_data_ecommerce/_search' -H 'Content-Type: application/json' -H 'Authorization: ApiKey <token>' \
-d '{
  "query": {
    "match": {
      "customer_id": 10   
    }
  }
}'
```

The GraphQL query would look something like:

```graphql
query MyQuery {
  searchCustomerId(customer_id: 10) {
    hits
  }
}
```

You can use the one-click to deploy on Hasura Cloud to get started quickly

[![Deploy to Hasura Cloud](https://hasura.io/deploy-button.svg)](https://cloud.hasura.io/deploy?github_repo=https://github.com/hasura/data-hub&hasura_dir=action-transforms/elasticsearch/hasura)

## Configuring an Action Transform

You'll need the following environment variables.

```bash
ELASTIC_SEARCH_ENDPOINT: "https://test-tiru.es.us-central1.gcp.cloud.es.io:9243/kibana_sample_data_ecommerce/_search"
ELASTIC_API_KEY: "ApiKey <token>"
```

If you are using Docker you can provide these environment variables along with the rest of your Hasura configuration information.

Find your Elasticsearch API Key or [create one from scratch](https://www.elastic.co/guide/en/elasticsearch/reference/current/security-api-create-api-key.html)

## Importing an Action Transform

Importing actions and events into Hasura apply one or more actions. Actions based on request configurations and will need metadata to be applied. Events need underlying table structure to trigger the events.

Steps required for this integration:

- Metadata Apply

### Metatadata Apply

To apply metadata into your project. You will need:

1. The Hasura CLI installed.
2. Run "hasura metadata apply" from the root folder of your Hasura metadata project. In this project, you can find that folder under `/hasura`.

More [information about Hasura CLI](https://hasura.io/docs/latest/graphql/core/hasura-cli/index.html) can be found in the documentation.

Creating a Data Graph with GraphQL Mesh and Hasura Remote Joins

You can use the one-click to deploy on Hasura Cloud to get started quickly

[![Deploy to Hasura Cloud](https://hasura.io/deploy-button.svg)](https://cloud.hasura.io/deploy?github_repo=https://github.com/hasura/data-hub&hasura_dir=remote-schemas/graphql-mesh/hasura)

## Using GraphQL Mesh

GraphQL Mesh can be used as

- SDK in Node.js code
- Gateway to serve GraphQL API

We will look at using Mesh as a Gateway that exposes an endpoint that can be added as a Remote Schema in Hasura.

## Initialise a GraphQL Mesh project

We can initialise a new project using yarn.

```bash
yarn init -y
yarn add graphql @graphql-mesh/cli @graphql-mesh/openapi
```

We are setting up the mesh CLI and adding the openapi client.

Create a config file .meshrc.yml to specify the data source and let's add the Currency Open API.

```yaml
sources:
  - name: CurrencyOpenAPI
    handler:
      openapi:
        source: <path-to-open-api-schema.json>
```

Download the Open API Spec for this example and replace the source path appropriately. This is a spec for API served at `https://api.exchangerate-api.com/v4`.

## Run GraphQL Mesh

Run the GraphQL Mesh instance with the following command:

```bash
yarn mesh serve
```

This will run a GraphQL API at `http://localhost:4000`.

To add this as a remote schema to the Hasura Cloud project, we will have to deploy this on a public endpoint. I'm going to make use of Codesandbox to try this out.

```
https://codesandbox.io/embed/stupefied-mclaren-00e5c?fontsize=14&hidenavigation=1&theme=dark
```

You can create a new Sandbox/fork the above with Node.js and put in the mesh config file over there.

In your Hasura Cloud project, add the graphql endpoint from codesandbox. In the above example, it would be `https://00e5c.sse.codesandbox.io/graphql`. Replace this if necessary with your own forked sandbox URL.

Alright, now we have configured GraphQL Mesh to serve a GraphQL API over an existing OpenAPI spec.

![Remote Schemas](https://hasura.io/blog/content/images/2020/12/remote-schema-graphql-mesh.png)

## Try out the GraphQL Query

```graphql
query {
  getLatestBaseCurrency(baseCurrency: "USD") {
    base
    date
    rates
    timeLastUpdated
  }
}
```

![GraphQL Query](https://hasura.io/blog/content/images/2020/12/remote-schema-query.png)

This should fetch data from the underlying currency API.

## Remote Relationship with Mesh

Assuming that we have a users table with columns id, name and currency. Let's add a remote relationship called currency_rates from inside of users table.

![Remote Relationship](https://hasura.io/blog/content/images/2020/12/remote-schema-relationship.png)

Now the GraphQL query to fetch this data in a single API call would look like the following:

```graphql
query {
  users {
    id
    name
    currency
    currency_rates {
      date
      rates
    }
  }
}
```

Notice that, the nested query currency_rates come from exchange rate API following the OpenAPI spec. It will apply the filter of users.currency = currency_rates.baseCurrency, there by only giving exchange rates related to the current user's currency.
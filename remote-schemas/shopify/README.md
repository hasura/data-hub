Shopify is an e-commerce platform that allows you to start and run an online store.

You can use the one-click to deploy on Hasura Cloud to get started quickly

[![Deploy to Hasura Cloud](https://hasura.io/deploy-button.svg)](https://cloud.hasura.io/deploy?github_repo=https://github.com/hasura/data-hub&hasura_dir=remote-schemas/shopify/hasura)

## Setup the Shopify GraphQL API

Shopify does not come with a GraphQL API by default. You have to install and configure it manually.

1. Go to `https://<your-store-name>.myshopify.com/admin/apps`
2. Click on `Develop apps`
3. Click on `Allow custom app development`
4. On the next page, press the same button again
5. Click on `Create an app`
6. Choose a name such as "graphql-api"
7. Go to `API credentials` and configure your `Admin/Storefront API scopes`
8. After that, go again to `API Credentials` and click on `Install app`
9. A new pop-up appears - click on `Install` again
10. You will get the `Admin API access token`, which you need to copy and save somewhere safe

Now it's time to add your Shopify store to Hasura as a remote schema.

## Adding Shopify as Remote Schema

Head over to the Hasura Console, go to the “Remote Schemas” page and click on the “Add” button.

1. Give your Remote Schema a name
2. Add the GraphQL endpoint - `https://<your-store-name>.myshopify.com/admin/api/2022-01/graphql.json`
3. Set the `Content-Type` header to `application/graphql`
4. Set the `X-Shopify-Access-Token` header
5. Click on “Add Remote Schema”

![Shopify Hasura Remote Schema](https://graphql-engine-cdn.hasura.io/data-hub/shopify/shopify-hasura-remote-schema.png)

After that, you can run queries and mutations on your Shopify shop.

![Shopify Hasura Query Example](https://graphql-engine-cdn.hasura.io/data-hub/shopify/shopify-hasura-query-example.png)

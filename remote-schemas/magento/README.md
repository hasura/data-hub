Magento is an open-source e-commerce platform that enables you to run an online store.

You can use the one-click to deploy on Hasura Cloud to get started quickly

[![Deploy to Hasura Cloud](https://hasura.io/deploy-button.svg)](https://cloud.hasura.io/deploy?github_repo=https://github.com/hasura/data-hub&hasura_dir=remote-schemas/magento/hasura)

## Magento GraphQL Endpoint

Magento stores come with GraphQL support as an alternative to REST and SOAP APIs.

The GraphQL endpoint of your store should be `http://<magento-store-url>/graphql`.

> Note: Check the Magento documentation to ensure your store supports GraphQL. Also, consult the documentation to learn how to enable GraphQL for your Magento store.

## Add Magento as Remote Schema

In the console of your Hasura project, go to the "Remote Schemas" page and click on the "Add" button.

On the new page:
- Choose a name for the remote schema - for example `my-magento-store`
- Enter your the URL of your GraphQL API - `http://<magento-store-url>/graphql`
- Press the button "Add Remote Schema" to save the remote schema

You are done and you can use the newly-created remote schema.
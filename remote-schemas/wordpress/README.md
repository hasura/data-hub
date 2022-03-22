WordPress is a content management system that you can use to build websites and blogs. It's free, open-source and it's written in PHP.

## Pre-requisites

WordPress does not come with GraphQL support by default. That means you have to set it up yourself. One way to do it is to install the **WPGraphQL** plugin.

"*WPGraphQL is a free, open-source WordPress plugin that provides an extendable GraphQL schema and API for any WordPress site.*" - WPGraphQL Website

This example uses the WordPress + WPGraphQL combo.

## Adding WordPress as a Remote Schema

After you configure GraphQL for your WordPress, you will have a GraphQL Endpoint available at:

```
https://<your-site-URL>/graphql
```

> Note: For the URL to work, make sure you set the URL structure to `<your-site-url>/%postname%/` in the "Permalinks Settings" page. We recommend checking the WPGraphQL documentation for in-depth information.

Head over to the "Remote Schemas" page in your project's console and click on the "Add" button.

![WordPress Remote Schema](https://graphql-engine-cdn.hasura.io/data-hub/wordpress/wordpress-remote-schema.png)

Choose a name for your remote schema and then enter the URL. You do not need to add any additional headers in this case so you can save the remote schema.

If you go to the API page and browse through the Explorer, you can see the queries and mutations available.

![WordPress Remote Schema Example](https://graphql-engine-cdn.hasura.io/data-hub/wordpress/wordpress-remote-schema-api-explorer)

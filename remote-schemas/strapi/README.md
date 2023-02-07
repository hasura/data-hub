# Strapi

Strapi is the leading open-source headless CMS. It offers a [GraphQL plugin](https://docs.strapi.io/developer-docs/latest/plugins/graphql.html) which we can join with Hasura using Remote Schemas.

You can use the one-click to deploy on Hasura Cloud to get started quickly

[![Deploy to Hasura Cloud](https://hasura.io/deploy-button.svg)](https://cloud.hasura.io/deploy?github_repo=https://github.com/hasura/data-hub&hasura_dir=remote-schemas/strapi/hasura)

## Adding Strapi as a Remote Schema

- In the Hasura Console, go to Remote Schemas and enter the Strapi Graphql API `https://<STRAPI_URL>/graphql`

- If you want to use the [Strapi roles & permissions system:](https://docs.strapi.io/developer-docs/latest/plugins/users-permissions.html)

  - Check `Forward all headers from client` option in the Hasura remote schema options.
  - Then attach your JWT in the Authorization header of your client.
  - You can also [layer Hasura permissions on top.](https://hasura.io/docs/latest/graphql/core/remote-schemas/auth/index.html)

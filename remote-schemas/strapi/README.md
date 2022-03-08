# Strapi

Strapi is the leading open-source headless CMS. It offers a [GraphQL plugin](https://docs.strapi.io/developer-docs/latest/plugins/graphql.html) which we can join with Hasura using Remote Schemas.

## Adding Strapi as a Remote Schema

- In the Hasura Console, go to Remote Schemas and enter the Strapi Graphql API `https://<STRAPI_URL>/graphql`

- If you want to use the [Strapi roles & permissions system:](https://docs.strapi.io/developer-docs/latest/plugins/users-permissions.html)

  1. Check `Forward all headers from client` option in the Hasura remote schema options.
  1. Then attach your JWT in the Authorization header of your client.
  1. You can also [layer Hasura permissions on top.](https://hasura.io/docs/latest/graphql/core/remote-schemas/auth/index.html)

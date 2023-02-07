Contentful is an API First CMS to build Digital products. It offers a [GraphQL API](https://www.contentful.com/developers/docs/references/graphql/#/introduction/basic-api-information) which can be joined with Hasura using Remote Schema.

You can use the one-click to deploy on Hasura Cloud to get started quickly

[![Deploy to Hasura Cloud](https://hasura.io/deploy-button.svg)](https://cloud.hasura.io/deploy?github_repo=https://github.com/hasura/data-hub&hasura_dir=remote-schemas/contentful/hasura)

## Adding Contentful as Remote Schema

- Get the GraphQL Content API Endpoint in the following format:

```
https://graphql.contentful.com/content/v1/spaces/<space-id>
```

And replace <space-id> with the appropriate value.

- In Contentful dashboard, click on **Settings**. Under **Space Settings** click on **API keys**. Copy the Space ID and paste in the above endpoint.
- Now copy Content Delivery API - access token and use it in Authorization headers like below:

```
Authorization: Bearer <access_token>
```

- In Hasura Console, head to Remote Schemas and enter GraphQL Server URL with the above contentful endpoint. Under Additional Headers, enter the Authorization header with the access_token as mentioned above.

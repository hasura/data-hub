# Auth0 Action Transform for Hasura

Auth0 is an identify platform for adding user authentication easily to apps.

In this integration, we are making use of Auth0's update profile REST API by defining a GraphQL mutation and mapping the input argument to the Auth0 payload.

For example, the equivalent REST API would look like the following:

```bash
curl --request PATCH \
  --url 'https://crossliftspro.auth0.com/api/v2/users/auth0|5c4acd40a5a4833f69d6bc45' \
  --header 'authorization: Bearer <token>' \
  --header 'content-type: application/json' \
  --data '{"user_metadata": {"picture": "https://example.com/some-image.png"}}'
```

The GraphQL mutation would look something like:

```graphql
mutation MyMutation {
  updateProfilePic(picture_url: "some-url.jpg") {
    email
    name
    user_id
    app_metadata
    created_at
    email_verified
    identities
    last_ip
    last_login
    logins_count
    nickname
    picture
    updated_at
    user_metadata
  }
}
```

You can pick and choose which fields to get back in the response based on the requirement.

## Configuring an Action Transform

You'll need the following environment variables.

```bash
AUTH0_DOMAIN: "crossliftspro.auth0.com"
AUTH0_AUTH_TOKEN: "Bearer xxxxx"
```

If you are using Docker you can provide these environment variables along with the rest of your Hasura configuration information.

Find your Auth0 Domain from the [basic settings of the dashboard](https://auth0.com/docs/configure/applications/application-settings#basic-settings)

## Importing an Action Transform

Importing actions and events into Hasura apply one or more actions. Actions based on request configurations and will need metadata to be applied. Events need underlying table structure to trigger the events.

Steps required for this integration:

- Metadata Apply

### Metatadata Apply

To apply metadata into your project. You will need:

1. The Hasura CLI installed.
2. Run "hasura metadata apply" from the root folder of your Hasura metadata project. In this project, you can find that folder under `/hasura`.

More [information about Hasura CLI](https://hasura.io/docs/latest/graphql/core/hasura-cli/index.html) can be found in the documentation.

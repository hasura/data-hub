Firebase is a popular suite of tools and services for starting projects quickly in the Google Cloud. Many startups begin there journey with Firebase and as such, have many user accounts still authenticating with Firebase, even after migrating to other tools for the the rest of their stack.

This integration allows you to create new user accounts, and authenticate users with `email` and `password`.

An example mutation to create a user:

```graphql
mutation {
  firebase_signup(
    params: { email: "username@userdomain.tld", password: "safe-password" }
  ) {
    idToken
    refreshToken
    expiresIn
    localId
    email
  }
}
```

An example mutation to authenticate a user:

```graphql
mutation {
  firebase_signin(
    params: { email: "username@userdomain.tld", password: "safe-password" }
  ) {
    idToken
    refreshToken
    expiresIn
    localId
    email
    registered
  }
}
```

You can use the one-click to deploy on Hasura Cloud to get started quickly

[![Deploy to Hasura Cloud](https://hasura.io/deploy-button.svg)](https://cloud.hasura.io/deploy?github_repo=https://github.com/hasura/data-hub&hasura_dir=action-transforms/firebase/hasura)

## Configuring an Action Transform

You'll need the following environment variables.

```bash
 FIREBASE_API_BASE: https://identitytoolkit.googleapis.com/v1
```

Additionally, you'll need your Web API key which you can find from your key settings page available `/settings/general` from your main console. You'll provide this as a query parameter. The Environment variable can be added along with the rest of your Hasura GraphQL Engine settings, but the API key will need to be added as a query parameter value for the action itself.

![Firebase API Key](https://graphql-engine-cdn.hasura.io/assets/main-site/marketplace/firebase-guide-image-1.png)
![Firebase API Key](https://graphql-engine-cdn.hasura.io/assets/main-site/marketplace/firebase-guide-image-2.png)

## Importing an Action Transform

Importing actions and events into Hasura apply one or more actions. Actions based on request configurations and will need metadata to be applied. Events need underlying table structure to trigger the events.

Steps required for this integration:

- Metadata Apply

### Metatadata Apply

To apply metadata into your project. You will need:

1. The Hasura CLI installed.
2. Run "hasura metadata apply" from the root folder of your Hasura metadata project. In this project, you can find that folder under `/hasura`.

More [information about Hasura CLI](https://hasura.io/docs/latest/graphql/core/hasura-cli/index.html) can be found in the documentation.

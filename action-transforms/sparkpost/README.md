Sparkpost is a platform for sending commercial emails.

In this example, we are making use of Sparkpost REST API to send email.

We are making use of this endpoint:

```bash
https://api.sparkpost.com/api/v1/transmissions
```

You can use the one-click to deploy on Hasura Cloud to get started quickly

[![Deploy to Hasura Cloud](https://hasura.io/deploy-button.svg)](https://cloud.hasura.io/deploy?github_repo=https://github.com/hasura/data-hub&hasura_dir=action-transforms/sparkpost/hasura)

## Configuring an Action Transform

You'll need the following environment variables.

```bash
SPARKPOST_API_KEY: "xxxxxx"
```

If you are using Docker you can provide these environment variables along with the rest of your Hasura configuration information.

Check out Sparkpost docs on [creating an API key](https://support.sparkpost.com/docs/getting-started/create-api-keys)

## Importing an Action Transform

Importing actions and events into Hasura apply one or more actions. Actions are based on request configurations and will need metadata to be applied. Events need underlying table structure to trigger the events.

Steps required for this integration:

- Metadata Apply
- Migrate Apply
- Metadata Reload

### Metatadata Apply

To apply metadata into your project. You will need:

1. The Hasura CLI installed.
2. Run "hasura metadata apply" from the root folder of your Hasura metadata project. In this project, you can find that folder under `/hasura`.

More [information about Hasura CLI](https://hasura.io/docs/latest/graphql/core/hasura-cli/index.html) can be found in the documentation.

### Migrate Apply

Once metadata is applied, you will apply the database migrations.

```bash
hasura migrate apply
```

### Metadata Reload

For the migration changes to reflect, we will execute the metadata reload command.

```bash
hasura metadata reload
```

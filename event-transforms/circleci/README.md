# CircleCI

CircleCI is the world’s largest shared continuous integration and continuous delivery (CI/CD) platform.

In this example, we are going to make use of CircleCI's API to trigger a pipeline automatically on the main branch whenever there is an insert/update/delete on our blog table.

## Configuring an Event Transform

You'll need the following environment variables.

```bash
CIRCLECI_TOKEN: "<Personal API token https://circleci.com/docs/2.0/managing-api-tokens/>"

CIRCLECI_PIPELINE_URL: "<https://circleci.com/api/v2/project/<PROJECT_SLUG>/pipeline>"
```

If you are using Docker you can provide these environment variables along with the rest of your Hasura configuration information.

Check out [CircleCI API Docs](https://circleci.com/docs/2.0/api-intro/)

## Importing an Event Transform

Importing actions and events into Hasura apply one or more actions. Actions based on request configurations and will need metadata to be applied. Events need underlying table structure to trigger the events.

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

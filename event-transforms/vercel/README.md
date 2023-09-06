Vercel is a platform for frontend teams to manage your modern app infrastructure.

In this example, we are going to make use of Vercel Deploy Hooks to trigger a deployment automatically on a configured branch whenever there is an insert on a database table.

For example:

If a new row is inserted in the blog table, we trigger the Vercel deploy hook to rebuild our site deployed on Vercel.

You can use the one-click to deploy on Hasura Cloud to get started quickly

[![Deploy to Hasura Cloud](https://hasura.io/deploy-button.svg)](https://cloud.hasura.io/deploy?github_repo=https://github.com/hasura/data-hub&hasura_dir=event-transforms/vercel/hasura)

## Configuring an Event Transform

You'll need the following environment variables.

```bash
VERCEL_DEPLOY_HOOK: "https://api.vercel.com/v1/integrations/deploy/QmcwKGEbAyFtfybXBxvuSjFT54dc5dRLmAYNB5jxxXsbeZ/hUg65Lj4CV"
```

If you are using Docker you can provide these environment variables along with the rest of your Hasura configuration information.

Check out Vercel Docs on [Creating and configuring a deploy hook](https://vercel.com/docs/concepts/git/deploy-hooks)

## Importing an Event Transform

Importing actions and events into Hasura apply one or more actions. Actions based on request configurations and will need metadata to be applied. Events need underlying table structure to trigger the events.

Steps required for this integration:

- Metadata Apply
- Migrate Apply
- Metadata Reload

### Metadata Apply

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

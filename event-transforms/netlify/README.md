Netlify is an all-in-one platform for automating modern web projects with a single workflow.

In this example, we are going to make use of Netlify Build Hooks to trigger a deployment automatically on a configured branch whenever there is an insert on a database table.

For example:

If a new row is inserted in the blog table, we trigger the netlify build hook to rebuild our site deployed on Netlify.

You can use the one-click to deploy on Hasura Cloud to get started quickly

[![Deploy to Hasura Cloud](https://hasura.io/deploy-button.svg)](https://cloud.hasura.io/deploy?github_repo=https://github.com/hasura/data-hub&hasura_dir=event-transforms/netlify/hasura)

## Configuring an Event Transform

You'll need the following environment variables.

```bash
NETLIFY_BUILD_HOOK: "https://api.netlify.com/build_hooks/XXXXXXXXXXXXXXX"
```

If you are using Docker you can provide these environment variables along with the rest of your Hasura configuration information.

Check out Netlify Docs on [Creating and configuring a build hook](https://docs.netlify.com/configure-builds/build-hooks/)

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

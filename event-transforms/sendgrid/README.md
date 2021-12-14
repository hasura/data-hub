# Sendgrid Event Transform for Hasura

Sendgrid is a platform for sending transactional and marketing emails.

In this example, we are making use of Sendgrid's REST API to send email.

We are making use of this endpoint:

```bash
https://api.sendgrid.com/v3/mail/send
```

## Configuring an Event Transform

You'll need the following environment variables.

```bash
SENDGRID_API_KEY: "Bearer xxxxxx"
```

If you are using Docker you can provide these environment variables along with the rest of your Hasura configuration information.

Check out Sendgrid dashboard on [creating an API key](https://app.sendgrid.com/settings/api_keys)

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

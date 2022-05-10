Regenerate Next.js Pages On-demand (ISR) with Hasura Table Events.

Read [the blog post for step-by-step directions](https://hasura.io/blog/nextjs-incremental-static-regeneration-hasura-table-events/).

## Setting Hasura enviroment

You'll need the following environment variable in your Hasura instance.

```bash
SECRET_TOKEN: <a random string you come up with>
NEXTJS_REVALIDATE_URL: <Your nextjs api route>
```

## Importing the data schema

Open a terminal in the Hasura directory. Now we apply the migrations, metadata, and seeds.

```bash
hasura migrate apply --endpoint <Remote Hasura URL if applicable> --admin-secret <admin secret> --database-name default

hasura metadata apply --endpoint <Remote Hasura URL> --admin-secret <admin secret>
```

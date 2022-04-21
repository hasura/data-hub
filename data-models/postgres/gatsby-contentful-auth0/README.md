Building a Music Playlist App with Gatsby, Contentful and Hasura Remote Joins.

Read [the blog post for step-by-step directions](https://hasura.io/blog/building-a-music-playlist-app-with-gatsby-contentful-auth0-hasura/).

## Setting Hasura enviroment Variables

You'll need the following environment variables in your Hasura instance.

```bash
CONTENTFUL_GRAPHQL_URL: https://graphql.contentful.com/blog/content/v1/spaces/<space-id>
CONTENTFUL_API_TOKEN: Bearer <access_token>
```

## Importing the data schema

Open a terminal in the Hasura directory. Now we apply the migrations, metadata, and seeds.

```bash
hasura migrate apply --endpoint <Remote Hasura URL if applicable> --admin-secret <admin secret> --database-name default

hasura metadata apply --endpoint <Remote Hasura URL> --admin-secret <admin secret>
```

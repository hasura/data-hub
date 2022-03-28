Drupal is a content management system written in PHP that it's free and open-source.

## Add Drupal as Remote Schema

Before adding Drupal as a remote schema, you need to enable and configure GraphQL in your Drupal project. Check the [drupal-graphql documentation](https://drupal-graphql.gitbook.io/graphql/) to learn how to do it.

After enabling and configuring GraphQL for your Drupal project, your GrahpQL endpoint should be - `<project-URL>/graphql`.

Go to your project's console in Hasura and then to the "REMOTE SCHEMAS" page. Once there:
* choose a name for the remote schema
* add the GraphQL URL
 
Save it by clicking the "Add Remote Schema" button and you are done!

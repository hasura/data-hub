# Netlify Graph

Netlify unites an entire ecosystem of modern tools and services into a single, simple workflow for building high-performance sites and apps. Using [Netlify Graph](https://github.com/netlify/labs/tree/main/features/graph/documentation) we can join selected APIs with Hasura using Remote Schemas.

## Adding Netlify Graph as a Remote Schema

1. Create

1. Create a [Gitlab personal access token](https://docs.gitlab.com/ee/user/profile/personal_access_tokens.html#create-a-personal-access-token), for this example we'll give it [the read_api scope](https://gitlab.com/gitlab-org/gitlab/-/issues/217102).

1. Add the token as an environment variable in Hasura in the form of `bearer <your personal access token>`

1. In the Hasura Console, go to Remote Schemas and add the Gitlab API

   - The GraphQL Server URL is `https://gitlab.com/api/graphql`
   - Add the `Authorization` header from the environment variable you created earlier

1. Test by querying the token user

   ```graphql
   {
     currentUser {
       name
     }
   }
   ```

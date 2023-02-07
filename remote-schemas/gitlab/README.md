# Gitlab

GitLab is DevOps software that combines the ability to develop, secure, and operate software in a single application. It offers a [GraphQL API](https://docs.gitlab.com/ee/api/graphql/) which we can join with Hasura using Remote Schemas.

You can use the one-click to deploy on Hasura Cloud to get started quickly

[![Deploy to Hasura Cloud](https://hasura.io/deploy-button.svg)](https://cloud.hasura.io/deploy?github_repo=https://github.com/hasura/data-hub&hasura_dir=remote-schemas/gitlab/hasura)

## Adding Gitlab as a Remote Schema

1. Create a [Gitlab personal access token](https://docs.gitlab.com/ee/user/profile/personal_access_tokens.html#create-a-personal-access-token), for this example we'll give it [the read_api scope](https://gitlab.com/gitlab-org/gitlab/-/issues/217102).

2. Add the token as an environment variable in Hasura in the form of `bearer <your personal access token>`

3. In the Hasura Console, go to Remote Schemas and add the Gitlab API

   - The GraphQL Server URL is `https://gitlab.com/api/graphql`
   - Add the `Authorization` header from the environment variable you created earlier

4. Test by querying the token user

   ```graphql
   {
     currentUser {
       name
     }
   }
   ```

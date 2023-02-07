# Github

Github is a development platform where millions of developers and companies build, ship, and maintain their software. It offers a [GraphQL API](https://docs.github.com/en/graphql) which we can join with Hasura using Remote Schemas.

You can use the one-click to deploy on Hasura Cloud to get started quickly

[![Deploy to Hasura Cloud](https://hasura.io/deploy-button.svg)](https://cloud.hasura.io/deploy?github_repo=https://github.com/hasura/data-hub&hasura_dir=remote-schemas/github/hasura)

## Adding Github as a Remote Schema

1. Create a [Github personal access token with the proper scopes](https://docs.github.com/en/graphql/guides/forming-calls-with-graphql#authenticating-with-graphql).

2. Add the token as an environment variable in Hasura in the form of `bearer <your personal access token>`

3. In the Hasura Console, go to Remote Schemas and add the Github API

   - The GraphQL Server URL is `https://api.github.com/graphql`
   - Add the `Authorization` header from the environment variable you created earlier

4. Test by querying the token user

   ```graphql
   {
     viewer {
       login
     }
   }
   ```

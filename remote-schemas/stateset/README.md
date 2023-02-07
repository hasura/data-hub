[Stateset](https://www.stateset.io/) is the Serverless Operations Platform for direct-to-consumer merchants.

You can use the one-click to deploy on Hasura Cloud to get started quickly

[![Deploy to Hasura Cloud](https://hasura.io/deploy-button.svg)](https://cloud.hasura.io/deploy?github_repo=https://github.com/hasura/data-hub&hasura_dir=remote-schemas/stateset/hasura)

## Enable the GraphQL API for your Stateset Project

Stateset projects come with a GraphQL API by default. After creating the Stateset project, you need to deploy the GraphQL API manually.

You can deploy the API only by signing up on stateset.io/signup.

Upon SignUp at https://stateset.io/signup you will receive an email with your Stateset backend URL and Stateset Admin Secret.

- Get the Stateset GraphQL API Endpoint:

```
https://<your-project-name>.stateset.app/v1/graphql
```

It’s important to note that all data is accessible only to authenticated users. There are two ways to access data:

- using JWTs
- using static tokens that are set for each user and do not expire

## Accessing your Stateset Operations Backend

You will need this Stateset Admin Secret Key to access the Stateset GraphQL API.

- Now go to the Hasura Project Console, head to Remote Schemas, and enter the GraphQL Server URL you copied from the API Playground.

  Select the 'Forward all headers from client' option

  Under Additional Headers,  
  Enter the header name as `Authorization` and in `value` use the following:

  ```
  Authorization: Bearer <your-Stateset-API-Token>
  ```

  or

  ```
  x-hasura-admin-secret: Bearer <Stateset Admin Secret>
  ```

## Adding Stateset as Remote Schema

- All set, now Press the `Add Remote Schema` button to add the remote schema, that's it!

See the image above for reference.

Save it and you are done!

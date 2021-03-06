[openapi-to-graphql](https://github.com/IBM/openapi-to-graphql) translates APIs described by OpenAPI Specifications (OAS) or Swagger into GraphQL. This server uses that package as a dependency to convert OAS to GraphQL.

## Deploy with Glitch

1. Click the following button to edit on glitch

   [![glitch-deploy-button](https://raw.githubusercontent.com/hasura/graphql-engine/master/community/boilerplates/auth-webhooks/nodejs-express/assets/deploy-glitch.png)](http://glitch.com/edit/#!/import/github/praveenweb/openapi-swagger-remote-schema)

2. Change the OpenAPI spec in the `openapi.json` file, as necessary.

## Adding OpenAPI/Swagger as Remote Schema

To be able to query OpenAPI/Swagger data via Hasura, it needs to be added as a Remote Schema using the Hasura Console.

## Running Locally

```bash
npm install
PORT=3000 npm start
```
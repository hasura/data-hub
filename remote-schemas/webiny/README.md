[Webiny](https://www.webiny.com/) is Open-Source Serverless Enterprise CMS. It Includes a Headless CMS, Page Builder, Form Builder, and File Manager.

## Adding Webiny as Remote Schema

- Get the Webiny GraphQL API Endpoint:

  You can visit the API Playground from your Webiny Admin Area application:
  ```
  https://<your-admin-area-url>/api-playground
  ```
  Here you will see the Main API, Headless CMS - Manage/Read/Preview API GraphQL URL.  
  Copy the GraphQL URL that you would like to access from Hasura.

- Get the API Key
You will need this Key to access the GraphQL API. Please follow this [document](https://www.webiny.com/docs/how-to-guides/webiny-applications/headless-cms/using-graphql-api/#creating-the-api-key) to create the API Key.

- Now go to the Hasura Project Console, head to Remote Schemas and enter GraphQL Server URL with the above GraphQL endpoint.

  Select the 'Forward all headers from client' option

  Under Additional Headers,  
  Enter the header name as `Authorization` and in `value` use the following:

  ```
  Authorization: Bearer <your-Webiny-API-key>
  ```

- All set, now Press the `Add Remote Schema` button to add the remote schema, that's it!

A realtime tracking schema example from the Hasura sample apps.

To run the fullstack example please see the [Github repository](https://github.com/hasura/graphql-engine/tree/master/community/sample-apps/realtime-location-tracking).

## Importing the data schema

Open a terminal in the Hasura directory. Now we apply the migrations, metadata, and seeds.

```bash
hasura migrate apply --endpoint <Remote Hasura URL if applicable> --admin-secret <admin secret> --database-name default

hasura metadata apply --endpoint <Remote Hasura URL> --admin-secret <admin secret>
```

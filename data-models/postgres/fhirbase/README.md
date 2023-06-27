A sample data schema based on the [Fhirbase](https://github.com/fhirbase/fhirbase).

Fast Healthcare Interoperability Resources (FHIR) is a standard specification for exchanging electronic health care data.

## Importing the data schema

Open a terminal in the Hasura directory. Now we apply the migrations, metadata, and seeds.

```bash
hasura deploy --endpoint <Remote Hasura URL> --admin-secret <admin secret> --database-name default
```

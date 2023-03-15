A sample data schema based on the [OHDSI CDM](https://www.ohdsi.org/data-standardization/) with the [database schema](https://github.com/OHDSI/CommonDataModel).

The Observational Medical Outcomes Partnership (OMOP) Common Data Model (CDM) is an open community data standard, designed to standardize the structure and content of observational data and to enable efficient analyses that can produce reliable evidence.

## Importing the data schema

Open a terminal in the Hasura directory. Now we apply the migrations, metadata, and seeds.

```bash
hasura deploy --endpoint <Remote Hasura URL> --admin-secret <admin secret> --database-name default
```

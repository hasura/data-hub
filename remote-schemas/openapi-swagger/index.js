const express = require('express')
const graphqlHTTP = require('express-graphql')
const { createGraphQlSchema } = require('openapi-to-graphql')
const oas = require('./openapi.json');

async function main(oas) {
  // generate schema:
  const { schema, report } = await createGraphQlSchema(oas)

  // server schema:
  const app = express()
  app.use(
    '/graphql',
    graphqlHTTP({
      schema,
      graphiql: true
    })
  )
  app.listen(3000)
}

main(oas);
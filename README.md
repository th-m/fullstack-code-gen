# fullstack-code-gen

## 
`make gen` will take annotated proto definitions from the `/proto` dir and start processing them through the code gen pipeline. 
## Generator
`main-gen.sh` manages a pipeline of code generation.
Docker images hosted here https://hub.docker.com/u/thomasvaladez
Each image used in this pipeline is defined in a Dockerfile in /generator/{dir} 

## Generated
`/generated` is where all the output for the code generation goes. Currently generating code for `go`, `graphql`, `openapi`, and `ts`

## Examples
Here we have some go apps that will run the generated code.

## Typescript
`/typescript` is a built output from `tsc` command. It is the TS all ready to be hosted in an NPM repo.

## Postgres
`/postgres` here we are defining `migrations` using `Goose` and  `queries`. Then we use `sqlc` to convert that to `go`
## TODO

- [ ] fix buf lint
- [ ] https://github.com/danielvladco/go-proto-gql <- get this working 
- [ ] openapi with runtime js and component switch
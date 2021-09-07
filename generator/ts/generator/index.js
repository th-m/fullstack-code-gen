const { readFileSync, writeFileSync } = require("fs");
const swaggerToTS = require("openapi-typescript").default

const swaggerKey = ".swagger.json"
const openapiKey = "openapi.json"
const files = process.argv.filter((arg) => arg.includes(openapiKey))

const opts = {
    propertyMapper: (swaggerDefinition, property) => {
        // console.log({ swaggerDefinition, property });
        // if (swaggerDefinition.format === "date-time") ...
        return {
            ...property,
        }
    }
}

files.forEach(file => {
    const input = JSON.parse(readFileSync(file, "utf8")); // Input can be any JS object (OpenAPI format)
   
    // sharedUUID is a special snowflake
    if(input.components && input.components.schemas && input.components.schemas.sharedUUID){
        delete input.components.schemas.sharedUUID.properties.Bytes;
    }
    let output = swaggerToTS(input, opts);
  
    // replace file prefix
    let out = file.replace(swaggerKey + "/" + openapiKey, ".ts");
    // switch to out dir.
    out = out.replace("tmp/openapis", "tmp/ts")
    
    console.log({ file, out })
    writeFileSync(out, output);
});
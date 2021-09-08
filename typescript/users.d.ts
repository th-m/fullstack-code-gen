/**
 * This file was auto-generated by openapi-typescript.
 * Do not make direct changes to the file.
 */
export interface paths {
    "/users": {
        get: operations["UserAPI_ListUsers"];
        post: operations["UserAPI_CreateUser"];
    };
    "/users/{id}": {
        get: operations["UserAPI_GetUser"];
        delete: operations["UserAPI_DeleteUser"];
    };
    "/users/{user.id}": {
        put: operations["UserAPI_UpdateUser"];
    };
}
export interface operations {
    UserAPI_ListUsers: {
        parameters: {
            query: {
                "filters.id"?: string;
                "filters.name"?: string;
                "filters.email"?: string;
            };
        };
        responses: {
            /** A successful response. */
            200: {
                "application/json": components["schemas"]["usersListUsersResponse"];
            };
            /** An unexpected error response. */
            default: {
                "application/json": components["schemas"]["rpcStatus"];
            };
        };
    };
    UserAPI_CreateUser: {
        requestBody: {
            "application/json": components["schemas"]["usersCreateUserRequest"];
        };
        responses: {
            /** A successful response. */
            200: {
                "application/json": components["schemas"]["usersUser"];
            };
            /** An unexpected error response. */
            default: {
                "application/json": components["schemas"]["rpcStatus"];
            };
        };
    };
    UserAPI_GetUser: {
        parameters: {
            path: {
                id: string;
            };
        };
        responses: {
            /** A successful response. */
            200: {
                "application/json": components["schemas"]["usersUser"];
            };
            /** An unexpected error response. */
            default: {
                "application/json": components["schemas"]["rpcStatus"];
            };
        };
    };
    UserAPI_DeleteUser: {
        parameters: {
            path: {
                id: string;
            };
        };
        responses: {
            /** A successful response. */
            200: {
                "application/json": {
                    [key: string]: any;
                };
            };
            /** An unexpected error response. */
            default: {
                "application/json": components["schemas"]["rpcStatus"];
            };
        };
    };
    UserAPI_UpdateUser: {
        parameters: {
            path: {
                "user.id": string;
            };
        };
        requestBody: {
            "application/json": components["schemas"]["usersUpdateUserRequest"];
        };
        responses: {
            /** A successful response. */
            200: {
                "application/json": components["schemas"]["usersUser"];
            };
            /** An unexpected error response. */
            default: {
                "application/json": components["schemas"]["rpcStatus"];
            };
        };
    };
}
export interface components {
    schemas: {
        protobufAny: {
            typeUrl?: string;
            value?: string;
        };
        rpcStatus: {
            code?: number;
            message?: string;
            details?: components["schemas"]["protobufAny"][];
        };
        usersCreateUserRequest: {
            user?: components["schemas"]["usersUser"];
        };
        usersListUsersResponse: {
            users?: components["schemas"]["usersUser"][];
        };
        usersUpdateUserRequest: {
            user?: components["schemas"]["usersUser"];
        };
        /** This is a person who uses my app */
        usersUser: {
            id?: string;
            name?: string;
            email?: string;
        };
    };
}

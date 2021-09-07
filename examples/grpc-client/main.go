package main

import (
	"context"
	"log"
	"time"

	"google.golang.org/grpc"
	"th-m.codes/fullstack-code-gen/generated/go/services/users"
)

const (
	address = "localhost:9090"
)

func main() {
	// Set up a connection to the server.
	conn, err := grpc.Dial(address, grpc.WithInsecure(), grpc.WithBlock())
	if err != nil {
		log.Fatalf("did not connect: %v", err)
	}
	defer conn.Close()
	c := users.NewUserAPIClient(conn)

	ctx, cancel := context.WithTimeout(context.Background(), time.Second)
	defer cancel()
	r, err := c.ListUsers(ctx, &users.ListUsersRequest{Filters: &users.User{Name: "thom"}})
	if err != nil {
		log.Fatalf("could not greet: %v", err)
	}
	log.Printf("Greeting: %s", r.GetUsers())
}

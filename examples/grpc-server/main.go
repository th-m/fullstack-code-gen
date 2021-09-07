package main

import (
	"context"
	"log"
	"net"

	"th-m.codes/fullstack-code-gen/generated/go/services/users"

	"google.golang.org/grpc"
)

const (
	port = ":9090"
)

// server is used to implement helloworld.GreeterServer.
type server struct {
	users.UserAPIServer
}

// SayHello implements helloworld.GreeterServer
func (s *server) ListUsers(ctx context.Context, in *users.ListUsersRequest) (*users.ListUsersResponse, error) {
	log.Printf("Received: %v", in.Filters.Name)
	return &users.ListUsersResponse{
		Users: []*users.User{
			{Name: in.Filters.Name},
		},
	}, nil
}

func main() {
	lis, err := net.Listen("tcp", port)
	if err != nil {
		log.Fatalf("failed to listen: %v", err)
	}
	s := grpc.NewServer()
	users.RegisterUserAPIServer(s, &server{})
	log.Printf("server listening at %v", lis.Addr())
	if err := s.Serve(lis); err != nil {
		log.Fatalf("failed to serve: %v", err)
	}
}

package main

import (
	"context"
	"log"
	"net"

	"google.golang.org/grpc"
	usersPB "th-m.codes/fullstack-code-gen/generated/go/services/users"
	"th-m.codes/fullstack-code-gen/generated/sqlc"

	"database/sql"
	"fmt"

	_ "github.com/lib/pq"
)

const (
	port        = ":9090"
	db_host     = "localhost"
	db_port     = 5432
	db_user     = "postgres"
	db_password = "your-password"
	db_name     = "calhounio_demo"
)

// server is used to implement helloworld.GreeterServer.
type server struct {
	usersPB.UserAPIServer
	queries *sqlc.Queries
}

// ListUsers implements search users functionality
func (s *server) ListUsers(ctx context.Context, in *usersPB.ListUsersRequest) (*usersPB.ListUsersResponse, error) {
	log.Printf("Received: %v", in.Filters.Name)

	dbUsers, err := s.queries.SearchUsers(ctx, sqlc.SearchUsersParams{
		Name:     []string{in.Filters.Name},
		SkipName: in.Filters.Name == "",
		SkipID:   true,
	})

	if err != nil {
		log.Fatalf("failed to query users: %v", err)
	}

	users := make([]*usersPB.User, len(dbUsers))
	for i, user := range dbUsers {
		users[i] = &usersPB.User{
			Id:   user.ID,
			Name: user.Name.String,
		}
	}

	return &usersPB.ListUsersResponse{
		Users: users,
	}, nil
}

func main() {
	lis, err := net.Listen("tcp", port)
	if err != nil {
		log.Fatalf("failed to listen: %v", err)
	}
	s := grpc.NewServer()

	psqlInfo := fmt.Sprintf("host=%s port=%d user=%s "+
		"password=%s dbname=%s sslmode=disable",
		db_host, db_port, db_user, db_password, db_name)

	db, err := sql.Open("postgres", psqlInfo)
	if err != nil {
		panic(err)
	}
	defer db.Close()

	usersPB.RegisterUserAPIServer(s, &server{
		queries: sqlc.New(db),
	})
	log.Printf("server listening at %v", lis.Addr())
	if err := s.Serve(lis); err != nil {
		log.Fatalf("failed to serve: %v", err)
	}
}

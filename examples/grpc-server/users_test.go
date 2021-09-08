package main

import (
	"context"
	"fmt"
	"testing"

	"github.com/DATA-DOG/go-sqlmock"
	"th-m.codes/fullstack-code-gen/examples/grpc-server/internal/sqlc"
	usersPB "th-m.codes/fullstack-code-gen/generated/go/services/users"
)

func TestServer_Users(t *testing.T) {
	type args struct {
		ctx context.Context
		in  *usersPB.ListUsersRequest
	}

	bgctx := context.Background()
	tests := []struct {
		name    string
		args    args
		dbSetup func() (*sqlc.Queries, sqlmock.Sqlmock)
		want    *usersPB.ListUsersResponse
	}{

		{
			name: "happy path",
			args: args{ctx: bgctx, in: &usersPB.ListUsersRequest{
				Filters: &usersPB.User{Name: "foo"},
			}},
			dbSetup: func() (*sqlc.Queries, sqlmock.Sqlmock) {
				db, mock, _ := sqlmock.New()

				mock.ExpectQuery(`^-- name: SelectUser :One (.+)`).WillReturnRows(mock.
					NewRows([]string{"id", "name"}).
					AddRow("id1", "name1").
					AddRow("id2", "name2"))

				return sqlc.New(db), mock
			},
			want: &usersPB.ListUsersResponse{Users: []*usersPB.User{{Id: "id1", Name: "name1"}, {Id: "id2", Name: "name2"}}},
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			db, _ := tt.dbSetup()
			s := &server{
				queries: db,
			}

			got, _ := s.ListUsers(tt.args.ctx, tt.args.in)
			fmt.Println(got)

		})
	}
}

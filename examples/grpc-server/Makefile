migrateup:
	cloud_sql_proxy -instances=th-m-val:us-west3:full-stack-codegen=tcp:5433 &
	sleep 2 && goose -dir ./db/migrations postgres "postgres://$(TV_PG_USER):$(TV_PG_PW)@localhost:5433/$(TV_PG_DB)?sslmode=disable" up
	lsof -t -i tcp:5433 | xargs kill

migratedown:
	cloud_sql_proxy -instances=th-m-val:us-west3:full-stack-codegen=tcp:5433 &
	sleep 2 && goose -dir ./db/migrations postgres "postgres://$(TV_PG_USER):$(TV_PG_PW)@localhost:5433/$(TV_PG_DB)?sslmode=disable" down
	lsof -t -i tcp:5433 | xargs kill

sqlc-gen:
	docker pull kjconroy/sqlc
	docker run --rm -v `pwd`:/src -w /src kjconroy/sqlc generate
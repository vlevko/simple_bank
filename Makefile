# Makefile rules work for Windows PowerShell
# Check comments for rules if using them in Git Bash MINGW64

postgres:
	docker run --name postgres14 -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=secret -d postgres:14-alpine

# winpty make createdb
createdb:
	docker exec -it postgres14 createdb --username=root --owner=root simple_bank

# winpty make dropdb
dropdb:
	docker exec -it postgres14 dropdb simple_bank

migrateup:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" -verbose up

migratedown:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" -verbose down

# Alternative 'generate' rule that supports only MySQL DB driver in Windows OS currently
sqlc:
	sqlc generate

# MSYS_NO_PATHCONV=1 make generate
generate:
	docker run --rm -v "${CURDIR}:/src" -w /src kjconroy/sqlc generate

# MSYS_NO_PATHCONV=1 make compile
compile:
	docker run --rm -v "${CURDIR}:/src" -w /src kjconroy/sqlc compile

test:
	go test -v -cover ./...

.PHONY: postgres createdb dropdb migrateup migratedown sqlc generate compile test

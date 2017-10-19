resource "aws_dynamodb_table" "users" {
  name           = "BrewMap_Users"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "UserID"

  attribute {
    name = "UserID"
    type = "S"
  }
}

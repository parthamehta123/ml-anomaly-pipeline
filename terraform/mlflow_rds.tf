resource "aws_db_instance" "mlflow" {
  identifier          = "mlflow-rds"
  engine              = "postgres"
  instance_class      = "db.t3.medium"
  allocated_storage   = 20
  username            = "mlflow"
  password            = "mlflow_pass123"
  skip_final_snapshot = true
}
resource "aws_db_instance" "mlflow" {
  identifier          = "mlflow-rds-${var.env}"
  engine              = "postgres"
  instance_class      = "db.t3.medium"
  allocated_storage   = 20
  username            = "mlflow"
  password            = "mlflowpass"
  skip_final_snapshot = true
}

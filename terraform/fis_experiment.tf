resource "aws_iam_role" "fis_role" {
  name = "fis-experiment-role-${var.env}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "fis.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "fis_role_policy" {
  role       = aws_iam_role.fis_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

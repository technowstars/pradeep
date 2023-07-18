
resource "aws_key_pair" "ami_key_pair" {
  key_name   = "deployer-key_vs"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCS6HYsYD+0ynzVMYSMIvcSId75PNJ76nPgLBpmsiOEHigq1rgSrsbcEDj5ONqdMVJU9/fcUBbRQf0OLAjao7WePhqUNAI/BRaA1kwj3t0gh/EmE2PmlhyWk7zMi3cjV05e5zjcNk8NZG9V90hu7dEof8u1HBtErxYAV3iwB1sx8N9SFqg19lUwRMYY+TjBl0uDhgs1dvjBJmWtVn+5J2KYg580GQEd7UcxOHnxWg5oJk6k5+BoY5pL75naVipe6qe4pxY8SLevBOLIsgaJMDALOkGvPzCYAZ3ac3wQ9qVGTon9F27IfD14sEv7bqTBGVtgfdx8s3plEbnrwDlhbtyYtmsJ5UM4Y6kCqdnnzNV1gxxVmDjmNkMRwjNwF/YQwq7/culA0QlFaoZsq93+b+15U2WULf+lHC7FxZF1HcdPgFiZFNFm51eKO8jQN9KnxdbQIVFJSdHeoW/bDXoix+qV+9xhjP+a7Xw0fRItdSAh0LXtFd5uRb/u32imcvtI4sE= A200095793@BE2BM603"
}

resource "aws_instance" "ami_instance_server" {
  ami           = "ami-076309742d466ad69" # us-west-2
  instance_type = "t2.micro"
  key_name   = "${aws_key_pair.ami_key_pair.key_name}"
  disable_api_termination     = false
  monitoring                  = false

  tags = {
    Name    = "aws_ami_instance_server_vs"
    Project = var.project
    Role    = "ec2"
  }


}
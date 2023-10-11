# main.tf

terraform {
  backend "local" {}
}


module "vpc" {
  source = "./modules/vpc"
  vpc_cidr = "10.0.0.0/16"
}

module "cloudfront" {
  source = "./modules/cloudfront"
  region = "us-west-2"
  s3_name = "my-bucket"
}

module "rds" {
  source = "./modules/rds"
  db_engine = "mysql"
  db_name = "my-db"
}

module "ecs_inventory" {
  source = "./modules/ecs"
  ecs_cluster = "my-cluster"
  ecs_capacity_provider = "my-capacity-provider"
  vpc_cidr = "10.0.0.0/16"
  image = "my-image-inventory"
  task = "my-task-inventory"
  docker = "my-docker-inventory"
}

module "ecs_accounting" {
  source = "./modules/ecs"
  ecs_cluster = "my-cluster"
  ecs_capacity_provider = "my-capacity-provider"
  vpc_cidr = "10.0.0.0/16"
  image = "my-image-accounting"
  task = "my-task-accounting"
  docker = "my-docker-accounting"
}

module "ecs_shipping" {
  source = "./modules/ecs"
  ecs_cluster = "my-cluster"
  ecs_capacity_provider = "my-capacity-provider"
  vpc_cidr = "10.0.0.0/16"
  image = "my-image-shipping"
  task = "my-task-shipping"
  docker = "my-docker-shipping"
}
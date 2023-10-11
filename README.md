# test-novatech
Architectural / Devops design test

# DevOps Challenge

## Index

* [Instructions](#instructions)
* [Proposed Architecture](#proposed-architecture)
* [Terraform Plan](#terraform-plan-terratest)
* [CICD - Automation](#cicd-automation-bonus)
* [Observability](#observability-bonus)
* [Permissions](#permissions-bonus)
* [Best Practices](#best-practices-bonus)
* [Disaster Recovery Plan](#disaster-recovery-plan-bonus)
* [Compliance](#compliance-bonus)
* [Budget](#budget-bonus)


## Instructions

<summary><b>Test Details</b></summary>
<details>

Asignación preentrevista técnica.
Instrucciones:
Deberá presentar el desarrollo de la siguiente asignación en la entrevista técnica ya que se le solicitará
explique el desarrollo y respalde su criterio de resolución.

Ejercicio:
Dado el siguiente ejemplo de arquitectura de solución:

![alt text](/images/architecture.png "Current Architecture")

Se le solicita cree un diagrama proponiendo la migración hacia una arquitectura de microservicios.
Puede usar su herramienta preferida para creación de diagramas.

Consideraciones:
- Incluir manejo de Cache.
- Incluir todo lo relacionado a la seguridad
- Incluir componentes para CI/CD
- Tomar en cuenta que se implementara en la nube de AWS
- Crear los scripts de terrafom para la implementación y mantenimiento

- Al momento de la entrevista técnica, presentara y explicara el diagrama y los scripts de
terraform correspondientes.

</details>


## Proposed Architecture

La siguiente es ***una propuesta***. Por lo tanto, la infraestructura puede tener los recursos necesarios y la correlación entre ellos, pero de ninguna manera está lista para su uso. Funciona hasta cierto punto. 

Se comprende por un UI estatica bsasada en Cloudfront para el cache y S3 Bucket Y 3 backend en 2 AZ basados en ECS + EC2 

Todo a ser aplicado con Github Actions

 Este es un ejemplo que está completado en un 70% y no está destinado a ser aplicado.

![alt text](/images/novatech.drawio.png "Proposed diagram")

La solución propuesta realiza las siguientes acciones.
```
1. El usuario final consumirá la UI mediante un DNS de cloudfront+s3.
2. ALB redijira al ECS con Backend en Java/Docker
3. RDS suminitrara la informacion al Backend.
```

## Requerimientos

* An active AWS account
* Github Secrets added for the CICD
* AWS Keys
* Terraform => https://learn.hashicorp.com/tutorials/terraform/install-cli
* AWS CLI => https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html

## Restricciones

* CICD con privilegios de AWS para ejecutar Terraform
* Secretos almacenados en el repositorio de Github para que el proceso no falle.
* Un S3 Bucket para almacenar el backend del código Terraform (o en su defecto local)
* Vars de entorno local (.env) para implementación de prueba

# Process for local testing

1. Use the `env.template` file to create the `.env` file.
2. Populate the `.env` file with your AWS access KEYs and selected Region.
3. Execute `source .env`.
4. Change Backend to `local {}`
5. Execute `terraform init`
6. Execute `terraform plan`

## Terraform plan / Terratest

<details>
<summary>Summary</summary>
  
```
terraform plan
```
</details>

## Networking

We have created  1 Network(VPC)with 2 subnets.

4 Subnets of 256 ips (two public, two private with Internet access)


```
public-subnets ["10.0.0.0/24", "10.0.0.0/24"]

pruvate-subnets ["10.0.0.0/24", "10.0.0.0/24"]

```

## Testing 
```
```


## Observabilidad

Consideraremos las siguientes métricas.
```
* Escalabilidad
* Fiabilidad
* Disponibilidad
* Latencia
* Fexibilidad
```
## Monitoreo y alertas

Usaremos Cloudwatch para monitorear Cloudfront y ECS Metrics

Key metrics para monitoreo Cloudwatch
```
1. aws.cloudfront.cache_hit_rate	
2. aws.cloudfront.origin_latency	
```
Key metrics para monitoreo ECS+EC2
```
1. 5XX Error
2. 4XX Error
3. Service health status.
4. CPU
5. Memory
```
## Automatización CICD

![texto alternativo](/images/cicd.png "CICD")

Usar una herramienta CI/CD (es decir, aGithub Actions)
```
1. El CICD revisará el Código mediante Sonarqube.
2. El uso de las funciones de Terraform Github Actions ejecutará terraform fmt/validate/plan.
3. Se realizara el Docker Build de las aplicaciones (por simplicidad, pero consideramos que a futuro estos fluos seran separados)
3. Actualiza la task definition con una nueva versión si es necesario.
4. La CICD publicará el plan terraforma en PR
5. Después de que el PR se mergea en main, el CICD ejecutará Terraform Apply
```

## Permisos

Toda la autenticación de la infraestructura está controlada por los roles de IAM.

Usaremos el principio de Least Priviledge
```
1. Crearemos roles de IAM específicos para Lambda para acceder solo al recurso del depósito S3.
2. El bucket S3 estará restringido y la ACL estará configurada como privada.
3. Business Logic se implementará en la capa privada
```

## Informe de cálculo
![texto alternativo](/images/estimate.png "Estimación de precios de AWS")

Lo anterior se generó usando https://calculator.aws/#/. Es una aproximación para un uso intensivo de 100 millones de solicitudes por mes.
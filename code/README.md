# spring4shell-demo
Based on https://github.com/FourCoreLabs/spring4shell-exploit-poc

This folder contains a vulnerable springboot application which can be exploited using Spring4Shell.

## Usage
Push the container into the ECR using the GitHub pipeline `build_deploy.yml` or build the container directly on the host and run it. Exploitation can be done using:
```bash
$ ./exploit.sh
```

## Description of Vulnerable Spring Application

The vulnerable Spring application contains a GET and POST request handler for `/helloworld/greeting`. The `exploit.sh` uses `curl` to write a webshell to `http://<HOST>:8080/shell.jsp`. The shell can be used to grab the flag present at `/flag` inside the container's filesystem or move further into the infrastructure.

## Additional

### Requirements
For running the image by yourself the following snippets might be useful:
- Attach ECR reader role to EC2.
- Install awscli & docker  
`sudo apt install awscli docker.io`
- Login into ECR  
`$(aws ecr get-login --region us-east-2)` | or `aws configure` with correct region
- Install container defender (optional)
`curl -sSL -k --header "authorization: Bearer <TOKEN>" -X POST https://europe-west3.cloud.twistlock.com/eu-2-143538055/api/v1/scripts/defender.sh  | sudo bash -s -- -c "europe-west3.cloud.twistlock.com" -d "none"    `
- Run vulnerable image  
`sudo docker run -it -p 8080:8080 <ID>.dkr.ecr.<REGION>.amazonaws.com/<REPO>:<IMAGE>`
- Check availability  
`http://<HOST>:8080/helloworld/greeting`

- Download Malware  
`curl -o elf http://wildfire.paloaltonetworks.com/publicapi/test/elf`./

#### Locally
```
docker build -t spring4shell:local .
checkov --docker-image spring4shell:local --dockerfile-path ./Dockerfile
```
### CVE-2022-22965

The **CVE-2022-22965** with a **CVSS** score of **9.8** has been to the vulnerability in Spring Core allowing Remote Code Execution. The exploit is easy to achieve and hence the high CVSS score, pre-requisites for the exploit are:

- JDK version 9+
- Application built on Spring Or derived frameworks
- Running Tomcat with WAR deployment

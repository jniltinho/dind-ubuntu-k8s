# dind-ubuntu-k8s
dind (docker in docker) + kubectl + python + docker-compose + CA import + batteries ^^ love

## Usage
  0. Fork and clone
  1. Create .env file (root directory)
  2. You can put variables in the .env file:

```
    KUBE_CONFIG=<encoded in base64>
    REGISTRY_ADDRESS=reg.acme.com
    REGISTRY_PORT=5000
    GITLAB_ADDRESS=git.acme.com
    GITLAB_PORT=443
```


  3. Run make... :)
  
  ## Links
  
  - [How to use docker in docker](http://blog.teracy.com/2017/09/11/how-to-use-docker-in-docker-dind-and-docker-outside-of-docker-dood-for-local-ci-testing/) 

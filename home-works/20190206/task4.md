# Lesson task 4: terraform & k8s \(advanced\)

terraform has a lot of providers, now we will use another provider, k8s. lets play with it...

given you a k8s deployment yaml, bellow. your tasks are the following: 1. convert the deployment yaml into terraform code, place it on the the _deployment/terraform\_app/task4\_0_ directory 2. the code you wrote should be supperated into MAIN.tf, and \*.tfvars 3. deploy & test that 4. try to convert it into module, with maximum configurations, plase the result into task4\_1 directory.

```yaml
apiVersion: apps/v1beta2
kind: Deployment
metadata:
  name: nginx-deployment
spec:
  selector:
    matchLabels:
      app: nginx
  replicas: 2 
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx
        ports:
        - containerPort: 80
```


#!/bin/bash
#   DEPLOYMENT SCRIPT FOR TF MODULE

#CONFIG AREA
DEPLOYMENT_PROFILE_NAME='aws-infinity-lab'
# END CONFIG AREA
TF_MODULE_SRC="src"
TF_BACKEND_FILE="deployment-profiles/${DEPLOYMENT_PROFILE_NAME}/beckend"
TF_VAR_FILE="deployment-profiles/${DEPLOYMENT_PROFILE_NAME}/envconfig.tfvars"
TF_PLAN_FILENAME=$(date +"tf-plans/${DEPLOYMENT_PROFILE_NAME}%Y%m%d_%H%M%S")


rm -rf .terraform

terraform init -backend-config=${TF_BACKEND_FILE} -var-file=${TF_VAR_FILE} \
     -backend=true -force-copy -get=true -input=false \
    ${TF_MODULE_SRC}

if [ $? -eq 0 ]; then echo "######TERRAFORM INIT DONE######"; else echo "TERRAFORM INIT FAILED, EXITING"; exit 1; fi

terraform plan -var-file=${TF_VAR_FILE} -input=false -module-depth=-1 \
    -refresh=true -detailed-exitcode -out=${TF_PLAN_FILENAME} \
    ${TF_MODULE_SRC}

case "$?" in
    0)
         echo "######>TERRAFORM PLAN DONE, NO CHANGES FOUND"
    ;;
    2)
        echo "######>TERRAFORM PLAN DONE, SOME CHANGES FOUND"
        ;;
    1)
        echo "######>TERRAFORM PLAN FAILED, EXITING..."
        exit 1;
        ;;
esac

echo -n "proceed to apply the generated plan?, type only \"YES\" to apply [ENTER]:"
read confirm
if [ "$confirm" = "YES" ]; then
    echo "CONTINUING TO TF APPLY";
    terraform apply -input=false ${TF_PLAN_FILENAME}
    if [ $? -eq 0 ]; then echo "######TERRAFORM APPLY DONE######"; else echo "TERRAFORM APPLY FAILED, EXITING"; exit 1; fi
else
    echo "TERRAFORM APPLY CANCELLED, EXITING";
fi




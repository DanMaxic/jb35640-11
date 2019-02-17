#!/bin/bash
#   DEPLOYMENT SCRIPT FOR TF MODULE

assume_role_util_path="/usr/local/bin/assume-role"

echo "Listing all available deployment profiles"
dep_profiles="$(find deployment-profiles/* -prune -type d -exec basename {} \; )"
IFS=$'\n'
dep_names=( $dep_profiles exit )
select dep_profile in "${dep_names[@]}"; do
    echo "You have chosen following deployment profile: \"$dep_profile\""
    [[ $dep_profile == exit ]] && break
    break
done

if [  -f "$assume_role_util_path" ]; then
    echo "assume-role util found, Listing all available AWS profiles"
    aws_profs="$(cat ~/.aws/credentials | grep "^\[" | sed 's/\[//g; s/\]//g; s/default//g' )"
    aws_names=( $aws_profs exit )
    select aws_profile in "${aws_names[@]}"; do
        echo "You have chosen following AWS profile: \"$aws_profile\""
        [[ $aws_profile == exit ]] && break
        break
    done
    eval $(${assume_role_util_path} ${aws_profile})
    current_account=$(aws iam list-account-aliases --output text | awk -F '\t' '{print $2}')
    echo "connected to account $current_account"
fi

#CONFIG AREA
DEPLOYMENT_PROFILE_NAME="$dep_profile"
# END CONFIG AREA
TF_MODULE_SRC="src/terraform"
TF_BACKEND_FILE="deployment-profiles/${DEPLOYMENT_PROFILE_NAME}/beckend"
TF_VAR_FILE="deployment-profiles/${DEPLOYMENT_PROFILE_NAME}/envconfig.tfvars"
TF_PLAN_FILENAME=$(date +"tf-plans/${DEPLOYMENT_PROFILE_NAME}%Y%m%d_%H%M%S")

ls -lha ${TF_VAR_FILE}
rm -rf .terraform

terraform init -backend-config=${TF_BACKEND_FILE} -var-file=${TF_VAR_FILE} \
     -backend=true -input=false \
    ${TF_MODULE_SRC}

if [ $? -eq 0 ]; then echo "######TERRAFORM INIT DONE######"; else echo "TERRAFORM INIT FAILED, EXITING"; exit 1; fi

#terraform plan -var-file=${TF_VAR_FILE} \
#    -input=false -module-depth=-1 \
#    -refresh=true -detailed-exitcode \
#    ${TF_MODULE_SRC}
#
#case "$?" in
#    0)
#         echo "######>TERRAFORM PLAN DONE, NO CHANGES FOUND"
#    ;;
#    2)
#        echo "######>TERRAFORM PLAN DONE, SOME CHANGES FOUND"
#        ;;
#    1)
#        echo "######>TERRAFORM PLAN FAILED, EXITING..."
#        exit 1;
#        ;;
#esac

echo -n "proceed to apply the generated plan?, type only \"YES\" to apply [ENTER]:"
read confirm
if [ "$confirm" = "YES" ]; then
    echo "CONTINUING TO TF APPLY";
    terraform apply -parallelism=1 -refresh=true -auto-approve -var-file=${TF_VAR_FILE} ${TF_MODULE_SRC}
    if [ $? -eq 0 ]; then echo "######TERRAFORM APPLY DONE######"; else echo "TERRAFORM APPLY FAILED, EXITING"; exit 1; fi
else
    echo "TERRAFORM APPLY CANCELLED, EXITING";
fi




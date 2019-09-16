# terraform_ansible
Create vm and mysql server using terraform and execute python webapp using ansible

## follow the steps
    ### Follow the steps from output of 'az login' command.
        - az login

    ### To create azure vm and mysql server/database using terraform.
        - cd terraform
        - terraform init
        - terraform plan
        - terraform apply -auto-approve

    ### To parse tfstate file and create inventory and variable file for ansible
        - cd ..
        - python parse.py <tfstate_file_with_path> <ansible_root_dir>
        - python parse.py terraform/terraform.tfstate ansible

    ### To run python flask webapp using ansible for created VM and database
        - cd ansible
        - ansible-playbook run_webapp.yml -i inv -e "vm_name=myVM dump_file=mysql_dump"

    ### To test, open a browser and go to URL
        - http://<IP>:5000                            => Welcome
        - http://<IP>:5000/how%20are%20you            => I am good, how about you?
        - http://<IP>:5000/read%20from%20database     => Bhavin Zalavadia

    ### To destroy all resources
        - cd ..
        - cd terraform
        - terraform destroy -auto-approve


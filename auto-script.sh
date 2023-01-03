{
    # Clone this repo to get the manifests
    git clone --depth 1 https://github.com/kodekloudhub/kubernetes-challenges.git

    ### PVC
    kubectl apply -f kubernetes-challenges/challenge-1/jekyll-pvc.yaml

    ### POD
    kubectl apply -f kubernetes-challenges/challenge-1/jekyll-pod.yaml

    # Wait for pod to be running
    echo "Waiting up to 120s for Jekyll pod to be running..."
    kubectl wait -n development --for=condition=ready pod -l run=jekyll --timeout 120s

    if [ $? -ne 0 ]
    then
        echo "The pod did not start correctly. Please reload the lab and try again."
        echo "If the issue persists, please report it in Slack in kubernetes-challenges channel"
        echo "https://kodekloud.slack.com/archives/C02LS58EGQ4"
        cd ~
        echo "Press CTRL-C to exit"
        read x
    fi

    ### Service
    kubectl apply -f kubernetes-challenges/challenge-1/jekyll-node-service.yaml

    ### Role
    kubectl create role developer-role --resource=pods,svc,pvc --verb="*" -n development

    ## RoleBinding
    kubectl create rolebinding developer-rolebinding --role=developer-role --user=martin -n development

    ## Martin

    kubectl config set-credentials martin --client-certificate ./martin.crt --client-key ./martin.key
    kubectl config set-context developer --cluster kubernetes --user martin

    ## kube-config

    kubectl config use-context developer

    echo -e "\n\nAutomation complete! Press the Check button.\n"
}

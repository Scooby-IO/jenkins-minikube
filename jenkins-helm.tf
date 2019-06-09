resource "helm_release" "jenkins" {
    name      = "jenkins"
    chart     = "stable/jenkins"
    namespace = "jenkins"

    values = [
      "${file("jenkins-values.yaml")}"
    ]
    depends_on = ["kubernetes_namespace.jenkins"]
}


data "template_file" "PrivateIpAddress" {
    template = "temp_ip.tmp"
}

resource "null_resource" "get-minikube-ip" {
    provisioner "local-exec" {
         command = "minikube ip  > ${data.template_file.PrivateIpAddress.rendered}"
    }

}

data "local_file" "minikube_ip" {
    filename = "${data.template_file.PrivateIpAddress.rendered}"
    depends_on = ["null_resource.get-minikube-ip"]
}


output "minikube-ip-address" {
    value = "${data.local_file.minikube_ip.content}"
}

output "jenkins-url" {
    value = "http://${chomp(data.local_file.minikube_ip.content)}:32000/login"
}

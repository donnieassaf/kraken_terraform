from kubernetes import client, config
import sys

# Function to clean up pods in specified namespaces
def clean_pods(namespaces):
    config.load_kube_config()  # Load the kubeconfig file to configure access to the cluster
    v1 = client.CoreV1Api()    # Initialize the Kubernetes API client
    deleted_pods = []          # List to store deleted pods information

    for namespace in namespaces:
        try:
            # Get all pods in the given namespace
            pods = v1.list_namespaced_pod(namespace)
            for pod in pods.items:
                # Check pod status and delete if it's Failed, Succeeded, or has an OOMKilled/Error status
                if pod.status.phase in ['Failed', 'Succeeded']:
                    v1.delete_namespaced_pod(name=pod.metadata.name, namespace=namespace, body=client.V1DeleteOptions())
                    deleted_pods.append((pod.metadata.name, pod.status.phase))
                    print(f"Deleted pod {pod.metadata.name} with status {pod.status.phase}")
        except client.exceptions.ApiException as e:
            print(f"Exception when processing namespace {namespace}: {e}", file=sys.stderr)

    return deleted_pods

# Main block for command-line execution
if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser(description="Clean up completed and failed pods.")
    parser.add_argument('namespaces', metavar='N', type=str, nargs='+',
                        help='A space separated list of Kubernetes namespaces.')
    args = parser.parse_args()

    # Run the cleanup process
    deleted_pods = clean_pods(args.namespaces)
    if deleted_pods:
        print("Deleted pods:", deleted_pods)
    else:
        print("No pods were deleted.")

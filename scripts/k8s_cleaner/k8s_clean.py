from kubernetes import client, config
from kubernetes.client.rest import ApiException

# Load configuration
config.load_kube_config()

# Initialize API client
api_instance = client.CoreV1Api()

namespace = 'default'  # Modify as needed

try:
    # List all pods in the namespace
    pods = api_instance.list_namespaced_pod(namespace)
    for pod in pods.items:
        if pod.status.phase in ['Failed', 'Succeeded']:
            print(f"Deleting pod: {pod.metadata.name} in namespace: {namespace}")
            api_instance.delete_namespaced_pod(name=pod.metadata.name, namespace=namespace)
except ApiException as e:
    print(f"Exception when calling CoreV1Api: {e}")

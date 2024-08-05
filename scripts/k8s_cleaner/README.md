# Kubernetes Pod Cleanup Script

## Overview

This repository contains a Python script designed to clean up Kubernetes pods in specified namespaces that are in specific states, such as `Failed`, `Succeeded`, `OOMKilled`, and `Error`. This script can be used to maintain a clean Kubernetes environment by automatically removing pods that are no longer needed.

## Features

- **Targeted Namespace Cleanup:** Specify one or more Kubernetes namespaces, and the script will clean up the pods in those namespaces.
- **Handles Common Pod States:** The script identifies and deletes pods that have completed, failed, or encountered errors, including out-of-memory (OOMKilled) pods.
- **Command-Line Execution:** Run the script directly from the command line.

## Prerequisites

- **Python 3.x**: Make sure you have Python 3 installed.
- **Kubernetes Cluster**: The script assumes you have access to a Kubernetes cluster (e.g., Minikube, EKS, GKE).
- **kubectl**: Ensure `kubectl` is configured to interact with your cluster.
- **Kubernetes Python Client**: The script uses the Kubernetes Python client, which should be installed in your environment.

## Setup

### 1. Clone the Repository

```bash
git clone https://github.com/your-username/your-repo-name.git
cd your-repo-name
```

### 2. Set Up a Virtual Environment

It's recommended to use a virtual environment to manage dependencies:

```bash
python3 -m venv myenv
source myenv/bin/activate
```

### 3. Install Required Dependencies

Install the necessary Python packages:

```bash
pip install kubernetes
```

### 4. Add the Virtual Environment to `.gitignore`

To prevent your virtual environment files from being tracked by Git, ensure the following line is in your `.gitignore`:

```plaintext
myenv/
```

Replace `myenv/` with your virtual environment directory name if it's different.

## Usage

### Running the Script from the Command Line

To run the script and clean up pods in a specific namespace, use the following command:

```bash
python3 k8s_clean.py <namespace1> <namespace2> ...
```

For example:

```bash
python3 k8s_clean.py default
```

This script will delete any pods in the specified namespace(s) that are in a `Failed`, `Succeeded`, `OOMKilled`, or `Error` state.


## Testing with Minikube

If you're using Minikube, make sure your cluster is up and running:

```bash
minikube start
```

### Creating Test Pods

To test the cleanup script, you can create some test pods in your Minikube cluster. These commands will create pods with different statuses:

```bash
# Create a pod that completes successfully
kubectl run successful-pod --image=busybox --restart=Never --command -- echo "This is a successful pod"

# Create a pod that fails immediately
kubectl run failed-pod --image=busybox --restart=Never --command -- false

# Create a pod that simulates an out-of-memory (OOMKilled) scenario
kubectl run oom-pod --image=busybox --restart=Never --command -- sh -c "sleep 5 && dd if=/dev/zero of=/dev/null bs=1024 count=1 && exit 1"
```

### Verifying Pods in the Default Namespace

To check if the pods were created in the `default` namespace, run:

```bash
kubectl get pods -n default
```

This command will list all the pods in the `default` namespace, showing their statuses.

### Running the Cleanup Script

After creating the test pods, you can run the cleanup script to remove the pods with `Failed`, `Succeeded`, or `OOMKilled` statuses:

```bash
python3 k8s_clean.py default
```

### Verifying the Cleanup

After running the script, you can verify that the pods were deleted by running:

```bash
kubectl get pods -n default
```

This should return "No resources found" if the script worked correctly.

### Cleaning Up

If you created test pods specifically for this script, you can clean up by deleting any remaining test pods:

```bash
kubectl delete pod successful-pod failed-pod oom-pod
```

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
